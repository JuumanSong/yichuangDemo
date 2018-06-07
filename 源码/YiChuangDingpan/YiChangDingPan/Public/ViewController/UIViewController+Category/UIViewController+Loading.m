//
//  UIViewController+Loading.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "DYProgressHUD.h"
#import "DYToastUtil.h"

@implementation UIViewController (Loading)
#pragma 加载菊花的方法，在子类中重写设置
- (void)showLoading {
    [DYProgressHUD showBaseHUDAddTo:self.view];
}

- (void)showBlackLoading {
    [DYProgressHUD showBlackHUDAddTo:self.view];
}

- (void)hideLoading {
    [DYProgressHUD hideHUDToView:self.view];
}


- (void)showLoadingInWindow {
    [DYProgressHUD showBaseHUDInWindow];
}

- (void)hideLoadingInWindow {
    [DYProgressHUD hideHUDToView:[UIApplication sharedApplication].delegate.window];
}


- (void)showRobotLoading:(UIView *)view {
    [DYRoboViewHUD showRoboStateTo:view state:DYRoboViewTypeIsLoading];
}

- (void)hideRobotLoading:(UIView *)view {
    [DYRoboViewHUD showRoboStateTo:view state:DYRoboViewTypeNormal];
}

- (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type {
    [DYRoboViewHUD showRoboStateTo:view state:type];
}

-(void)showRoboStateTo:(UIView *)view
                 state:(DYRoboViewType)type
             withBlock:(DataBlock)block {
     [DYRoboViewHUD showRoboStateTo:view state:type withBlock:block];
}

- (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)backColor {
    [DYRoboViewHUD showRoboStateTo:view state:type backColor:backColor];
}

-(void)showRoboStateTo:(UIView *)view
                 state:(DYRoboViewType)type
             backColor:(UIColor *)backColor
             withBlock:(DataBlock)block {
    [DYRoboViewHUD showRoboStateTo:view state:type backColor:backColor withBlock:block];
}

@end

