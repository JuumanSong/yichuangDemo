//
//  DYMixedData1_2_XAdapter.m
//  DYChartViewDemo
//
//  Created by 鄢彭超 on 2016/9/28.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYMixedData1_2_XAdapter.h"

@interface DYMixedData1_2_XAdapter ()

/**
 *	@brief	存放缩放比的数组
 */
@property (nonatomic, strong)NSMutableArray* calculateZoomArray;

@property (nonatomic, strong)NSMutableArray* calculateMinYArray;

@end

@implementation DYMixedData1_2_XAdapter

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
    
    for (NSUInteger i = 0 ; i < chartItemCount ; i ++) {
        CGFloat currentMaxY = [self.maxYArray[i] floatValue];
        CGFloat currentMinY = [self.minYArray[i] floatValue];
        
        BOOL isLeft = NO;
        BOOL isFix = NO;
        if (i == 0) {
            isLeft = YES;
            isFix = YES;
        }
        else if (i == 1)
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
            DYFixDataBy125RuleResult* result = [DYMixedData1_2_XAdapter fixDataBy125RuleWithMinValue:currentMinY
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
        else if (i == 1) {
            self.minRightY = currentMinY;
            self.maxRightY = currentMaxY;
        }
        
        [self.calculateMinYArray addObject:@(currentMinY)];
        
        CGFloat zoomY = 1;
        if (currentMinY < currentMaxY) {
            zoomY = chartHeight/(currentMaxY - currentMinY);
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
    return twoUnitsWith1_2_X;
}

@end
