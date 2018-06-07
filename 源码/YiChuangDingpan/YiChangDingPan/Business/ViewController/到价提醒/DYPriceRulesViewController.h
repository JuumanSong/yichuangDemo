//
//  DYPriceRulesViewController.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTableViewController.h"
@class DYPriceRulesService;
@class DYStareWizardPriceRuleModel;
/**
 到价提醒页
 */

@protocol DYPriceRulesViewControllerDelegate <NSObject>

@optional
// 完成创建提醒后需要跳转至VC的delegate
- (void)creatRemindDownNeedToPushVC;

@end

@interface DYPriceRulesViewController : DYTableViewController

@property (nonatomic, weak) DYPriceRulesService *service;
@property (nonatomic, weak) id<DYPriceRulesViewControllerDelegate> delegate;

- (void)setEditModel:(DYStareWizardPriceRuleModel *)model;

@end

