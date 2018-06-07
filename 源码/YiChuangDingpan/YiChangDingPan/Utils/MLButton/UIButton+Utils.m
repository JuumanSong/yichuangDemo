//
//  UIButton+Utils.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "UIButton+Utils.h"

@interface UIButton ()

@property (nonatomic ,assign) BOOL ignoreClick;

@property (nonatomic ,copy) void (^actionBlock)(UIButton *);

@end

@implementation UIButton (Utils)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(sendAction:to:forEvent:);
        SEL destinationSel = @selector(dy_sendAction:to:forEvent:);
        Method originMethod = class_getInstanceMethod(self, originSel);
        Method destinationMethod = class_getInstanceMethod(self, destinationSel);
        class_addMethod(self, originSel, method_getImplementation(destinationMethod), method_getTypeEncoding(destinationMethod));
        class_replaceMethod(self, destinationSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    });
}

-(void)dy_addActionBlock:(void (^)(UIButton *))action
{
    self.actionBlock = action;
    [self addTarget:self action:@selector(dy_blockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dy_blockBtnAction:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    if (self.actionBlock) {
        self.actionBlock(weakSelf);
    }
}

-(void)dy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (![self isKindOfClass:[UIButton class]]) {
        [self dy_sendAction:action to:target forEvent:event];
    }
    if (self.ignoreClick) {
        return;
    }
    if (self.dy_IgnoreClickInterval > 0) {
        self.ignoreClick = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dy_IgnoreClickInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{///不宜用performSelector系方法，object进行强转时无法保证值正确
            self.ignoreClick = NO;
        });
    }
    [self dy_sendAction:action to:target forEvent:event];
}

#pragma mark ---setter、getter---
-(void)setDy_IgnoreClickInterval:(NSTimeInterval)dy_IgnoreClickInterval
{
    objc_setAssociatedObject(self, @selector(dy_IgnoreClickInterval), @(dy_IgnoreClickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)dy_IgnoreClickInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

-(void)setActionBlock:(void (^)(UIButton *))actionBlock
{
    objc_setAssociatedObject(self, @selector(actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(UIButton *))actionBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setIgnoreClick:(BOOL)ignoreClick
{
    objc_setAssociatedObject(self, @selector(ignoreClick), @(ignoreClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)ignoreClick
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setDy_EnlargeRect:(UIEdgeInsets)dy_EnlargeRect
{
    objc_setAssociatedObject(self, @selector(dy_EnlargeRect), [NSValue valueWithUIEdgeInsets:dy_EnlargeRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)dy_EnlargeRect
{
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, self.dy_EnlargeRect);
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

@end
