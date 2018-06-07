//
//  DYStareWizardSeachStockCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

/**
 搜索股票cell
 */
@interface DYStareWizardSeachStockCell : DYBorderViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteWidth;

- (void)addBtnIsAdded:(BOOL)addedFlag;

- (void)addBtnClickBlock:(DataBlock)block;

- (void)deleteBtnClickBlock:(DataBlock)block;

@end
