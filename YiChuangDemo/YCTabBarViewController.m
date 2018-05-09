//
//  YCTabBarViewController.m
//  YiChuangDemo
//
//  Created by 宋骁俊 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "YCTabBarViewController.h"
#import "ViewController.h"

@interface YCTabBarViewController ()

@end

@implementation YCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
    NSArray *titleArray = @[@"首页",@"行情",@"交易",@"数据",@"我的"];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    [self navigationVCComPare:nav1 SetTitle:titleArray[0] image:nil selImage:nil];
    
    ViewController *vc2 = [[ViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    [self navigationVCComPare:nav2 SetTitle:titleArray[1] image:nil selImage:nil];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    [self navigationVCComPare:nav3 SetTitle:titleArray[2] image:nil selImage:nil];
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    [self navigationVCComPare:nav4 SetTitle:titleArray[3] image:nil selImage:nil];
    
    UIViewController *vc5 = [[UIViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    [self navigationVCComPare:nav5 SetTitle:titleArray[4] image:nil selImage:nil];
    
    
    self.viewControllers = @[nav1, nav2, nav3, nav4, nav5];
    self.selectedIndex = 0;
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationVCComPare:(UINavigationController *)navigationVC
                   SetTitle:(NSString *)titleStr
                      image:(NSString *)imageStr
                   selImage:(NSString *)selImageStr
{
    [navigationVC setTitle:titleStr];
    navigationVC.tabBarItem.image =  [UIImage imageNamed:imageStr];
    UIImage *img3 =[UIImage imageNamed:selImageStr];
    img3 = [img3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationVC.tabBarItem.selectedImage = img3;
    navigationVC.interactivePopGestureRecognizer.enabled =NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
