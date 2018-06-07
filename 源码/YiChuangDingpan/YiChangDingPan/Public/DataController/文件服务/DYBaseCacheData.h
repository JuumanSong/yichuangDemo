//
//  DYBaseCacheData.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYCacheKeys.h"
#import "JMCacheUtil.h"

//写缓存
#define saveToCache(key,object)  [DYBaseCacheData saveData:object DataType:JMDataTypeEnumData SubPath:key]
#define saveToCacheWithType(key,object,type)  [DYBaseCacheData saveData:object DataType:type SubPath:key]
//读缓存
#define loadFromCache(key)   [DYBaseCacheData loadDataWithDataType:JMDataTypeEnumData SubPath:key]
#define loadFromCacheWithType(key,type)   [DYBaseCacheData loadDataWithDataType:type SubPath:key]
//删缓存
#define removeCache(key)    [DYBaseCacheData deleteCacheBySubPath:key]


@interface DYBaseCacheData : NSObject

// 获取缓存路径
+(NSString *)getPathBySubpath:(NSString *)subPath;

// 存缓存
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType SubPath:(NSString *)subPath;

// 读缓存
+(id)loadDataWithDataType:(JMDataTypeEnum)dataType SubPath:(NSString *)subPath;

// 删缓存
+(BOOL)deleteCacheBySubPath:(NSString *)subPath;

@end
