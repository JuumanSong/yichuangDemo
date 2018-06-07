//
//  JMCacheUtil.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface JMCacheUtil : NSObject


typedef enum {
    JMDataTypeEnumData  = 0,         //NSData
    JMDataTypeEnumImage  = 1,        //UIImage
    JMDataTypeEnumString  = 2,       //NSString
    JMDataTypeEnumDictionary  = 3,   //NSDictionary
    JMDataTypeEnumArray  = 4,        //NSArray
    JMDataTypeEnumObject  = 5,       //NSObject
} JMDataTypeEnum;//可缓存的基本类型

//单例
+(instancetype)sharedInstance;

// 将data存入path路径下
+(BOOL)saveData:(NSData *)data AtPath:(NSString *)path;

// 读取path路径下data
+(NSData *)loadDataAtPath:(NSString *)path;

// 移除path路径
+(BOOL)removeDataAtPath:(NSString *)path;

// 获取文件(文件夹)大小
+(long long)getSizeAtPath:(NSString *)path;

// 获取path所在文件的属性（创建日期，大小等）
+(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path;



#pragma mark - 基本对象
// 将基本对象存入path路径下
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path;

// 将基本对象存从path路径下取出
+(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType;


@end
