//
//  DYPriceRulesService.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYStareWizardPriceRuleModel.h"
#import "DYStockPropertyService.h"

@interface DYPriceRulesService : NSObject

//到价股票
@property (nonatomic, strong) DYStareWizardPriceRuleModel *stockModel;
//我的设置的股票
@property (nonatomic, strong) NSArray *rulesArray;

// 获取用户到价提醒配置
- (void)getStareWizardPriceRulesWithResultBlock:(void(^)(id data))block;

// 设置用户到价提醒
+ (void)setStareWizardPriceRuleWithInfo:(DYStareWizardPriceRuleModel *)model resultBlock:(void(^)(id data))block;

//获取行情
- (void)getStockMarket:(NSArray *)array WithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail;

//添加股票
- (void)rePlaceChooseStock:(DYStockPropertyItem *)item;
//添加股票
- (void)rePlaceChooseStockCode:(NSString *)secId;

//设置输入的值
- (void)setValue:(NSString *)str withPrice:(BOOL)isPrice withRise:(BOOL)isRise;
//输入变化的值，返回数据
- (NSDictionary *)textChangeValue:(CGFloat)value withPrice:(BOOL)isPrice withRise:(BOOL)isRise;

//获取已存在的用户ID
- (NSString *)getExistDataIdByTicker:(NSString *)ticker;

@end
