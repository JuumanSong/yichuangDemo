//
//  UIButton+Utils.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  提供防重点、响应区域放大、Block方法等属性
 */
@interface UIButton (Utils)

/**
 防重复点击间隔
 */
@property (nonatomic ,assign) NSTimeInterval dy_IgnoreClickInterval;

/**
 扩大按钮响应区域，上左下右，负数扩大正数缩小
 */
@property (nonatomic ,assign) UIEdgeInsets dy_EnlargeRect;


-(void)dy_addActionBlock:(void(^)(UIButton * btn))action;

@end
