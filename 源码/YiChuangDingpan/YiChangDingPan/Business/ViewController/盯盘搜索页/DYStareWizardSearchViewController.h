//
//  DYStareWizardSearchViewController.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTableViewController.h"
#import "DYStareWizardSearchDelegate.h"
/**
 盯盘搜索-添加页
 */
@interface DYStareWizardSearchViewController : DYTableViewController

@property (nonatomic, weak) id<DYStareWizardSearchDelegate>delegate;

@end
