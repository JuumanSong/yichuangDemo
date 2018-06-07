//
//  DYHotChartView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/28.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYHotChartView.h"

@interface DYHotChartView ()

@end

@implementation DYHotChartView

- (void)drawRect:(CGRect)rect {
//    [self setupBasicProperty];
//    [self setupFixedSubViews];
    self.leftYAxisView.offset = 8;
    self.rightYAxisView.axisPosition = eAxisPositionRight;
    self.rightYAxisView.textAlignment = NSTextAlignmentRight;
    self.rightYAxisView.offset = 8;
    [super drawRect:rect];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setupBasicProperty
{
    [super setupBasicProperty];
    
    self.autoResizeYZoom = YES;
    self.drawXDashedLines = YES;
    self.drawYDashedLines = NO;
    
    self.yTop = 20;
    self.xLeft = 30;
    self.xRight = 28;
}

- (void)setupFixedSubViews
{
    [super setupFixedSubViews];
    
    self.leftYAxisView.axisPosition = eAxisPositionLeft;
    self.leftYAxisView.drawContentFlag = eDrawAxis | eDrawMajorScaleText;
    self.leftYAxisView.textAlignment = NSTextAlignmentLeft;
    self.leftYAxisView.axisWidth = 1;
    self.leftYAxisView.majorScaleLength = 0;
    self.leftYAxisView.textEdgeOffset = 2;
    self.leftYAxisView.offset = 8;
    
    self.rightYAxisView.axisPosition = eAxisPositionRight;
    self.rightYAxisView.drawContentFlag = eDrawAxis | eDrawMajorScaleText;
    self.rightYAxisView.textAlignment = NSTextAlignmentRight;
    self.rightYAxisView.axisWidth = 1;
    self.rightYAxisView.majorScaleLength = 0;
    self.rightYAxisView.textEdgeOffset = 2;
    self.rightYAxisView.offset = 8;
}

- (void)resetDataAdapter
{
    CGRect rect = self.canvasRect;
     self.dataAdapter.canvasWidth = rect.size.width;
    self.dataAdapter.canvasHeight = rect.size.height;
    self.dataAdapter.yPartCount = 7;
    self.dataAdapter.yRightPartCount = 7;
    self.dataAdapter.xPartCount = 12;
    
    [self.dataAdapter adapterData];
}

- (CGRect)leftYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(self.xLeft,
                      self.yTop,
                      self.yWidth,
                      parentBounds.size.height - self.yTop - self.yBottom);
}

- (CGRect)rightYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(parentBounds.size.width - self.yWidth,
                      self.yTop,
                      self.yWidth,
                      parentBounds.size.height - self.yTop - self.yBottom);
}

// 大刻度占有的空间
- (NSInteger)dataIndexForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    NSUInteger chartItemCount = [self.dataSource countOfChartItemViewForChartView:self];
    NSUInteger maxCount = 0;
    
    for (NSUInteger i = 0 ; i < chartItemCount ; i ++) {
        NSUInteger dataCount = [self.dataSource countOfDataForChartView:self atIndex:i];
        EDYChartItemViewType type = [self.dataSource chartItemViewTypeForChartView:self
                                                                           atIndex:i];
        if (type == eDYChartTypeBar ||
            type == eDYChartTypeGroupBar) {
            dataCount --;
        }
        if (maxCount < dataCount) {
            maxCount = dataCount;
        }
    }
    
    if (maxCount <= 0) {
        return 0;
    }
    
    NSInteger numberOfScale = [self numberOfScaleSections:axisView];
    
    if (numberOfScale < 2) {
        maxCount -= 1;
    }
    NSInteger dataIndex = 0;
    if (numberOfScale > 0) {
        NSInteger jumpCountPerSection = maxCount/numberOfScale + (maxCount%numberOfScale == 0 ? 0 : 1);
        dataIndex = section*jumpCountPerSection;
    }
    
    return dataIndex;
}

@end
