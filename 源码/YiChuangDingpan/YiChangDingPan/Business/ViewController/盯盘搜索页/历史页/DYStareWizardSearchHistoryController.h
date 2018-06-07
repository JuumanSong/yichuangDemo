//
//  DYStareWizardSearchHistoryController.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTableViewController.h"
#import "DYStareWizardSearchDelegate.h"
/**
 搜索历史页
 */
@interface DYStareWizardSearchHistoryController : DYTableViewController
@property (nonatomic, weak) id<DYStareWizardSearchDelegate>delegate;

- (void)isShowingToastBlock:(DataBlock)block endEditBlock:(DataBlock)endBlock;

@end
