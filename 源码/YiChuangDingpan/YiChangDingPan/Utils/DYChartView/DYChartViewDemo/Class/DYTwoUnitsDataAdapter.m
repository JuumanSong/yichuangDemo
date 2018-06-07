//
//  DYTwoUnitsDataAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYTwoUnitsDataAdapter.h"

@interface DYTwoUnitsDataAdapter ()

/**
 *	@brief	存放缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

@end

@implementation DYTwoUnitsDataAdapter

- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    [super adapterDataWithStartIndex:startIndex andEndIndex:endIndex];
    
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        return;
    }
    
    self.calculateZoomArray = [NSMutableArray arrayWithCapacity:chartItemCount];
//    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*self.canvasHeight;
    CGFloat chartHeight = self.canvasHeight;
    
    // 第一个数据以左侧Y轴单位为基准，他有统一的zoom参数
    CGFloat currentMaxY = [self.maxYArray[0] floatValue];
    CGFloat currentMinY = [self.minYArray[0] floatValue];
    
    if (self.drawYZeroLines && currentMinY > 0) {
        currentMinY = .0;
    }
    
    if (!self.notFixDataWith125Rule) {
        DYFixDataBy125RuleResult* result = [DYDataAdapterBase fixDataBy125RuleWithMinValue:currentMinY
                                                                               andMaxValue:currentMaxY
                                                                      andDefaultYPartCount:self.yPartCount
                                                                       andFixPartCountFlag:YES
                                                                        andIsYZeroInMiddle:self.yZeroInMiddle
                                                                           andCanvasHeight:self.canvasHeight];
        currentMinY = result.minValue;
        currentMaxY = result.maxValue;
        
        self.yZeroPosition = result.yZeroPosition;
        [self setJustYPartCount:result.yPartCount];
    }
    
    CGFloat zoomY = 1;
    
    if (currentMinY < currentMaxY) {
        zoomY = chartHeight/(currentMaxY - currentMinY);
    }
    else
    {
        zoomY = chartHeight/(self.maxY - self.minY);
    }
    
    [self.calculateZoomArray addObject:@(zoomY)];
    
    self.maxY = currentMaxY;
    self.minY = currentMinY;
    self.originalZoomY = zoomY;
    
    
    // 后续的数据以右侧单位为基准，他们拥有统一的zoom参数，保证最大振幅
    CGFloat minY = MAXFLOAT;
    CGFloat maxY = -MAXFLOAT;
    for (NSUInteger i = 1 ; i < chartItemCount ; i ++) {
        currentMaxY = [self.maxYArray[i] floatValue];
        currentMinY = [self.minYArray[i] floatValue];
        
        if (minY > currentMinY) {
            minY = currentMinY;
        }
        if (maxY < currentMaxY) {
            maxY = currentMaxY;
        }
    }
    
    BOOL isFix = NO;
    if (chartItemCount == 2) {
        isFix = YES;
    }
    
    if (self.drawYZeroLines && minY > 0) {
        minY = .0;
    }
    
    if (!self.notFixDataWith125Rule) {
        DYFixDataBy125RuleResult* result = [DYDataAdapterBase fixDataBy125RuleWithMinValue:minY
                                                                               andMaxValue:maxY
                                                                      andDefaultYPartCount:self.yRightPartCount
                                                                       andFixPartCountFlag:isFix
                                                                        andIsYZeroInMiddle:self.yZeroInMiddle
                                                                           andCanvasHeight:self.canvasHeight];
        minY = result.minValue;
        maxY = result.maxValue;
        
        self.yRightZeroPosition = result.yZeroPosition;
        [self setJustYRightPartCount:result.yPartCount];
    }
    
    // 计算后续数据的统一缩放系数
    if (minY < maxY) {
        zoomY = chartHeight/(maxY - minY);
    }
    else
    {
        zoomY = chartHeight/(self.maxY - self.minY);
    }
    
    [self.calculateZoomArray addObject:@(zoomY)];
    
    self.originalRightZoomY = zoomY;
    self.maxRightY = maxY;
    self.minRightY = minY;
}

- (CGFloat)yZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    if (index == 0) {
        if ([self.calculateZoomArray count] > index) {
            return [self.calculateZoomArray[index] floatValue];
        }
    }
    else
    {
        // 后续数据统一缩放系数
        if ([self.calculateZoomArray count] > 1) {
            return [self.calculateZoomArray[1] floatValue];
        }
    }
    
    return .0f;
}

- (CGFloat)yRightMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.minRightY;
}

- (DataAdapterType)adapterType
{
    return twoUnitsAdapter;
}

@end
