//
//  DYAdjustTimeService.m
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYAdjustTimeService.h"
#import "DYSystemDataSource.h"

static DYAdjustTimeService* gDYAdjustTimeService = nil;

@interface DYAdjustTimeService()
@property(nonatomic)NSInteger timeGap;//手机时间戳-系统时间戳
@end

@implementation DYAdjustTimeService

//单例
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDYAdjustTimeService = [DYAdjustTimeService new];
        //获取本地差值
        NSNumber *nub = loadFromCacheWithType(CK_ServerTimeGap, JMDataTypeEnumObject);
        if(nub){
            gDYAdjustTimeService.timeGap = [nub integerValue];
        }
        else{
            gDYAdjustTimeService.timeGap = 0;
        }
    });
    return gDYAdjustTimeService;
}

//获取服务器时间戳，与本地时间戳比较将差值保存本地
- (void)checkServerTime{
    WS(weakSelf);
    [DYSystemDataSource getServerTimeInterval:nil Success:^(NSInteger code, id data, NSString *message) {
        if (data >0) {
            NSTimeInterval serverInterval = (NSTimeInterval)[data longLongValue]/1000.0;
            NSDate *sysNow = [NSDate date];
            NSTimeInterval sysInterval = [sysNow timeIntervalSince1970];
            weakSelf.timeGap = sysInterval - serverInterval;
            saveToCacheWithType(CK_ServerTimeGap, [NSNumber numberWithInteger:weakSelf.timeGap], JMDataTypeEnumObject);
        }
    } Fail:^(NSError *error) {
        
    }];
}


//获取当前服务器时间
- (NSDate*)getCurrentTime{
    NSTimeInterval serverInterval = [self getCurrentTimeInterval];
    return [NSDate dateWithTimeIntervalSince1970:serverInterval];
}

//获取当前服务器时间戳
- (NSTimeInterval)getCurrentTimeInterval{
    NSDate *sysNow = [NSDate date];
    NSTimeInterval sysInterval = [sysNow timeIntervalSince1970];
    NSTimeInterval serverInterval = sysInterval - self.timeGap;
    return serverInterval;
}

//获取当前服务器北京时区成分
- (NSDateComponents*)getCurrentTimeComponentsOfBeiJing{
    NSTimeInterval timeInterval = [self getCurrentTimeInterval];
    return [self getBeiJingTimeComponentsByTimeInterval:timeInterval];
}

//获取当前服务器手机时区成分
- (NSDateComponents*)getCurrentTimeComponentsOfSystem{
    NSTimeInterval timeInterval = [self getCurrentTimeInterval];
    return [self getSystemTimeComponentsByTimeInterval:timeInterval];
}

//-------------------------------------------------------------

//根据时间戳获取北京时区成分
-(NSDateComponents*)getBeiJingTimeComponentsByTimeInterval:(NSTimeInterval)timeInterval{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//阳历
    [calendar setTimeZone:BeiJingTimeZone];
    NSDateComponents *comps;// = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    comps = [calendar components:unitFlags fromDate:pDate];
    return comps;
}


//根据时间戳获取服务器时区成分
-(NSDateComponents*)getSystemTimeComponentsByTimeInterval:(NSTimeInterval)timeInterval{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//阳历
    [calendar setTimeZone:SystrmTimeZone];
    NSDateComponents *comps;// = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    comps = [calendar components:unitFlags fromDate:pDate];
    return comps;
}
@end
