//
//  DYStareMonitorSetHeaderView.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 自选监控编辑个股headerView
#import <UIKit/UIKit.h>

@protocol DYStareMonitorSetHeaderViewDelegate <NSObject>

// 获取个股数目
- (NSInteger)getStockCount;

// 编辑按钮点击事件
- (void)editStockClick;

@end

@interface DYStareMonitorSetHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *countLabel;  //数据label
@property (weak, nonatomic) IBOutlet UIButton *editButton; //编辑按钮

@property (nonatomic, weak) id<DYStareMonitorSetHeaderViewDelegate> delegate;

// 获取个股数目
- (void)reloadCountLabelText;

@end
