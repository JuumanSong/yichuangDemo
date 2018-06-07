//
//  UIViewController+Toast.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Toast)

/**
 HUD的toast弹框
 
 @param message string
 */
- (void)showHUDToast:(NSString *)message;

/**
 自己的toast弹框
 
 @param message string
 */
- (void)showToast:(NSString *)message;


/**
 自己的toast弹框

 @param message     弹框内容
 @param duration    toast时长
 */
- (void)showToast:(NSString *)message duration:(CGFloat)duration;

@end
