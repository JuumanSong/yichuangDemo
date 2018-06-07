//
//  DYViewController.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/3/30.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYViewController.h"
#import "View+MASAdditions.h"
#import "DYProgressHUD.h"
//#import <YWFeedbackFMWK/YWFeedbackKit.h>
//#import "DYLoginService.h"

//NSString * const kAlicloudFeedbackAppKey = @"24811041";
//NSString * const kAlicloudFeedbackAppSecret = @"4a6613d8d9168970c770de2d50cd3b59";

@interface DYViewController ()

@end

@implementation DYViewController

-(instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    
    //导航栏
    self.dyNavTitleView = [[DYNavTitleView alloc]init];
    if(self.navigationController.childViewControllers.firstObject == self){
        self.dyNavTitleView.backBtn.hidden = YES;
    }
    WS(weakSelf);
    [self.dyNavTitleView setBackBtnImage:nil withClick:^(id data) {
        [weakSelf backBtnclicked];
    }];
    [self.dyNavTitleView.closeBtn addTarget:self action:@selector(closeBtnclicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.dyNavTitleView];
    
    //主界面
    self.mainView = [[UIView alloc]init];
    [self.view addSubview:self.mainView];
    
    _isFirstTimeAppear = YES;
    [self initViewData];
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isVisible = YES;
    if(_isFirstTimeAppear){
        if(![self.parentViewController isKindOfClass:[UINavigationController class]]){
            [self setDyNavTitleViewHide:YES];
        }
        
        if(!self.dyNavTitleView.hidden){
            //关闭按钮
            self.dyNavTitleView.closeBtn.hidden = !(self.navigationController.childViewControllers.count>5);
        }
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.dyNavTitleView.frame = CGRectMake(0, 0, DYSelfViewWidth, DYStatusBarHeight + DYNavigationBarHeight);
    if(self.dyNavTitleView.hidden == YES){
        self.mainView.frame = CGRectMake(0, 0, DYSelfViewWidth, DYSelfViewHeight);
    }
    else{
        self.mainView.frame = CGRectMake(0, DYStatusBarHeight + DYNavigationBarHeight, DYSelfViewWidth, DYSelfViewHeight - DYStatusBarHeight - DYNavigationBarHeight);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    _isFirstTimeAppear = NO;
    _isVisible = NO;
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
}


- (void)initViewData {
    
}

- (void)initSubViews {
}


//是否显示titleview
-(void)setDyNavTitleViewHide:(BOOL)hide{
    if(hide){
        self.dyNavTitleView.hidden = YES;
        self.mainView.frame = CGRectMake(0, 0, DYSelfViewWidth, DYSelfViewHeight);
    }
    else{
        self.dyNavTitleView.hidden = NO;
        self.mainView.frame = CGRectMake(0, DYStatusBarHeight + DYNavigationBarHeight, DYSelfViewWidth, DYSelfViewHeight - DYStatusBarHeight - DYNavigationBarHeight);
    }
}

// 设置导航栏文字
- (void)setNavTitleText:(NSString *)title {
    [self.dyNavTitleView setTitle:NilToEmptyString(title)];
}

-(NSString *)getNavTitleText{
    return self.dyNavTitleView.titleLabel.text;
}

//actions
-(void)backBtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeBtnclicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma 获取网络

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    if (motion == UIEventSubtypeMotionShake) {
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
//            [self showTipsForFeedback];
//        }
//    }
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
