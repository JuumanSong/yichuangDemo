//
//  DYSegmentControlView.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/2.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYSegmentControlViewDelegate <NSObject>

// 返回segment的items，默认三个item<新闻，公告，研报>
- (NSArray *)segmentControlItems;

// segment点击事件，index = 当前选中索引
- (void)segmentControlClickWithIndex:(NSInteger)index;

@optional
// 设置首次默认选中的索引, 默认0
- (NSInteger)segmentSelectedIndex;

// 设置选中时的背景颜色，默认系统蓝色
- (UIColor *)segmentSelectBackColor;
// 设置未选中的背景颜色，默认白色
- (UIColor *)segmentBackgroundColor;

// 设置选中时的文字颜色，默认白色
- (UIColor *)segmentSelectTitleColor;
// 设置未选中时的文字颜色，默认系统蓝色
- (UIColor *)segmentTitleColor;

// 设置字体大小，默认T3
- (UIFont *)segmentTitleFont;
// 设置border的颜色
- (UIColor *)segmentBorderLayerColor;

@end

@interface DYSegmentControlView : UIView

@property (nonatomic, weak) id<DYSegmentControlViewDelegate> delegate;

// 实现代理方法后刷新UI
- (void)reloadSegmentStyle;

@end
