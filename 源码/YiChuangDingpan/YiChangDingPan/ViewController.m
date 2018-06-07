//
//  ViewController.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "ViewController.h"
#import "DYYC_PlateMoveEnterView.h"
#import "DYYCStockBarIndexView.h"
@interface ViewController ()
@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.v1 =  [[DYYCInterface shareInstance]dyStocksStareBarViewWithPushBlock:^(id data) {
        UIViewController *vc =[[DYYCInterface shareInstance]dyStareStockVC:1];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.v1.frame= CGRectMake(0, 220, DYSelfViewWidth, 35);
    [self.view addSubview:self.v1];
    
    self.v2 =[[DYYCInterface shareInstance]dyThemeStareBarViewWithPushBlock:^(id data) {
        UIViewController *vc =[[DYYCInterface shareInstance]dyStareStockVC:2];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.v2.frame = CGRectMake(0, 150, DYScreenWidth, 35);
    [self.view addSubview:self.v2];
 
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[DYYCInterface shareInstance]stocksStareOpen:YES target:self.v1];
    [[DYYCInterface shareInstance]themeStareOpen:YES target:self.v2];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[DYYCInterface shareInstance]stocksStareOpen:NO target:self.v1];
    [[DYYCInterface shareInstance]themeStareOpen:NO target:self.v2];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
