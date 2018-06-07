//
//  DYTimeTransformUtil.m
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//  时间处理转换类

#import "DYTimeTransformUtil.h"

@implementation DYTimeTransformUtil

#pragma mark - 基本格式转换

//将时间戳根据Format转换为北京时间
//主线程或单线程重复转换推荐
+ (NSString *)translateTime:(NSTimeInterval)time withDateFormat:(NSDateFormatter *)dateFormatter{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    //北京时区
    [dateFormatter setTimeZone:BeiJingTimeZone];
    
    NSString *dateString = [dateFormatter stringFromDate:timeDate];
    return dateString;
}

//将时间戳转换为北京时间:20161023
+ (NSString *)translateToYYYYMMDDWithTime:(NSTimeInterval)time{
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    return [NSString stringWithFormat:@"%d%02d%02d",(int)com.year,(int)com.month,(int)com.day];
}

//将时间戳转换为北京时间:HH:mm
+ (NSString *)translateToHHMMWithTime:(NSTimeInterval)time {
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    return [NSString stringWithFormat:@"%02d:%02d",(int)com.hour,(int)com.minute];
}

//将时间戳转换为北京时间:HH:mm:ss
+ (NSString *)translateToHHMMSSWithTime:(NSTimeInterval)time {
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    return [NSString stringWithFormat:@"%02d:%02d:%02d",(int)com.hour,(int)com.minute,(int)com.second];
}

//将时间戳转换为北京时间:1995-03-02
+ (NSString *)translateToYYYY_MM_DDWithTime:(NSTimeInterval)time{
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    return [NSString stringWithFormat:@"%d-%02d-%02d",(int)com.year,(int)com.month,(int)com.day];
}

//将时间戳转换为北京时间:1995年03月02日
+ (NSString *)translateToYMDWithTime:(NSTimeInterval)time{
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    return [NSString stringWithFormat:@"%d年%02d月%02d日",(int)com.year,(int)com.month,(int)com.day];
}

//将时间戳根据dateStr转换为北京时间
//(方法内会生成NSDateFormatter，性能较差：万次秒级别，不适合重复调）
//dateStr:默认:@"yyyy/MM/dd hh:mm:ss"
 + (NSString *)translateTime:(NSTimeInterval)time withDateStr:(NSString *)dateStr{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    if(!dateStr||dateStr.length<=0){
        dateStr = @"yyyy/MM/dd HH:mm:ss";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateStr];
    //北京时区
    [dateFormatter setTimeZone:BeiJingTimeZone];
    
    NSString *dateString = [dateFormatter stringFromDate:timeDate];
    return dateString;
}

//根据字符串(北京时间，格式:yyyyMMddhhmmss 14位)返回时间戳
+ (NSTimeInterval)getTimeIntervalByTimeString14:(NSString *)timeStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.timeZone = BeiJingTimeZone;
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:timeStr];
    NSTimeInterval interval = [inputDate timeIntervalSince1970];
    return interval;
}

//根据字符串(北京时间，格式:yyyyMMdd 8位)返回时间戳
+ (NSTimeInterval)getTimeIntervalByTimeString8:(NSString *)timeStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.timeZone = BeiJingTimeZone;
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:timeStr];
    NSTimeInterval interval = [inputDate timeIntervalSince1970];
    return interval;
}


+ (NSString *)translateToMM_DDWithTime:(NSTimeInterval)time
{
    
    NSTimeInterval nowInterval = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];//当前时间戳
    int days = (nowInterval +  [BeiJingTimeZone secondsFromGMT])/(60*60*24);//北京自1970年过了多少天(第一天只有16小时)
    NSTimeInterval zero=60*60*24*days -  [BeiJingTimeZone secondsFromGMT];//北京0点时间戳
    
    if(time>=zero && time<zero+60*60*24){//今天
        return @"今天";
    }
    else {
        
        NSString *date = [DYTimeTransformUtil translateToYYYY_MM_DDWithTime:time];
        
        return [date substringWithRange:NSMakeRange(5, 5)];
    }
}

#pragma mark - 特殊格式转换
/*
 将时间戳转换为北京时间的格式01
 今天         HH:mm
 昨天         昨天
 前天         前天
 今年         MM-dd
 非今年       yyyy-MM-dd
 */
+ (NSString *)translateDate01WithTime:(NSTimeInterval)time{
    
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    
    NSTimeInterval nowInterval = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];//当前时间戳
    int days = (nowInterval +  [BeiJingTimeZone secondsFromGMT])/(60*60*24);//北京自1970年过了多少天(第一天只有16小时)
    NSTimeInterval zero=60*60*24*days -  [BeiJingTimeZone secondsFromGMT];//北京0点时间戳
    
    if(time>=zero && time<zero+60*60*24){//今天
        if (com.hour == 0 &&
            com.minute == 0) {
            return [NSString stringWithFormat:@"%02d-%02d",(int)com.month,(int)com.day];
        }
        return [NSString stringWithFormat:@"%02d:%02d",(int)com.hour,(int)com.minute];
    }
    else if (zero-time<=60*60*24 && zero-time>0){//昨天
        return @"昨天";
    }
    else if (zero-time<=60*60*48 && zero-time>60*60*24){//前天
        return @"前天";
    }
    else{
        NSInteger currentYear = [[DYAdjustTimeService shareInstance]getCurrentTimeComponentsOfBeiJing].year;//当前北京年
        NSInteger timeYear = com.year;//time所在的北京年
        if(currentYear == timeYear){//今年
            return [NSString stringWithFormat:@"%02d-%02d",(int)com.month,(int)com.day];
        }
        else{//非今年
            return [NSString stringWithFormat:@"%d-%02d-%02d",(int)com.year,(int)com.month,(int)com.day];
        }
    }
}


/*
 将时间戳转换为北京时间的格式02
 今年         MM-dd
 非今年       yyyy-MM-dd
 */
+ (NSString *)translateDate02WithTime:(NSTimeInterval)time{
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    NSInteger currentYear = [[DYAdjustTimeService shareInstance]getCurrentTimeComponentsOfBeiJing].year;//当前北京年
    NSInteger timeYear = com.year;//time所在的北京年
    if(currentYear == timeYear){//今年
        return [NSString stringWithFormat:@"%02d-%02d",(int)com.month,(int)com.day];
    }
    else{//非今年
        return [NSString stringWithFormat:@"%d-%02d-%02d",(int)com.year,(int)com.month,(int)com.day];
    }
}


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
+ (NSString *)translateDate03WithTime:(NSTimeInterval)time{
    NSTimeInterval now = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];//当前时间戳
    if(now-time<=60){
        return @"刚刚";
    }
    else if (now-time<=60*60){
        int minutes=(now-time)/60;
        return [NSString stringWithFormat:@"%i分钟前",minutes];
    }
    else if (now-time<=60*60*24){
        int houes=(now-time)/60/60;
        return [NSString stringWithFormat:@"%i小时前",houes];
    }
    else if (now-time<=60*60*48){
        return @"1天前";
    }
    else if (now-time<=60*60*72){
        return @"2天前";
    }
    else if (now-time<=60*60*96){
        return @"3天前";
    }
    else{
        NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
        NSInteger currentYear = [[DYAdjustTimeService shareInstance]getCurrentTimeComponentsOfBeiJing].year;//当前北京年
        NSInteger timeYear = com.year;//time所在的北京年
        if(currentYear == timeYear){//今年
            return [NSString stringWithFormat:@"%02d-%02d",(int)com.month,(int)com.day];
        }
        else{//非今年
            return [NSString stringWithFormat:@"%d-%02d-%02d",(int)com.year,(int)com.month,(int)com.day];
        }
    }
}

/**
 将时间戳转换为北京时间的格式04
 今天        HH:mm
 今年        MM-dd HH:mm
 非今年      yyyy-MM-dd HH:mm
 */
+ (NSString *)translateDate04WithTime:(NSTimeInterval)time{
    NSDateComponents *com = [[DYAdjustTimeService shareInstance]getBeiJingTimeComponentsByTimeInterval:time];//time的北京时间成分
    
    NSTimeInterval nowInterval = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];//当前时间戳
    int days = (nowInterval +  [BeiJingTimeZone secondsFromGMT]) / (60 * 60 * 24);//北京自1970年过了多少天(第一天只有16小时)
    NSTimeInterval zero = 60 * 60 * 24 * days -  [BeiJingTimeZone secondsFromGMT];//北京0点时间戳
    
    if(time >= zero && time < zero + 60 * 60 * 24){ //今天
        return [NSString stringWithFormat:@"%02d:%02d", (int)com.hour, (int)com.minute];
        
    }else {
        NSInteger currentYear = [[DYAdjustTimeService shareInstance]getCurrentTimeComponentsOfBeiJing].year;//当前北京年
        NSInteger timeYear = com.year;//time所在的北京年
        if(currentYear == timeYear){ //今年
            return [NSString stringWithFormat:@"%02d-%02d %02d:%02d", (int)com.month, (int)com.day, (int)com.hour, (int)com.minute];
            
        }else { //非今年
            return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", (int)com.year, (int)com.month,(int)com.day, (int)com.hour, (int)com.minute];
        }
    }
}



#pragma mark - 其他常用方法
// 比较日期是不是与当前日期相同
// dateStr:yyyy-MM-dd
+ (BOOL)compareDateNowAndWithDateStr:(NSString *)dateStr{
    NSString *nowDateStr = [DYTimeTransformUtil translateToYYYY_MM_DDWithTime:[[DYAdjustTimeService shareInstance]  getCurrentTimeInterval]];
    if([nowDateStr isEqualToString:dateStr]){
        return YES;
    }
    else{
        return NO;
    }
}

// 比较日期是不是大于当前日期
// dateStr:yyyy-MM-dd
+ (BOOL)compareCurrentDateAndWithDateStr:(NSString *)dateStr {
    NSString *dataS = dateStr;
    dataS = [dataS stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dataS = [dataS stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger dateInt = [dataS integerValue];
    
    NSString *nowDate = [DYTimeTransformUtil translateToYYYYMMDDWithTime:[[DYAdjustTimeService shareInstance]  getCurrentTimeInterval]];
    NSInteger nowInt = [nowDate integerValue];
    
    if(dateInt > nowInt){ //dateStr大于当前时间，返回YES,否则返回NO
        return YES;
    }
    else {
        return NO;
    }
}

// 比较第一个日期是否大于第二个日期
// date格式：yyyyMMdd
+ (BOOL)compareFirstDate:(NSString *)firstDate nextDate:(NSString *)nextDate {
    if ([firstDate rangeOfString:@"-"].location != NSNotFound) {
        firstDate = [firstDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([nextDate rangeOfString:@"-"].location != NSNotFound) {
        nextDate = [nextDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    NSInteger firstInt = [firstDate integerValue];
    NSInteger nextInt = [nextDate integerValue];
    
    if (firstInt > nextInt) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
