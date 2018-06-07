//
//  DYTwoUnitsReverseDataAdapter.m
//  DYChartViewDemo
//
//  Created by 鄢彭超 on 2016/9/28.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYTwoUnitsReverseDataAdapter.h"

@interface DYTwoUnitsReverseDataAdapter ()

/**
 *	@brief	存放缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

@end

@implementation DYTwoUnitsReverseDataAdapter

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
    CGFloat currentMaxY = .0f;
    CGFloat currentMinY = .0f;
    CGFloat zoomY = 1;
    
    // 0到N-2序号的数据以左侧单位为基准，他们拥有统一的zoom参数，保证最大振幅
    CGFloat minY = MAXFLOAT;
    CGFloat maxY = -MAXFLOAT;
    for (NSUInteger i = 0 ; i < chartItemCount - 1 ; i ++) {
        currentMaxY = [self.maxYArray[i] floatValue];
        currentMinY = [self.minYArray[i] floatValue];
        
        if (minY > currentMinY) {
            minY = currentMinY;
        }
        if (maxY < currentMaxY) {
            maxY = currentMaxY;
        }
    }
    
    if (self.drawYZeroLines && minY > 0) {
        minY = .0;
    }
    
    if (!self.notFixDataWith125Rule) {
        DYFixDataBy125RuleResult* result = [DYDataAdapterBase fixDataBy125RuleWithMinValue:minY
                                                                               andMaxValue:maxY
                                                                      andDefaultYPartCount:self.yPartCount
                                                                       andFixPartCountFlag:YES
                                                                        andIsYZeroInMiddle:self.yZeroInMiddle
                                                                           andCanvasHeight:self.canvasHeight];
        minY = result.minValue;
        maxY = result.maxValue;
        
        self.yZeroPosition = result.yZeroPosition;
        [self setJustYPartCount:result.yPartCount];
    }
    
    // 计算后续数据的统一缩放系数
    if (minY < maxY) {
        zoomY = chartHeight/(maxY - minY);
    }
    
    [self.calculateZoomArray addObject:@(zoomY)];
    
    self.originalZoomY = zoomY;
    self.maxY = maxY;
    self.minY = minY;
    
    
    // 第N-1个数据以右侧Y轴单位为基准，他有统一的zoom参数
    currentMaxY = [self.maxYArray[chartItemCount - 1] floatValue];
    currentMinY = [self.minYArray[chartItemCount - 1] floatValue];
    
    if (self.drawYZeroLines && currentMinY > 0) {
        currentMinY = .0;
    }
    
    if (!self.notFixDataWith125Rule) {
        DYFixDataBy125RuleResult* result = [DYDataAdapterBase fixDataBy125RuleWithMinValue:currentMinY
                                                                               andMaxValue:currentMaxY
                                                                      andDefaultYPartCount:self.yRightPartCount
                                                                       andFixPartCountFlag:NO
                                                                        andIsYZeroInMiddle:self.yZeroInMiddle
                                                                           andCanvasHeight:self.canvasHeight];
        currentMinY = result.minValue;
        currentMaxY = result.maxValue;
        
        self.yRightZeroPosition = result.yZeroPosition;
        [self setJustYRightPartCount:result.yPartCount];
    }
    
    zoomY = 1;
    if (currentMinY < currentMaxY) {
        zoomY = chartHeight/(currentMaxY - currentMinY);
    }
    
    [self.calculateZoomArray addObject:@(zoomY)];
    
    self.maxRightY = currentMaxY;
    self.minRightY = currentMinY;
    self.originalRightZoomY = zoomY;
}

- (CGFloat)yZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount > 0) {
        // 右轴
        if (index == chartItemCount - 1) {
            if ([self.calculateZoomArray count] > 1) {
                return [self.calculateZoomArray[1] floatValue];
            }
            else if ([self.calculateZoomArray count] > 0) {
                return [self.calculateZoomArray[0] floatValue];
            }
        }
        else
        {
            // 左轴
            if ([self.calculateZoomArray count] > 0) {
                return [self.calculateZoomArray[0] floatValue];
            }
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
    return twoUnitsReverseAdapter;
}

- (CGFloat)xZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.originalZoomX;
}

- (CGFloat)yMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.minY;
}

@end
