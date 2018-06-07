//
//  DYStareMonitorStockEditBottomView.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 监控股票编辑页面-底部工具栏
#import <UIKit/UIKit.h>

@protocol DYStareMonitorStockEditBottomViewDelegate <NSObject>

- (void)stareMonitorEditToolViewClickWithTag:(NSInteger)tag;

@end

@interface DYStareMonitorStockEditBottomView : UIView

@property (nonatomic, strong) UIView *topLineView;          // 顶部分割线
@property (nonatomic, strong) UIImageView *checkImageView;  // 选择器
@property (nonatomic, strong) UILabel *leftLabel;           // '全选'label
@property (nonatomic, strong) UIButton *leftButton;         // 左侧点击按钮
@property (nonatomic, strong) UILabel *rightLabel;          // ‘删除’label
@property (nonatomic, strong) UIButton *rightButton;        // 右侧点击按钮

@property (nonatomic, weak) id<DYStareMonitorStockEditBottomViewDelegate> delegate;

// 刷新UI
- (void)reloadUIIsSelectAll:(BOOL)isAll
                deleteCount:(NSInteger)count;

// 返回高度
+ (CGFloat)getBottomHeight;

@end
