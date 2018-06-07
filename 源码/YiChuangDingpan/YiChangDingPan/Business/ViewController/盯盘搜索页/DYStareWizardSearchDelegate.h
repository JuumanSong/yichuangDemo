//
//  DYStareWizardSearchDelegate.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DYStockPropertyItem;
@protocol DYStareWizardSearchDelegate <NSObject>

//是否选中及model, fromStatus:1, 自选股添加; 2, 手工添加; 3, 持仓股添加
- (void)stockPropertyItemSelected:(BOOL)selected
                        withModel:(DYStockPropertyItem *)item
                       fromStatus:(NSInteger)status;
//是否显示添加按钮
- (BOOL)showAddedFlag;

@optional
//判断是否添加
- (BOOL)judgeStockItemIsAdded:(DYStockPropertyItem *)item;
@end
