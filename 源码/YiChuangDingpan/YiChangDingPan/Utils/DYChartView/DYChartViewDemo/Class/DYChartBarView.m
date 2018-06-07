//
//  DYChartBarView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYChartBarView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"

@implementation DYChartBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showingAnimation = NO;
        self.clipsToBounds = YES;
        self.barWidth = 8;
        self.lineColor = [UIColor redColor];
        self.fillColor = [UIColor redColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.showingAnimation) {
        return;
    }
    
    if ([self.layersArray count] > 0) {
        for (CAShapeLayer* layer in self.layersArray) {
            [layer removeFromSuperlayer];
        }
        
        self.layersArray = nil;
    }
    
    if (self.dataSource != nil) {
        NSUInteger count = [self.dataSource countOfChartItemView:self];
        if (count > 0) {
            NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
            [self calcBarWidth];
            
            for (NSUInteger i = range.location ; i < range.location + range.length ; i ++) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, .25f);
                
                CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
                CGContextSetFillColorWithColor(context, [self.fillColor CGColor]);
                
                UIColor* lineColor = [self.barDataSource lineColorForBarView:self atIndex:i];
                UIColor* fillColor = [self.barDataSource fillColorForBarView:self atIndex:i];
                
                if (lineColor != nil) {
                    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
                }
                if (fillColor != nil) {
                    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
                }
                
                CGPoint point = [self.dataSource pointOfChartItemView:self atIndex:i];
                if (point.y < -MAXFLOAT/2) {
                    point.y = .0f;
                }
                CGFloat x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
                CGFloat y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                if (self.fillToXZero) {
                    if (point.y < 0) {
                        y = (point.y - 0)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGContextAddRect(context, CGRectMake(x, self.bounds.size.height - zeroY, self.barWidth, -y));
                    }
                    else
                    {
                        y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat height = y - zeroY;
                        CGContextAddRect(context, CGRectMake(x, self.bounds.size.height - y, self.barWidth, height));
                    }
                }
                else
                {
                    CGContextAddRect(context, CGRectMake(x, self.bounds.size.height - y, self.barWidth, y));
                }
                
                
                CGContextDrawPath(context, kCGPathFillStroke);
                
                CGContextStrokePath(context);
            }
        }
    }
}

#pragma mark - 本地函数

- (void)strokeChart
{
    self.showingAnimation = YES;
    
    NSUInteger count = [self.dataSource countOfChartItemView:self];
    if (count > 0) {
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        
        [self calcBarWidth];
        
        NSMutableArray* mArray = [NSMutableArray array];
        for (NSUInteger i = range.location ; i < range.location + range.length ; i ++) {
            CAShapeLayer* lineLayer = [CAShapeLayer layer];
            
            lineLayer.lineCap = kCALineCapButt;
            lineLayer.strokeColor = [self.lineColor CGColor];
            lineLayer.fillColor   = [self.fillColor CGColor];
            
            UIColor* lineColor = [self.barDataSource lineColorForBarView:self atIndex:i];
            UIColor* fillColor = [self.barDataSource fillColorForBarView:self atIndex:i];
            
            if (lineColor != nil) {
                lineLayer.strokeColor   = [lineColor CGColor];
            }
            if (fillColor != nil) {
                lineLayer.fillColor = [fillColor CGColor];
            }
            
            lineLayer.lineWidth   = self.barWidth;
            lineLayer.strokeEnd   = 0.0;
            
            [self.layer addSublayer:lineLayer];
            
            UIBezierPath* linePath = [UIBezierPath bezierPath];
            [linePath setLineWidth:self.barWidth];
            [linePath setLineCapStyle:kCGLineCapButt];
            [linePath setLineJoinStyle:kCGLineJoinMiter];
            
            CGPoint point = [self.dataSource pointOfChartItemView:self atIndex:i];
            if (point.y < -MAXFLOAT/2) {
                point.y = .0f;
            }
            
            CGFloat x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
            CGFloat y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
            
            if (self.fillToXZero) {
                if (point.y < 0) {
                    y = (point.y - 0)*self.zoomForYAxis + self.yAxisOffset;
                    CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    
                    [linePath moveToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height - zeroY)];
                    [linePath addLineToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height - zeroY - y)];
                }
                else
                {
                    y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    
                    [linePath moveToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height - zeroY)];
                    [linePath addLineToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height - y)];
                }
            }
            else
            {
                [linePath moveToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height)];
                [linePath addLineToPoint:CGPointMake(x + self.barWidth/2, self.bounds.size.height - y)];
            }
            
            lineLayer.path = [linePath CGPath];
            
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 1.0f;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self performSelector:@selector(pathAnimationStoped) withObject:nil afterDelay:1.0f];
            lineLayer.strokeEnd = 1.0;
            
            [mArray addObject:lineLayer];
        }
        
        self.layersArray = mArray;
    }
}

- (CGFloat)calcBarWidth
{
    NSUInteger count = [self.dataSource countOfChartItemView:self];
    
    if (count > 2) {
        CGFloat width = self.frame.size.width/count;
        if (self.originalZoomForXAxis > 0) {
            width *= self.zoomForXAxis/self.originalZoomForXAxis;
        }
        CGFloat space = width/10;
        if (space < .2) {
            space = .2;
        }
        self.barWidth = width - space;
        if (self.barWidth < .5f) {
            self.barWidth = .5f;
        }
        
        if (self.barWidth > MAX_BAR_WIDTH) {
            self.barWidth = MAX_BAR_WIDTH;
        }
    }
    else
    {
        self.barWidth = MAX_BAR_WIDTH;
    }
    
    return self.barWidth;
}

- (CGFloat)calcPointWidth
{
    CGFloat barWidth = [self calcBarWidth];
    if (fabs(barWidth - 0.5) <= 0.5*0.000001) {
        NSUInteger count = [self.dataSource countOfChartItemView:self];
        if (count > 2) {
            CGFloat width = self.frame.size.width/count;
            if (self.originalZoomForXAxis > 0) {
                width *= self.zoomForXAxis/self.originalZoomForXAxis;
            }
            
            if (width > MAX_BAR_WIDTH) {
                width = MAX_BAR_WIDTH;
            }
            
            return self.pointWidth = width;
        }
        else
        {
            return self.pointWidth = MAX_BAR_WIDTH;
        }
    }
    else {
        return self.pointWidth = barWidth;
    }
}

- (void)pathAnimationStoped
{
    [self performSelectorOnMainThread:@selector(_pathAnimationStoped_) withObject:nil waitUntilDone:NO];
}

- (void)_pathAnimationStoped_
{
    self.showingAnimation = NO;
    //    [self setNeedsDisplay];
}

- (void)showAnimation
{
    [self strokeChart];
}

#pragma mark - HBMaskViewDataSource 函数

- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition
{
    [self calcPointWidth];
    
    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
    
    if (range.location + range.length > 0) {
        for (NSInteger index = range.location ; index < (NSInteger)range.location + range.length - 1; index ++) {
            CGFloat curPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
            CGFloat nextPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index + 1].x;
            
            CGFloat curPosition = (curPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset + self.pointWidth/2;
            CGFloat nextPosition = (nextPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset + self.pointWidth/2;
            
            if (xPosition < curPosition) {
                return index;
            }
            else if (xPosition >= curPosition && xPosition <= nextPosition) {
                if (xPosition - curPosition < nextPosition - xPosition) {
                    return index;
                }
                else {
                    return index + 1;
                }
            }
        }
        
        return (NSInteger)range.location + range.length - 1;
    }
    
    return 0;
}

// 校正X方向的位置
- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    CGFloat xPositionValue = 0;
    
    NSRange validDataRange = [self.dataSource rangeOfValidCountOfChartItemView:self];
    if (index >= validDataRange.location  && index < validDataRange.location + validDataRange.length) {
        xPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
    }
    
    [self calcPointWidth];
    CGFloat fixedXPosition = (xPositionValue - self.minX)*self.zoomForXAxis + self.xAxisOffset + self.pointWidth/2;
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    return fixedPoint.x;
}

- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atIndex:(NSInteger)index
{
    CGFloat xPositionValue = 0;
    
    NSRange validDataRange = [self.dataSource rangeOfValidCountOfChartItemView:self];
    if (index >= validDataRange.location  && index < validDataRange.location + validDataRange.length) {
        xPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
    }
    
    [self calcPointWidth];
    CGFloat fixedXPosition = (xPositionValue - self.minX)*self.zoomForXAxis + self.xAxisOffset + self.pointWidth/2;
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    return fixedPoint.x;
}

- (int64_t)getTimestampValueFromXPosition:(CGFloat)xPosition
{
    [self calcPointWidth];
    
    CGFloat fixedPosition = xPosition - self.pointWidth/2;
    
    int64_t xPositionValue = (fixedPosition - self.xAxisOffset)/self.zoomForXAxis + self.minX;
    
    // 因为接口给的时间戳都是0点0分的，为了避免误差，给时间戳加上半小时，最大程度上避免误差
    return xPositionValue + 30*60*1000;
}

// 获取Y方向的位置
- (CGFloat)getYPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
    
    return self.bounds.size.height - (y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
}

//// X方向上提醒文字
//- (NSString*)xTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
//{
//    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
//    return [self.dataSource xTipsOfChartItemView:self atIndex:index];
////    return [NSString stringWithFormat:@"公元%ld年第%ld天", (long)index/283, (long)index%283];
//    //    return [NSString stringWithFormat:@"%ld",  index];
//}

- (NSDictionary *)dictionaryForShowViewValue:(DYMaskView*)maskView
                                  atPosition:(CGFloat)xPosition
{
    return nil;
}

// X方向上提示文字的位置
- (CGRect)xTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString
{
    NSDictionary *attributes = @{NSFontAttributeName:DYAppearanceFont(@"T1")};
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    return CGRectMake(xPos - rect.size.width/2 - tipTextGap, self.bounds.size.height +  tipTextGap, rect.size.width + tipTextGap*2, rect.size.height + tipTextGap*2);
}

//// Y方向上提醒文字
//- (NSString*)yTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
//{
//    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
//    return [self.dataSource yTipsOfChartItemView:self atIndex:index];
////    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
////    
////    return [NSString stringWithFormat:@"%.2f",  y];
//}

// 选中区间的X方向上的提示文字
- (NSString*)xSelectTipsOfMaskView:(DYMaskView*)maskView fromPosition:(CGFloat)fromPos toPosition:(CGFloat)toPos
{
    NSInteger fromIndex = [self getIndexFromXPosition:fromPos fromView:maskView];
    NSInteger toIndex = [self getIndexFromXPosition:toPos fromView:maskView];
    
    return [NSString stringWithFormat:@"从 %@ 到 %@",
            [NSString stringWithFormat:@"公元%ld年第%ld天", (long)fromIndex/283, (long)fromIndex%283],
            [NSString stringWithFormat:@"公元%ld年第%ld天", (long)toIndex/283, (long)toIndex%283]];
}

// 选中区间提示文字的范围
- (CGRect)xSelectTipsRectOfMaskView:(DYMaskView*)maskView fromPosition:(CGFloat)fromPos toPosition:(CGFloat)toPos withTipString:(NSString*)tipString
{
    CGFloat centerPos = (fromPos + toPos)/2;
    NSDictionary *attributes = @{NSFontAttributeName:DYAppearanceFont(@"T1")};
    
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGRectMake(centerPos - rect.size.width/2 - tipTextGap,
                      self.bounds.size.height + tipTextGap,
                      rect.size.width + tipTextGap*2,
                      rect.size.height + tipTextGap*2);
}

@end
