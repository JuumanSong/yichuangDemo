//
//  DYAxisView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYAxisView.h"
#import "DYTools+FloatingPoint.h"

@implementation DYAxisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:NO];
        
        [self setOffset:0];
        [self setDrawContentFlag:eDrawNothing];
        [self setTextEdgeOffset:6];
        [self setTextTransform:0];
        [self setTextAlignment:NSTextAlignmentRight];
        
        [self setMajorScaleWidth:4];
        [self setMajorScaleLength:4];
        [self setMajorScaleColor:[UIColor lightGrayColor]];
        
        [self setMinorScaleWidth:2];
        [self setMinorScaleLength:2];
        [self setMinorScaleColor:[UIColor grayColor]];
        
        [self setAxisWidth:1];
        [self setAxisColor:[UIColor grayColor]];
    }
    return self;
}

- (void)reloadData
{
    //
}

- (void)resetLabelPosition
{
    //
}

- (void)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(UIColor*)color andLineWidth:(CGFloat)lineWidth
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextStrokePath(context);
}

- (BOOL)isZoomed
{
    return [DYTools compareFloatNumber1:self.zoomValue withFloatNumber2:self.originalZoomValue] != eEqual;
}
@end
