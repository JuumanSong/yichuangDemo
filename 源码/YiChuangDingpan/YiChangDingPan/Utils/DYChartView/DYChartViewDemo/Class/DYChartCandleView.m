//
//  DYChartCandleView.m
//  IntelligenceResearchReport
//  蜡烛图
//  Created by datayes on 16/1/5.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYChartCandleView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"

#define MAX_BAR_WIDTH   128

@implementation DYChartCandleDataItem

//

@end

@implementation DYChartCandleView

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

- (void)drawRect:(CGRect)rect
{
    NSUInteger count = [self.dataSource countOfChartItemView:self];
    if (count > 0) {
        NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
        
        [self calcBarWidth];
        
        for (NSUInteger i = range.location ; i < range.location + range.length ; i ++) {
            DYChartCandleDataItem* item = [self.dataSource dataOfChartItemView:self atIndex:i];
            DYChartCandleDataItem* preItem;
            if (i>0) {
                preItem = [self.dataSource dataOfChartItemView:self atIndex:i-1];
            }else {
                preItem = [self.dataSource dataOfChartItemView:self atIndex:0];
            }
             if (item) {
                [self drawCandleItem:item withLineWidth:self.barWidth withPreCloseItem:preItem];
            }
        }
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
    return self.pointWidth = fabs(barWidth - 0.5) <= 0.5*0.000001 ? 0 : barWidth;
}

- (void)drawCandleItem:(DYChartCandleDataItem*)item
         withLineWidth:(CGFloat)width
      withPreCloseItem:(DYChartCandleDataItem*)preItem
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat frameHeight = self.bounds.size.height;
    
    CGFloat x = (item.xPosition - self.minX)*self.zoomForXAxis + self.xAxisOffset;
    CGFloat openValue = frameHeight - (item.openValue - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    CGFloat closeValue = frameHeight - (item.closeValue - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    CGFloat hightValue = frameHeight - (item.highValue - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    CGFloat lowValue = frameHeight - (item.lowValue - self.minY)*self.zoomForYAxis - self.yAxisOffset;
    
    if (item.openValue < item.closeValue) {
        CGContextSetFillColorWithColor(context, self.riseColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.riseColor.CGColor);
    }
    else if (item.openValue == item.closeValue && preItem){
             if (item.closeValue < preItem.closeValue) {
                CGContextSetFillColorWithColor(context, self.fallColor.CGColor);
                CGContextSetStrokeColorWithColor(context, self.fallColor.CGColor);
            }else {
                CGContextSetFillColorWithColor(context, self.riseColor.CGColor);
                CGContextSetStrokeColorWithColor(context, self.riseColor.CGColor);
            }
     }
    else
    {
        CGContextSetFillColorWithColor(context, self.fallColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.fallColor.CGColor);
    }
    
    // 画实体线
    CGFloat entityHeight = fabs(closeValue - openValue);
    entityHeight = entityHeight > 1 ? entityHeight : 1;
    CGRect entityRect = CGRectMake(x,
                                   openValue > closeValue ? closeValue : openValue,
                                   width,
                                   entityHeight);
    CGContextStrokeRect(context, entityRect);     //画方框
    CGContextFillRect(context, entityRect);       //填充框
    
    // 画影线
    CGContextSetLineWidth(context, 1.0);
    CGPoint aPoints[2];
    aPoints[0] =CGPointMake(x + width/2, hightValue);
    aPoints[1] =CGPointMake(x + width/2, lowValue);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextStrokePath(context);
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
    
    CGPoint fixedPoint = [self convertPoint:CGPointMake(fixedXPosition, 0) toView:maskView];
    fixedPoint.x += self.barWidth/2;
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

- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition
{
//    CGFloat xPositionValue = (xPosition - self.xAxisOffset)/self.zoomForXAxis + self.minX;
    NSRange range = [self.dataSource rangeOfValidCountOfChartItemView:self];
    
    if (range.location + range.length > 0) {
        for (NSInteger index = range.location ; index < (NSInteger)range.location + range.length ; index ++) {
            CGFloat curPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index].x;
            CGFloat nextPositionValue = [self.dataSource pointOfChartItemView:self atIndex:index + 1].x;
            
            CGFloat curPosition = (curPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset + self.barWidth/2;
            CGFloat nextPosition = (nextPositionValue - self.minX)* self.zoomForXAxis + self.xAxisOffset + self.barWidth/2;
            
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

- (CGRect)yTipsRectOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPos withTipString:(NSString*)tipString withFont:(UIFont *)font
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
        tipTextGap = DYTIPS_TEXT_GAP/2;
    }
    
    NSArray* yStringArray = [tipString componentsSeparatedByString:@"\n"];
//    CGFloat addedHeightGap = ([yStringArray count] + 1)*tipTextGap;
//    rect.size.height += addedHeightGap;
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

@end
