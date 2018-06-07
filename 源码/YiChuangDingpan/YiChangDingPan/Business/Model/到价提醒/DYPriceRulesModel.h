//
//  DYPriceRulesModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DYPriceStockModel;

@interface DYPriceRulesModel : NSObject<YYModel>
//配置的唯一ID
@property (nonatomic,copy) NSString *rulesId;
// 配置状态, 0: 监控中, 1: 达到上限, 2: 达到下限
@property (nonatomic,assign) NSInteger state;
//
@property (nonatomic, strong) DYPriceStockModel *tickerModel;
//提醒涨价值
@property (nonatomic,assign) CGFloat cp;
//提醒涨价幅度
@property (nonatomic,assign) CGFloat cr;
//提醒跌价值
@property (nonatomic,assign) CGFloat fp;
//提醒跌价幅度
@property (nonatomic,assign) CGFloat fr;

@end



@interface DYPriceStockModel : NSObject
@property (nonatomic,copy) NSString *t;
@property (nonatomic,copy) NSString *e;
@property (nonatomic,copy) NSString *a;

@end
