//
//  DYViewService.h
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/21.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "APPRootViewController.h"
//#import "DYRootTabBarController.h"
#import "DYNibInitService.h"
#import "NSString+NumberFormat.h"

//应用tabbar
#define RootTabBarController         [[UITabBarController alloc]init]
//当前NavigationController
#define RootNavigationController    [[UIViewController alloc]init].navigationController


//屏幕宽高
#define DYScreenWidth [UIScreen mainScreen].bounds.size.width
#define DYScreenHeight [UIScreen mainScreen].bounds.size.height
#define DYSelfViewWidth self.view.bounds.size.width
#define DYSelfViewHeight self.view.bounds.size.height

#define DYStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define DYNavigationBarHeight 44
#define DYISVirtualHome (DYStatusBarHeight > 40)
#define DYIponeXBottomHeight 34
#define DYTabbarHeight 49

//屏幕宽高判断
#define WIDTH_EQUAL(w)  (fabs([[UIScreen mainScreen] bounds].size.width - w) <= FLT_EPSILON?YES : NO)
#define HEIGHT_EQUAL(h)  (fabs([[UIScreen mainScreen] bounds].size.height - h) <= FLT_EPSILON?YES : NO)

#define WIDTH_LARGE(w)  (fabs([[UIScreen mainScreen] bounds].size.width - w) > FLT_EPSILON && [[UIScreen mainScreen] bounds].size.width > w?YES : NO)
#define HEIGHT_LARGE(h)  (fabs([[UIScreen mainScreen] bounds].size.height - h) > FLT_EPSILON && [[UIScreen mainScreen] bounds].size.height > h?YES : NO)


//系统版本
#pragma mark - 设备系统版本相关
#define IOS_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_LATER(s)   ([[[UIDevice currentDevice] systemVersion] floatValue] >= s)

// 手机型号
/**
 *  iPhone4 or iPhone4s
 */
#define  iPhone4_4s     (DYScreenWidth == 320.f && DYScreenHeight == 480.f ? YES : NO)

/**
 *  iPhone5 or iPhone5s or iPhoneSE
 */
#define  iPhone5_5s     (DYScreenWidth == 320.f && DYScreenHeight == 568.f ? YES : NO)

/**
 *  iPhone6 or iPhone6s or iPhone 7 or iPhone 8
 */
#define  iPhone6_6s     (DYScreenWidth == 375.f && DYScreenHeight == 667.f ? YES : NO)

/**
 *  iPhone6Plus or iPhone6sPlus or iPhone7sPlus or iPhone8sPlus
 */
#define  iPhone6_6sPlus (DYScreenWidth == 414.f && DYScreenHeight == 736.f ? YES : NO)

/**
 *  iPhoneX
 */
#define  iPhoneX        (DYScreenWidth == 375.f && DYScreenHeight == 812.f ? YES : NO)

@interface DYViewService : NSObject

+ (UINavigationController *)getNowRootNavC;

@end
