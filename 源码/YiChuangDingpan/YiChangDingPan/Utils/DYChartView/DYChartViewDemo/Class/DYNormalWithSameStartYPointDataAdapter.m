//
//  DYNormalWithSameStartYPointDataAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYNormalWithSameStartYPointDataAdapter.h"
#import "DYChartCandleView.h"
#import "DYIndexPath.h"

@interface DYNormalWithSameStartYPointDataAdapter ()

/**
 *	@brief	存放调整所需缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

/**
 *	@brief	存放调整所需平移的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateTranslationArray;


@end

@implementation DYNormalWithSameStartYPointDataAdapter

- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    [super adapterDataWithStartIndex:startIndex andEndIndex:endIndex];
    
    // 以第一根线为准，其他几根线的起始点向这点靠齐，计算一个新的最大最小值
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        return;
    }
    
    self.calculateTranslationArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.calculateZoomArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    
    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:0];
    id startDataValue = [self.chartView dataValueForDataAdapter:self
                                                  atIndexPath:indexPath];
    CGFloat minY = [self.minYArray[0] floatValue];
    CGFloat maxY = [self.maxYArray[0] floatValue];
    [self.calculateTranslationArray addObject:@(0)];
    
    if (self.adjustMethod == adjustByTranslation) {
        for (NSUInteger i = 1 ; i < chartItemCount ; i ++) {
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
    }
    else if (self.adjustMethod == adjustByZoom) {
        // 待实现
    }
    
    self.minY = minY;
    self.maxY = maxY;
    
    if (!self.notFixDataWith125Rule) {
        DYFixDataBy125RuleResult* result = [DYNormalWithSameStartYPointDataAdapter fixDataBy125RuleWithMinValue:self.minY
                                                                                                    andMaxValue:self.maxY
                                                                                           andDefaultYPartCount:self.yPartCount
                                                                                            andFixPartCountFlag:YES
                                                                                             andIsYZeroInMiddle:self.yZeroInMiddle
                                                                                                andCanvasHeight:self.canvasHeight];
        self.minY = result.minValue;
        self.maxY = result.maxValue;
        self.yZeroPosition = result.yZeroPosition;
        [self setJustYPartCount:result.yPartCount];
    }
    
//    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*self.canvasHeight;
    CGFloat chartHeight = self.canvasHeight;
    self.originalZoomY = chartHeight/(self.maxY - self.minY);
}

- (CGFloat)yOffsetForChartItemViewAtIndex:(NSUInteger)index
{
    if (self.adjustMethod == adjustByTranslation) {
        if ([self.calculateTranslationArray count] > index) {
            return [self.calculateTranslationArray[index] floatValue]*self.originalZoomY;
        }
    }
    
    return .0f;
}

- (DataAdapterType)adapterType
{
    return normalWithSameStartYPoint;
}

@end
