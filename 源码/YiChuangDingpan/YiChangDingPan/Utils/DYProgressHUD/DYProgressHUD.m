//
//  DYProgressHUD.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYProgressHUD.h"
#import "MBProgressHUD.h"


#define kIndicatorViewAlpha 0.6
#define kDurationTime 1.0

@interface MBProgressHUD (HideGesture)

- (void)addGestureToHideProgressHUD;

@end

@implementation MBProgressHUD (HideGesture)

- (void)addGestureToHideProgressHUD
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProgressHUD:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)hideProgressHUD:(UIGestureRecognizer *)gesture {
    [self hideAnimated:YES];
 
}
@end

@implementation DYProgressHUD

+ (DYProgressHUD*)shareInstance {
    static DYProgressHUD *progressHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[DYProgressHUD alloc]init];
    });
    return progressHUD;
}


+ (void)hideHUDToView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+(MBProgressHUD *)createMBProgressHUD:(UIView*)view
                                 mode:(MBProgressHUDMode)mode
                                block:(DYHUDCompletionBlock)blcok{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    if (blcok) {
        hud.completionBlock = blcok;
    }
    return hud;
}

////////////////////
////普通菊花

+ (void)showBaseHUDInWindow {
    [self showBaseHUDAddTo:[UIApplication sharedApplication].delegate.window];
}

// 显示白色的菊花
+ (void)showBaseHUDAddTo:(UIView *)view {
    [self showBaseHUDAddTo:view
                   details:nil
                 touchHide:NO
          isBlackIndicator:NO
              completBlock:nil];
}

// 显示黑色的菊花
+ (void)showBlackHUDAddTo:(UIView *)view {
    [self showBaseHUDAddTo:view
                   details:nil
                 touchHide:NO
          isBlackIndicator:YES
              completBlock:nil];
}

+ (void)showBaseHUDAddTo:(UIView *)view
                 details:(NSString *)str
               touchHide:(BOOL)touch
        isBlackIndicator:(BOOL)isBlack
            completBlock:(DYHUDCompletionBlock)block {
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [self createMBProgressHUD:view mode:MBProgressHUDModeIndeterminate block:block];
        // 无背景效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        
        // 设置菊花颜色
        for (UIView *view in hud.subviews) {
            if ([view isKindOfClass:[MBBackgroundView class]]) {
                for (UIView *indicatorV in view.subviews) {
                    if ([indicatorV isKindOfClass:[UIActivityIndicatorView class]]) {
                        if (isBlack) {
                            [(UIActivityIndicatorView *)indicatorV setColor:DYAppearanceColor(@"H8", 1.0)];
                        }else {
                            [(UIActivityIndicatorView *)indicatorV setColor:DYAppearanceColor(@"H2", 1.0)];
                        }
                    }
                }
            }
        }
        hud.detailsLabel.text = str?str:@"";
        
        if (touch) {
            [hud addGestureToHideProgressHUD];
        }
    }
}

////////////////////
////只显示文字
+ (void)showText:(NSString *)str {
    if (str) {
        [self showTextHUDAddTo:[UIApplication sharedApplication].delegate.window withDetails:str];
    }
}

+ (void)showTextHUDAddTo:(UIView *)view
         withDetails:str {
    [self showTextHUDAddTo:view details:str touchHide:NO completBlock:nil];
}

+ (void)showTextHUDAddTo:(UIView *)view
             details:(NSString *)str
           touchHide:(BOOL)touch
        completBlock:(DYHUDCompletionBlock)block {
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [self createMBProgressHUD:view mode:MBProgressHUDModeText block:block];
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        hud.detailsLabel.text = str?str:@"";
        hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        hud.detailsLabel.textColor = [UIColor whiteColor];
        if (touch) {
            [hud addGestureToHideProgressHUD];
        }
        NSTimeInterval time;
        if (str.length < 10) {
            time = 1;
        }else{
            time = 2;
        }
        [hud hideAnimated:YES afterDelay:time];
    }
}


////////////////////
////自定义View
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)str
                         duration:(double)duration
                        touchHide:(BOOL)touch
                     completBlock:(DYHUDCompletionBlock)block
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    hud = [DYProgressHUD createMBProgressHUD:view mode:MBProgressHUDModeCustomView block:block];
    hud.userInteractionEnabled = NO;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.detailsLabel.text = str?str:@"";
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    hud.detailsLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    
    if (!duration) {
        duration = kDurationTime;
    }
    if (touch) {
        [hud addGestureToHideProgressHUD];
    }
    [hud hideAnimated:YES afterDelay:duration];
}

// 显示对勾图片
+ (void)showBingGoIndicatorInView:(UIView *)view
                         message:(NSString *)str
{
    [DYProgressHUD showCustomIndicatorInView:view image:DY_ImgLoader(@"dy_optional_search_success", @"YiChuangLibrary") message:str duration:kDurationTime touchHide:NO completBlock:nil];
}

// 显示叉号图片
+ (void)showErrorIndicatorInView:(UIView *)view
                         message:(NSString *)str
{
    [DYProgressHUD showCustomIndicatorInView:view image:DY_ImgLoader(@"dy_optional_search_cancel", @"YiChuangLibrary") message:str duration:kDurationTime touchHide:NO completBlock:nil];
}

@end
