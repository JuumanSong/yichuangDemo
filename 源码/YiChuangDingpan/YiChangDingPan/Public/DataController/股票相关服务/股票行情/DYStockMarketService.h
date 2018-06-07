//
//  DYStockMarketService.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/17.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYStockMarketModel.h"
//个股盘口
#import "DYMarketStatisticsModel.h"
//个股分时
#import "DYTimeShareModel.h"
//个股五档
#import "DYStockFiveGearModel.h"
//个股交易明细
#import "DYStockTradeDetailModel.h"



/**
 股票行情相关
 */
@interface DYStockMarketService : NSObject

//返回当前是否交易时间
//周一至周五 8:55~11:35&12:55~15:05
+ (BOOL)checkIsMarketTime;

//获取股票行情
+ (void)getStockMarketInfo:(NSArray <DYStockMarketModel*>*)array withSuccess:(void(^)(id data))success fail:(void(^)(id data))fail;


@end
