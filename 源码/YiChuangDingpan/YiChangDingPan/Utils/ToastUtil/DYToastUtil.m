//
//  DYToastUtil.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYToastUtil.h"

static const CGFloat DYToastPadding = 10.0;
static const NSString * DYToastBottomPosition = @"bottom";
static const NSString * DYToastNaviCenterPosition = @"NaviOfCenter";   // 有导航栏的中心点
static const NSString * DYToastCenterPosition = @"center";             // 无导航栏的中心点

@implementation DYToastUtil

// 仅显示提示文字
+ (void)showToastInView:(UIView *)view message:(NSString *)message
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:nil];
    [DYToastUtil showToast:toast onView:view alpha:0 duration:1.0 position:DYToastNaviCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:backgroundColor];
    [DYToastUtil showToast:toast onView:view alpha:0 duration:0 position:DYToastNaviCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
               position:(id)position
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:nil];
    [DYToastUtil  showToast:toast onView:view alpha:0 duration:0 position:position];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:nil];
    [DYToastUtil showToast:toast onView:view alpha:0 duration:durationTime position:DYToastNaviCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:nil];
    [DYToastUtil  showToast:toast onView:view alpha:alpha duration:0 position:DYToastNaviCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
               position:(id)position
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:nil];
    [DYToastUtil showToast:toast onView:view alpha:0 duration:durationTime position:position];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position
        backgroundColor:(UIColor *)backgroundColor
{
    UIView *toast = [DYToastUtil toastInView:view image:nil message:message toastBackGroundColor:backgroundColor];
    [DYToastUtil showToast:toast onView:view alpha:alpha duration:durationTime position:position];
}




#pragma mark - 自定义图片（图左文字右）
// 自定义图片 （图左文字右）
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
{
    UIView *toast = [DYToastUtil toastInView:view image:image message:message toastBackGroundColor:nil];
    [DYToastUtil showToast:toast onView:view alpha:0 duration:0 position:DYToastNaviCenterPosition];
}


// 创建toast
+ (UIView *)toastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
{
    if (image == nil && message == nil) {
        return nil;
    }
    
    UIImageView *imageView = nil;
    UILabel *messageLabel = nil;
    
    // toastView
    UIView *toastView = [[UIView alloc] init];
    if (!backgroundColor) {
        toastView.backgroundColor = DYAppearanceColor(@"H13",0.8);
    }
    toastView.layer.cornerRadius = 3;
    
    // imageView
    if (image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(DYToastPadding, DYToastPadding, image.size.width, image.size.height);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    if (imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = DYToastPadding;
    }else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    // messageLabel
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.text = message;
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [UIFont systemFontOfSize:14];
        
        CGFloat toastMaxWidth = 0.8;
        CGSize maxSizeMessage = CGSizeMake((view.bounds.size.width * toastMaxWidth) - imageWidth, view.bounds.size.height * toastMaxWidth);
        NSDictionary *attributes = @{NSFontAttributeName:messageLabel.font};
        CGRect expectedRectMessage = [message boundingRectWithSize:maxSizeMessage options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedRectMessage.size.width, expectedRectMessage.size.height);
    }
    
    CGFloat labelWidth, labelHeight,labelLeft, labelTop;
    if (messageLabel != nil) {
        labelWidth = messageLabel.bounds.size.width;
        labelHeight = messageLabel.bounds.size.height;
        labelLeft = imageLeft + imageWidth + DYToastPadding;
        labelTop = DYToastPadding;
    }else {
        labelWidth = labelHeight = labelLeft = labelTop = 0.0;
    }
    
    // toastView frame
    CGFloat toastViewW = MAX((imageWidth + (DYToastPadding * 2)),labelLeft + labelWidth + DYToastPadding);
    CGFloat toastViewH = MAX((labelHeight + DYToastPadding + labelTop), (imageHeight + (DYToastPadding * 2)));
    toastView.frame = CGRectMake(0, 0, toastViewW, toastViewH);
    
    // messageLabel frame
    if (messageLabel != nil) {
        messageLabel.frame = CGRectMake(labelLeft, labelTop, labelWidth, labelHeight);
        [toastView addSubview:messageLabel];
    }
    
    // imageView frame
    if (imageView != nil) {
        CGRect imageViewF = imageView.frame;
        imageViewF.origin.y = (toastView.frame.size.height - imageHeight) * 0.5;
        imageView.frame = imageViewF;
        [toastView addSubview:imageView];
    }
    
    return toastView;
}
// 显示toast
+ (void)showToast:(UIView *)toast onView:(UIView *)superView alpha:(CGFloat)alpha duration:(CGFloat)durationTime position:(id)point {
    CGPoint centerPoint = [self centerPointForPosition:point withToast:toast withView:superView];
    if ([superView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)superView;
        centerPoint.y += scrollView.contentOffset.y;
    }
    toast.center = centerPoint;
    [superView addSubview:toast];
    
    if (!alpha) {
        alpha = 1.0;
    }
    toast.alpha = alpha;
    
    // animation
    if (!durationTime) {
        durationTime = 1;
    }
    
    [UIView animateWithDuration:durationTime
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:durationTime
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

// toast frame
+ (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast withView:(UIView *)view {
    if([point isKindOfClass:[NSString class]]) {
        
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(view.bounds.size.width/2, (toast.frame.size.height / 2) + DYToastPadding);
            
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(view.bounds.size.width/2, (view.bounds.size.height - (toast.frame.size.height / 2)) - DYToastPadding);
            
        } else if([point caseInsensitiveCompare:@"NaviOfCenter"] == NSOrderedSame) {
            // 返回有导航栏的中心点
            return CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2 - 50);
            
        }else if ([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            // 返回无导航栏的中心点
            return CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:DYToastBottomPosition withToast:toast withView:view];
}

@end
