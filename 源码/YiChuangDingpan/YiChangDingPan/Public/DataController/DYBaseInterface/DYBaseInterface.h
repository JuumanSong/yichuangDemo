//
//  DYBaseInterface.h
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/2/1.
//  Copyright © 2018年 datayes. All rights reserved.
//  功能模块(业务层)暴露接口基类

#import <Foundation/Foundation.h>
#import "DYNavigationController.h"

@interface DYBaseInterface : NSObject

//返回模块存在的根UINavigationController{没有就不返回}
+ (DYNavigationController *)getRootNavigation;

//app启动时调用
+ (void)AppStart;

@end
