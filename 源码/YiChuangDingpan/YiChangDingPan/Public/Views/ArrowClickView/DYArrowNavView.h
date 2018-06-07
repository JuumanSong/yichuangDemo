//
//  DYArrowNavView.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/27.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYArrowButton.h"

/**
 带箭头按钮的数组View
 */
@interface DYArrowNavView : UIView

//初始化
- (id)initWithArr:(NSArray *)arr AndClickedBlock:(DataBlock)block;

//初始化
- (id)initWithArr:(NSArray *)arr
  AndClickedBlock:(DataBlock)block
        withImage:(UIImage *)image
         selImage:(UIImage *)selImage;

//清除选中标记
- (void)clearSelected;
//改变分割线位置
- (void)changeBottomLineFrameToTop;
//隐藏中间分割线
- (void)hideMidLine:(BOOL)hide;
//隐藏底部分割线
- (void)hideBottomLine:(BOOL)hide;
//设置文字内容
- (void)setText:(NSString *)string
        AtIndex:(NSInteger)index;
//设置字体样式, 可以不穿参数
- (void)setLabelFont:(UIFont *)font
               color:(UIColor *)color
       selectedColor:(UIColor*)selectColor;
@end
