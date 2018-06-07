//
//  DYHasReadService.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/28.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 新闻公告研报已读未读记录
 */
@interface DYHasReadService : NSObject


//获取是否已读新闻
+(BOOL)getNewsHasReadById:(NSString *)nId;

//保存新闻已读状态
+(void)setNewsHasReadById:(NSString *)nId;


//获取是否已读公告
+(BOOL)getAnnounceHasReadById:(NSString *)nId;

//保存公告已读状态
+(void)setAnnounceHasReadById:(NSString *)nId;

//获取是否已读研报
+(BOOL)getReportHasReadById:(NSString *)nId;

//保存研报已读状态
+(void)setReportHasReadById:(NSString *)nId;

@end
