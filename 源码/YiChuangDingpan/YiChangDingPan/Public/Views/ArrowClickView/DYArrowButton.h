//
//  DYArrowButton.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/26.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 带右边箭头的按钮*(如资讯中的)
 */
@interface DYArrowButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

- (void)setLabelFont:(UIFont *)font
               color:(UIColor *)color
       selectedColor:(UIColor*)selectColor;

- (void)setImageViewImage:(UIImage *)image
            selectedImage:(UIImage *)selectedImage;


- (void)setBtnSelected:(BOOL)selected;
/**
 点击事件
 @param block block
 */
- (void)arrowButtonClick:(DataBlock)block;

- (void)resetTextFrame;
@end
