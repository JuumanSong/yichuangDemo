//
//  UIViewController+Toast.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "UIViewController+Toast.h"
#import "DYProgressHUD.h"
#import "DYToastUtil.h"

@implementation UIViewController (Toast)
- (void)showHUDToast:(NSString *)message {
    [DYProgressHUD showTextHUDAddTo:self.view withDetails:message];
}

- (void)showToast:(NSString *)message {
    [DYToastUtil showToastInView:self.view message:message];
}

- (void)showToast:(NSString *)message duration:(CGFloat)duration {
    [DYToastUtil showToastInView:self.view message:message durationTime:duration];
}

@end
