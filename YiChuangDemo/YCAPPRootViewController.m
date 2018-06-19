//
//  YCAPPRootViewController.m
//  YiChuangDemo
//
//  Created by 宋骁俊 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "YCAPPRootViewController.h"
#import "YCTabBarViewController.h"
#import <YiChuangLibrary/DYYCInterface.h>

@interface YCAPPRootViewController ()<DYYCInterfaceDelegate>

@end

@implementation YCAPPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(&*self)weakSelf = self;
    
    [DYYCInterface shareInstance].delegate = self;
    [[DYYCInterface shareInstance] appStart];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf presentView];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转
-(void)presentView {
    YCTabBarViewController *tabBarController =[[YCTabBarViewController alloc]init];
    [self presentViewController:tabBarController animated:NO completion:nil];
}
#pragma mark--DYYCInterfaceDelegate
//返回设备id
- (NSString *)deviceId{
    return @"xxxxxx87";
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
    return @"userCert";
}

//返回用户id
- (NSString *)userId{
    return @"opUser";
}

//返回用户(设备)自选股信息
- (NSArray *)userStockArr{
    return @[@"600001",@"600105",@"000001",@"600050"];
}

/*
 获取baseUrl
 返回格式：{webSocketBase:@"",ycBase:@""}
 */
- (NSDictionary *)getBaseUrl{
    NSDictionary *dic = @{@"webSocketBase":@"ws://101.226.198.90:8722/",
                          @"ycBase":@"https://gw.wmcloud-stg.com/fcsc/"};
//    NSDictionary *dic = @{@"webSocketBase":@"ws://fcsc-staring.respool.wmcloud-stg.com:8722/",
//                          @"ycBase":@"http://fcsc-staring.respool.wmcloud-stg.com/"};
    return dic;
}

//沪深A股详情页跳转:(ticker:600001)
-(void)pushToStockDetailVCWithTicker:(NSString *)ticker{
    
    NSLog(@"跳转个股详情页%@",ticker);
}

@end
