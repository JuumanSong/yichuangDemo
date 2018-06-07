//
//  DYHasReadService.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/28.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYHasReadService.h"

@implementation DYHasReadService


//获取是否已读新闻
+(BOOL)getNewsHasReadById:(NSString *)nId{
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_NewsIDs,nId];
    NSString *str = loadFromCacheWithType(key, JMDataTypeEnumString);
    if(str&&str.length>0){
        return YES;
    }
    else{
        return NO;
    }
}

//保存新闻已读状态
+(void)setNewsHasReadById:(NSString *)nId{
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_NewsIDs,nId];
    NSTimeInterval time = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    saveToCacheWithType(key, timeStr, JMDataTypeEnumString);
}

//获取是否已读公告
+(BOOL)getAnnounceHasReadById:(NSString *)nId{
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_AnnounceIDs,nId];
    NSString *str = loadFromCacheWithType(key, JMDataTypeEnumString);
    if(str&&str.length>0){
        return YES;
    }
    else{
        return NO;
    }
}

//保存公告已读状态
+(void)setAnnounceHasReadById:(NSString *)nId{
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_AnnounceIDs,nId];
    NSTimeInterval time = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    saveToCacheWithType(key, timeStr, JMDataTypeEnumString);
}


//获取是否已读研报
+(BOOL)getReportHasReadById:(NSString *)nId{
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_ReportIDs,nId];
    NSString *str = loadFromCacheWithType(key, JMDataTypeEnumString);
    if(str&&str.length>0){
        return YES;
    }
    else{
        return NO;
    }
}

//保存研报已读状态
+(void)setReportHasReadById:(NSString *)nId {
    NSString *key = [NSString stringWithFormat:@"%@/%@",CK_ReportIDs,nId];
    NSTimeInterval time = [[DYAdjustTimeService shareInstance]getCurrentTimeInterval];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    saveToCacheWithType(key, timeStr, JMDataTypeEnumString);
}
@end
