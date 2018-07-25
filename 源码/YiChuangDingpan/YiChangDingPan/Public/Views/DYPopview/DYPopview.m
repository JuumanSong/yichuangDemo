//
//  DYPopview.m
//  popview
//
//  Created by 宋骁俊 on 15/5/20.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYPopview.h"
#import <QuartzCore/QuartzCore.h>

#define TriangleDefultColor [UIColor whiteColor]
#define TriangleDefultSize CGSizeMake(10,10)

@interface DYPopview(){
    UIButton *backgroundBtn;//背景btn，默认点击消失
    UIView *triangleView;//小三角
    UIView *contentBackgroundView;//主内容框，默认无色
    UIView *contentView;//内容(contentBackgroundView的子view）
    id clickSender;//箭头的目标
    TriangleDirection triangleDirection;//用户箭头方向
    TriangleDirection nowTriangleDir;//当前箭头方向
}
@end


@implementation DYPopview


- (id)initWithSender:(id)sender
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        
        if(sender){
            clickSender = sender;
        }
        triangleDirection = defult;
        
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        
        backgroundBtn=[[UIButton alloc]initWithFrame:self.bounds];
        [backgroundBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundBtn];
        
        triangleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TriangleDefultSize.width, TriangleDefultSize.height)];
        contentBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];
        contentBackgroundView.backgroundColor=[UIColor clearColor];
        contentBackgroundView.clipsToBounds=YES;
        
        [self addSubview:triangleView];
        [self addSubview:contentBackgroundView];
    }
    return self;
}


//绘制三角view
- (void)drawTriangleView{
    if([self.delegate respondsToSelector:@selector(sizeOfTriangleView)]){
        CGSize triangleViewSize = [self.delegate sizeOfTriangleView];
        triangleView.frame=CGRectMake(0, 0, triangleViewSize.width, triangleViewSize.height);
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(triangleView.frame.size.width/2, 0);
    CGPoint bottomLeft = CGPointMake(0, triangleView.frame.size.height);
    CGPoint bottomRight = CGPointMake(triangleView.frame.size.width, triangleView.frame.size.height);
    
    [bezierPath moveToPoint:center];
    [bezierPath addLineToPoint:bottomLeft];
    [bezierPath addLineToPoint:bottomRight];
    [bezierPath closePath];

    maskLayer.path = [bezierPath CGPath];
//    maskLayer.fillColor = [fillColor CGColor];
    maskLayer.frame = triangleView.bounds;
    triangleView.layer.mask = maskLayer;
    
    //设置颜色
    UIColor *fillColor=TriangleDefultColor;
    if([self.delegate respondsToSelector:@selector(colorOfTriangleView)]){
        fillColor=[self.delegate colorOfTriangleView];
    }
    triangleView.backgroundColor=fillColor;
}


//刷新view
-(void)reInitViewWithSender:(id)sender{
    [self drawTriangleView];
    
    contentView = [self.delegate contentViewOfDYPopview:self];
    if(contentView){
        contentBackgroundView.frame=CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    }
    
    if (contentView != nil) {
        [contentView removeFromSuperview];
        [contentBackgroundView addSubview:contentView];
    }
    
    [self adaptationWithTarget:sender];
    [self adaptationBackground];
}

//显示view
-(void)showView{
    [self reInitViewWithSender:clickSender];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    CGRect contentBackgroundViewFrame=contentBackgroundView.frame;
    
    CFTimeInterval duration=0.2;
    if([self.delegate respondsToSelector:@selector(animationDuration)]){
        duration=[self.delegate animationDuration];
    }
    
    switch (nowTriangleDir) {
        case up:{
            contentBackgroundView.frame=CGRectMake(contentBackgroundView.frame.origin.x, contentBackgroundView.frame.origin.y, contentBackgroundView.frame.size.width, 0);
            [UIView animateWithDuration:duration animations:^{
                contentBackgroundView.frame=contentBackgroundViewFrame;
            }completion:^(BOOL finished) {
                
            }];
        }
            break;
        case down:{
            contentBackgroundView.frame=CGRectMake(contentBackgroundView.frame.origin.x, contentBackgroundView.frame.origin.y+contentBackgroundView.frame.size.height, contentBackgroundView.frame.size.width, 0);
            [UIView animateWithDuration:duration animations:^{
                contentBackgroundView.frame=contentBackgroundViewFrame;
            }completion:^(BOOL finished) {
                
            }];
        }
            break;
        default:
            break;
    }
}

//关闭view
-(void)closeView{
    
    CFTimeInterval duration=0.2;
    if([self.delegate respondsToSelector:@selector(animationDuration)]){
        duration=[self.delegate animationDuration];
    }
    
    switch (nowTriangleDir) {
        case up:{
            [UIView animateWithDuration:duration animations:^{
                contentBackgroundView.frame=CGRectMake(contentBackgroundView.frame.origin.x, contentBackgroundView.frame.origin.y, contentBackgroundView.frame.size.width, 0);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                if([self.delegate respondsToSelector:@selector(viewDidClosed)]){
                    [self.delegate viewDidClosed];
                }
            }];
        }
            break;
        case down:{
            [UIView animateWithDuration:duration animations:^{
                contentBackgroundView.frame=CGRectMake(contentBackgroundView.frame.origin.x, contentBackgroundView.frame.origin.y+contentBackgroundView.frame.size.height, contentBackgroundView.frame.size.width, 0);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                if([self.delegate respondsToSelector:@selector(viewDidClosed)]){
                    [self.delegate viewDidClosed];
                }
            }];
        }
            break;
        default:
            break;
    }
}

//适配位置
-(void)adaptationWithTarget:(id)target{
    CGSize keyWindowSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    CGRect targetRect=[self getTargrtRect:target];
    CGSize cbViewSize=contentBackgroundView.frame.size;
    
    //如果设置了箭头的方向
    if([self.delegate respondsToSelector:@selector(triangleViewDirection)]){
        triangleDirection=[self.delegate triangleViewDirection];
        nowTriangleDir=triangleDirection;
    }
    if(triangleDirection==defult){
        nowTriangleDir=targetRect.origin.y+targetRect.size.height/2<keyWindowSize.height/2?up:down;
    }
    
    switch (nowTriangleDir) {
        case up:{
            triangleView.frame=CGRectMake(targetRect.origin.x+(targetRect.size.width-triangleView.frame.size.width)/2, targetRect.origin.y+targetRect.size.height, triangleView.frame.size.width, triangleView.frame.size.height);
            
            //如果已经设置了contentView的原点
            if([self.delegate respondsToSelector:@selector(originOfContentView)]){
                CGPoint cbViewOrigin=[self.delegate originOfContentView];
                contentBackgroundView.frame=CGRectMake(cbViewOrigin.x,cbViewOrigin.y,cbViewSize.width,cbViewSize.height);
                break;
            }
            
            CGRect triangleRect=triangleView.frame;
            
            CGFloat cbViewX;
            CGFloat cbViewY;
            
            if(triangleView.center.x<keyWindowSize.width/2){
                if (triangleRect.origin.x-20>10) {
                    cbViewX=triangleRect.origin.x-20;
                }
                else{
                    cbViewX=MIN(triangleRect.origin.x,10);
                }
                
                if(cbViewX+cbViewSize.width>=keyWindowSize.width){
                    cbViewX=(keyWindowSize.width-cbViewSize.width)/2;
                }

                cbViewY=triangleRect.origin.y+triangleRect.size.height;
            }
            else{
                if(triangleRect.origin.x+triangleRect.size.width+20>keyWindowSize.width-10){
                    cbViewX=MAX(triangleRect.origin.x+triangleRect.size.width-cbViewSize.width,keyWindowSize.width-cbViewSize.width-10);
                }
                else{
                    cbViewX=triangleRect.origin.x-(cbViewSize.width-triangleRect.size.width-20);
                }
                
                if(cbViewX<=0){
                    cbViewX=(keyWindowSize.width-cbViewSize.width)/2;
                }
                cbViewY=triangleRect.origin.y+triangleRect.size.height;
            }
            contentBackgroundView.frame=CGRectMake(cbViewX,cbViewY,cbViewSize.width,cbViewSize.height);
        }
            break;
        case down:{
            triangleView.frame=CGRectMake(targetRect.origin.x+(targetRect.size.width-triangleView.frame.size.width)/2, targetRect.origin.y-triangleView.frame.size.height, triangleView.frame.size.width, triangleView.frame.size.height);
            
            [triangleView setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            //如果已经设置了contentView的原点
            if([self.delegate respondsToSelector:@selector(originOfContentView)]){
                CGPoint cbViewOrigin=[self.delegate originOfContentView];
                contentBackgroundView.frame=CGRectMake(cbViewOrigin.x,cbViewOrigin.y,cbViewSize.width,cbViewSize.height);
                break;
            }
            
            CGRect triangleRect=triangleView.frame;
            
            CGFloat cbViewX;
            CGFloat cbViewY;
            
            if(triangleView.center.x<keyWindowSize.width/2){
                if (triangleRect.origin.x-20>10) {
                    cbViewX=triangleRect.origin.x-20;
                }
                else{
                    cbViewX=MIN(triangleRect.origin.x,10);
                }
                
                if(cbViewX+cbViewSize.width>=keyWindowSize.width){
                    cbViewX=(keyWindowSize.width-cbViewSize.width)/2;
                }
                
                cbViewY=triangleRect.origin.y-cbViewSize.height;
            }
            else{
                if(triangleRect.origin.x+triangleRect.size.width+20>keyWindowSize.width-10){
                    cbViewX=MAX(triangleRect.origin.x+triangleRect.size.width-cbViewSize.width,keyWindowSize.width-cbViewSize.width-10);
                }
                else{
                    cbViewX=triangleRect.origin.x-(cbViewSize.width-triangleRect.size.width-20);
                }
                
                if(cbViewX<=0){
                    cbViewX=(keyWindowSize.width-cbViewSize.width)/2;
                }
                cbViewY=triangleRect.origin.y-cbViewSize.height;
            }
            contentBackgroundView.frame=CGRectMake(cbViewX,cbViewY,cbViewSize.width,cbViewSize.height);
        }
            
        default:
            break;
    }
}

//适配背景
-(void)adaptationBackground{
    //是否设置了显示背景
    if(self.delegate && [self.delegate respondsToSelector:@selector(showBackground)]&&![self.delegate showBackground]){//不显示背景
        self.frame=contentBackgroundView.frame;
        backgroundBtn.frame=self.bounds;
        triangleView.frame=CGRectMake(triangleView.frame.origin.x-contentBackgroundView.frame.origin.x, triangleView.frame.origin.y-contentBackgroundView.frame.origin.y, triangleView.frame.size.width, triangleView.frame.size.height);
        contentBackgroundView.frame=self.bounds;
        
        self.backgroundColor=[UIColor clearColor];
    }
    else{
        self.frame=[UIApplication sharedApplication].keyWindow.bounds;
        backgroundBtn.frame=self.bounds;
        if(self.delegate && [self.delegate respondsToSelector:@selector(colorOfBackground)]){
            self.backgroundColor=[self.delegate colorOfBackground];
        }
    }
}

//返回绝对位置
-(CGRect)getTargrtRect:(id)sender{
    UIView *view=(UIView*)sender;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[view convertRect: view.bounds toView:window];
    return rect;
}

@end
