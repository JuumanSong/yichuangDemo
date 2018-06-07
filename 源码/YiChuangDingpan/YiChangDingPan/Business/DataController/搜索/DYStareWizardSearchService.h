//
//  DYStareWizardSearchService.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYStockMarketModel.h"
#import "DYStockPropertyService.h"

@interface DYStareWizardSearchService : NSObject

#pragma mark 用户相关
//获取用户股票
+ (NSArray <DYStockPropertyItem*>*)getAllStockMarket;

#pragma mark 历史记录

+ (NSArray *)getHistoryData;

+ (void)saveHistoryModel:(DYStockPropertyItem *)model;

+ (void)deleteModel:(DYStockPropertyItem *)model;

+ (void)deleteAllHistory;


@end
