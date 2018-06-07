//
//  UIViewController+Loading.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRoboViewHUD.h"

/**
 加载菊花、覆盖层
 */
@interface UIViewController (Loading)

//当前View上加载菊花，白色菊花
- (void)showLoading;
// 当前View上加载菊花，黑色菊花
- (void)showBlackLoading;
//当前View上隐藏菊花
- (void)hideLoading;

//window上加载菊花
- (void)showLoadingInWindow;
//window上隐藏菊花
- (void)hideLoadingInWindow;


/**
 加载萝卜动画

 @param view view
 */
- (void)showRobotLoading:(UIView *)view;
/**
 隐藏萝卜动画

 @param view view
 */
- (void)hideRobotLoading:(UIView *)view;


/**
 根据类型展示覆盖层

 @param view superView
 @param type 类型
 */
- (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type;

-(void)showRoboStateTo:(UIView *)view
                 state:(DYRoboViewType)type
             withBlock:(DataBlock)block;


/**
 根据类型展示覆盖层

 @param view        superView
 @param backColor   覆盖层的背景颜色
 @param type        类型
 */
- (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)backColor;

-(void)showRoboStateTo:(UIView *)view
                 state:(DYRoboViewType)type
             backColor:(UIColor *)backColor
             withBlock:(DataBlock)block;
@end

