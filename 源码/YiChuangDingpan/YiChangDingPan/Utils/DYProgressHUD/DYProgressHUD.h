//
//  DYProgressHUD.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DYHUDCompletionBlock)(void);

typedef NS_ENUM(NSInteger, DYHUDType) {
    DYHUDTypeLoading,
    DYHUDTypeText,
    DYHUDTypeRightImg,
    DYHUDTypeErrorImg
};

@interface DYProgressHUD : NSObject

+ (void)showBaseHUDInWindow;

/**
 显示白色的菊花
 */
+ (void)showBaseHUDAddTo:(UIView *)view;

// 显示黑色的菊花
+ (void)showBlackHUDAddTo:(UIView *)view;

/**
 显示菊花加载中
 @param view 显示到的View
 @param str 文字描述
 @param touch 是否可以点击取消加载
 @param block 加载隐藏回调
 */
+ (void)showBaseHUDAddTo:(UIView *)view
                 details:(NSString *)str
               touchHide:(BOOL)touch
        isBlackIndicator:(BOOL)isBlack
            completBlock:(DYHUDCompletionBlock)block;

/**
 显示文字提示
 */

+ (void)showText:(NSString *)str;

+ (void)showTextHUDAddTo:(UIView *)view
             withDetails:(NSString *)str;

/**
 显示文字提示中
 @param view 显示到的View
 @param str 文字描述
 @param touch 是否可以点击取消加载
 @param block 加载隐藏回调
 */
+ (void)showTextHUDAddTo:(UIView *)view
                 details:(NSString *)str
               touchHide:(BOOL)touch
            completBlock:(DYHUDCompletionBlock)block;


+ (void)showBingGoIndicatorInView:(UIView *)view
                          message:(NSString *)str;

+ (void)showErrorIndicatorInView:(UIView *)view
                          message:(NSString *)str;
/**
 隐藏加载

 @param view 加载的view
 */
+ (void)hideHUDToView:(UIView *)view;


@end
