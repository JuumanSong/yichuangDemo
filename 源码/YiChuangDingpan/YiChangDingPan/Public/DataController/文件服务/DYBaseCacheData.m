//
//  DYBaseCacheData.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYBaseCacheData.h"
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//根目录

@implementation DYBaseCacheData

// 获取缓存路径
+(NSString *)getPathBySubpath:(NSString *)subPath{
    NSString *folderDirectory = [DocumentsDirectory stringByAppendingPathComponent:subPath];
    return folderDirectory;
}

// 存缓存
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType SubPath:(NSString *)subPath{
    NSString *path = [self getPathBySubpath:subPath];
    return [JMCacheUtil saveData:object DataType:dataType AtPath:path];
}

// 读缓存
+(id)loadDataWithDataType:(JMDataTypeEnum)dataType SubPath:(NSString *)subPath{
    NSString *path = [self getPathBySubpath:subPath];
    return [JMCacheUtil loadDataAtPath:path DataType:dataType];
}

// 删缓存
+(BOOL)deleteCacheBySubPath:(NSString *)subPath{
    NSString *path = [self getPathBySubpath:subPath];
    return [JMCacheUtil removeDataAtPath:path];
}

@end
