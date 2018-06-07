//
//  DYMixedDataWithNoUnitsAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/2.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYMixedDataWithNoUnitsAdapter.h"

@interface DYMixedDataWithNoUnitsAdapter ()

/**
 *	@brief	存放缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

@property (nonatomic, strong)NSMutableArray* calculateMinYArray;

@end

@implementation DYMixedDataWithNoUnitsAdapter

- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    [super adapterDataWithStartIndex:startIndex andEndIndex:endIndex];
    
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        return;
    }
    
    self.calculateZoomArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.calculateMinYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
//    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*self.canvasHeight;
    CGFloat chartHeight = self.canvasHeight;
    
    // 第二根轴需要赋值maxRightY
    if (chartItemCount > 1) {
        self.maxRightY = [self.maxYArray[1] floatValue];
        self.minRightY = [self.minYArray[1] floatValue];
    }
    
    for (NSUInteger i = 0 ; i < chartItemCount ; i ++) {
        CGFloat currentMaxY = [self.maxYArray[i] floatValue];
        CGFloat currentMinY = [self.minYArray[i] floatValue];
        
        BOOL isLeft = NO;
        BOOL isFix = NO;
        if (i == 0) {
            isLeft = YES;
            isFix = YES;
        }
        else if (i == 1 && chartItemCount == 2)
        {
            isLeft = NO;
            isFix = YES;
        }
        else
        {
            isLeft = NO;
            isFix = NO;
        }
        
        if (self.drawYZeroLines && currentMinY > 0) {
            currentMinY = .0;
        }
        
        if (i < 2 && !self.notFixDataWith125Rule) {
            DYFixDataBy125RuleResult* result = [DYMixedDataWithNoUnitsAdapter fixDataBy125RuleWithMinValue:currentMinY
                                                                                             andMaxValue:currentMaxY
                                                                                    andDefaultYPartCount:isLeft ? self.yPartCount : self.yRightPartCount
                                                                                     andFixPartCountFlag:isFix
                                                                                      andIsYZeroInMiddle:self.yZeroInMiddle
                                                                                         andCanvasHeight:self.canvasHeight];
            currentMinY = result.minValue;
            currentMaxY = result.maxValue;
            
            if (isLeft) {
                self.yZeroPosition = result.yZeroPosition;
                [self setJustYPartCount:result.yPartCount];
            }
            else {
                self.yRightZeroPosition = result.yZeroPosition;
                [self setJustYRightPartCount:result.yPartCount];
            }
        }
        
        if (i == 0) {
            self.minY = currentMinY;
            self.maxY = currentMaxY;
        }
        [self.calculateMinYArray addObject:@(currentMinY)];
        
        CGFloat zoomY = 1;
        if (currentMinY < currentMaxY) {
            zoomY = chartHeight/(currentMaxY - currentMinY);
        }
        else
        {
            zoomY = chartHeight/(self.maxY - self.minY);
        }
        
        [self.calculateZoomArray addObject:@(zoomY)];
    }
}

- (CGFloat)yZoomValueForChartItemViewAtIndex:(NSUInteger)index
{
    if ([self.calculateZoomArray count] > index) {
        return [self.calculateZoomArray[index] floatValue];
    }
    
    return .0f;
}

- (CGFloat)yRightMinValueForChartItemViewAtIndex:(NSUInteger)index
{
    if ([self.calculateMinYArray count] > index) {
        return [self.calculateMinYArray[index] floatValue];
    }
    
    return .0f;
}

- (DataAdapterType)adapterType
{
    return mixedDataWithNoUnitsAdapter;
}

@end
