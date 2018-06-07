//
//  DYStareMonitorStockEditCell.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 监控股票编辑cell
#import "DYBorderViewCell.h"

static NSString *DYStareMonitorStockEditCellID = @"DYStareMonitorStockEditCellIdentifier";

@interface DYStareMonitorStockEditCell : DYBorderViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectButton; //选择器
@property (weak, nonatomic) IBOutlet UIView *rootContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rootContentLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;   // 股票名称
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;   // 股票代码
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel; // 来源

@property (nonatomic, assign) BOOL isEdit;

// cell赋值
- (void)configCellName:(NSString *)name
                  code:(NSString *)codeStr
                source:(NSString *)source
                isEdit:(BOOL)isEdit
              isSelect:(BOOL)isSelect;

@end
