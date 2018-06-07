//
//  DYStockMarketModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/7.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,KPriceFreshType) {
    KPriceFreshTypeDefault =0,
    KPriceFreshTypeRise,
    KPriceFreshTypeDecrease
};

/**
 股票行情信息
 */
@interface DYStockMarketModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *secId;
@property (nonatomic,copy) NSString *exchangeCD;
@property (nonatomic,copy) NSString *ticker;
@property (nonatomic,assign) int64_t timestamp;
@property (nonatomic,assign) Float64 openPrice;
@property (nonatomic,assign) Float64 lastPrice;
@property (nonatomic,copy) NSString *shortNM;
@property (nonatomic,assign) Float64 changePct;
@property (nonatomic,assign) Float64 prevClosePrice;
@property (nonatomic,assign) Float64 highPrice;
@property (nonatomic,assign) Float64 lowPrice;
@property (nonatomic,assign) Float64 volume;
@property (nonatomic,assign) Float64 suspension;
@property (nonatomic,assign) Float64 value;
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,assign) NSInteger orderIndex;
@property (nonatomic, strong)NSString* secType;
//股票当前价变动状态，0：不变;1:变红;2:变绿
@property (nonatomic, assign)KPriceFreshType priceFreshType;

@end
