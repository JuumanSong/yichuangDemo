//
//  DYNavTitleView.h
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYScrollRepeatLable.h"

@interface DYNavTitleView : UIView
@property (nonatomic,strong)UIView *defultNavView;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic,strong)DYScrollRepeatLable *titleLabel;

//自定义整个view,但默认的按钮的frame还是直接可以添加使用的
-(void)redefine;
//自定义整个view,所有frame自己实现
-(void)redefineWithSubFrame;

//设置title
- (void)setTitle:(NSString *)title;
//设置右边按钮图片
- (void)setRightBtnImage:(UIImage *)image
               withClick:(DataBlock)click;
//设置右边按钮文字
- (void)setRightBtnText:(NSString *)text
                  color:(UIColor *)color
              withClick:(DataBlock)click;
//设置左边按钮图片
- (void)setBackBtnImage:(UIImage *)image
              withClick:(DataBlock)click;

//设置导航栏为白色样式
- (void)setNavWhiteStyle;
//设置导航栏为黑色样式
- (void)setNavBlackStyle;
@end
