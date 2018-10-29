//
//  AppDelegate.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "AppDelegate.h"
#import "DYNavigationController.h"
#import "DYYCInterface.h"
#import "ViewController.h"
#import "DYProgressHUD.h"
@interface AppDelegate ()<DYYCInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DYYCInterface shareInstance].delegate = self;
    [[DYYCInterface shareInstance] appStart];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController * vc =[[ViewController alloc]init];
    DYNavigationController *rootVC = [[DYNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[DYYCInterface shareInstance] applicationWillEnterBackground];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[DYYCInterface shareInstance] applicationWillEnterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




//返回设备id
- (NSString *)deviceId{
    return @"xxxxx";
}


//返回应用id
- (NSString *)appKey{
    return @"6";
}

//返回设备类型
- (NSString *)appType{
    return @"ios";
}

//返回用户token
- (NSString *)token{
    return @"123123123xxx";
}

//返回用户id
- (NSString *)userId{
    return @"123123123";
}

//返回用户(设备)自选股信息
- (NSArray *)userStockArr{
    return @[@"600001",@"600105",@"000001",@"600050",@"603922",@"600115",@"300133",@"300134",@"300135",@"300136",@"300137"];
}

/*
 获取baseUrl
 返回格式：{webSocketBase:@"",ycBase:@""}
 */
- (NSDictionary *)getBaseUrl{
//    NSDictionary *dic = @{@"webSocketBase":@"ws://101.226.198.90:8722/",
//                          @"ycBase":@"https://gw.wmcloud-stg.com/fcsc/"};
    //    NSDictionary *dic = @{@"webSocketBase":@"ws://fcsc-staring.respool.wmcloud-stg.com:8722/",
    //                          @"ycBase":@"http://fcsc-staring.respool.wmcloud-stg.com/"};
    
        NSDictionary *dic = @{@"webSocketBase":@"ws://staretest.fcsc.com:8722/",
                              @"ycBase":@"https://staretest.fcsc.com/staringservice/"};
    
    return dic;
}


#pragma mark--DYYCInterfaceDelegate
-(void)pushToStockDetailVCWithTicker:(NSString *)ticker{
    
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [DYProgressHUD showTextHUDAddTo:self.window withDetails:[NSString stringWithFormat:@"跳转%@对应个股详情",ticker]];
}
@end
