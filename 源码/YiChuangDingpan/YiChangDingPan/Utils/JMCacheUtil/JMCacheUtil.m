//
//  JMCacheUtil.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "JMCacheUtil.h"
static JMCacheUtil *instance;

@interface JMCacheUtil()
@property(nonatomic,strong)NSFileManager *fileMgr;
@end

@implementation JMCacheUtil

#pragma mark - Method
// 单例
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.fileMgr = [NSFileManager defaultManager];
    });
    return instance;
}

// 将data存入path路径下
+(BOOL)saveData:(NSData *)data AtPath:(NSString *)path{
    BOOL result = NO;
    @try {
        JMCacheUtil *util = [self sharedInstance];
        [self createDirectoryAtPath:path];
        if (![util.fileMgr fileExistsAtPath:path]) {
            return [util.fileMgr createFileAtPath:path contents:data attributes:nil];
        } else {
            return [data writeToFile:path atomically:YES];
        }
    }
    @catch (NSException *e) {
        result = NO;
    }
    return result;
}

// 读取path路径下data
+(NSData *)loadDataAtPath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

// 移除path路径
+(BOOL)removeDataAtPath:(NSString *)path{
    NSError *error;
    JMCacheUtil *util = [self sharedInstance];
    return [util.fileMgr removeItemAtPath:path error:&error];
}

// 获取文件(文件夹)大小
+(long long)getSizeAtPath:(NSString *)path{
    JMCacheUtil *util = [self sharedInstance];
    NSArray * tempFileList = [[NSArray alloc] initWithArray:[util.fileMgr contentsOfDirectoryAtPath:path error:nil]];
    if(tempFileList.count==0){//文件
        return [self getFileSizeAtPath:path];
    }
    else{//文件夹
        return [self getFolderSizeAtPath:path];
    }
}

// 获取path所在文件的属性（创建日期，大小等）
+(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path{
    JMCacheUtil *util = [self sharedInstance];
    NSDictionary *fileAttributes = [util.fileMgr attributesOfItemAtPath:path error:nil];
    return fileAttributes;
}


#pragma mark - 辅助方法
//获取filePath所在文件大小
+(long long)getFileSizeAtPath:(NSString *)filePath{
    JMCacheUtil *util = [self sharedInstance];
    if (![util.fileMgr fileExistsAtPath:filePath]){
        return 0;
    }
    long long fileSize=[util.fileMgr attributesOfItemAtPath:filePath error:nil].fileSize;
    return fileSize;
}

//获取folderPath所在文件夹大小
+(long long)getFolderSizeAtPath:(NSString *)folderPath{
    JMCacheUtil *util = [self sharedInstance];
    if (![util.fileMgr fileExistsAtPath:folderPath]){
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[util.fileMgr subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    NSString *filePath;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        filePath=[folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self getFileSizeAtPath:filePath];
    }
    return folderSize;
}


//生产path路径所需的文件夹
+(void)createDirectoryAtPath:(NSString *)path{
    JMCacheUtil *util = [self sharedInstance];
    if([util.fileMgr fileExistsAtPath:path]){
        return;
    }
    else{
        NSString *folderPath=@"";
        NSArray *folderArr = [self splitPath:path withflag:@"/"];
        for(int i=0;i<folderArr.count-1;i++){
            folderPath=[folderPath stringByAppendingPathComponent:[folderArr objectAtIndex:i]];
            if([util.fileMgr fileExistsAtPath:folderPath]){
                
            }
            else{
                [util.fileMgr createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
}

// 通过flag分割字符串
+ (NSArray *)splitPath:(NSString *)path withflag:(NSString *)flag{
    NSString *splitPath = nil;
    NSArray *folderArr;
    if (path!=nil||![path isEqual:@""]) {
        splitPath = path;
    } else {
        return nil;
    }
    folderArr = [splitPath componentsSeparatedByString:flag];
    return folderArr;
}



#pragma mark - 基本对象
//将基本对象存入path路径下
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path{
    BOOL result = NO;
    @try {
        NSData *tempData = [self returnData:object type:dataType name:path];
        return [self saveData:tempData AtPath:path];
    }
    @catch (NSException *e) {
        result = NO;
    }
    return result;
}

//将基本对象从path路径下取出
+(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType{
    id res = nil;
    @try {
        NSData *fileData = [self loadDataAtPath:path];
        if (fileData != nil && [fileData length] > 0) {
            res=[self returnObjectWithData:fileData type:dataType];
        }
    }
    @catch (NSException *e) {
        res = nil;
    }
    return res;
}


//nsdata转基本对象
+(id)returnObjectWithData:(NSData *)data type:(JMDataTypeEnum)dataType{
    id res = nil;
    switch (dataType) {
        case JMDataTypeEnumData:{//二进制流
            res=data;
        }
            break;
        case JMDataTypeEnumImage:{//图片
            res=[UIImage imageWithData:data];
        }
            break;
        case JMDataTypeEnumString:{//字符串
            res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
        default:{//字典,数组
            res = [NSKeyedUnarchiver unarchiveObjectWithData:data];//序列化
        }
            break;
    }
    return res;
}

//基本对象转nsdata
+ (NSData *)returnData:(id)object type:(JMDataTypeEnum)dataType name:(NSString *)name {
    NSData *tempData = nil;
    
    switch (dataType) {
        case JMDataTypeEnumData:{//二进制流
            tempData = object;
        }
            break;
        case JMDataTypeEnumImage:{//图片
            if ([self endsWith:name arg:@"png"] || [self endsWith:name arg:@"PNG"]) {
                tempData = UIImagePNGRepresentation(object);
            } else {
                tempData = UIImageJPEGRepresentation(object, 0);
            }
        }
            break;
        case JMDataTypeEnumString:{//字符串
            tempData = [object dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        default:{//字典,数组,NSObject
            tempData = [NSKeyedArchiver archivedDataWithRootObject:object];//序列化
        }
            break;
    }
    return tempData;
}

//判断字符串resource是否以arg结尾（用于区分图片类型）
+ (BOOL)endsWith:(NSString *)resource arg:(NSString *)arg {
    if(resource==nil || arg==nil){
        return NO;
    }
    if([arg length]>[resource length]){
        return NO;
    }
    int index = (int)([resource length]-[arg length]);
    NSString *substr = [resource substringFromIndex:index];
    if([arg isEqual:substr]){
        return YES;
    }else{
        return NO;
    }
}


@end
