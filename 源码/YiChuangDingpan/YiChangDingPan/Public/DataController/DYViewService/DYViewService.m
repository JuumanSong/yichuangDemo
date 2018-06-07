//
//  DYViewService.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/21.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYViewService.h"

@implementation DYViewService
//#warning message
//RootNavigationController
+ (UINavigationController *)getNowRootNavC {
    UITabBarController *tabBarController = RootTabBarController;
    return tabBarController.selectedViewController;
}

@end
