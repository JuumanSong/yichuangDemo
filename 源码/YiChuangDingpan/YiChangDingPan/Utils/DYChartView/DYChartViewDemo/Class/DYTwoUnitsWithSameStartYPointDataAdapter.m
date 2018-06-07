//
//  DYTwoUnitsWithSameStartYPointDataAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYTwoUnitsWithSameStartYPointDataAdapter.h"
#import "DYChartCandleView.h"
#import "DYIndexPath.h"

@interface DYTwoUnitsWithSameStartYPointDataAdapter ()

/**
 *	@brief	存放调整所需缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

/**
 *	@brief	存放调整所需平移的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateTranslationArray;


@end

@implementation DYTwoUnitsWithSameStartYPointDataAdapter

- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    [super adapterDataWithStartIndex:startIndex andEndIndex:endIndex];
    
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        return;
    }
    
    self.calculateZoomArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.calculateTranslationArray = [NSMutableArray arrayWithCapacity:chartItemCount];
//    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*self.canvasHeight;
    CGFloat chartHeight = self.canvasHeight;
    
    // 第一个数据以左侧Y轴单位为基准，他有统一的zoom参数
    CGFloat currentMaxY = [self.maxYArray[0] floatValue];
    CGFloat currentMinY = [self.minYArray[0] floatValue];
    
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
    [self.calculateTranslationArray addObject:@(0)];
    
    self.originalZoomY = zoomY;
    self.maxY = currentMaxY;
    self.minY = currentMinY;
    
    if (chartItemCount <= 1) {
        return;
    }
    
    // 后续的数据以右侧单位为基准，他们拥有统一的zoom参数，保证最大振幅
    // 后续有多组数据，其他数据以后续的第一组为准
    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:1];
    id startDataValue = [self.chartView dataValueForDataAdapter:self
                                                  atIndexPath:indexPath];
    CGFloat minY = [self.minYArray[1] floatValue];
    CGFloat maxY = [self.maxYArray[1] floatValue];
    [self.calculateTranslationArray addObject:@(0)];
    
    if (self.adjustMethod == adjustByTranslation) {
        for (NSUInteger i = 2 ; i < chartItemCount ; i ++) {
            CGFloat currentMaxY = [self.maxYArray[i] floatValue];
            CGFloat currentMinY = [self.minYArray[i] floatValue];
            
            indexPath = [DYIndexPath indexPathForRow:0 inSection:i];
            
            id currentYValue = [self.chartView dataValueForDataAdapter:self
                                                         atIndexPath:indexPath];
            
            if ([currentYValue isKindOfClass:[NSNumber class]]) {
                if ([currentYValue floatValue] < -MAXFLOAT/2) {
                    currentYValue = @(.0f);
                }
                
                CGFloat startYValue = [startDataValue floatValue];
                if (startYValue < -MAXFLOAT/2) {
                    startYValue = .0f;
                }
                
                CGFloat calculatedMaxY = currentMaxY + (startYValue - [currentYValue floatValue]);
                CGFloat calculatedMinY = currentMinY + (startYValue - [currentYValue floatValue]);
                
                [self.calculateTranslationArray addObject:@(startYValue - [currentYValue floatValue])];
                
                if (minY > calculatedMinY) {
                    minY = calculatedMinY;
                }
                if (maxY < calculatedMaxY) {
                    maxY = calculatedMaxY;
                }
            }
            else if ([currentYValue isKindOfClass:[DYChartCandleDataItem class]]) {
                // 有K线图的一般都不会有这样的需求
                continue;
            }
        }
        
        BOOL isFix = NO;
        if (chartItemCount == 2) {
            isFix = YES;
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
        
        zoomY = chartHeight/(maxY - minY);
        [self.calculateZoomArray addObject:@(zoomY)];
        
        self.originalRightZoomY = zoomY;
        self.maxRightY = maxY;
        self.minRightY = minY;
    }
    else if (self.adjustMethod == adjustByZoom) {
        // 待实现
    }
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
        if (self.adjustMethod == adjustByTranslation) {
            if ([self.calculateZoomArray count] > 1) {
                return [self.calculateZoomArray[1] floatValue];
            }
        }
        else
        {
            if ([self.calculateZoomArray count] > index) {
                return [self.calculateZoomArray[index] floatValue];
            }
        }
    }
    
    return .0f;
}

- (CGFloat)yOffsetForChartItemViewAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return [super yOffsetForChartItemViewAtIndex:index];
    }
    else
    {
        if (self.adjustMethod == adjustByTranslation) {
            if ([self.calculateTranslationArray count] > index &&
                [self.calculateZoomArray count] > 1) {
                return [self.calculateTranslationArray[index] floatValue]*[self.calculateZoomArray[1] floatValue];
            }
        }
        else
        {
            return [super yOffsetForChartItemViewAtIndex:index];
        }
    }
    
    return .0f;
}

- (CGFloat)yRightZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    if (self.adjustMethod == adjustByTranslation) {
        if ([self.calculateZoomArray count] > 1) {
            return [self.calculateZoomArray[1] floatValue];
        }
    }
    else
    {
        if ([self.calculateZoomArray count] > index) {
            return [self.calculateZoomArray[index] floatValue];
        }
    }
    
    return .0f;
}

- (CGFloat)yRightOffsetForChartItemViewAtIndex:(NSUInteger)index
{
    if (self.adjustMethod == adjustByTranslation) {
        if ([self.calculateTranslationArray count] > index &&
            [self.calculateZoomArray count]) {
            return [self.calculateTranslationArray[index] floatValue]*[self.calculateZoomArray[1] floatValue];
        }
    }
    else
    {
        return [super yOffsetForChartItemViewAtIndex:index];
    }
    
    return .0f;
}

- (CGFloat)yRightMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    return self.minRightY;
}

- (DataAdapterType)adapterType
{
    return twoUnitsWithSameStartYPoint;
}

@end
