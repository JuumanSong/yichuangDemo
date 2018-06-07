//
//  DYNavigationController.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/26.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYNavigationController.h"

@interface DYNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation DYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count == 1) {
        //除了root都隐藏导航栏
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([navigationController.viewControllers count] > 1) {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        else
        {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}



#pragma mark - Oriention
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
