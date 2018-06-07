//
//  DYStareMonitorStockEditHeaderView.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 监控股票编辑headerView
#import <UIKit/UIKit.h>

@interface DYStareMonitorStockEditHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *rootContentView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel; // countLabel
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton; // 添加按钮
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, copy) DataBlock clickBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottonLine;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

// 赋值
- (void)configStockCount:(NSString *)count
              clickBlock:(DataBlock)block;

// height
+ (CGFloat)getHeaderHeight;

@end
