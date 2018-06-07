//
//  DYStareMonitorSectionHeaderView.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 自选监控tableSection-headerView
#import <UIKit/UIKit.h>

@interface DYStareMonitorSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLabel;  // title

// 获取header
+ (id)getDequeueReusableStareMonitorHeaderViewforTableView:(UITableView *)tableView;

// title赋值
- (void)setTitleLabelText:(NSString *)text;

// height
+ (CGFloat)getHeaderHeight;

@end
