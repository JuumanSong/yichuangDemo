//
//  DYDemoViewController.m
//  YiChuangDemo
//
//  Created by 周志忠 on 2018/5/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYDemoViewController.h"
#import <YiChuangLibrary/DYYCInterface.h>

#define DYScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DYDemoViewController ()
@property (nonatomic, strong) UIView *stockView;
@property (nonatomic, strong) UIView *plateView;
@end

@implementation DYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"异动入口Demo";
    self.view.backgroundColor = UIColor.grayColor;
    
    //添加个股入口view
    self.stockView =  [[DYYCInterface shareInstance]dyStocksStareBarViewWithPushBlock:^(id data) {
        //点击回调，push到相应页面
        UIViewController *vc =[[DYYCInterface shareInstance]dyStareStockVC:1];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.stockView.frame= CGRectMake(0, 150, DYScreenWidth, 35);
    [self.view addSubview:self.stockView];

    //添加板块入口view
    self.plateView =[[DYYCInterface shareInstance]dyThemeStareBarViewWithPushBlock:^(id data) {
        //点击回调，push到相应页面
        UIViewController *vc =[[DYYCInterface shareInstance]dyStareStockVC:2];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.plateView.frame = CGRectMake(0, 220, DYScreenWidth, 35);
    [self.view addSubview:self.plateView];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillAppear: animated];
    //开启个股监测
    [[DYYCInterface shareInstance]stocksStareOpen:YES target:self.stockView];
    //开启板块监测
    [[DYYCInterface shareInstance]themeStareOpen:YES target:self.plateView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //关闭个股监测
    [[DYYCInterface shareInstance]stocksStareOpen:NO target:self.stockView];
    //关闭板块监测
    [[DYYCInterface shareInstance]themeStareOpen:NO target:self.plateView];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
