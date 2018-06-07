/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  Database.m
//  SimpleEncapsulate
//
//  Created by yhtian on 13-9-27.
//

#import "SEDatabase.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <FMDB/FMDB.h>
#import "SEUtilities.h"
#import "NSObject+Representation.h"
#import <sqlite3.h>
#ifndef DEBUG
#define DEBUG 0
#endif

static const void *kDatabaseSpecificKey = &kDatabaseSpecificKey;

static void _DBGenerateObjects(NSOperation *operation, NSMutableArray *array, Class cls, FMResultSet *set)
{
    //使用AMCObject生成的对象效率不如kvcMagic高，
    //但是如果存储了带NSArray或Dictionary的复杂对象时可以kvcMagic就无能为力了
#define notCancelled     (!operation || (operation && ![operation isCancelled]))
    
    while ([set next] && notCancelled) {
        id item = [cls objectWithRepresentation:[set resultDictionary]];
        [array addObject:item];
    }
#undef notCancelled
}

typedef enum {
    kOperationQuery,
    kOperationQueryOneColumn,
    kOperationUpdate,
    kOperationTranscation,
} DBOperationType;

@interface SEDatabaseOperation : NSOperation

+ (instancetype)operationWithQuery:(NSString *)query;

- (instancetype)initWithQuery:(NSString *)query;

@property(nonatomic) DBOperationType type;
@property(nonatomic, strong) id context;
@property(atomic, readonly, strong) NSString *query;
@property(atomic, strong) id data;
@property(nonatomic) NSInteger tag;

@end

@implementation SEDatabaseOperation

+ (instancetype)operationWithQuery:(NSString *)query
{
    return [[self alloc] initWithQuery:query];
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"Please use -initWithQuery:"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        _query = query;
    }
    return self;
}

- (void)dealloc
{
//    DDLogInfo(@"%@", self);
}

- (void)main
{
    @autoreleasepool {
        if (![self isCancelled]) {
            __weak typeof(self) weakSelf = self;
            if (self.type == kOperationQuery) {
                [[SEDatabase sharedDatabase].dbQueue inDatabase:^(FMDatabase *db) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    FMResultSet *set = [db executeQuery:strongSelf.query];
                    NSMutableArray *array = [NSMutableArray array];
                    _DBGenerateObjects(strongSelf, array, NSClassFromString(strongSelf.context), set);
                    if ([array count]) {
                        strongSelf.data = array;
                    }
                }];
            } else if (self.type == kOperationQueryOneColumn) {
                [[SEDatabase sharedDatabase].dbQueue inDatabase:^(FMDatabase *db) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    NSMutableArray *array = [NSMutableArray array];
                    FMResultSet *set = [db executeQuery:strongSelf.query];
                    while ([set next] && ![strongSelf isCancelled]) {
                        [array addObject:[set objectForColumnIndex:0]];
                    }
                    if ([array count]) {
                        strongSelf.data = array;
                    }
                }];
            } else if (self.type == kOperationUpdate) {
                [[SEDatabase sharedDatabase].dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    NSError *error;
                    NSArray *queries = strongSelf.context;
                    for (NSString *sql in queries) {
                        BOOL success = [db executeUpdate:sql withErrorAndBindings:&error];
                        if (!success && ![strongSelf isCancelled]) {
                            strongSelf.data = error;
                            break;
                        }
                    }
                    *rollback = [strongSelf isCancelled];
                }];
            } else if (self.type == kOperationTranscation) {
                [[SEDatabase sharedDatabase].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    void (^block)(BOOL *) = strongSelf.context;
                    BOOL shouldRollback = [strongSelf isCancelled];
                    block(&shouldRollback);
                    *rollback = shouldRollback;
                }];
            }
        }
    }
}

- (void)cancel
{
    [super cancel];
    if (sqlite3_complete([self.query UTF8String]) != 1) {
        [[SEDatabase sharedDatabase].dbQueue inDatabase:^(FMDatabase *db) {
            sqlite3_interrupt(db.sqliteHandle);
        }];
    }
}

- (void)setCompletionBlock:(void (^)(void))block
{
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![strongSelf isCancelled] && block) {
            block();
        }
    };
    [super setCompletionBlock:completionBlock];
}

- (BOOL)isConcurrent
{
    return (self.type == kOperationQuery || self.type == kOperationQueryOneColumn);
}

- (BOOL)isAsynchronous
{
    return (self.type == kOperationQuery || self.type == kOperationQueryOneColumn);
}

@end

@implementation SEDatabase

@dynamic dbQueue;

+ (instancetype)sharedDatabase
{
    static SEDatabase *z_database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        z_database = [[self alloc] init];
    });
    return z_database;
}

- (id)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _updateQueue = dispatch_queue_create("__update_queue", NULL);
    }
    return self;
}

- (void)dealloc
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    dispatch_release(_updateQueue);
#endif
    [self.dbQueue close];
}

- (FMDatabaseQueue *)dbQueue
{
    @synchronized(self) {
        if (!_dbQueue) {
            NSString *filePath = [SEUtilities duplicateBundleFileWithName:self.dbName
                                                              toDirectory:NSLibraryDirectory
                                                                overwrite:_override];
//            DDLogInfo(@"SEDatabase path is :%@",filePath);
            if (filePath) {
                // 添加到iCloud备份忽略列表
                [SEUtilities addSkipBackupAttributeToFileAtPath:filePath];
                
                _dbQueue = [[FMDatabaseQueue alloc] initWithPath:filePath];
                [_dbQueue inDatabase:^(FMDatabase *db) {
                    db.logsErrors = DEBUG;
                    if (![db open]) {
//                        DDLogInfo(@"Could not create database queue for path %@", filePath);
                        return;
                    }
                    _db = db;
                    // We can accept data lost...
                    sqlite3_exec(db.sqliteHandle, "PRAGMA synchronous = OFF; ", 0,0,0);
                }];
                if (!_dbQueue) {
                    return nil;
                }
                // We need to get the fmdb-queue to check if we're in queue,
                // but it's private, so we have this...
                Ivar queue = class_getInstanceVariable([FMDatabaseQueue class], "_queue");
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
                dispatch_queue_t dbQueue = ((dispatch_queue_t (*)(id, Ivar))object_getIvar)(_dbQueue, queue);
#else
                dispatch_queue_t dbQueue = object_getIvar(_dbQueue, queue);
#endif
                dispatch_set_target_queue(_updateQueue, dbQueue);
                dispatch_queue_set_specific(dbQueue, kDatabaseSpecificKey, (__bridge void *)self, NULL);
            }
        }
        return _dbQueue;
    }
}

- (void)setDbName:(NSString *)dbName
{
    [self setDbName:dbName override:NO];
}

- (void)setDbName:(NSString *)dbName override:(BOOL)override
{
    if (dbName == nil ||
        ([dbName isEqualToString:_dbName] && override == _override)) {
        return;
    }
    _dbName = dbName;
    _override = override;
    @synchronized(self) {
        if (_dbQueue) {
            [_dbQueue close];
            _dbQueue = nil;
        }
    }
}

- (void)setMigrateDataBlock:(void (^)(FMDatabase *db))block
{
    if (block) {
        id obj = (__bridge SEDatabase *)dispatch_get_specific(kDatabaseSpecificKey);
        if (obj != self) {
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                block(db);
            }];
        } else {
            block(_db);
        }
    }
}

- (NSArray *)fetchWithQuery:(NSString *)query
                   regClass:(Class)cls
{
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        id obj = (__bridge SEDatabase *)dispatch_get_specific(kDatabaseSpecificKey);
        if (obj != self) {
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                FMResultSet *set = [db executeQuery:query];
                _DBGenerateObjects(nil, array, cls, set);
            }];
        } else {
            FMResultSet *set = [_db executeQuery:query];
            _DBGenerateObjects(nil, array, cls, set);
        }
        if ([array count]) {
            return array;
        }
        return nil;
    }
}

- (NSArray *)fetchOneColumnWithQuery:(NSString *)query
{
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        id obj = (__bridge SEDatabase *)dispatch_get_specific(kDatabaseSpecificKey);
        if (obj != self) { // We are not in db queue.
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                FMResultSet *set = [db executeQuery:query];
                while ([set next]) {
                    [array addObject:[set objectForColumnIndex:0]];
                }
            }];
        } else {
            FMResultSet *set = [_db executeQuery:query];
            while ([set next]) {
                [array addObject:[set objectForColumnIndex:0]];
            }
        }
        if ([array count]) {
            return array;
        }
        return nil;
    }
}

- (void)fetchAsyncWithQuery:(NSString *)query
                   regClass:(Class)cls
          completionHandler:(void (^)(NSArray *data))handler
{
    [self fetchAsyncWithQuery:query tag:0 regClass:cls completionHandler:handler];
}

- (void)fetchAsyncWithQuery:(NSString *)query
                        tag:(NSInteger)tag
                   regClass:(Class)cls
          completionHandler:(void (^)(NSArray *data))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ (void) {
        SEDatabaseOperation *operation = [SEDatabaseOperation operationWithQuery:query];
        operation.type = kOperationQuery;
        operation.context = NSStringFromClass(cls);
        operation.tag = tag;
        [operation setQueuePriority:NSOperationQueuePriorityNormal];
        [_operationQueue addOperation:operation];
        if (handler) {
            __weak typeof (operation) weakOp = operation;
            [operation setCompletionBlock:^{
                __strong typeof (weakOp) strongOp = weakOp;
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(strongOp.data);
                });
            }];
        }
        if ([_operationQueue isSuspended]) {
            [_operationQueue setSuspended:NO];
        }
    });
}

- (void)fetchOneColumnAsyncWithQuery:(NSString *)query
                   completionHandler:(void (^)(NSArray *))handler
{
    [self fetchOneColumnAsyncWithQuery:query tag:0 completionHandler:handler];
}

- (void)fetchOneColumnAsyncWithQuery:(NSString *)query
                                 tag:(NSInteger)tag
                   completionHandler:(void (^)(NSArray *))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ (void) {
        SEDatabaseOperation *operation = [SEDatabaseOperation operationWithQuery:query];
        operation.type = kOperationQueryOneColumn;
        operation.tag = tag;
        [operation setQueuePriority:NSOperationQueuePriorityNormal];
        [_operationQueue addOperation:operation];
        if (handler) {
            __weak typeof (operation) weakOp = operation;
            [operation setCompletionBlock:^{
                __strong typeof (weakOp) strongOp = weakOp;
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(strongOp.data);
                });
            }];
        }
        if ([_operationQueue isSuspended]) {
            [_operationQueue setSuspended:NO];
        }
    });
}

- (BOOL)updateWithQuery:(NSString *)query error:(NSError * __autoreleasing *)error
{
    id obj = (__bridge SEDatabase *)dispatch_get_specific(kDatabaseSpecificKey);
    if (obj != self) { // We are not in db queue.
        __block BOOL success = YES;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:query withErrorAndBindings:error];
        }];
        return success;
    } else {
        return [_db executeUpdate:query withErrorAndBindings:error];
    }
}

- (void)updateBatchWithQueries:(NSArray *)queries
             completionHandler:(void (^)(NSError *error))handler
{
    [self updateBatchWithQueries:queries tag:0 completionHandler:handler];
}

- (void)updateBatchWithQueries:(NSArray *)queries
                           tag:(NSInteger)tag
             completionHandler:(void (^)(NSError *error))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        SEDatabaseOperation *operation = [SEDatabaseOperation operationWithQuery:@"begin deferred transaction"];
        operation.type = kOperationUpdate;
        operation.context = queries;
        operation.tag = tag;
        [operation setQueuePriority:NSOperationQueuePriorityLow];
        [_operationQueue addOperation:operation];
        if (handler) {
            __weak typeof (operation) weakOp = operation;
            [operation setCompletionBlock:^{
                __strong typeof (weakOp) strongOp = weakOp;
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(strongOp.data);
                });
            }];
        }
        if ([_operationQueue isSuspended]) {
            [_operationQueue setSuspended:NO];
        }
    });
}

- (void)inDeferredTransaction:(void (^)(BOOL *))block
{
    [self inDeferredTransaction:block tag:0];
}

- (void)inDeferredTransaction:(void (^)(BOOL *))block
                          tag:(NSInteger)tag
{
    if (block) {
        SEDatabaseOperation *operation = [SEDatabaseOperation operationWithQuery:@"begin transaction"];
        operation.context = block;
        operation.tag = tag;
        operation.type = kOperationTranscation;
        [operation setQueuePriority:NSOperationQueuePriorityLow];
        [_operationQueue addOperation:operation];
        if ([_operationQueue isSuspended]) {
            [_operationQueue setSuspended:NO];
        }
    }
}

- (BOOL)isQueryExcuting:(NSString *)query
{
    if (query) {
        NSArray *operations = [_operationQueue operations];
        for (SEDatabaseOperation *operation in operations) {
            if ([operation.query isEqualToString:query]) {
                return [operation isExecuting];
            }
        }
    }
    return NO;
}

- (void)cancelQuery:(NSString *)query
{
    if (query) {
        NSArray *operations = [_operationQueue operations];
        for (SEDatabaseOperation *operation in operations) {
            if ([operation.query isEqualToString:query]) {
                [operation cancel];
                break;
            }
        }
    }
}

- (BOOL)isQueryExcutingWithTag:(NSInteger)tag
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tag == %d", tag];
    NSArray *array = [_operationQueue.operations filteredArrayUsingPredicate:predicate];
    return [[array lastObject] isExecuting];
}

- (void)cancelQueryWithTag:(NSInteger)tag
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tag == %d", tag];
    NSArray *array = [_operationQueue.operations filteredArrayUsingPredicate:predicate];
    [[array lastObject] cancel];
}

#pragma mark - Other function
//获取字符串的下一个比它大的字符串
- (NSString *)nextStringAfterString:(NSString *)text
{
    NSString *nextString = nil;
    NSUInteger length = text.length;
    NSString *prefixString = [text substringToIndex:length - 1];
    NSString *lastString = [text substringFromIndex:length - 1];
    const char* lastChar = [lastString UTF8String];
    size_t lastLength = strlen(lastChar);
    if (lastLength == 1) {//ASCII
        char newChar1[2];
        newChar1[0] = lastChar[0] + 1;
        newChar1[1] = 0;
        NSString *newString1 = [NSString stringWithUTF8String:newChar1];
        nextString = [prefixString stringByAppendingString:newString1];
    } else if (lastLength == 3) {//中文
        char newChar2[4];
        newChar2[0] = lastChar[0];
        newChar2[1] = lastChar[1];
        newChar2[2] = lastChar[2] + 1;
        newChar2[3] = 0;
        NSString *newString2 = [NSString stringWithUTF8String:newChar2];
        nextString = [prefixString stringByAppendingString:newString2];
    }
    return nextString;
}

@end
