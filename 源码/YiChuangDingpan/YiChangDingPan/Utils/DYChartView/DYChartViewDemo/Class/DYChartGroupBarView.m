//
//  DYChartGroupBarView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/2/15.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYChartGroupBarView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"

@implementation DYChartGroupBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barCountInGroup = 3;
        self.groupGapWidth = 12;
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
                static CGFloat x = 0;
                if (i % self.barCountInGroup == 0) {
                    x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
                }
                if (point.y < -MAXFLOAT/2) {
                    point.y = .0f;
                }
                CGFloat y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                if (self.fillToXZero) {
                    if (point.y < 0) {
                        y = (point.y - 0)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGContextAddRect(context, CGRectMake(x + self.barWidth*(i%self.barCountInGroup), self.bounds.size.height - zeroY, self.barWidth, -y));
                    }
                    else
                    {
                        y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                        CGFloat height = y - zeroY;
                        CGContextAddRect(context, CGRectMake(x + self.barWidth*(i%self.barCountInGroup), self.bounds.size.height - y, self.barWidth, height));
                    }
                }
                else
                {
                    CGContextAddRect(context, CGRectMake(x + self.barWidth*(i%self.barCountInGroup), self.bounds.size.height - y, self.barWidth, y));
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
        // 计算bar宽度
        [self calcBarWidth];
        
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        
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
            static CGFloat x = 0;
            if (i % self.barCountInGroup == 0) {
                x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
            }
            
            if (point.y < -MAXFLOAT/2) {
                point.y = .0f;
            }
            CGFloat y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
            
            if (self.fillToXZero) {
                if (point.y < 0) {
                    y = (point.y - 0)*self.zoomForYAxis + self.yAxisOffset;
                    CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    [linePath moveToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height - zeroY)];
                    [linePath addLineToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height - zeroY - y)];
                }
                else
                {
                    y = (point.y - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    CGFloat zeroY = (0 - self.minY)*self.zoomForYAxis + self.yAxisOffset;
                    [linePath moveToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height - zeroY)];
                    [linePath addLineToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height - y)];
                }
            }
            else
            {
                [linePath moveToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height)];
                [linePath addLineToPoint:CGPointMake(x + self.barWidth*(i%self.barCountInGroup) + self.barWidth/2, self.bounds.size.height - y)];
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
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        if (range.length >= 2) {
            CGFloat width = self.frame.size.width/count;
            
            NSUInteger allCount = self.barCountInGroup + 1;
            CGFloat space = width/allCount;
            if (space * allCount > self.groupGapWidth) {
                space = self.groupGapWidth/allCount;
            }
            if (space < .2) {
                space = .2;
            }
            self.barWidth = width - space;
            if (self.barWidth < .5f) {
                self.barWidth = .5f;
            }
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
    return self.pointWidth = fabs(barWidth - 0.5) <= 0.5*0.000001 ? 0 : barWidth;
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

// 校正X方向的位置
- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    CGFloat fixedXPosition = index/self.barCountInGroup*self.barCountInGroup*self.zoomForXAxis + self.xAxisOffset + self.barWidth/2;
    
    fixedXPosition = fixedXPosition + self.barWidth*(index%self.barCountInGroup);
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    if (self.barCountInGroup%2 == 0) {
        fixedPoint.x -= self.barWidth/2;
    }
    return fixedPoint.x;
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
//    //    return [NSString stringWithFormat:@"公元%ld年第%ld天", (long)index/283, (long)index%283];
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
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    return CGRectMake(xPos - rect.size.width/2 - tipTextGap,
                      self.bounds.size.height +  tipTextGap,
                      rect.size.width + tipTextGap*2,
                      rect.size.height + tipTextGap*2);
}

//// Y方向上提醒文字
//- (NSString*)yTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
//{
//    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
//    return [self.dataSource yTipsOfChartItemView:self atIndex:index];
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
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    return CGRectMake(centerPos - rect.size.width/2 - tipTextGap,
                      self.bounds.size.height + tipTextGap,
                      rect.size.width + tipTextGap*2,
                      rect.size.height + tipTextGap*2);
}

- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atIndex:(NSInteger)index
{
    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
    NSInteger fixedIndex = (NSInteger)range.location + range.length - 1;
    BOOL writeFlag = NO;
    if (index >= range.location && index < range.location + range.length) {
        NSInteger firstIndexInGroup = index/self.barCountInGroup*self.barCountInGroup;
        fixedIndex = firstIndexInGroup + self.barCountInGroup/2;
        writeFlag = YES;
    }
    
    if (fixedIndex >= range.location + range.length)
    {
        fixedIndex = (NSInteger)range.location + range.length - 1 - self.barCountInGroup/2;
        writeFlag = YES;
    }
    
    if (fixedIndex < range.location)
    {
        fixedIndex = range.location + self.barCountInGroup/2;
        writeFlag = YES;
    }
    
    if (range.location + range.length < self.barCountInGroup) {
        fixedIndex = 0;
        writeFlag = YES;
    }
    
    if (!writeFlag) {
        return 999999999.0f;
    }
    
    CGFloat fixedXPosition = fixedIndex*self.zoomForXAxis + self.xAxisOffset;
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    [self calcBarWidth];
    
    if (self.barCountInGroup%2 == 0) {
        return fixedPoint.x;
    }
    else {
        return fixedPoint.x + self.barWidth/2;
    }
}

- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition
{
    NSInteger index = (NSInteger)((xPosition - self.xAxisOffset)/self.zoomForXAxis);
    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
    NSInteger fixedIndex = (NSInteger)range.location + range.length - 1;
    
    if (index > fixedIndex) {
        index = fixedIndex;
    }
    if (index < 0) {
        index = 0;
    }
    
    if (index >= range.location && index < range.location + range.length) {
        NSInteger firstIndexInGroup = index/self.barCountInGroup*self.barCountInGroup;
        fixedIndex = firstIndexInGroup + self.barCountInGroup/2;
    }
    
    if (fixedIndex >= range.location + range.length)
    {
        fixedIndex = (NSInteger)range.location + range.length - 1 - self.barCountInGroup/2;
    }
    
    if (fixedIndex < range.location)
    {
        fixedIndex = range.location + self.barCountInGroup/2;
    }
    
    if (range.location + range.length < self.barCountInGroup) {
        return 0;
    }
    
    return fixedIndex;
    
//    NSInteger index = (NSInteger)((xPosition - self.xAxisOffset)/self.zoomForXAxis);
//    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
//    NSInteger fixedIndex = range.location + range.length - 1;
//    
//    if (index >= range.location && index < range.location + range.length) {
//        NSInteger firstIndexInGroup = index/self.barCountInGroup*self.barCountInGroup;
//        for (NSInteger i = 0 ; i < self.barCountInGroup - 1; i ++) {
//            CGFloat prePosition = (firstIndexInGroup + i)*self.zoomForXAxis + self.xAxisOffset + self.barWidth/2;
//            CGFloat nextPosition = (firstIndexInGroup + i + 1)*self.zoomForXAxis + self.xAxisOffset + self.barWidth/2;
//            if (prePosition < xPosition && nextPosition > xPosition) {
//                if (xPosition - prePosition < nextPosition - xPosition) {
//                    fixedIndex = firstIndexInGroup;
//                }
//                else
//                {
//                    fixedIndex = firstIndexInGroup + 1;
//                }
//                break;
//            }
//        }
//    }
//    
//    if (fixedIndex >= range.location + range.length)
//    {
//        fixedIndex = range.location + range.length - 1 - self.barCountInGroup/2;
//    }
//    
//    if (fixedIndex < range.location)
//    {
//        fixedIndex = range.location + self.barCountInGroup/2 + 1;
//    }
//    
//    if (range.location + range.length < self.barCountInGroup) {
//        return 0;
//    }
//    
//    return fixedIndex;
}

@end
