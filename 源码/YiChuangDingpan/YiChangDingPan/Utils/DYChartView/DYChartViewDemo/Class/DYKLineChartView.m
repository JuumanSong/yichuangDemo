//
//  DYKLineChartView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/6.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYKLineChartView.h"
#import "DYDataAdapterBase.h"
#import "DYChartItemView.h"
#import "DYChartCurveView.h"
#import "DYChartBarView.h"
#import "DYChartCandleView.h"
#import "DYTools+Formatting.h"
#import "DYXAxisView.h"
#import "DYYAxisView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"
#import "DYIndexPath.h"

#define SECTION_MAX_COUNT   100
#define NAN2ZERO(x)    if(isnan(x.y))x.y=0;

@implementation SectionPositionInfo

//

@end

@implementation SectionFixedSubViewsInfo

//

@end

@interface DYKLineChartView () <DYChartItemViewDataSource, DYAxisViewDataSource, DYMaskViewDelegate, DYChartBarViewDataSource>

@end

@implementation DYKLineChartView

- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    // 填充背景
    CGContextFillRect(context, self.bounds);
    
    NSUInteger count = [self.dataSource sectionCountInKLineChartView:self];
    
    // 画实线
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
    
    for (NSUInteger i = 0 ; i < count ; i ++) {
        CGRect canvasRect = [self canvasRectOfSectionInChartView:self atIndex:i];
        
        // 画横向的实线(上、下)
        CGContextMoveToPoint(context, canvasRect.origin.x, canvasRect.origin.y);
        CGContextAddLineToPoint(context, canvasRect.origin.x + canvasRect.size.width, canvasRect.origin.y);
        
        CGContextMoveToPoint(context, canvasRect.origin.x, canvasRect.origin.y + canvasRect.size.height);
        CGContextAddLineToPoint(context, canvasRect.origin.x + canvasRect.size.width, canvasRect.origin.y + canvasRect.size.height);
        
        // 画竖向的实线（左、右）
        CGContextMoveToPoint(context, canvasRect.origin.x, canvasRect.origin.y);
        CGContextAddLineToPoint(context, canvasRect.origin.x, canvasRect.origin.y + canvasRect.size.height);
        
        CGContextMoveToPoint(context, canvasRect.origin.x + canvasRect.size.width, canvasRect.origin.y);
        CGContextAddLineToPoint(context, canvasRect.origin.x + canvasRect.size.width, canvasRect.origin.y + canvasRect.size.height);
        
        CGContextStrokePath(context);
    }
    
    // K线图画虚线中线
    if (count > 0 && self.drawXDashedLines) {
        CGRect canvasRect = [self canvasRectOfSectionInChartView:self atIndex:0];
        if (self.kLineFlag) {
            CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
        }
        else {
            CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"B9", 1.0).CGColor);
        }
        CGFloat lengths[] = {2, 1};
        CGContextSetLineDash(context, 0, lengths, 2);
        
        CGContextMoveToPoint(context, canvasRect.origin.x, canvasRect.origin.y + canvasRect.size.height/2);
        CGContextAddLineToPoint(context, canvasRect.origin.x + canvasRect.size.width, canvasRect.origin.y + canvasRect.size.height/2);
        
        CGContextStrokePath(context);
    }
    
    
    // 画虚线
    for (NSUInteger i = 0 ; i < count ; i ++) {
        CGRect canvasRect = [self canvasRectOfSectionInChartView:self atIndex:i];
        DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                               atIndex:i];
        
        CGFloat xDistance = canvasRect.size.width/dataAdapter.xPartCount;
        CGFloat yDistance = canvasRect.size.height/dataAdapter.yPartCount;
        if (isnan(xDistance) ||
            isnan(yDistance)) {
            return;
        }
        
        // 画虚线
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, .5);
        CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
        CGFloat lengths[] = {2, 1};
        CGContextSetLineDash(context, 0, lengths, 2);
        
        // 横的虚线
        if (self.drawXDashedLines) {
            CGPoint yPointLeft = CGPointMake(canvasRect.origin.x, canvasRect.size.height + canvasRect.origin.y);
            NAN2ZERO(yPointLeft);
            CGPoint yPointRight = CGPointMake(canvasRect.origin.x + canvasRect.size.width, canvasRect.size.height + canvasRect.origin.y);
            NAN2ZERO(yPointRight);
            for (int j = 0 ; j < dataAdapter.yPartCount + 1; j ++) {
                // 如果中间画实线，则跳过画虚线
                if (self.drawXLineInMiddle && i == 0 && dataAdapter.yPartCount%2 == 0 && j == dataAdapter.yPartCount/2) {
                    yPointLeft.y -= yDistance;
                    yPointRight.y -= yDistance;
                    
                    continue;
                }
                
                if (j == 0 ||
                    j == dataAdapter.yPartCount) {
                    // 不画
                }
                else {
                    CGContextMoveToPoint(context, yPointLeft.x, yPointLeft.y);
                    CGContextAddLineToPoint(context, yPointRight.x, yPointRight.y);
                }
                
                yPointLeft.y -= yDistance;
                yPointRight.y -= yDistance;
            }
        }
        
        // 竖的虚线
        CGContextSetLineWidth(context, .5);
        CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
        if (self.drawYDashedLines) {
            CGPoint xPointTop  = CGPointMake(canvasRect.origin.x, canvasRect.origin.y);
            NAN2ZERO(xPointTop);
            CGPoint xPointBottom = CGPointMake(canvasRect.origin.x, canvasRect.origin.y + canvasRect.size.height);
            NAN2ZERO(xPointBottom);
            for (int j = 0 ; j < dataAdapter.xPartCount + 1; j ++) {
                if (j == 0 ||
                    j == dataAdapter.xPartCount) {
                    // 不画
                }
                else {
                    CGContextMoveToPoint(context, xPointTop.x, xPointTop.y);
                    CGContextAddLineToPoint(context, xPointBottom.x, xPointBottom.y);
                }
                
                xPointTop.x += xDistance;
                xPointBottom.x += xDistance;
            }
        }
        
        CGContextStrokePath(context);
    }
}

- (void)reloadData
{
    [self reloadDataWithAnimation:YES];
}

- (void)reloadDataWithAnimation:(BOOL)animation
{
    for (NSArray* sectionArray in self.chartItemViewsArray) {
        for (DYChartItemView* itemView in sectionArray) {
            [itemView removeFromSuperview];
        }
    }
    [self.maskView deleteAllDataSource];
    
    
    NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
    NSMutableArray* mArrayContainSection = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
        NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self atIndex:i];
        NSMutableArray* mArrayContainChartItemView = [NSMutableArray arrayWithCapacity:chartItemCount];
        DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                               atIndex:i];
        CGRect canvasRect = [self canvasRectOfSectionInChartView:self atIndex:i];
        
        for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:j inSection:i];
            EDYChartItemViewType chartType = [self.dataSource viewTypeInKLineChartView:self
                                                                           atIndexPath:indexPath];
            DYChartItemView* chartItemView = [DYChartItemViewFactory createChartItemViewByType:chartType inFrame:canvasRect];
            chartItemView.calcRect = canvasRect;
            if (chartType == eDYChartTypeCurve ||
                chartType == eDYChartTypeArea) {
                DYChartCurveView* curveView = (DYChartCurveView* )chartItemView;
                [curveView setTag:i*SECTION_MAX_COUNT + j];
                curveView.drawSmoothCurveFlag = NO;
                curveView.fillToXZero = dataAdapter.yZeroInMiddle;
                curveView.dataSource = self;
                curveView.lineWidth = self.lineWidth==0?1.5:self.lineWidth;
                curveView.drawArcFlag = [self.dataSource drawArcFlagForChartView:self  atIndexPath:indexPath];
                curveView.lineColor = [self lineColorInChartView:self atIndexPath:indexPath];
                curveView.fillColor = [self fillColorInChartView:self atIndexPath:indexPath];
                [self insertSubview:curveView atIndex:0];
                [mArrayContainChartItemView addObject:curveView];
                curveView.bindMaskView = _isTimeLine ? YES : NO;
                curveView.tipRectFollowWithFinger = _isTimeLine ? YES : NO;
                
                [self.maskView addDataSource:curveView];
            }
            else if (chartType == eDYChartTypeBar) {
                DYChartBarView* barView = (DYChartBarView*)chartItemView;
                
                [barView setTag:i*SECTION_MAX_COUNT + j];
                barView.dataSource = self;
                barView.barDataSource = self;
                barView.fillToXZero = dataAdapter.yZeroInMiddle;
                barView.lineColor = [self lineColorInChartView:self atIndexPath:indexPath];
                barView.fillColor = [self fillColorInChartView:self atIndexPath:indexPath];
                [self insertSubview:barView atIndex:0];
                [mArrayContainChartItemView addObject:barView];
                barView.bindMaskView = NO;
                
                [self.maskView addDataSource:barView];
            }
            else if (chartType == eDYChartTypeCandle) {
                DYChartCandleView* candleView = (DYChartCandleView*)chartItemView;
                
                [candleView setTag:i*SECTION_MAX_COUNT + j];
                candleView.dataSource = self;
                candleView.riseColor = DYAppearanceColor(@"R1", 1.0);
                candleView.fallColor = [DYAppearance colorWithRGB:0x07cc89];
                [self insertSubview:candleView atIndex:0];
                [mArrayContainChartItemView addObject:candleView];
                candleView.bindMaskView = YES;
                
                [self.maskView addDataSource:candleView];
            }
        }
        
        [mArrayContainSection addObject:mArrayContainChartItemView];
    }
    
    self.chartItemViewsArray = mArrayContainSection;
    
    [self reloadDataForFixedSubViews];
    [self redrawChartItemViews];
}

- (void)redrawChartItemViews
{
    NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
    CGFloat curveViewOffset = -1.0f;
    
    for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
        NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                  atIndex:i];
        NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
        DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                               atIndex:i];
        for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
            DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
            chartItemView.zoomForXAxis = [dataAdapter xZoomValueForChartItemViewAtIndex:j];
            chartItemView.originalZoomForXAxis = [dataAdapter xZoomValueForChartItemViewAtIndex:j];
            chartItemView.zoomForYAxis = [dataAdapter yZoomValueForChartItemViewAtIndex:j];
            
            chartItemView.xAxisOffset = 0;
            chartItemView.yAxisOffset = [dataAdapter yOffsetForChartItemViewAtIndex:j];
            
            chartItemView.minX = dataAdapter.minX;
            
            if ([chartItemView isKindOfClass:[DYChartCurveView class]]) {
                // 分时图的面积图加红点
                if (!self.kLineFlag) {
                    DYChartCurveView* chartCurveView = (DYChartCurveView*)chartItemView;
                    if (chartCurveView.fillFlag) {
                        chartCurveView.showLastPoint = YES;
                        chartCurveView.drawSmoothCurveFlag = NO;
                    }
                }
            }
            else if ([chartItemView isKindOfClass:[DYChartBarView class]] ||
                     [chartItemView isKindOfClass:[DYChartCandleView class]]) {
                [chartItemView calcPointWidth];
                CGFloat offset = chartItemView.pointWidth/2;
                if (offset > curveViewOffset) {
                    curveViewOffset = offset;
                }
            }
            
            if (j == 0) {
                chartItemView.minY = [dataAdapter yMinValueForChartItemViewAtIndex:j];
            }
            else
            {
                chartItemView.minY = [dataAdapter yRightMinValueForChartItemViewAtIndex:j];
            }
        }
    }
    
    if (curveViewOffset > .0) {
        for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
            NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                      atIndex:i];
            NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
//            DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
//                                                                                   atIndex:i];
            for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
                DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
                
                if ([chartItemView isKindOfClass:[DYChartCurveView class]]) {
                    chartItemView.xAxisOffset = curveViewOffset;
                }
                
                [chartItemView setNeedsDisplay];
            }
        }
    }
    
    [self.maskView setNeedsDisplay];
    [self setNeedsDisplay];
}

- (void)setGestureConflictView:(UIScrollView*)conflictView
{
    _gestureConflictView = conflictView;
    
    if (self.maskView != nil) {
        self.maskView.gestureConflictView = conflictView;
    }
}

- (void)resizeSubViews
{
    [self reloadDataForFixedSubViews];
    [self redrawChartItemViews];
}

#pragma mark - view life functions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupBasicProperty];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setupBasicProperty];
}

- (void)setupBasicProperty
{
    self.drawXDashedLines = YES;
    self.drawYDashedLines = YES;
    self.maxXZoomValue = 5;
    self.minXZoomValue = 1;
    self.zoomValue = 1;
}

- (void)setDataSource:(id<DYKLineChartViewDataSource>)dataSource
{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        if (_dataSource != nil) {
            [self setupFixedSubViews];
        }
    }
}

/**
 *	@brief	构建固定的几个子View：纵轴、横轴、maskView
 */
- (void)setupFixedSubViews
{
    [self setMultipleTouchEnabled:YES];
    [self setUserInteractionEnabled:YES];
    
    NSUInteger count = 0;
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(sectionCountInKLineChartView:)]) {
        count = [self.dataSource sectionCountInKLineChartView:self];
    }
    NSMutableArray* mFixedViewArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0 ; i < count ; i ++) {
        EFixedViewItemType fixedViewItemType = [self fixedViewItemTypeInChartView:self atIndex:i];
        SectionPositionInfo* positionInfo = [self.dataSource sectionPositionInKLineChartView:self
                                                                                     atIndex:i];
        DYXAxisView* xAxisView = nil;
        DYYAxisView* leftYAxisView = nil;
        DYYAxisView* rightYAxisView = nil;
        
        SectionFixedSubViewsInfo* fixedSubViewsInfo = [SectionFixedSubViewsInfo new];
        
        if (fixedViewItemType & eFixedViewItemXAxis) {
            CGRect rect = [self xAxisRectOfSectionInChartView:self atIndex:i];
            xAxisView = [[DYXAxisView alloc] initWithFrame:rect];
            [self addSubview:xAxisView];
            
            xAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
            xAxisView.dataSource = self;
            xAxisView.showMoreMajorText = NO;
            [xAxisView setOffset:positionInfo.yWidth - positionInfo.xLeft];
            [xAxisView setTextAlignment:NSTextAlignmentCenter];
            xAxisView.textEdgeOffset = 0;
            xAxisView.majorScaleLength = 0;
            [xAxisView setDrawContentFlag:eDrawMajorScaleText];
            xAxisView.tag = i*SECTION_MAX_COUNT;
            
            fixedSubViewsInfo.xAxisView = xAxisView;
        }
        
        if (fixedViewItemType & eFixedViewItemLeftYAxis) {
            CGRect rect = [self leftYAxisRectOfSectionInChartView:self atIndex:i];
            leftYAxisView = [[DYYAxisView alloc] initWithFrame:rect];
            [self addSubview:leftYAxisView];
            
            leftYAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
            leftYAxisView.dataSource = self;
            [leftYAxisView setOffset:positionInfo.xHeight - positionInfo.yBottom];
            [leftYAxisView setTextEdgeOffset:20];
            [leftYAxisView setTextAlignment:NSTextAlignmentRight];
            [leftYAxisView setDrawContentFlag:eDrawMajorScaleText];
            leftYAxisView.justShowMinAndMaxValue = YES;
            leftYAxisView.axisPosition = eAxisPositionLeft;
            leftYAxisView.tag = i*SECTION_MAX_COUNT + 1;
            
            fixedSubViewsInfo.leftYAxisView = leftYAxisView;
        }
        
        if (fixedViewItemType & eFixedViewItemRightYAxis) {
            CGRect rect = [self rightYAxisRectOfSectionInChartView:self atIndex:i];
            rightYAxisView = [[DYYAxisView alloc] initWithFrame:rect];
            [self addSubview:rightYAxisView];
            
            rightYAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
            rightYAxisView.dataSource = self;
            [rightYAxisView setOffset:positionInfo.xHeight - positionInfo.yBottom];
            [rightYAxisView setTextAlignment:NSTextAlignmentLeft];
            [rightYAxisView setTextEdgeOffset:positionInfo.xHeight - positionInfo.yBottom];
            [rightYAxisView setDrawContentFlag:eDrawMajorScaleText];
            rightYAxisView.justShowMinAndMaxValue = YES;
            rightYAxisView.axisPosition = eAxisPositionRight;
            rightYAxisView.tag = i*SECTION_MAX_COUNT + 2;
            
            fixedSubViewsInfo.rightYAxisView = rightYAxisView;
        }
        
        [mFixedViewArray addObject:fixedSubViewsInfo];
    }
    
    self.fixedSubViewsArray = mFixedViewArray;
    
    // maskView
    CGRect maskViewRect = [self maskViewRectOfSectionInChartView:self];
    DYMaskView* maskView = [[DYMaskView alloc] initWithFrame:maskViewRect];
    maskView.gestureConflictView = _gestureConflictView;
    self.maskView = maskView;
    [self addSubview:maskView];
    
    maskView.mydelegate = self;
    maskView.beginX = 0;
    maskView.endX = maskViewRect.size.width;
    maskView.beginY = 0;
    maskView.endY = maskViewRect.size.height;
    maskView.showMask = eDYMaskViewShowVerticalLine;
    maskView.fingerLeaveFlag = YES;
    maskView.tipsShowType = eDYShowTipsAtXLine;
    maskView.touchEventsMask =eDYTouchStatePan|eDYTouchStateOneFingerSingleTap|eDYTouchStateOneFingerLongPress;
    maskView.tipNotShowWithFixedChartItemView = YES;
    maskView.lineColor = DYAppearanceColor(@"H13", 1.0);
}

- (void)reloadDataForFixedSubViews
{
    NSUInteger count = 0;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(sectionCountInKLineChartView:)]) {
        count = [self.dataSource sectionCountInKLineChartView:self];
    }
    
    for (NSUInteger i = 0 ; i < count ; i ++) {
        DYXAxisView* xAxisView = nil;
        DYYAxisView* leftYAxisView = nil;
        DYYAxisView* rightYAxisView = nil;
        
        EFixedViewItemType fixedViewItemType = [self fixedViewItemTypeInChartView:self atIndex:i];
        SectionFixedSubViewsInfo* fixedSubViewsInfo = [self.fixedSubViewsArray count] > i ? self.fixedSubViewsArray[i] : 0;
        DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                               atIndex:i];
        
        if (fixedViewItemType & eFixedViewItemXAxis) {
            xAxisView = fixedSubViewsInfo.xAxisView;
            
            CGRect rect = [self xAxisRectOfSectionInChartView:self atIndex:i];
            xAxisView.frame = rect;
        }
        
        if (fixedViewItemType & eFixedViewItemLeftYAxis) {
            leftYAxisView = fixedSubViewsInfo.leftYAxisView;
            
            CGRect rect = [self leftYAxisRectOfSectionInChartView:self atIndex:i];
            leftYAxisView.frame = rect;
        }
        
        if (fixedViewItemType & eFixedViewItemRightYAxis) {
            rightYAxisView = fixedSubViewsInfo.rightYAxisView;
            
            CGRect rect = [self rightYAxisRectOfSectionInChartView:self atIndex:i];
            rightYAxisView.frame = rect;
        }
        
        CGRect rect = [self canvasRectOfSectionInChartView:self atIndex:i];
        
        dataAdapter.canvasWidth = rect.size.width;
        dataAdapter.canvasHeight = rect.size.height;
        [dataAdapter adapterData];
        
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:0];
        xAxisView.offset = (CGFloat)self.xMajorTextOffset*dataAdapter.canvasWidth/[self.dataSource countOfDataForChartItemViewInKLineChartView:self atIndexPath:indexPath];
        
        // 当要求显示Y为0的中轴线时，将X轴移到中间
        CGRect xAxisViewFrame = xAxisView.frame;
        if (dataAdapter.yZeroInMiddle) {
            CGRect leftYAxisViewFrame = leftYAxisView.frame;
            xAxisViewFrame.origin.y = leftYAxisViewFrame.origin.y + leftYAxisViewFrame.size.height/2;
            xAxisView.frame = xAxisViewFrame;
        }
        else if (dataAdapter.yZeroPosition <= rect.size.height) {
            CGRect leftYAxisViewFrame = leftYAxisView.frame;
            xAxisViewFrame.origin.y = leftYAxisViewFrame.origin.y + dataAdapter.yZeroPosition;
            xAxisView.frame = xAxisViewFrame;
            
            NSArray* subViewsArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
            for (DYChartItemView* chartItemView in subViewsArray) {
                chartItemView.fillToXZero = YES;
            }
        }
        
        xAxisView.zoomValue = dataAdapter.originalZoomX;
        xAxisView.majorScaleLength = 0;
        [xAxisView reloadData];
        
        leftYAxisView.zoomValue = dataAdapter.originalZoomY;
        [leftYAxisView reloadData];
        
        rightYAxisView.zoomValue = dataAdapter.originalRightZoomY;
        [rightYAxisView reloadData];
    }
    
    CGRect maskViewRect = [self maskViewRectOfSectionInChartView:self];
    [self.maskView setFrame:maskViewRect];
    self.maskView.endX = maskViewRect.size.width;
    self.maskView.endY = maskViewRect.size.height;
}

#pragma mark - DYChartItemViewDataSource functions

- (NSUInteger)countOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfDataForChartItemViewInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        
        return [self.dataSource countOfDataForChartItemViewInKLineChartView:self
                                                                atIndexPath:indexPath];
    }
    
    return 0;
}

- (NSRange)rangeOfValidCountOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(rangeOfValidDataForChartItemViewInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource rangeOfValidDataForChartItemViewInKLineChartView:self
                                                                     atIndexPath:indexPath];
    }
    
    return NSMakeRange(0, 0);
}

- (CGPoint)pointOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    if ([chartItemView isKindOfClass:[DYChartCandleView class]]) {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(dataValueForChartItemViewInKLineChartView:atIndexPath:atDataIndex:)]) {
            NSInteger tag = chartItemView.tag;
            CGFloat x = index;
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                        inSection:tag/SECTION_MAX_COUNT];
            DYChartCandleDataItem* yValue = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                              atIndexPath:indexPath
                                                                              atDataIndex:index];
            
            return CGPointMake(x, yValue.closeValue);
        }
        return CGPointMake(index, 0);
    }
    else
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(dataValueForChartItemViewInKLineChartView:atIndexPath:atDataIndex:)]) {
            NSInteger tag = chartItemView.tag;
            CGFloat x = index;
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                        inSection:tag/SECTION_MAX_COUNT];
            NSNumber* yValue = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                              atIndexPath:indexPath
                                                                              atDataIndex:index];
            
            return CGPointMake(x, [yValue floatValue]);
        }
        
        CGFloat x = index;
        return CGPointMake(x, 0);
    }
}

- (id)dataOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    if (![chartItemView isKindOfClass:[DYChartCandleView class]]) {
        return nil;
    }
    else
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(dataValueForChartItemViewInKLineChartView:atIndexPath:atDataIndex:)]) {
            NSInteger tag = chartItemView.tag;
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                        inSection:tag/SECTION_MAX_COUNT];
            return [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                  atIndexPath:indexPath
                                                                  atDataIndex:index];
        }
        
        return nil;
    }
}

- (NSString*)xTipsOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(xDescriptionForChartItemViewInKLineChartView:atIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:chartItemView.tag];
        return [self.dataSource xDescriptionForChartItemViewInKLineChartView:self atIndexPath:indexPath];
    }
    
    return nil;
}

- (NSString*)yTipsOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yDescriptionForChartItemViewInKLineChartView:atIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:chartItemView.tag];
        return [self.dataSource yDescriptionForChartItemViewInKLineChartView:self atIndexPath:indexPath];
    }
    
    return nil;
}

- (UIFont*)yColorTipsFontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsFontInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource yColorTipsFontInKLineChartView:self atIndexPath:indexPath];
    }
    
    return DYAppearanceFont(@"T1");
}

- (NSArray*)yColorTipsColorOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsColorInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource yColorTipsColorInKLineChartView:self atIndexPath:indexPath];
    }
    
    return @[DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0)];
}

- (BOOL)ifDrawPointBeforeYColorTipsOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(ifDrawPointBeforeYColorTipsInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource ifDrawPointBeforeYColorTipsInKLineChartView:self
                                                                atIndexPath:indexPath];
    }
    
    return NO;
}

- (UIFont*)yTipsFontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsFontInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource yTipsFontInKLineChartView:self atIndexPath:indexPath];
    }
    
    return DYAppearanceFont(@"T1");
}

- (NSArray*)yTipsColorOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsColorInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource yTipsColorInKLineChartView:self atIndexPath:indexPath];
    }
    
    return @[DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0),
             DYAppearanceColor(@"W1", 1.0)];
}

- (UIColor*)colorOfTipsOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(colorOfTipsInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource colorOfTipsInKLineChartView:self atIndexPath:indexPath];
    }
    
    return DYAppearanceColor(@"W1", 1.0);
}

- (UIFont*)fontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(fontInKLineChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:tag%SECTION_MAX_COUNT
                                                    inSection:tag/SECTION_MAX_COUNT];
        return [self.dataSource fontInKLineChartView:self atIndexPath:indexPath];
    }
    
    return DYAppearanceFont(@"T15");
}

//单个浮层的值
- (NSDictionary *)dictionaryForShowViewValue:(DYChartItemView *)maskView
                                     atIndex:(NSUInteger)index
{
    return nil;
}

#pragma mark - HBAxisViewDelegate functions

// 大刻度的个数
- (NSInteger)numberOfScaleSections:(DYAxisView*)axisView
{
    NSUInteger section = axisView.tag/SECTION_MAX_COUNT;
    SectionFixedSubViewsInfo* fixedSubViewsInfo = [self.fixedSubViewsArray count] > section ? self.fixedSubViewsArray[section] : nil;
    DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                           atIndex:section];
    
    if (axisView == fixedSubViewsInfo.leftYAxisView) {
        return dataAdapter.yPartCount;
    }
    else if (axisView == fixedSubViewsInfo.rightYAxisView) {
        return dataAdapter.yRightPartCount;
    }
    else if (axisView == fixedSubViewsInfo.xAxisView) {
        return dataAdapter.xPartCount*self.zoomValue;
    }
    
    return 1;
}

// 每个大刻度里小刻度的个数
- (NSInteger)numberOfScaleForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    NSUInteger viewSection = axisView.tag/SECTION_MAX_COUNT;
    SectionFixedSubViewsInfo* fixedSubViewsInfo =
    [self.fixedSubViewsArray count] > viewSection ? self.fixedSubViewsArray[viewSection] : nil;
    DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                           atIndex:viewSection];
    
    if (axisView == fixedSubViewsInfo.leftYAxisView) {
        return dataAdapter.ySubPartCount;
    }
    else if (axisView == fixedSubViewsInfo.rightYAxisView) {
        return dataAdapter.yRightSubPartCount;
    }
    else if (axisView == fixedSubViewsInfo.xAxisView) {
        return dataAdapter.xSubPartCount;
    }
    
    return 0;
}

- (CGFloat)positionOfScaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset
{
    return -MAXFLOAT;
}

// 大刻度上显示的文字
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset
{
    NSUInteger viewSection = axisView.tag/SECTION_MAX_COUNT;
    SectionFixedSubViewsInfo* fixedSubViewsInfo =
    [self.fixedSubViewsArray count] > viewSection ? self.fixedSubViewsArray[viewSection] : nil;
    DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                           atIndex:viewSection];
    
    CGFloat value = 0;
    if (axisView == fixedSubViewsInfo.xAxisView) {
        CGFloat distance = dataAdapter.maxX - dataAdapter.minX;
        value = distance/dataAdapter.xPartCount/self.zoomValue*section;   // 位置
        
        CGFloat floorValue = floorf(value);
        CGFloat ceilfValue = ceilf(value);
        
        if (value - floorValue > ceilfValue - value) {
            value = ceilfValue;
        }
        else
        {
            value = floorValue;
        }
        
        long long nValue = (long long)value + self.xMajorTextOffset;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:viewSection];
        NSRange range = [self.dataSource rangeOfValidDataForChartItemViewInKLineChartView:self atIndexPath:indexPath];
        if (nValue < range.location + range.length) {
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:nValue inSection:viewSection];
            NSString* string = [self.dataSource xDescriptionForChartItemViewInKLineChartView:self
                                                                                 atIndexPath:indexPath];
            
            return string;
        }
        
        return nil;
    }
    else if (axisView == fixedSubViewsInfo.leftYAxisView)
    {
        if (section == 0 || section == dataAdapter.yPartCount) {
            CGFloat distance = dataAdapter.maxY - dataAdapter.minY;
            value = dataAdapter.minY + distance/dataAdapter.yPartCount*section;
            CGFloat gap = dataAdapter.yRightPartCount == 0 ? 1 : distance/dataAdapter.yRightPartCount;
            return [DYTools formatingToShortStringWithNumber:value andGap:gap leftDecimalNumber:2];
        }
        else
        {
            return @"";
        }
    }
    else
    {
        CGFloat distance = dataAdapter.maxRightY - dataAdapter.minRightY;
        value = dataAdapter.minRightY + distance/dataAdapter.yRightPartCount*section;
        CGFloat gap = dataAdapter.yRightPartCount == 0 ? 1 : distance/dataAdapter.yRightPartCount;
        return [DYTools formatingToShortStringWithNumber:value andGap:gap leftDecimalNumber:2];
    }
    
    return nil;
}

// 小刻度上显示的文字
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath
{
    // 待续
    return nil;
}

// 大刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    NSUInteger viewSection = axisView.tag/SECTION_MAX_COUNT;
    SectionFixedSubViewsInfo* fixedSubViewsInfo =
    [self.fixedSubViewsArray count] > viewSection ? self.fixedSubViewsArray[viewSection] : nil;
    DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                           atIndex:viewSection];
    
    if (axisView == fixedSubViewsInfo.xAxisView) {
        if (dataAdapter.xPartCount > 0) {
            return (dataAdapter.maxX - dataAdapter.minX)/dataAdapter.xPartCount/self.zoomValue;
        }
    }
    else if (axisView == fixedSubViewsInfo.leftYAxisView)
    {
        if (dataAdapter.yPartCount > 0) {
            return (dataAdapter.maxY - dataAdapter.minY)/dataAdapter.yPartCount;
        }
    }
    else
    {
        if (dataAdapter.yRightPartCount > 0) {
            return (dataAdapter.maxRightY - dataAdapter.minRightY)/dataAdapter.yRightPartCount;
        }
    }
    
    return .0f;
}

- (CGFloat)distanceForAxisView:(DYAxisView*)axisView forOffset:(NSInteger)offset
{
    return 0;
}

// 小刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath
{
    NSUInteger viewSection = axisView.tag/SECTION_MAX_COUNT;
    SectionFixedSubViewsInfo* fixedSubViewsInfo =
    [self.fixedSubViewsArray count] > viewSection ? self.fixedSubViewsArray[viewSection] : nil;
    DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                           atIndex:viewSection];
    
    if (axisView == fixedSubViewsInfo.xAxisView) {
        CGFloat xPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return xPartDistance/(dataAdapter.xSubPartCount + 1);
    }
    else if (axisView == fixedSubViewsInfo.leftYAxisView)
    {
        CGFloat yPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return yPartDistance/(dataAdapter.ySubPartCount + 1);
    }
    else
    {
        CGFloat yPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return yPartDistance/(dataAdapter.yRightPartCount + 1);
    }
    
    return .0f;
}

// 大刻度上显示的文字的字体
- (UIFont*)fontForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    if ([[axisView class] isSubclassOfClass:[DYYAxisView class]]) {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    }
    else
    {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    }
}

// 小刻度上显示的文字的字体
- (UIFont*)fontForAxisView:(DYAxisView *)axisView atIndexPath:(DYIndexPath*)indexPath
{
    return DYAppearanceFont(@"T14");
}

// 大刻度上显示文字的颜色
- (UIColor*)colorForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    if ([[axisView class] isSubclassOfClass:[DYYAxisView class]]) {
        return DYAppearanceColor(@"B5", 1.0);
    }
    else
    {
        return DYAppearanceColor(@"B5", 1.0);
    }
}

// 小刻度上显示文字的颜色
- (UIColor*)colorForAxisView:(DYAxisView *)axisView atIndexPath:(DYIndexPath*)indexPath
{
    if (indexPath.section > 1) {
        return [UIColor redColor];
    }
    return [UIColor greenColor];
}

// 返回底部View
- (UIView *)bottomViewForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)pointsGapForAxisView:(DYAxisView*)axisView
{
    return .0f;
}

// 显示的最小值
- (CGFloat)minValueForAxisView:(DYAxisView* )axisView
{
    SectionFixedSubViewsInfo* fixedSubViewsInfo = [self.fixedSubViewsArray count] > 0 ? self.fixedSubViewsArray[0] : nil;
    
    if (axisView == fixedSubViewsInfo.leftYAxisView)
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(minValueForKLineChartView:)]) {
            return [self.dataSource minValueForKLineChartView:self];
        }
    }
    else if (axisView == fixedSubViewsInfo.rightYAxisView)
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(minRangeValueForKLineChartView:)]) {
            return [self.dataSource minRangeValueForKLineChartView:self];
        }
    }
    
    return .0f;
}
// 显示的最大值
- (CGFloat)maxValueForAxisView:(DYAxisView* )axisView
{
    SectionFixedSubViewsInfo* fixedSubViewsInfo = [self.fixedSubViewsArray count] > 0 ? self.fixedSubViewsArray[0] : nil;
    
    if (axisView == fixedSubViewsInfo.leftYAxisView)
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(maxValueForKLineChartView:)]) {
            return [self.dataSource maxValueForKLineChartView:self];
        }
    }
    else if (axisView == fixedSubViewsInfo.rightYAxisView)
    {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(maxRangeValueForKLineChartView:)]) {
            return [self.dataSource maxRangeValueForKLineChartView:self];
        }
    }
    
    return .0f;
}

#pragma mark - HBMaskViewDelegate 函数

// 当前手指移动的位置
- (void)maskView:(DYMaskView*)maskView movedTo:(CGFloat)xToPos from:(CGFloat)xFromPos
{
    if (maskView.eTouchState == eDYTouchStatePan || maskView.eTouchState == eDYTouchStateTwoFingersLongPress) {
        CGFloat offset = 0;
        NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
        for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
            NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                      atIndex:i];
            NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
            DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                                   atIndex:i];
            SectionFixedSubViewsInfo* fixedSubViews = [self.fixedSubViewsArray count] > i ? self.fixedSubViewsArray[i] : nil;
            for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
                DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
                if (chartItemView.xAxisOffset - xFromPos + xToPos > 0) {
                    chartItemView.xAxisOffset = 0;
                    
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(panChartViewToLeftTop:)]) {
                        [self.delegate panChartViewToLeftTop:self];
                    }
                }
                else if (chartItemView.xAxisOffset - xFromPos + xToPos <
                         - (chartItemView.bounds.size.width)*(chartItemView.zoomForXAxis/dataAdapter.originalZoomX - 1))
                {
                    chartItemView.xAxisOffset = - chartItemView.bounds.size.width*(chartItemView.zoomForXAxis/dataAdapter.originalZoomX - 1);
                    
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(panChartViewToRightTop:)]) {
                        [self.delegate panChartViewToRightTop:self];
                    }
                }
                else
                {
                    chartItemView.xAxisOffset -= xFromPos - xToPos;
                }
                
                offset = chartItemView.xAxisOffset;
                [chartItemView setNeedsDisplay];
            }
            
            // 更新X轴
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:0];
            fixedSubViews.xAxisView.offset = offset + (CGFloat)self.xMajorTextOffset/[self.dataSource countOfDataForChartItemViewInKLineChartView:self atIndexPath:indexPath]*dataAdapter.canvasWidth;
            [fixedSubViews.xAxisView resetLabelPosition];
            
//          [self autoRecalculationYAxisNow];
        }
    }
    else if (maskView.eTouchState == eDYTouchStateOneFingerLongPress)
    {
        NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
        for (NSUInteger i = 0 ; i < sectionCount; i++) {
            NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                      atIndex:i];
            NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
            for (NSUInteger j = 0 ; j < chartItemCount ; j++) {
                DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
                if (chartItemView.isFixXPosition) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:j inSection:i];
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(oneFingerInChartView:atIndexPath:pressAtPosition:)]) {
                        [self.delegate oneFingerInChartView:self
                                                atIndexPath:indexPath
                                            pressAtPosition:[chartItemView getIndexFromXPosition:xToPos
                                                                                        fromView:maskView]];
                        break;
                    }
                }
            }
            
            break;
        }
    }
}

// 在某个位置上缩放
- (void)zoomForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point withZoomValue:(CGFloat)zoomValue
{
    CGFloat offset = 0;
    CGFloat zoom = 0;
    
    NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
    for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
        NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                  atIndex:i];
        
        DYDataAdapterBase* dataAdapter = [self.dataSource dataAdapterForKLineChartView:self
                                                                               atIndex:i];
        SectionFixedSubViewsInfo* fixedSubViews = [self.fixedSubViewsArray count] > i ? self.fixedSubViewsArray[i] : nil;
        if (fixedSubViews.xAxisView.zoomValue * zoomValue / dataAdapter.originalZoomX > self.maxXZoomValue) {
            zoomValue = self.maxXZoomValue*dataAdapter.originalZoomX/fixedSubViews.xAxisView.zoomValue;
        }
        else if (fixedSubViews.xAxisView.zoomValue * zoomValue / dataAdapter.originalZoomX < self.minXZoomValue)
        {
            zoomValue = self.minXZoomValue*dataAdapter.originalZoomX/fixedSubViews.xAxisView.zoomValue;
        }
        
        BOOL hit = NO;
        NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
        for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
            DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
            
            CGPoint chartViewPoint = [maskView convertPoint:point toView:chartItemView];
            
            CGFloat oldStartPosition = chartItemView.xAxisOffset;
            CGFloat newStartPosition = chartViewPoint.x - zoomValue*(chartViewPoint.x - oldStartPosition);
            
            // 防止图像左边、右边的边界滑到屏幕中间来
            // 先看看左边界有没有问题
            if (newStartPosition > 0) {
                newStartPosition = 0;
                
                // 再检查右边界
                if (newStartPosition < - chartItemView.bounds.size.width*(chartItemView.zoomForXAxis*zoomValue/dataAdapter.originalZoomX - 1)) {
                    break;
                }
            }
            // 再看看右边界有没有问题
            else if (newStartPosition <  - chartItemView.bounds.size.width*(chartItemView.zoomForXAxis*zoomValue/dataAdapter.originalZoomX - 1))
            {
                // 再检查左边界
                newStartPosition = - chartItemView.bounds.size.width*(chartItemView.zoomForXAxis*zoomValue/dataAdapter.originalZoomX - 1);
                
                if (newStartPosition > 0) {
                    break;
                }
            }
            
            chartItemView.zoomForXAxis *= zoomValue;
            chartItemView.xAxisOffset = newStartPosition;
            hit = YES;
            offset = chartItemView.xAxisOffset;
            zoom = chartItemView.zoomForXAxis;
            
            [chartItemView setNeedsDisplay];
        }
        
        // 更新X轴
        if (hit) {
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:0 inSection:0];
            fixedSubViews.xAxisView.offset = offset + (CGFloat)self.xMajorTextOffset/[self.dataSource countOfDataForChartItemViewInKLineChartView:self atIndexPath:indexPath]*dataAdapter.canvasWidth;
            fixedSubViews.xAxisView.zoomValue = zoom;
            [fixedSubViews.xAxisView reloadData];
            
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(chartView:xZoomOutLevelChanged:)]) {
                [self.delegate chartView:self xZoomOutLevelChanged:zoom/dataAdapter.originalZoomX];
            }
//        [self autoRecalculationYAxisNow];
        }
    }
}

// 单指双击
- (void)oneFingerDoubleClickForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point
{
    //
}

// 双指单击
- (void)twoFingerSingleClickForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point
{
    //
}

// 双指双击
- (void)twoFingerDoubleClickForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point
{
    //
}

// 选中区域变化
- (void)selectAreaChangedForMaskView:(DYMaskView*)maskView fromXPos:(CGFloat)fromPos toXPos:(CGFloat)toPos
{
    NSUInteger sectionCount = [self.dataSource sectionCountInKLineChartView:self];
    for (NSUInteger i = 0 ; i < sectionCount ; i ++) {
        NSUInteger chartItemCount = [self.dataSource countOfChartItemViewInKLineChartView:self
                                                                                  atIndex:i];
        NSArray* chartItemArray = [self.chartItemViewsArray count] > i ? self.chartItemViewsArray[i] : nil;
        for (NSUInteger j = 0 ; j < chartItemCount ; j ++) {
            DYChartItemView* chartItemView = [chartItemArray count] > j ? chartItemArray[j] : nil;
            [chartItemView.delegate twoFingerInChartView:chartItemView
                                           fromIndex:[chartItemView getIndexFromXPosition:fromPos fromView:maskView]
                                             toIndex:[chartItemView getIndexFromXPosition:toPos fromView:maskView]];
            
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:j inSection:i];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(twoFingerInChartView:atIndexPath:fromPosition:toPosition:)]) {
                [self.delegate twoFingerInChartView:self atIndexPath:indexPath
                                       fromPosition:[chartItemView getIndexFromXPosition:fromPos fromView:maskView]
                                         toPosition:[chartItemView getIndexFromXPosition:toPos fromView:maskView]];
            }
        }
    }
}

// 退出绘图操作
- (void)touchEnded:(DYMaskView*)maskView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(touchEndedAtChartView:)]) {
        [self.delegate touchEndedAtChartView:self];
    }
    
    [self.maskView redrawMaskView];
}

- (void)oneFingerSingleTap:(DYMaskView *)maskView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(oneFingerSingleTapInChartView:)]) {
        [self.delegate oneFingerSingleTapInChartView:self];
    }
}

#pragma mark - 子类可覆盖实现的接口

- (EFixedViewItemType)fixedViewItemTypeInChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index
{
    if (index == 0) {
//        if (self.isTimeLine) {
            return eFixedViewItemXAxis | eFixedViewItemLeftYAxis | eFixedViewItemRightYAxis;
//        } else {
//            return eFixedViewItemXAxis | eFixedViewItemLeftYAxis;
//        }
    }
    
    return eFixedViewItemNone;
}

- (CGRect)canvasRectOfSectionInChartView:(DYKLineChartView*)chartView atIndex:(NSUInteger)index
{
    CGRect rect = CGRectZero;
    if (self.dataSource != nil) {
        CGRect sectionBounds = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                       atIndex:index];
        SectionPositionInfo* positionInfo = [self.dataSource sectionPositionInKLineChartView:self
                                                                                     atIndex:index];
        rect = CGRectMake(sectionBounds.origin.x + positionInfo.yWidth,
                          sectionBounds.origin.y + positionInfo.yTop,
                          sectionBounds.size.width - positionInfo.yWidth*2,
                          sectionBounds.size.height - positionInfo.xHeight - positionInfo.yTop);
    }
    
    return rect;
}

- (CGRect)xAxisRectOfSectionInChartView:(DYKLineChartView*)chartView atIndex:(NSUInteger)index
{
    CGRect rect = CGRectZero;
    if (self.dataSource != nil) {
        CGRect sectionBounds = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                       atIndex:index];
        SectionPositionInfo* positionInfo = [self.dataSource sectionPositionInKLineChartView:self
                                                                                     atIndex:index];
        rect = CGRectMake(sectionBounds.origin.x + positionInfo.xLeft,
                          sectionBounds.origin.y + sectionBounds.size.height - positionInfo.xHeight,
                          sectionBounds.size.width - positionInfo.xLeft - positionInfo.xRight,
                          positionInfo.xHeight);
    }
    
    return rect;
}

- (CGRect)leftYAxisRectOfSectionInChartView:(DYKLineChartView*)chartView atIndex:(NSUInteger)index
{
    CGRect rect = CGRectZero;
    if (self.dataSource != nil) {
        CGRect sectionBounds = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                       atIndex:index];
        SectionPositionInfo* positionInfo = [self.dataSource sectionPositionInKLineChartView:self
                                                                                     atIndex:index];
        rect = CGRectMake(sectionBounds.origin.x,
                          sectionBounds.origin.y + positionInfo.yTop,
                          positionInfo.yWidth,
                          sectionBounds.size.height - positionInfo.yTop - positionInfo.yBottom);
    }
    
    return rect;
}

- (CGRect)rightYAxisRectOfSectionInChartView:(DYKLineChartView*)chartView atIndex:(NSUInteger)index
{
    CGRect rect = CGRectZero;
    if (self.dataSource != nil) {
        CGRect sectionBounds = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                       atIndex:index];
        SectionPositionInfo* positionInfo = [self.dataSource sectionPositionInKLineChartView:self
                                                                                     atIndex:index];
        rect = CGRectMake(sectionBounds.origin.x + sectionBounds.size.width - positionInfo.yWidth*2,
                          sectionBounds.origin.y + positionInfo.yTop,
                          positionInfo.yWidth,
                          sectionBounds.size.height - positionInfo.yTop - positionInfo.yBottom);
    }
    
    return rect;
}

- (CGRect)maskViewRectOfSectionInChartView:(DYKLineChartView*)chartView
{
    CGRect rect = CGRectZero;
    if (self.dataSource != nil) {
        SectionPositionInfo* positionInfoStart = nil;
        SectionPositionInfo* positionInfoEnd = nil;
        CGRect rectSectionStart = CGRectZero;
        CGRect rectSectionEnd = CGRectZero;
        NSUInteger count = [self.dataSource sectionCountInKLineChartView:self];
        if (count > 0) {
            positionInfoStart = [self.dataSource sectionPositionInKLineChartView:self atIndex:0];
            rectSectionStart = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                       atIndex:0];
            positionInfoEnd = [self.dataSource sectionPositionInKLineChartView:self atIndex:count - 1];
            rectSectionEnd = [self.dataSource frameOfSectionInKLineChartView:chartView
                                                                     atIndex:count - 1];
        }
        
        CGRect myBounds = self.bounds;
        rect = CGRectMake(rectSectionStart.origin.x + positionInfoStart.yWidth,
                          rectSectionStart.origin.y + positionInfoStart.yTop,
                          rectSectionStart.size.width - positionInfoStart.yWidth*2,
                          myBounds.size.height - rectSectionStart.origin.y - positionInfoStart.yTop - positionInfoEnd.xHeight -
                          (myBounds.size.height - rectSectionEnd.origin.y - rectSectionEnd.size.height));
        return rect;
    }
    
    return rect;
}

- (BOOL)fillFlagInChartView:(DYKLineChartView*)chartView
                atIndexPath:(DYIndexPath*)indexPath
{
    return NO;
}

- (UIColor*)lineColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath
{
    if (self.isTimeLine) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return DYAppearanceColor(@"B8", 1.0);
                    case 1:
                        return [DYAppearance colorWithRGB:0xfcba5d];
                    case 2:
                        return [DYAppearance colorWithRGB:0xfc4c7a];
                    case 3:
                        return DYAppearanceColor(@"W1", 1.0);
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        return DYAppearanceColor(@"W1", 1.0);
                        break;
                        
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
        
        return DYAppearanceColor(@"W1", 1.0);
    }
    else {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return DYAppearanceColor(@"Y3", 1.0);
                    case 1:
                        return DYAppearanceColor(@"B9", 1.0);
                    case 2:
                        return DYAppearanceColor(@"P1", 1.0);
                    case 3:
                        return DYAppearanceColor(@"W1", 1.0);
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        return DYAppearanceColor(@"W1", 1.0);
                        break;
                        
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
        
        return DYAppearanceColor(@"W1", 1.0);
    }
}

- (UIColor*)fillColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return DYAppearanceColor(@"B8", 0.1);
                case 1:
                    return [DYAppearance colorWithRGB:0xfcba5d];
                case 2:
                    return [DYAppearance colorWithRGB:0xfc4c7a];
                case 3:
                    return DYAppearanceColor(@"W1", 1.0);
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    return DYAppearanceColor(@"W1", 1.0);
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return DYAppearanceColor(@"W1", 1.0);
}

#pragma mark - DYChartBarViewDataSource functions

- (UIColor*)lineColorForBarView:(DYChartBarView *)barView atIndex:(NSUInteger)index
{
    DYIndexPath* dataIndexPath = [DYIndexPath indexPathForRow:3 inSection:0];
    DYChartCandleDataItem* item = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                                 atIndexPath:dataIndexPath
                                                                                 atDataIndex:index];
    DYChartCandleDataItem* preItem;
    if (index>0) {
        preItem = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                 atIndexPath:dataIndexPath
                                                                 atDataIndex:index-1];
    }else {
        preItem = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                 atIndexPath:dataIndexPath
                                                                 atDataIndex:0];
    }
    UIColor* riseColor = DYAppearanceColor(@"R1", 1.0);
    UIColor* fallColor = [DYAppearance colorWithRGB:0x07cc89];
    if (item.openValue < item.closeValue) {
        return riseColor;
    } else if (item.openValue == item.closeValue  && preItem) {
        if (item.closeValue < preItem.closeValue) {
            return fallColor;
        }else {
            return riseColor;
        }
    } else
    {
        return fallColor;
    }
}

- (UIColor*)fillColorForBarView:(DYChartBarView *)barView atIndex:(NSUInteger)index
{
    DYIndexPath* dataIndexPath = [DYIndexPath indexPathForRow:3 inSection:0];
    DYChartCandleDataItem* item = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                                 atIndexPath:dataIndexPath
                                                                                 atDataIndex:index];
    DYChartCandleDataItem* preItem;
    if (index>0) {
        preItem = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                 atIndexPath:dataIndexPath
                                                                 atDataIndex:index-1];
    }else {
        preItem = [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                                 atIndexPath:dataIndexPath
                                                                 atDataIndex:0];
    }
    UIColor* riseColor = DYAppearanceColor(@"R1", 1.0);
    UIColor* fallColor = [DYAppearance colorWithRGB:0x07cc89];
    if (item.openValue < item.closeValue) {
        return riseColor;
    } else if (item.openValue == item.closeValue && preItem) {
        if (item.closeValue < preItem.closeValue) {
            return fallColor;
        }else {
            return riseColor;
        }
    } else
    {
        return fallColor;
    }
}

#pragma mark - DYDataAdapterDataSource functions

- (NSUInteger)countOfChartItemViewForDataAdapter:(DYDataAdapterBase*)dataAdapter
{
    NSUInteger section = dataAdapter.tag;
    return [self.dataSource countOfChartItemViewInKLineChartView:self atIndex:section];
}

- (NSUInteger)countOfDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                atIndex:(NSUInteger)index
{
    NSUInteger section = dataAdapter.tag;
    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:section];
    return [self.dataSource countOfDataForChartItemViewInKLineChartView:self
                                                            atIndexPath:indexPath];
}

- (NSRange)rangeOfValidDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                  atIndex:(NSUInteger)index;
{
    NSUInteger section = dataAdapter.tag;
    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:section];
    return [self.dataSource rangeOfValidDataForChartItemViewInKLineChartView:self atIndexPath:indexPath];
}

- (id)dataValueForDataAdapter:(DYDataAdapterBase*)dataAdapter
                  atIndexPath:(DYIndexPath*)indexPath
{
    NSUInteger section = dataAdapter.tag;
    DYIndexPath* chartItemViewIndexPath = [DYIndexPath indexPathForRow:indexPath.section inSection:section];
    return [self.dataSource dataValueForChartItemViewInKLineChartView:self
                                                          atIndexPath:chartItemViewIndexPath
                                                          atDataIndex:indexPath.row];
}

- (CGPoint)getDrawPointForChartViewAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    NSArray *subArray = self.chartItemViewsArray[indexPath.section];
    DYChartItemView *subChartView = subArray[indexPath.row];
    CGPoint point = [self pointOfChartItemView:subChartView atIndex:index];
    CGFloat x = (point.x - subChartView.minX)*subChartView.zoomForXAxis + subChartView.xAxisOffset;
    CGFloat y = subChartView.calcRect.size.height - (point.y - subChartView.minY)*subChartView.zoomForYAxis - subChartView.yAxisOffset;
    
    CGPoint returnPoint = CGPointMake(x, y);
    return [subChartView convertPoint:returnPoint toView:self];
}
@end
