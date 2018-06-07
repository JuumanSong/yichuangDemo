//
//  UIView+Extension.h
//  UIFiterDemo
//
//  Created by wyy on 16/10/12.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property(nonatomic) CGFloat left;

@property(nonatomic) CGFloat right;

@property(nonatomic) CGFloat top;

@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;

@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat offsetX;

@property(nonatomic) CGFloat offsetY;

@property(nonatomic) CGSize size;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGFloat centerX;

@property(nonatomic) CGFloat centerY;

/*----------------------
 * Relative coordinate *
 ----------------------*/

@property (nonatomic, readonly) CGFloat middleX;
@property (nonatomic, readonly) CGFloat middleY;
@property (nonatomic, readonly) CGPoint middlePoint;

/*-----------
 * iPhone X *
 -----------*/

@property (class, nonatomic, readonly) CGFloat additionaliPhoneXBottomSafeHeight;
@property (class, nonatomic, readonly) CGFloat additionaliPhoneXTopSafeHeight;
@end
