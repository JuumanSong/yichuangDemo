//
//  DYMarketStatisticsModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 个股盘口数据model
 */
@interface DYMarketStatisticsModel : NSObject

@property (nonatomic,copy) NSString *ticker;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int64_t timestamp;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) CGFloat lastPrice;
@property (nonatomic,assign) CGFloat change;
@property (nonatomic,assign) CGFloat changePct;
@property (nonatomic,assign) CGFloat highPrice;
@property (nonatomic,assign) CGFloat lowPrice;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,assign) CGFloat turnoverRate;
@property (nonatomic,assign) CGFloat pettm;
@property (nonatomic,copy) NSString *marketValue;
@property (nonatomic,assign) CGFloat limitUpPrice;
@property (nonatomic,assign) CGFloat limitDownPrice;
@property (nonatomic,assign) CGFloat prevClosePrice;
@property (nonatomic,assign) CGFloat openPrice;
@property (nonatomic,assign) CGFloat amplitude;
@property (nonatomic,assign) CGFloat avgPrice;
@property (nonatomic,copy) NSString *volume;
@property (nonatomic,assign) CGFloat volumeRatio;
@property (nonatomic,assign) CGFloat pb;
@property (nonatomic,copy) NSString *mktValue;
@property (nonatomic,copy) NSString *floatShares;
@property (nonatomic,copy) NSString *totalShares;
@property (nonatomic,copy) NSString *negMktValue;
@property (nonatomic,copy) NSString *hTicker;
@property (nonatomic,assign) CGFloat hLastPrice;
@property (nonatomic,assign) CGFloat hChg;
@property (nonatomic,assign) CGFloat hChgPct;
//0:开盘；1：停牌
@property (nonatomic,assign) NSInteger suspension;
@property (nonatomic,strong) NSArray *stockTags;
@property (nonatomic,copy) NSString * mktStatus;
@property (nonatomic,assign) BOOL mktOpen;


@end
