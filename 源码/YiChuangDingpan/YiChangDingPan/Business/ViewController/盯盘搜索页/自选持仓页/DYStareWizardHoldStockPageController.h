//
//  DYStareWizardHoldStockPageController.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPageRootViewController.h"
#import "DYStareWizardSearchDelegate.h"
/**
 自选持仓page页
 */
@interface DYStareWizardHoldStockPageController : DYPageRootViewController
@property (nonatomic, weak) id<DYStareWizardSearchDelegate>delegate;

- (void)reloadTable;


@end
