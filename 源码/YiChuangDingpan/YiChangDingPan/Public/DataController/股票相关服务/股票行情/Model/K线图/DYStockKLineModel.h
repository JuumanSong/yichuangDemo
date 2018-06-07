//
//  DYStockKLineModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/22.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 k线model
 high 最高价
 low 最低价
 open 开盘价
 close 收盘价
 chg 涨跌幅
 chgPct 涨跌幅百分比
 volume 交易量
 value 交易额
 */
@interface DYStockKLineModel : NSObject

@property (nonatomic,copy) NSString *date;
@property (nonatomic,assign) CGFloat high;
@property (nonatomic,assign) CGFloat low;
@property (nonatomic,assign) CGFloat open;
@property (nonatomic,assign) CGFloat close;
@property (nonatomic,assign) CGFloat chg;
@property (nonatomic,assign) CGFloat chgPct;
@property (nonatomic,assign) CGFloat volume;
@property (nonatomic,assign) CGFloat value;
@property (nonatomic,assign) CGFloat ma5;
@property (nonatomic,assign) CGFloat ma10;
@property (nonatomic,assign) CGFloat ma20;
@property (nonatomic,assign) CGFloat dea;
@property (nonatomic,assign) CGFloat diff;
@property (nonatomic,assign) CGFloat macd;
@property (nonatomic,assign) CGFloat turnover;
@property (nonatomic,assign) CGFloat pettm;
@property (nonatomic,assign) CGFloat marketValue;
@property (nonatomic,assign) BOOL noMACD;
@property (nonatomic,assign) CGFloat preClosePrice;

+ (instancetype)initWithDic:(NSDictionary *)dic;
@end
