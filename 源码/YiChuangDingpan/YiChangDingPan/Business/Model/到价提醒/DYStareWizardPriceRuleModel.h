//
//  DYStareWizardPriceRuleModel.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 盯盘精灵到价提醒model
#import <Foundation/Foundation.h>
#import "DYStareWizardStockInfoModel.h"

@interface DYStareWizardPriceRuleModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *cId;  // 配置的唯一ID
@property (nonatomic, assign) NSInteger state;// 配置状态,0:监控中,1:达到上限,2:达到下限
@property (nonatomic, strong) DYStareWizardStockInfoModel *stockInfo; // 个股信息
@property (nonatomic, assign) CGFloat cp;   // 提醒涨价值
@property (nonatomic, assign) CGFloat cr;   // 提醒涨价幅度
@property (nonatomic, assign) CGFloat fp;   // 提醒跌价值
@property (nonatomic, assign) CGFloat fr;   // 提醒跌价幅度

@end

