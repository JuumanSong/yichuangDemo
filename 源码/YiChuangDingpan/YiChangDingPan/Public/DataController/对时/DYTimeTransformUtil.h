//
//  DYTimeTransformUtil.h
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//  时间字符串转换类(北京时区)
//  由于NSDateFormatter的性能较差，故转换类方法大多使用NSDateComponents

#import <Foundation/Foundation.h>

@interface DYTimeTransformUtil : NSObject

#pragma mark - 基本格式转换
//默认所有时间戳单位都是秒
//将时间戳转换为北京时间:20161023
+ (NSString *)translateToYYYYMMDDWithTime:(NSTimeInterval)time;

//将时间戳转换为北京时间:1995-03-02
+ (NSString *)translateToYYYY_MM_DDWithTime:(NSTimeInterval)time;

//将时间戳转换为北京时间:1995年03月02日
+ (NSString *)translateToYMDWithTime:(NSTimeInterval)time;

//将时间戳转换为北京时间:HH:mm
+ (NSString *)translateToHHMMWithTime:(NSTimeInterval)time;

//将时间戳转换为北京时间:HH:mm:ss
+ (NSString *)translateToHHMMSSWithTime:(NSTimeInterval)time;

//将时间戳根据Format转换为北京时间
//主线程或单线程重复转换推荐
+ (NSString *)translateTime:(NSTimeInterval)time withDateFormat:(NSDateFormatter *)dateFormatter;

//将时间戳根据dateStr转换为北京时间
//(方法内会生成NSDateFormatter，性能较差：万次秒级别，不适合重复调）
//dateStr:默认:@"yyyy/MM/dd hh:mm:ss"
+ (NSString *)translateTime:(NSTimeInterval)time withDateStr:(NSString *)dateStr;

//根据字符串(北京时间，格式:yyyyMMddhhmmss 14位)返回时间戳
+ (NSTimeInterval)getTimeIntervalByTimeString14:(NSString *)timeStr;

//根据字符串(北京时间，格式:yyyyMMdd 8位)返回时间戳
+ (NSTimeInterval)getTimeIntervalByTimeString8:(NSString *)timeStr;

/*
 将时间戳转换为北京时间的格式01
 今天         今天
 其他         MM-dd
 */
+ (NSString *)translateToMM_DDWithTime:(NSTimeInterval)time;


#pragma mark - 特殊格式转换
/*
 将时间戳转换为北京时间的格式01
 今天         HH:mm
 昨天         昨天
 前天         前天
 今年         MM-dd
 非今年       yyyy-MM-dd
 */
+ (NSString *)translateDate01WithTime:(NSTimeInterval)time;


/*
 将时间戳转换为北京时间的格式02
 今年         MM-dd
 非今年       yyyy-MM-dd
 */
+ (NSString *)translateDate02WithTime:(NSTimeInterval)time;


/*
 将时间戳转换为北京时间的格式03
 <1min       刚刚
 <60mins     *分钟前
 <24hours    *小时前
 <48hours    1天前
 <72hours    2天前
 <96hours    3天前
 今年         MM-dd
 非今年       yyyy-MM-dd
 */
+ (NSString *)translateDate03WithTime:(NSTimeInterval)time;


/**
 将时间戳转换为北京时间的格式04
 今天        HH:mm
 今年        MM-dd HH:mm
 非今年      yyyy-MM-dd HH:mm
 */
+ (NSString *)translateDate04WithTime:(NSTimeInterval)time;


#pragma mark - 其他常用方法
// 比较日期是不是与当前日期相同
// dateStr:yyyy-MM-dd
+ (BOOL)compareDateNowAndWithDateStr:(NSString *)dateStr;

// 比较日期是不是大于当前日期
// dateStr:yyyy-MM-dd
+ (BOOL)compareCurrentDateAndWithDateStr:(NSString *)dateStr;

// 比较第一个日期是否大于第二个日期,大于：YES;小于：NO
// date格式：yyyyMMdd
+ (BOOL)compareFirstDate:(NSString *)firstDate nextDate:(NSString *)nextDate;

@end
