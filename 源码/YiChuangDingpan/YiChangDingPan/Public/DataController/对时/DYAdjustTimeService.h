//
//  DYAdjustTimeService.h
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//  对时后当前时间Service

#import <Foundation/Foundation.h>

#define BeiJingTimeZone  [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]
#define SystrmTimeZone  [NSTimeZone systemTimeZone]

@interface DYAdjustTimeService : NSObject

//单例
+ (instancetype)shareInstance;

//获取服务器时间戳，与本地时间戳比较将差值保存本地
- (void)checkServerTime;

//获取当前服务器时间
- (NSDate*)getCurrentTime;

//获取当前服务器时间戳
- (NSTimeInterval)getCurrentTimeInterval;

//获取当前服务器北京时区成分
- (NSDateComponents*)getCurrentTimeComponentsOfBeiJing;

//获取当前服务器手机时区成分
- (NSDateComponents*)getCurrentTimeComponentsOfSystem;

//-------------------------------------------------------------

//根据时间戳获取北京时区成分
-(NSDateComponents*)getBeiJingTimeComponentsByTimeInterval:(NSTimeInterval)timeInterval;

//根据时间戳获取系统时区成分
-(NSDateComponents*)getSystemTimeComponentsByTimeInterval:(NSTimeInterval)timeInterval;


@end
