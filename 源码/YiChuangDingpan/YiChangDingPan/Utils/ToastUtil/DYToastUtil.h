//
//  DYToastUtil.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYToastUtil : NSObject
/**
 *  仅显示提示文字
 *
 *  @param view    view
 *  @param message message
 */
+ (void)showToastInView:(UIView *)view message:(NSString *)message;


/**
 *  仅显示提示文字
 *
 *  @param view            view
 *  @param message         message
 *  @param backgroundColor 背景颜色
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor;

/**
 *  仅显示提示文字
 *
 *  @param view     view
 *  @param message  message
 *  @param position toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
               position:(id)position;

/**
 *  仅显示提示文字
 *
 *  @param view         view
 *  @param message      message
 *  @param durationTime durationTime
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime;

/**
 *  仅显示提示文字
 *
 *  @param view      view
 *  @param message   message
 *  @param alpha     alpha
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha;

/**
 *  仅显示提示文字
 *
 *  @param view         view
 *  @param message      message
 *  @param durationTime durationTime
 *  @param position     toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
               position:(id)position;

/**
 *  仅显示提示文字
 *
 *  @param view            view
 *  @param message         message
 *  @param alpha           alpha
 *  @param durationTime    durationTime
 *  @param position        toast显示位置
 *  @param backgroundColor 背景颜色
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position
        backgroundColor:(UIColor *)backgroundColor;

// 自定义图片 （图左文字右）
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message;
@end
