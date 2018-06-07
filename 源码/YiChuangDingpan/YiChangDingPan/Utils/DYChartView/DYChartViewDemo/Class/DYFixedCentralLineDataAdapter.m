//
//  DYFixedCentralLineDataAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/15.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYFixedCentralLineDataAdapter.h"
#import "DYChartCandleView.h"
#import "DYIndexPath.h"

@implementation DYFixedCentralLineDataAdapter

- (BOOL)calcMinMaxValueWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    if (startIndex >= endIndex) {
        return NO;
    }
    
//    self.minX = startIndex;
//    self.maxX = endIndex;
//    
//    if (self.redesignMaxX) {
//        self.maxX = [self getMaxXDataWithMinX:self.minX andMaxV:self.maxX];
//    }
    
    self.minX = MAXFLOAT;
    self.maxX = -MAXFLOAT;
    
    self.minY = MAXFLOAT;
    self.maxY = -MAXFLOAT;
    
    NSUInteger chartItemCount = [self.chartView countOfChartItemViewForDataAdapter:self];
    if (chartItemCount <= 0) {
        self.minX = 0;
        self.maxX = 0;
        
        self.minY = 0;
        self.maxY = 0;
        return NO;
    }
    
    self.minYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.maxYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.minXArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.maxXArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    self.startYArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    
    BOOL hitData = NO;
    for (NSUInteger i = 0; i < chartItemCount ; i ++) {
        CGFloat minXOfChartItemView = MAXFLOAT;
        CGFloat maxXOfChartItemView = -MAXFLOAT;
        CGFloat minYOfChartItemView = MAXFLOAT;
        CGFloat maxYOfChartItemView = -MAXFLOAT;
        
        NSRange validDataRange = [self.chartView rangeOfValidDataForDataAdapter:self atIndex:i];
        for (NSUInteger j = validDataRange.location ; j < validDataRange.location + validDataRange.length ; j ++) {
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:j inSection:i];
            
            id dataValue = [self.chartView dataValueForDataAdapter:self
                                                       atIndexPath:indexPath];
            id dataXValue = @(j);
            if ([self.chartView respondsToSelector:@selector(dataXValueForDataAdapter:atIndexPath:)]) {
                dataXValue = [self.chartView dataXValueForDataAdapter:self atIndexPath:indexPath];
            }
            
            if (dataValue==nil) {
                continue;
            }
            
            if (j == startIndex) {
                [self.startYArray addObject:dataValue];
            }
            
            if ([dataValue isKindOfClass:[NSNumber class]]) {
                CGFloat yValue = [dataValue floatValue];
                CGFloat xValue = [dataXValue floatValue];
                
                if (yValue < -MAXFLOAT/2) {
                    continue;
                }
                
                if (yValue > self.maxY) {
                    self.maxY = yValue;
                }
                if (yValue < self.minY) {
                    self.minY = yValue;
                }
                if (xValue > self.maxX) {
                    self.maxX = xValue;
                }
                if (xValue < self.minX) {
                    self.minX = xValue;
                }
                
                if (yValue > maxYOfChartItemView) {
                    maxYOfChartItemView = yValue;
                }
                if (yValue < minYOfChartItemView) {
                    minYOfChartItemView = yValue;
                }
                if (xValue > maxXOfChartItemView) {
                    maxXOfChartItemView = xValue;
                }
                if (xValue < minXOfChartItemView) {
                    minXOfChartItemView = xValue;
                }
                
                hitData = YES;
            }
            else if ([dataValue isKindOfClass:[DYChartCandleDataItem class]]) {
                DYChartCandleDataItem* dataItem = dataValue;
                
                if (dataItem.highValue > self.maxY) {
                    self.maxY = dataItem.highValue;
                }
                if (dataItem.lowValue < self.minY) {
                    self.minY = dataItem.lowValue;
                }
                if (dataItem.xPosition > self.maxX) {
                    self.maxX = dataItem.xPosition;
                }
                if (dataItem.xPosition < self.minX) {
                    self.minX = dataItem.xPosition;
                }
                
                if (dataItem.highValue > maxYOfChartItemView) {
                    maxYOfChartItemView = dataItem.highValue;
                }
                if (dataItem.lowValue < minYOfChartItemView) {
                    minYOfChartItemView = dataItem.lowValue;
                }
                if (dataItem.xPosition > maxXOfChartItemView) {
                    maxXOfChartItemView = dataItem.xPosition;
                }
                if (dataItem.xPosition < minXOfChartItemView) {
                    minXOfChartItemView = dataItem.xPosition;
                }
                
                hitData = YES;
            }
        }
        
        [self.minXArray addObject:@(minXOfChartItemView)];
        [self.maxXArray addObject:@(maxXOfChartItemView)];
        
        if (minYOfChartItemView == maxYOfChartItemView) {
            minYOfChartItemView -= .2;
            maxYOfChartItemView += .2;
        }
        [self.minYArray addObject:@(minYOfChartItemView)];
        [self.maxYArray addObject:@(maxYOfChartItemView)];
    }
    
    if (!hitData) {
        self.minY = 0;
        self.maxY = 0;
    }
    
    // 调整中线
    if (self.minY > self.reserveValue) {
        self.minY = self.reserveValue - (self.maxY - self.reserveValue);
    }
    else if (self.maxY < self.reserveValue) {
        self.maxY = self.reserveValue + (self.reserveValue - self.minY);
    }
    else {
        if (fabs(self.maxY - self.reserveValue) > fabs(self.reserveValue - self.minY)) {
            self.minY = self.reserveValue - (self.maxY - self.reserveValue);
        }
        else
        {
            self.maxY = self.reserveValue + (self.reserveValue - self.minY);
        }
    }
    
    if (self.topGapPercent + self.bottomGapPercent > 0 &&
        self.topGapPercent + self.bottomGapPercent < 1 &&
        self.maxY != .0 && self.minY != .0) {
        self.maxY += self.topGapPercent*(self.maxY - self.minY);
        self.minY -= self.bottomGapPercent*(self.maxY - self.minY);
    }
    
    return YES;
}

@end
