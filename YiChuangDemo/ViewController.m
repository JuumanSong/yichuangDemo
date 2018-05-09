//
//  ViewController.m
//  YiChuangDemo
//
//  Created by 黄义如 on 2018/4/25.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "ViewController.h"
#import "DYDemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(130, 150, 100, 50)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"异动监控" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)action {
    
    UIViewController *vc = [[DYDemoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
