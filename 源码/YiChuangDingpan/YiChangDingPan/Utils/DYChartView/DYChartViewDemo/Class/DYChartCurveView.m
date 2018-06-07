//
//  DYChartCurveView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYChartCurveView.h"
#import "DYChartViewCommonDef.h"
#import <QuartzCore/QuartzCore.h>
#import "DYAppearance.h"
#import "DYTools+FloatingPoint.h"

@interface DYChartCurveView ()

@property (nonatomic, strong)NSMutableArray *mPreArray;     // 之前计算好的数组
@property (nonatomic)CGMutablePathRef preCurvePath;         // 之前计算好的绘制path

@property (nonatomic)NSRange preValidDataRange;             // 上次数据的有效范文
@property (nonatomic)CGFloat preZoomForXAxis;               // X方向上图像的缩放系数
@property (nonatomic)CGFloat preZoomForYAxis;               // Y方向上图像的缩放系数
@property (nonatomic)CGFloat preXAxisOffset;                // X轴方向上图的偏移
@property (nonatomic)CGFloat preYAxisOffset;                // Y轴方向上图的偏移
@property (nonatomic)CGFloat preMinX;                       // X 最小值
@property (nonatomic)CGFloat preMinY;                       // Y 最小值
@property (nonatomic)CGRect preCalcRect;                    // 计算矩形（用于计算图形缩放系数的矩形）

@end

@implementation DYChartCurveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineColor:[UIColor redColor]];
        self.drawSmoothCurveFlag = NO;
        self.clipsToBounds = YES;
        self.fillFlag = NO;
        self.showingAnimation = NO;
        [self setupLineLayer];
    }
    return self;
}

- (void)setupLineLayer
{
    [self.lineLayer removeFromSuperlayer];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinBevel;
    if (self.fillFlag) {
//        self.lineLayer.fillColor = [UIColorFromRGBValueAndAlpha(0xcfdef7, .5) CGColor];// [UIColorFromRGBValue(0xcfdef7) CGColor];
//        self.fillColor = UIColorFromRGBValueAndAlpha(0xcfdef7, .5);//UIColorFromRGBValue(0xcfdef7);
    }
    else
    {
        self.lineLayer.fillColor   = [[UIColor clearColor] CGColor];
        self.fillColor = [UIColor clearColor];
    }
    self.lineLayer.strokeColor = [self.lineColor CGColor];
    self.lineLayer.lineWidth   = self.lineWidth;
    self.lineLayer.strokeEnd   = 0.0;
    self.coverColor = DYAppearanceColor(@"W1", 1.0);
    
    [self.layer addSublayer:self.lineLayer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)dealloc
{
    if (_preCurvePath != NULL) {
        CGPathRelease(_preCurvePath);
    }
}

- (BOOL)ifCanReusePreDataWithRange:(NSRange)validRange
{
    if (_preValidDataRange.location == validRange.location &&
        _preValidDataRange.length == validRange.length &&
        [DYTools compareFloatNumber1:_preZoomForXAxis withFloatNumber2:self.zoomForXAxis] == eEqual &&
        [DYTools compareFloatNumber1:_preZoomForYAxis withFloatNumber2:self.zoomForYAxis] == eEqual &&
        [DYTools compareFloatNumber1:_preXAxisOffset withFloatNumber2:self.xAxisOffset] == eEqual &&
        [DYTools compareFloatNumber1:_preYAxisOffset withFloatNumber2:self.yAxisOffset] == eEqual &&
        [DYTools compareFloatNumber1:_preMinX withFloatNumber2:self.minX] == eEqual &&
        [DYTools compareFloatNumber1:_preMinY withFloatNumber2:self.minY] == eEqual &&
        [DYTools compareFloatNumber1:_preCalcRect.size.width withFloatNumber2:self.calcRect.size.width] == eEqual &&
        [DYTools compareFloatNumber1:_preCalcRect.size.height withFloatNumber2:self.calcRect.size.height] == eEqual) {
        return YES;
    }
    
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    if (self.showingAnimation) {
        return;
    }
    
//    DDLogInfo(@"drawRect start ...");
    
    [self.lineLayer removeFromSuperlayer];
    self.lineLayer = nil;
    
    if (self.dataSource != nil)
    {
        // 先把有效点找出来，将点的值规范化
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        NSMutableArray* mArray = nil;
        if (_mPreArray != nil && [self ifCanReusePreDataWithRange:range]) {
            mArray = _mPreArray;
        } else {
            mArray = [NSMutableArray array];
            for (NSUInteger i = range.location ; i < range.location + range.length; i ++) {
                CGPoint point = [self.dataSource pointOfChartItemView:self atIndex:i];
                NAN_OR_INF_POINT_2_ZERO(point);
                if (JUDGE_EMPTY_VALUE(point.y)) {  // 这是无效数据
                    continue;
                }
                CGFloat x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
                CGFloat y = self.calcRect.size.height - (point.y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
                NAN_OR_INF_2_ZERO(x);
                NAN_OR_INF_2_ZERO(y);
                NSValue* pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
                [mArray addObject:pointValue];
            }
            
            _mPreArray = mArray;
        }
        
        
        NSUInteger validPointCount = [mArray count];
        
        if (!self.drawSmoothCurveFlag || validPointCount < 3) {   // 只有两个点，不需要画曲线
            if (validPointCount > 0) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGMutablePathRef curvePath1 = CGPathCreateMutable();
                
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
                
                // 先将画笔移到第一个有效点
                NSValue* pointValue = [mArray objectAtIndex:0];
                CGPoint point = [pointValue CGPointValue];
                
                CGPathMoveToPoint(curvePath1, NULL, point.x, point.y);
                CGContextMoveToPoint(context, point.x, point.y);
                
                // 画中间的点
                for (NSUInteger i = 1 ; i < validPointCount ; i ++) {
                    pointValue = [mArray objectAtIndex:i];
                    point = [pointValue CGPointValue];
                    
                    CGPathAddLineToPoint(curvePath1, NULL, point.x, point.y);
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
                CGContextStrokePath(context);
                
                if (self.fillFlag && validPointCount > 1) {
                    // 组成封闭图形
                    NSValue* firstPointValue = [mArray objectAtIndex:0];
                    NSValue* lastPointValue = [mArray objectAtIndex:validPointCount - 1];
                    CGPoint firstPoint = [firstPointValue CGPointValue];
                    CGPoint lastPoint = [lastPointValue CGPointValue];
                    
                    if (self.fillToXZero) {
                        CGFloat zeroY = self.calcRect.size.height - (0 - self.minY)*self.zoomForYAxis - self.yAxisOffset;
                        CGPathAddLineToPoint(curvePath1, NULL, lastPoint.x, zeroY);
                        CGPathAddLineToPoint(curvePath1, NULL, firstPoint.x, zeroY);
                    }
                    else
                    {
                        CGPathAddLineToPoint(curvePath1, NULL, lastPoint.x, self.calcRect.size.height);
                        CGPathAddLineToPoint(curvePath1, NULL, firstPoint.x, self.calcRect.size.height);
                    }
                    
                    CGPathCloseSubpath(curvePath1);
                    
                    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
//                    [self drawLinearGradient:context
//                                        path:curvePath1
//                                  startColor:[UIColor colorWithRed:0/255.0 green:142/255.0 blue:170/255.0 alpha:1.0].CGColor
//                                    endColor:[UIColor colorWithRed:0/255.0 green:142/255.0 blue:170/255.0 alpha:0.28].CGColor];
                    
                    CGContextAddPath(context, curvePath1);
                    CGContextDrawPath(context, kCGPathFill);
                }
                
                CGPathRelease(curvePath1);
                
                if (self.drawArcFlag)
                {
                    for (NSUInteger i = 0 ; i < validPointCount; i ++) {
                        NSValue* pointValue = [mArray objectAtIndex:i];
                        CGPoint point = [pointValue CGPointValue];
                        
                        [self drawCycleAtPoint:CGPointMake(point.x, point.y) withFillColor:self.lineColor];
                    }
                }
            }
        }
        else
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
            CGMutablePathRef curvePath = CGPathCreateMutable();
            CGPoint point4;
            
            if (_preCurvePath != NULL && [self ifCanReusePreDataWithRange:range]) {
                curvePath = _preCurvePath;
            } else {
                curvePath = CGPathCreateMutable();
                // 第一步：画起始的
                // 在前头加一个点
                NSValue* point1Value = [mArray objectAtIndex:0];
                NSValue* point2Value = [mArray objectAtIndex:0];
                NSValue* point3Value = [mArray objectAtIndex:1];
                NSValue* point4Value = [mArray objectAtIndex:2];
                
                CGPoint point1 = [point1Value CGPointValue];
                CGPoint point2 = [point2Value CGPointValue];
                CGPoint point3 = [point3Value CGPointValue];
                point4 = [point4Value CGPointValue];
                
                // 控制点1
                CGFloat cx1;
                CGFloat cy1;
                
                // 控制点2
                CGFloat cx2;
                CGFloat cy2;
                
                NSArray* array = [self getControlPointWithPoint0:CGPointMake(point1.x - .01, point1.y)
                                                       andPoint1:CGPointMake(point2.x, point2.y)
                                                       andPoint2:CGPointMake(point3.x, point3.y)
                                                       andPoint3:CGPointMake(point4.x, point4.y)
                                                 withSmoothValue:.8];
                cx1 = [[array objectAtIndex:0] floatValue];
                cy1 = [[array objectAtIndex:1] floatValue];
                cx2 = [[array objectAtIndex:2] floatValue];
                cy2 = [[array objectAtIndex:3] floatValue];
                
                CGPathMoveToPoint(curvePath, NULL, point1.x - .01, point1.y);
                CGPathAddCurveToPoint(curvePath, NULL, cx1, cy1, cx2, cy2, point3.x, point3.y);
                
                CGContextMoveToPoint(context, point1.x - .01, point1.y);
                CGContextAddCurveToPoint(context, cx1, cy1, cx2, cy2, point3.x, point3.y);
                
                // 第二步：画中间的
                for (NSUInteger i = 0 ; i < validPointCount - 3; i ++) {
                    point1Value = [mArray objectAtIndex:i];
                    point2Value = [mArray objectAtIndex:i + 1];
                    point3Value = [mArray objectAtIndex:i + 2];
                    point4Value = [mArray objectAtIndex:i + 3];
                    
                    point1 = [point1Value CGPointValue];
                    point2 = [point2Value CGPointValue];
                    point3 = [point3Value CGPointValue];
                    point4 = [point4Value CGPointValue];
                    
                    NSArray* array = [self getControlPointWithPoint0:CGPointMake(point1.x, point1.y)
                                                           andPoint1:CGPointMake(point2.x, point2.y)
                                                           andPoint2:CGPointMake(point3.x, point3.y)
                                                           andPoint3:CGPointMake(point4.x, point4.y)
                                                     withSmoothValue:.8];
                    
                    cx1 = [[array objectAtIndex:0] floatValue];
                    cy1 = [[array objectAtIndex:1] floatValue];
                    cx2 = [[array objectAtIndex:2] floatValue];
                    cy2 = [[array objectAtIndex:3] floatValue];
                    
                    CGPathAddLineToPoint(curvePath, NULL, point2.x, point2.y);
                    CGPathAddCurveToPoint(curvePath, NULL, cx1, cy1, cx2, cy2, point3.x, point3.y);
                    
                    CGContextAddCurveToPoint(context, cx1, cy1, cx2, cy2, point3.x, point3.y);
                }
                
                // 第三步：画结尾的
                if (validPointCount >= 3) {
                    point1Value = [mArray objectAtIndex:validPointCount - 3];
                    point2Value = [mArray objectAtIndex:validPointCount - 2];
                    point3Value = [mArray objectAtIndex:validPointCount - 1];
                    point4Value = [mArray objectAtIndex:validPointCount - 1];
                    
                    point1 = [point1Value CGPointValue];
                    point2 = [point2Value CGPointValue];
                    point3 = [point3Value CGPointValue];
                    point4 = [point4Value CGPointValue];
                    
                    array = [self getControlPointWithPoint0:CGPointMake(point1.x, point1.y)
                                                  andPoint1:CGPointMake(point2.x, point2.y)
                                                  andPoint2:CGPointMake(point3.x, point3.y)
                                                  andPoint3:CGPointMake(point4.x - .01, point4.y)
                                            withSmoothValue:.8];
                    cx1 = [[array objectAtIndex:0] floatValue];
                    cy1 = [[array objectAtIndex:1] floatValue];
                    cx2 = [[array objectAtIndex:2] floatValue];
                    cy2 = [[array objectAtIndex:3] floatValue];
                    
                    CGPathAddLineToPoint(curvePath, NULL, point2.x, point2.y);
                    CGPathAddCurveToPoint(curvePath, NULL, cx1, cy1, cx2, cy2, point3.x, point3.y);
                    
                    CGContextAddCurveToPoint(context, cx1, cy1, cx2, cy2, point3.x, point3.y);
                }
                
                if (self.fillFlag) {
                    if (_preCurvePath != NULL) {
                        CGPathRelease(_preCurvePath);
                    }
                    _preCurvePath = CGPathCreateMutableCopy(curvePath);
                    
                    CGContextStrokePath(context);
                }
                else
                {
                    if (_preCurvePath != NULL) {
                        CGPathRelease(_preCurvePath);
                    }
                    _preCurvePath = curvePath;
                    
                    CGContextStrokePath(context);
                }
                
//                CGPathRelease(curvePath);
            }
            
            if (self.fillFlag) {
                // 第四部：组成封闭图形
                NSValue* firstPointValue = [mArray objectAtIndex:0];
                NSValue* lastPointValue = [mArray objectAtIndex:validPointCount - 1];
                CGPoint firstPoint = [firstPointValue CGPointValue];
                CGPoint lastPoint = [lastPointValue CGPointValue];
                
                if (self.fillToXZero) {
                    CGFloat zeroY = self.calcRect.size.height - (0 - self.minY)*self.zoomForYAxis - self.yAxisOffset;
                    CGPathAddLineToPoint(curvePath, NULL, point4.x - .01, zeroY);
                    
                    CGPathAddLineToPoint(curvePath, NULL, lastPoint.x + .01, zeroY);
                    CGPathAddLineToPoint(curvePath, NULL, firstPoint.x - .01, zeroY);
                }
                else
                {
                    CGPathAddLineToPoint(curvePath, NULL, point4.x - .01, self.calcRect.size.height - self.yAxisOffset);
                    
                    CGPathAddLineToPoint(curvePath, NULL, lastPoint.x + .01, self.calcRect.size.height - self.yAxisOffset);
                    CGPathAddLineToPoint(curvePath, NULL, firstPoint.x - .01, self.calcRect.size.height - self.yAxisOffset);
                }
                
                CGPathCloseSubpath(curvePath);
                
                CGContextSetStrokeColorWithColor(context, [self.fillColor CGColor]);
                CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
//                [self drawLinearGradient:context
//                                    path:curvePath
//                              startColor:[UIColor colorWithRed:0/255.0 green:142/255.0 blue:170/255.0 alpha:1.0].CGColor
//                                endColor:[UIColor colorWithRed:0/255.0 green:142/255.0 blue:170/255.0 alpha:0.28].CGColor];
                
                CGContextAddPath(context, curvePath);
                CGContextDrawPath(context, kCGPathFillStroke);

                CGPathRelease(curvePath);
            }
        }
        
        if (validPointCount > 0)
        {
            if (self.showLastPoint) {
                NSValue* pointValue = [mArray objectAtIndex:validPointCount - 1];
                CGPoint point = [pointValue CGPointValue];
                
                [self drawCycleAtPoint:point];
            }
        }
    }
    
//    DDLogInfo(@"drawRect end ...");
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改 可改变方向是的渐变颜色45°或者垂直方向渐变颜色
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//根据线的颜色画圆点
- (void)drawCycleAtPoint:(CGPoint)point withFillColor:(UIColor*)fillColor{
    NAN_OR_INF_POINT_2_ZERO(point);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lengths[] = {1,0};
    CGContextSetLineDash(context,0, lengths,2);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddArc(context, point.x, point.y, 2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    
}
//- (void)fillPath:(CGMutablePathRef)mPath withPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
//{
//    CGFloat x1 = (point1.x - self.minX)*self.zoomForXAxis - 1 + self.xAxisOffset;
//    CGFloat y1 = self.calcRect.size.height - (point1.y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
//
//    CGFloat x2 = (point2.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
//    CGFloat y2 = self.calcRect.size.height - (point2.y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
//
//    CGPathAddLineToPoint(mPath, NULL, x2, y2);
//    CGPathAddLineToPoint(mPath, NULL, x2, self.calcRect.size.height);
//    CGPathAddLineToPoint(mPath, NULL, x1, self.calcRect.size.height);
//    CGPathAddLineToPoint(mPath, NULL, x1, y1);
//}

#pragma mark - 本地函数

// 计算控制点
- (NSArray*)getControlPointWithPoint0:(CGPoint)point0 andPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 andPoint3:(CGPoint)point3 withSmoothValue:(CGFloat)smoothValue
{
    CGFloat x0 = point0.x;
    CGFloat y0 = point0.y;
    
    CGFloat x1 = point1.x;
    CGFloat y1 = point1.y;
    
    CGFloat x2 = point2.x;
    CGFloat y2 = point2.y;
    
    CGFloat x3 = point3.x;
    CGFloat y3 = point3.y;
    
    CGFloat xc1 = (x0 + x1) / 2.0;
    CGFloat yc1 = (y0 + y1) / 2.0;
    CGFloat xc2 = (x1 + x2) / 2.0;
    CGFloat yc2 = (y1 + y2) / 2.0;
    CGFloat xc3 = (x2 + x3) / 2.0;
    CGFloat yc3 = (y2 + y3) / 2.0;
    
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    
    // Resulting control points. Here smooth_value is mentioned
    // above coefficient K whose value should be in range [0...1].
    CGFloat ctrl1_x = xm1 + (xc2 - xm1) * smoothValue + x1 - xm1;
    CGFloat ctrl1_y = ym1 + (yc2 - ym1) * smoothValue + y1 - ym1;
    
    CGFloat ctrl2_x = xm2 + (xc2 - xm2) * smoothValue + x2 - xm2;
    CGFloat ctrl2_y = ym2 + (yc2 - ym2) * smoothValue + y2 - ym2;
    
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:ctrl1_x], [NSNumber numberWithFloat:ctrl1_y], [NSNumber numberWithFloat:ctrl2_x], [NSNumber numberWithFloat:ctrl2_y], nil];
}

-(void)strokeChart
{
    self.showingAnimation = YES;
    [self setNeedsDisplay];
    
    if (self.dataSource != nil)
    {
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        NSMutableArray* mArray = nil;
        if (_mPreArray != nil && [self ifCanReusePreDataWithRange:range]) {
            mArray = _mPreArray;
        } else {
            mArray = [NSMutableArray array];
            
            for (NSUInteger i = range.location ; i < range.location + range.length; i ++) {
                CGPoint point = [self.dataSource pointOfChartItemView:self atIndex:i];
                NAN_OR_INF_POINT_2_ZERO(point);
                if (JUDGE_EMPTY_VALUE(point.y)) {  // 这是无效数据
                    continue;
                }
                CGFloat x = (point.x - self.minX)*self.zoomForXAxis + self.xAxisOffset;
                CGFloat y = self.calcRect.size.height - (point.y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
                NAN_OR_INF_2_ZERO(x);
                NAN_OR_INF_2_ZERO(y);
                NSValue* pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
                [mArray addObject:pointValue];
            }
            
            _mPreArray = mArray;
        }
        
        
        NSUInteger validPointCount = [mArray count];
        
        if (!self.drawSmoothCurveFlag || validPointCount < 3) {   // 只有两个点，不需要画曲线
            if (range.length > 0) {
                UIBezierPath* linePath = [UIBezierPath bezierPath];
                [linePath setLineWidth:1.0];
                [linePath setLineCapStyle:kCGLineCapRound];
                [linePath setLineJoinStyle:kCGLineJoinRound];
                
                NSValue* pointValue = [mArray objectAtIndex:0];
                CGPoint point = [pointValue CGPointValue];
                
                [linePath moveToPoint:CGPointMake(point.x, point.y)];
                
                for (NSUInteger i = 1; i < validPointCount; i ++) {
                    pointValue = [mArray objectAtIndex:i];
                    point = [pointValue CGPointValue];
                    
                    [linePath addLineToPoint:CGPointMake(point.x, point.y)];
                }
                
                self.lineLayer.path = linePath.CGPath;
                
                CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                pathAnimation.duration = 5.0;
                pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
                pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
                pathAnimation.autoreverses = NO;
                [self.lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
                
                self.lineLayer.strokeEnd = 1.0;
            }
        }
        else    // 画曲线，而且点个数 >= 3
        {
            UIBezierPath* linePath = [UIBezierPath bezierPath];
            [linePath setLineWidth:1.0];
            [linePath setLineCapStyle:kCGLineCapRound];
            [linePath setLineJoinStyle:kCGLineJoinRound];
            
            NSValue* point1Value = [mArray objectAtIndex:0];
            NSValue* point2Value = [mArray objectAtIndex:0];
            NSValue* point3Value = [mArray objectAtIndex:1];
            NSValue* point4Value = [mArray objectAtIndex:2];
            
            // 第一步：画起始的
            // 在前头加一个点
            CGPoint point1 = [point1Value CGPointValue];
            CGPoint point2 = [point2Value CGPointValue];
            CGPoint point3 = [point3Value CGPointValue];
            CGPoint point4 = [point4Value CGPointValue];
            // 控制点1
            CGFloat cx1;
            CGFloat cy1;
            
            // 控制点2R
            CGFloat cx2;
            CGFloat cy2;
            
            NSArray* array = [self getControlPointWithPoint0:CGPointMake(point1.x - .01, point1.y)
                                                   andPoint1:CGPointMake(point2.x, point2.y)
                                                   andPoint2:CGPointMake(point3.x, point3.y)
                                                   andPoint3:CGPointMake(point4.x, point4.y)
                                             withSmoothValue:.8];
            cx1 = [[array objectAtIndex:0] floatValue];
            cy1 = [[array objectAtIndex:1] floatValue];
            cx2 = [[array objectAtIndex:2] floatValue];
            cy2 = [[array objectAtIndex:3] floatValue];
            
            [linePath moveToPoint:CGPointMake(point2.x, point2.y)];
            [linePath addCurveToPoint:CGPointMake(point3.x, point3.y)
                        controlPoint1:CGPointMake(cx1, cy1)
                        controlPoint2:CGPointMake(cx2, cy2)];
            
            // 第二步：画中间的
            for (NSUInteger i = 0 ; i < validPointCount - 3; i ++) {
                point1Value = [mArray objectAtIndex:i];
                point2Value = [mArray objectAtIndex:i + 1];
                point3Value = [mArray objectAtIndex:i + 2];
                point4Value = [mArray objectAtIndex:i + 3];
                
                point1 = [point1Value CGPointValue];
                point2 = [point2Value CGPointValue];
                point3 = [point3Value CGPointValue];
                point4 = [point4Value CGPointValue];

                NSArray* array = [self getControlPointWithPoint0:CGPointMake(point1.x, point1.y)
                                                       andPoint1:CGPointMake(point2.x, point2.y)
                                                       andPoint2:CGPointMake(point3.x, point3.y)
                                                       andPoint3:CGPointMake(point4.x, point4.y)
                                                 withSmoothValue:.8];
                cx1 = [[array objectAtIndex:0] floatValue];
                cy1 = [[array objectAtIndex:1] floatValue];
                cx2 = [[array objectAtIndex:2] floatValue];
                cy2 = [[array objectAtIndex:3] floatValue];
                
                [linePath addLineToPoint:CGPointMake(point2.x, point2.y)];
                [linePath addCurveToPoint:CGPointMake(point3.x, point3.y)
                            controlPoint1:CGPointMake(cx1, cy1)
                            controlPoint2:CGPointMake(cx2, cy2)];
            }
            
            // 第三步：画结尾的
            if (validPointCount >= 3) {
                point1Value = [mArray objectAtIndex:validPointCount - 3];
                point2Value = [mArray objectAtIndex:validPointCount - 2];
                point3Value = [mArray objectAtIndex:validPointCount - 1];
                point4Value = [mArray objectAtIndex:validPointCount - 1];
                point1 = [point1Value CGPointValue];
                point2 = [point2Value CGPointValue];
                point3 = [point3Value CGPointValue];
                point4 = [point4Value CGPointValue];
                
                array = [self getControlPointWithPoint0:CGPointMake(point1.x, point1.y)
                                              andPoint1:CGPointMake(point2.x, point2.y)
                                              andPoint2:CGPointMake(point3.x, point3.y)
                                              andPoint3:CGPointMake(point4.x + .01, point4.y)
                                        withSmoothValue:.8];
                cx1 = [[array objectAtIndex:0] floatValue];
                cy1 = [[array objectAtIndex:1] floatValue];
                cx2 = [[array objectAtIndex:2] floatValue];
                cy2 = [[array objectAtIndex:3] floatValue];
                
                [linePath addLineToPoint:CGPointMake(point2.x, point2.y)];
                [linePath addCurveToPoint:CGPointMake(point3.x, point3.y)
                            controlPoint1:CGPointMake(cx1, cy1)
                            controlPoint2:CGPointMake(cx2, cy2)];
            }
            
            // 填充图形
            if (self.fillFlag) {
                if (self.fillToXZero) {
                    CGFloat zeroY = self.calcRect.size.height - (0 - self.minY)*self.zoomForYAxis - self.yAxisOffset;
                    [linePath addLineToPoint:CGPointMake(point3.x, zeroY)];
                    [linePath addLineToPoint:CGPointMake(self.minX, zeroY)];
                    [linePath closePath];
                }
                else
                {
                    [linePath addLineToPoint:CGPointMake(point3.x, self.calcRect.size.height - self.yAxisOffset)];
                    [linePath addLineToPoint:CGPointMake(self.minX, self.calcRect.size.height - self.yAxisOffset)];
                    [linePath closePath];
                }
            }
            
            self.lineLayer.path = linePath.CGPath;
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 1.0;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [self.lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self performSelector:@selector(pathAnimationStoped) withObject:nil afterDelay:1.0f];
            self.lineLayer.strokeEnd = 1.0;
        }
        
        
        if (validPointCount > 0)
        {
            if (self.showLastPoint) {
                NSValue* pointValue = [mArray objectAtIndex:validPointCount - 1];
                CGPoint point = [pointValue CGPointValue];
                
                [self drawCycleAtPoint:point];
            }
        }
    }
}

- (void)pathAnimationStoped
{
    [self performSelectorOnMainThread:@selector(_pathAnimationStoped_) withObject:nil waitUntilDone:NO];
}

- (void)_pathAnimationStoped_
{
    self.showingAnimation = NO;
    [self setNeedsDisplay];
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
    CGFloat xPositionValue = 0;
    
    NSRange validDataRange = [self.dataSource rangeOfValidCountOfChartItemView:self];
    if (index >= validDataRange.location  && index < validDataRange.location + validDataRange.length) {
        xPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
    }
    CGFloat fixedXPosition = (xPositionValue - self.minX)*self.zoomForXAxis + self.xAxisOffset;
    
    if (index == 0) {
        fixedXPosition = .0f;
    }
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    return fixedPoint.x;
}

// 获取Y方向的位置
- (CGFloat)getYPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
    
    CGFloat yPosition = self.calcRect.size.height - (y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    CGPoint point = [self convertPoint:CGPointMake(xPosition, yPosition) toView:maskView];
    
    return point.y;
}

//// X方向上提醒文字
//- (NSString*)xTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
//{
//    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
//    return [self.dataSource xTipsOfChartItemView:self atIndex:index];
//}

// X方向上提示文字的位置
- (CGRect)xTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString
{
    NSDictionary *attributes = @{NSFontAttributeName:maskView.tipsFont};
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP/2;
    }
    
    rect = CGRectMake(xPos - rect.size.width/2 - tipTextGap,
                      self.calcRect.size.height,
                      rect.size.width + tipTextGap*3,
                      rect.size.height + tipTextGap);
    
    
    CGRect returnRect = CGRectZero;
    if (xPos > rect.size.width/2) {
        if (xPos + rect.size.width/2 < self.calcRect.size.width) {
            returnRect = CGRectMake(xPos - rect.size.width/2,
                                    rect.origin.y,
                                    rect.size.width,
                                    rect.size.height);
        }
        else
        {
            returnRect = CGRectMake(self.calcRect.size.width - rect.size.width,
                                    rect.origin.y,
                                    rect.size.width,
                                    rect.size.height);
        }
    }
    else
    {
        returnRect = CGRectMake(0,
                                rect.origin.y,
                                rect.size.width,
                                rect.size.height);
    }
    
    return returnRect;
}

//// Y方向上提醒文字
//- (NSString*)yTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
//{
//    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
//    return [self.dataSource yTipsOfChartItemView:self atIndex:index];
////    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
////    
////    return [NSString stringWithFormat:@"%.1f",  y];
//}

- (NSDictionary *)dictionaryForShowViewValue:(DYMaskView*)maskView
                                  atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    return [self.dataSource dictionaryForShowViewValue:(id)self.superview atIndex:index];
}

// 选中区间的X方向上的提示文字
- (NSString*)xSelectTipsOfMaskView:(DYMaskView*)maskView fromPosition:(CGFloat)fromPos toPosition:(CGFloat)toPos
{
    return nil;
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
    
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(DYMAX_TIPS_WIDTH, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    return CGRectMake(centerPos - rect.size.width/2 - tipTextGap,
                      self.calcRect.size.height + tipTextGap,
                      rect.size.width + tipTextGap*2,
                      rect.size.height + tipTextGap*2);
}

// 画圆点
- (void)drawCycleAtPoint:(CGPoint)point
{
    UIColor* fillColor = DYAppearanceColor(@"R1", 1.0);
    UIColor* roundColor = DYAppearanceColor(@"R1", 0.3);
    [self drawCycleAtPoint:point strokeColor:roundColor andFillColor:fillColor];
}

- (void)drawCycleAtPoint:(CGPoint)point strokeColor:(UIColor *)strokeColor andFillColor:(UIColor*)fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NAN_OR_INF_POINT_2_ZERO(point);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context,strokeColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, point.x, point.y, 1.2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    
}

@end
