//
//  DYRoboViewHUD.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/27.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DYRoboViewType) {
    DYRoboViewTypeNormal =0,        //默认隐藏
    DYRoboViewTypeNoData ,          //显示无数据
    DYRoboViewTypeNoNetWork ,       //显示无网络
    DYRoboViewTypeIsLoading ,       //显示加载萝卜loading
    DYRoboViewTypeIsLoadingText,    //显示加载文字
    DYRoboViewTypeGoSubscribe,      //去订阅
    DYRoboViewTypeSubscribeGoLogin, //订阅中去登录
    DYRoboViewTypeNoNetWorkCanFresh ,//显示无网络，并有刷新按钮
    DYRoboViewTypeAddView,          //显示十字添加View
    DYRoboViewTypeInicatorLoad,    //显示菊花
};


/**
 View覆盖层
 */
@interface DYRoboViewHUD : UIView

+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type;


+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              withBlock:(DataBlock)block;

// 可以设置viewHud的背景颜色,默认白色
+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)color;

+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)color
              withBlock:(DataBlock)block;

// 自定义content
+ (void)showRoboStateTo:(UIView *)view
                content:(NSString *)content
                  state:(DYRoboViewType)type
              backColor:(UIColor *)backColor
              withBlock:(DataBlock)block;

+ (void)removeHUDForView:(UIView *)view;

@end



