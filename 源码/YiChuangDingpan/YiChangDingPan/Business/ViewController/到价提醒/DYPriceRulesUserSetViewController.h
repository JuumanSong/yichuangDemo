//
//  DYPriceRulesUserSetViewController.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTableViewController.h"
@class DYPriceRulesService;
/**
 到价提醒我的设置页
 */
@interface DYPriceRulesUserSetViewController : DYTableViewController

@property (nonatomic, weak) DYPriceRulesService *service;

- (void)editClickBlock:(DataBlock)block;

@end
