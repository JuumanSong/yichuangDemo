//
//  DYChartItemView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYChartItemView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"

@implementation DYChartItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        _lineWidth = 1.5f;
        _bindMaskView = YES;
    }
    return self;
}

- (void)showAnimation{}

- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition
{
    NSInteger index = [self getIndexFromXPosition:xPosition fromView:maskView];
    
    CGFloat xPositionValue = 0;
    
    NSRange validDataRange = [self.dataSource rangeOfValidCountOfChartItemView:self];
    if (index >= validDataRange.location  && index < validDataRange.location + validDataRange.length) {
        xPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
    }
    CGFloat fixedXPosition = (xPositionValue - self.minX)*self.zoomForXAxis + self.xAxisOffset;
    
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
    CGFloat fixedXPosition = (xPositionValue - self.minX)*self.zoomForXAxis + self.xAxisOffset;
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    return fixedPoint.x;
}

- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition fromView:(UIView*)fromView
{
    CGPoint point = [fromView convertPoint:CGPointMake(xPosition, 0) toView:self];
    NSInteger index = [self getIndexFromXPosition:point.x];
    
//    DDLogInfo(@"xPosition : %.02f point.x : %0.2f index : %ld", xPosition, point.x, (long)index);
    
    return index;
}

- (int64_t)getTimestampFromXPosition:(CGFloat)xPosition fromView:(UIView*)fromView
{
    CGPoint point = [fromView convertPoint:CGPointMake(xPosition, 0) toView:self];
    return [self getTimestampValueFromXPosition:point.x];
}

- (CGFloat)calcPointWidth
{
    return .0f;
}

- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition
{
//    CGFloat xPositionValue = (xPosition - self.xAxisOffset)/self.zoomForXAxis + self.minX;
    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
    
    if (range.location + range.length > 0) {
        for (NSInteger index = range.location ; index < (NSInteger)range.location + range.length - 1; index ++) {
            CGFloat curPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
            CGFloat nextPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index + 1].x;
            
            CGFloat curPosition = (curPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset;
            CGFloat nextPosition = (nextPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset;
            
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

- (int64_t)getTimestampValueFromXPosition:(CGFloat)xPosition
{
    int64_t xPositionValue = (xPosition - self.xAxisOffset)/self.zoomForXAxis + self.minX;
    
    // 因为接口给的时间戳都是0点0分的，为了避免误差，给时间戳加上半小时，最大程度上避免误差
    return xPositionValue + 30*60*1000;
}

#pragma mark - DYMaskViewDataSource functions

// Y方向上带颜色的提醒文字的字体数组
- (UIFont*)yColorTipsFontOfMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsFontOfChartItemView:)]) {
        return [self.dataSource yColorTipsFontOfChartItemView:self];
    }
    
    return DYAppearanceFont(@"T15");
}

// Y方向上带颜色的提醒文字的颜色数组
- (NSArray*)yColorTipsColorOfMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsColorOfChartItemView:)]) {
        return [self.dataSource yColorTipsColorOfChartItemView:self];
    }
    return @[[DYAppearance colorWithRGB:0xaef6ff],
             [DYAppearance colorWithRGB:0x99e2f5],
             [DYAppearance colorWithRGB:0x2dc0e8],
             [DYAppearance colorWithRGB:0x008eb4],
             [DYAppearance colorWithRGB:0x006c89]];
}

// 是否在带颜色的提醒文字的前面显示带颜色的小圆圈
- (BOOL)ifDrawPointBeforeYColorTipsOfMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(ifDrawPointBeforeYColorTipsOfChartItemView:)]) {
        return [self.dataSource ifDrawPointBeforeYColorTipsOfChartItemView:self];
    }
    return YES;
}

- (NSString*)xTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(xTipsOfChartItemView:atPosition:)]) {
        return [self.dataSource xTipsOfChartItemView:self atPosition:xPos];
    }
    else {
        NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
        return [self.dataSource xTipsOfChartItemView:self atIndex:index];
    }
}

- (NSString*)yTipsOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsOfChartItemView:atPosition:)]) {
        return [self.dataSource yTipsOfChartItemView:self atPosition:xPos];
    }
    else {
        NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
        return [self.dataSource yTipsOfChartItemView:self atIndex:index];
    }
}

- (UIFont*)yTipsFontOfMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsFontOfChartItemView:)]) {
        return [self.dataSource yTipsFontOfChartItemView:self];
    }
    return DYAppearanceFont(@"T15");
}

// Y方向上提醒文字的颜色
- (NSArray*)yTipsColorOfMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsColorOfChartItemView:)]) {
        return [self.dataSource yTipsColorOfChartItemView:self];
    }
    return @[DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0)];
}

- (UIColor*)colorOfTipsForMaskView:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(colorOfTipsOfChartItemView:)]) {
        return [self.dataSource colorOfTipsOfChartItemView:self];
    }
    
    return [DYAppearance colorWithRGB:0xc2c5c9];
}

- (UIFont*)fontOfTipsForMask:(DYMaskView*)maskView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(fontOfChartItemView:)]) {
        return [self.dataSource fontOfChartItemView:self];
    }
    return DYAppearanceFont(@"T1");
}

- (CGRect)yTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString withFont:(UIFont *)font
{
    if (_tipRectFollowWithFinger) {
        return [self followYTipsRectOfMaskView:maskView atPosition:xPos withTipString:tipString withFont:font];
    } else {
        return [self normalYTipsRectOfMaskView:maskView atPosition:xPos withTipString:tipString withFont:font];
    }
}

- (CGRect)normalYTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString withFont:(UIFont *)font
{
    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
    if (y < -MAXFLOAT/2) {
        y = self.bounds.size.height/2;
    }
    else
    {
        y = self.bounds.size.height -  (y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP;
    }
    
    NSArray* yStringArray = [tipString componentsSeparatedByString:@"\n"];
    CGFloat addedHeightGap = ([yStringArray count] + 1)*tipTextGap;
    rect.size.height += addedHeightGap;
    
    CGFloat addedWidthGap = tipTextGap*2;
    if ([yStringArray count] > 0) {
        NSString* lastLineString = yStringArray[[yStringArray count] - 1];
        // 文字有两组需要显示的话，宽度增加他们之间的间隙
        if ([[lastLineString componentsSeparatedByString:@"&"] count] > 1) {
            addedWidthGap += tipTextGap;
        }
    }
    if ([self.dataSource ifDrawPointBeforeYColorTipsOfChartItemView:self]) {
        addedWidthGap += DYTIPS_CYCLE_POINT_WIDTH + tipTextGap;
    }
    rect.size.width += addedWidthGap;
    rect.origin.x += self.xAxisOffset;
    
    CGRect returnRect = CGRectZero;
    // 显示在点上面或者下面的情况
    if (y > rect.size.height) {
        if (xPos > rect.size.width/2) {
            if (xPos + rect.size.width/2 < self.bounds.size.width) {
                returnRect = CGRectMake(xPos - rect.size.width/2,
                                        (self.bounds.size.height - rect.size.height)/2,
                                        rect.size.width,
                                        rect.size.height);
            }
            else
            {
                returnRect = CGRectMake(self.bounds.size.width - rect.size.width,
                                        (self.bounds.size.height - rect.size.height)/2,
                                        rect.size.width,
                                        rect.size.height);
            }
        }
        else
        {
            returnRect = CGRectMake(0,
                                    (self.bounds.size.height - rect.size.height)/2,
                                    rect.size.width,
                                    rect.size.height);
        }
    }
    else
    {
        if (xPos > rect.size.width/2) {
            if (xPos + rect.size.width/2 < self.bounds.size.width) {
                returnRect = CGRectMake(xPos - rect.size.width/2,
                                        (self.bounds.size.height - rect.size.height)/2,
                                        rect.size.width,
                                        rect.size.height);
            }
            else
            {
                returnRect = CGRectMake(self.bounds.size.width - rect.size.width,
                                        (self.bounds.size.height - rect.size.height)/2,
                                        rect.size.width,
                                        rect.size.height);
            }
        }
        else
        {
            returnRect = CGRectMake(0,
                                    (self.bounds.size.height - rect.size.height)/2,
                                    rect.size.width,
                                    rect.size.height);
        }
    }
    
    return [self convertRect:returnRect toView:maskView];
}

- (CGRect)followYTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString withFont:(UIFont *)font
{
    NSInteger index = [self getIndexFromXPosition:xPos fromView:maskView];
    CGFloat y = [self.dataSource pointOfChartItemView:self atIndex:index].y;
    if (y < -MAXFLOAT/2) {
        y = self.bounds.size.height/2;
    }
    else
    {
        if (isinf(self.zoomForYAxis)) {
            y = .0f;
        } else {
            y = self.bounds.size.height -  (y - self.minY)*self.zoomForYAxis - self.yAxisOffset;
        }
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [tipString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat tipTextGap = maskView.tipTextGap;
    if (tipTextGap < 0) {
        tipTextGap = DYTIPS_TEXT_GAP/2;
    }
    
    NSArray* yStringArray = [tipString componentsSeparatedByString:@"\n"];
//    CGFloat addedHeightGap = ([yStringArray count] + 1)*tipTextGap;
    rect.size.height += tipTextGap;
    
    CGFloat addedWidthGap = tipTextGap*2;
    if ([yStringArray count] > 0) {
        NSString* lastLineString = yStringArray[[yStringArray count] - 1];
        // 文字有两组需要显示的话，宽度增加他们之间的间隙
        if ([[lastLineString componentsSeparatedByString:@"&"] count] > 1) {
            addedWidthGap += tipTextGap;
        }
    }
    if ([self.dataSource ifDrawPointBeforeYColorTipsOfChartItemView:self]) {
        addedWidthGap += DYTIPS_CYCLE_POINT_WIDTH + tipTextGap;
    }
    rect.size.width += addedWidthGap;
    rect.origin.x += self.xAxisOffset;
    
    CGRect returnRect = CGRectZero;
    CGRect chartItemViewFrame = self.bounds;
    // 显示在点上面或者下面的情况
    
    if (y < rect.size.height/2) {   // 到顶了
        returnRect = CGRectMake(0,
                                0,
                                rect.size.width,
                                rect.size.height);
    } else if (y + rect.size.height/2 > chartItemViewFrame.size.height) {   // 到底了
        returnRect = CGRectMake(0,
                                chartItemViewFrame.size.height - rect.size.height,
                                rect.size.width,
                                rect.size.height);
    }
    else    // 在中间
    {
        returnRect = CGRectMake(0,
                                y - rect.size.height/2,
                                rect.size.width,
                                rect.size.height);
    }
    
    return [self convertRect:returnRect toView:maskView];
}

- (BOOL)isBindMaskView:(DYMaskView*)maskView
{
    return _bindMaskView;
}

@end
