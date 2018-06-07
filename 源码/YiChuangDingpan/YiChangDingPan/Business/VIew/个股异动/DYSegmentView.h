//
//  DYSegmentView.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/4.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYClickLabel.h"

typedef NS_ENUM(NSInteger, SegmentType) {
    SegmentTypeDefault = 0,                      // 滚动自适应宽度类型
    SegmentTypeFullScreen,                       // 未充满时充满全屏，充满时自适应可滚动类型
};

@protocol DYSegmentViewDelegate <NSObject>

@optional
//选中的颜色;默认:B1
- (UIColor *)selectedLabelColorWithView:(UIView *)view;
//选中的字体;默认:T5
- (UIFont *)selectedLabelFontWithView:(UIView *)view;
//未选中的颜色;默认:H8
- (UIColor *)nomalLabelColorWithView:(UIView *)view;
//未选中的字体;默认:T5
- (UIFont *)nomalLabelFontWithView:(UIView *)view;
//底部线颜色
- (UIColor *)bottomLineColorWithView:(UIView *)view;

//是否显示label下的线;默认：YES
- (BOOL)showShortLineViewWithView:(UIView *)view;
//是否显示底部分割线;默认：YES
- (BOOL)showBottomLineViewWithView:(UIView *)view;
//是否自动充满宽度;默认：YES
- (SegmentType)autoAdjustFullContentView;
//内容的宽度;默认：屏幕宽度
- (CGFloat)contentViewWidth;

//数据
- (NSArray *)conentsInfoArrayWithView:(UIView *)view;
//选中的index
- (NSUInteger)contentSelectedIndexWithView:(UIView *)view;
//点击
- (void)didSelected:(DYClickLabel*)label withIndex:(NSInteger)index atView:(UIView *)view;

@end

@interface DYSegmentView : UIView

@property (nonatomic, weak) id <DYSegmentViewDelegate> delegate;

//刷新数据
- (void)reloadData;

//获取指定按钮
- (DYClickLabel *)getClickLabelAtIndex:(NSInteger)index;
//获取指定按钮文字
- (NSString *)getLabelTextAtIndex:(NSInteger)index;
//获取当前选中文字
- (NSString *)getSelectedText;

/**
 设置当前选中的index
 */
- (void)selectedIndex:(NSInteger)index;

@end
