//
//  DYYCIndustryListService.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//  行业列表

#import "DYYCIndustryListService.h"
#import "DYYCIndustryModel.h"
#import "DYDataSourceModel.h"
#import "DYBaseDataSource.h"
#import "DYBaseCacheData.h"
#import "DYYCDataSourceList.h"

#define YCMobileBase @"http://fcsc-staring.respool.wmcloud-qa.com"
static DYYCIndustryListService *industryListService = nil;
static NSArray *fileCache = nil;
static NSDictionary *stockCache = nil;
static NSDate *fileDate = nil;
static NSDate *stockDate = nil;

@interface DYYCIndustryListService()

@property (nonatomic,strong) NSArray *cache;
@property (nonatomic,strong) NSDate *requestDate;
@property (nonatomic,strong) NSArray *tmpCache;

@end

@implementation DYYCIndustryListService

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        industryListService = [[DYYCIndustryListService alloc] init];
        industryListService.tmpCache = [NSMutableArray array];
//        removeCache(@"industryList");
        NSDictionary *listDict = loadFromCacheWithType(@"industryList", JMDataTypeEnumDictionary);
        fileDate = [listDict objectForKey:@"date"];
        fileCache = [listDict objectForKey:@"list"];
        
        NSDictionary *stockDict = loadFromCacheWithType(@"stockCache", JMDataTypeEnumDictionary);
        stockDate = [stockDict objectForKey:@"date"];
        stockCache = [stockDict objectForKey:@"list"];
        
    });
    return industryListService;
}

- (id)init {
    self = [super init];
    if (self) {
        _cache = [NSArray array];
    }
    return self;
}

- (void)loadIndustryListDataWithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail {
    
    // 是否超过一天
    if ([self isMoreOneDayWithDate:fileDate]) {
        [DYYCDataSourceList getSWIndustriesWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
            if (data && [data isKindOfClass:[NSDictionary class]] && data[@"data"]) {
                // 删除过期缓存
                removeCache(@"industryList");
                
                _cache = (NSArray *)data[@"data"];
                NSDictionary *dict = @{
                                       @"date": [NSDate date],
                                       @"list": data[@"data"]
                                       };
                
                saveToCacheWithType(@"industryList", dict, JMDataTypeEnumDictionary);
                
                success(_cache);
            }else{
                
                success(nil);
            }
        } fail:^(NSError *error) {
            fail(error);
        }];
        return;
    }
    // 是否有缓存
    if (fileCache && fileCache.count > 0) {
        _cache = fileCache;
        success(_cache);
        return;
    }
    
    [DYYCDataSourceList getSWIndustriesWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
        if (data && [data isKindOfClass:[NSDictionary class]] && data[@"data"]) {
            _requestDate = [NSDate date];
            // 删除过期缓存
            removeCache(@"industryList");
            
            _cache = (NSArray *)data[@"data"];
            NSDictionary *dict = @{
                                   @"date": [NSDate date],
                                   @"list": data[@"data"]
                                   };

            saveToCacheWithType(@"industryList", dict, JMDataTypeEnumDictionary);
            
            success(_cache);
        }else{
            
            success(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

- (NSString *)getIndustryNameWithID:(NSString *)ID {
    if (!ID.length)
    {
        return nil;
    }
    __block NSString *result = nil;
    if (!fileCache || fileCache.count == 0) {
        return nil;
    }
    [fileCache enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([ID isEqualToString:obj[@"id1"]]) {
            result = obj[@"name1"];
        }
    }];
    return result;
}

- (BOOL)isMoreOneDayWithDate:(NSDate *)date {
    
    if (!date) return NO;
    NSDate *now = [NSDate date];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta > 60 * 60 * 24) {
        _tmpCache = fileCache.copy;
        return YES;
    }
    else {
        return NO;
    }
}

//- (void)loadEquIndustriesDataWithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail {
//    // 是否超过一天
//    if ([self isMoreOneDayWithDate:stockDate]) {
//        [DYYCDataSourceList getEquIndustriesWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
//            if (data && [data isKindOfClass:[NSDictionary class]] && data[@"data"]) {
//                // 删除过期缓存
//                removeCache(@"stockCache");
//                // 修改数据结构
//                NSDictionary *result = [self handleRequestData:data[@"data"]];
//                NSDictionary *dict = @{
//                                       @"date": [NSDate date],
//                                       @"list": result
//                                       };
//                saveToCacheWithType(@"stockCache", dict, JMDataTypeEnumDictionary);
//                success(result);
//            }else{
//
//                success(nil);
//            }
//        } fail:^(NSError *error) {
//            fail(error);
//        }];
//        return;
//    }
//    // 是否有缓存
//    if (stockCache && stockCache.count > 0) {
//
//        success(stockCache);
//        return;
//    }
//
//    [DYYCDataSourceList getEquIndustriesWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
//        if (data && [data isKindOfClass:[NSDictionary class]] && data[@"data"]) {
//            // 删除过期缓存
//            removeCache(@"stockCache");
//
//            NSDictionary *result = [self handleRequestData:data[@"data"]];
//
//            NSDictionary *dict = @{
//                                   @"date": [NSDate date],
//                                   @"list": result
//                                   };
//
//            saveToCacheWithType(@"stockCache", dict, JMDataTypeEnumDictionary);
//
//            success(result);
//        }else{
//
//            success(nil);
//        }
//    } fail:^(NSError *error) {
//        fail(error);
//    }];
//}

- (NSDictionary *)handleRequestData:(NSArray *)array {
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            NSString *key = [obj objectForKey:@"t"];
            NSMutableDictionary *tmp = obj.mutableCopy;
            [tmp removeObjectForKey:@"t"];
            
            [dict setValue:tmp forKey:key];
        }
    }];
    return dict;
}


@end
