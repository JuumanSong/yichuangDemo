//
//  DYComplexChartView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/25.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYComplexChartView.h"
#import "DYDataAdapterBase.h"
#import "DYChartCurveView.h"
#import "DYChartBarView.h"
#import "DYTools+Formatting.h"
#import "DYChartCandleView.h"
#import "DYChartGroupBarView.h"
#import "DYChartViewCommonDef.h"
#import "DYAppearance.h"
#import "DYIndexPath.h"

#define AUTO_ZOOM_VALUE     6   // 自动缩放时的放大倍数
#define NAN2ZERO(x)    if(isnan(x.y))x.y=0;

@interface DYComplexChartView () <DYAxisViewDataSource, DYChartItemViewDataSource, DYChartItemViewDelegate, DYMaskViewDelegate, DYDataAdapterDataSource, DYChartBarViewDataSource>

//@property (nonatomic)CGRect canvasRect;
@property (nonatomic)CGRect xAxisRect;
@property (nonatomic)CGRect leftYAxisRect;
@property (nonatomic)CGRect rightYAxisRect;
@property (nonatomic)CGRect maskViewRect;
@property (nonatomic, strong)UIView* loadingView;
@property (nonatomic, strong)UIView* tipsView;

@end

@implementation DYComplexChartView

- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    // 填充背景
    CGContextFillRect(context, self.bounds);
    
    CGFloat xDistance = [self distanceForAxisView:self.xAxisView atSection:0];
//    if (isnan(xDistance) ||
//        isnan(yDistance)) {
//        return;
//    }
    
    CGRect canvas = [self canvasRect];
    
    // 画虚线
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
    CGFloat lengths[] = {2, 1};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    // 横的虚线
    if (self.drawXDashedLines) {
        CGPoint yPointLeft = CGPointMake(canvas.origin.x, canvas.size.height + canvas.origin.y);
        NAN2ZERO(yPointLeft);
        CGPoint yPointRight = CGPointMake(canvas.origin.x + canvas.size.width, canvas.size.height + canvas.origin.y);
        NAN2ZERO(yPointRight);
        for (int i = 0 ; i < self.dataAdapter.yPartCount; i ++) {
            CGContextMoveToPoint(context, yPointLeft.x, yPointLeft.y);
            CGContextAddLineToPoint(context, yPointRight.x, yPointRight.y);
            
            yPointLeft.y -= canvas.size.height/self.dataAdapter.yPartCount;
            yPointRight.y -= canvas.size.height/self.dataAdapter.yPartCount;
            NAN2ZERO(yPointRight);
            NAN2ZERO(yPointLeft);

        }
    }
    
    // 竖的虚线
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
    if (self.drawYDashedLines) {
        CGPoint xPointTop  = CGPointMake(canvas.origin.x, canvas.origin.y);
        NAN2ZERO(xPointTop);
        CGPoint xPointBottom = CGPointMake(canvas.origin.x, canvas.origin.y + canvas.size.height);
        NAN2ZERO(xPointBottom);
        if (isnan([self xZoomTimes])) {
            for (int i = 0 ; i < self.dataAdapter.xPartCount; i ++) {
                CGContextMoveToPoint(context, xPointTop.x, xPointTop.y);
                CGContextAddLineToPoint(context, xPointBottom.x, xPointBottom.y);
                
                xPointTop.x += isnan(xDistance) ? canvas.size.width/self.dataAdapter.xPartCount : xDistance*self.dataAdapter.originalZoomX*[self xZoomTimes];
                xPointBottom.x += isnan(xDistance) ? canvas.size.width/self.dataAdapter.xPartCount : xDistance*self.dataAdapter.originalZoomX*[self xZoomTimes];
            }
        }
        else {
            for (int i = 0 ; i < self.dataAdapter.xPartCount*[self xZoomTimes] + 1; i ++) {
                CGContextMoveToPoint(context, xPointTop.x, xPointTop.y);
                CGContextAddLineToPoint(context, xPointBottom.x, xPointBottom.y);
                
                xPointTop.x += isnan(xDistance) ? canvas.size.width/self.dataAdapter.xPartCount : xDistance*self.dataAdapter.originalZoomX*[self xZoomTimes];
                xPointBottom.x += isnan(xDistance) ? canvas.size.width/self.dataAdapter.xPartCount : xDistance*self.dataAdapter.originalZoomX*[self xZoomTimes];
            }
        }
    }
    
    CGContextStrokePath(context);
}

- (void)reloadData
{
    [self reloadDataWithAnimation:YES];
}

- (void)reloadDataWithAnimation:(BOOL)animation
{
    for (DYChartItemView* itemView in self.chartItemViews) {
        [itemView removeFromSuperview];
        [self.maskView deleteAllDataSource];
        self.maskView.eTouchState = eDYTouchStateNone;
     }
    
    NSUInteger chartItemCount = [self.dataSource countOfChartItemViewForChartView:self];
    NSMutableArray* mArray = [NSMutableArray arrayWithCapacity:chartItemCount];
    
    for (NSUInteger i = 0 ; i < chartItemCount ; i ++) {
        EDYChartItemViewType chartType = [self.dataSource chartItemViewTypeForChartView:self atIndex:i];
        BOOL drawArcFlag = self.drawArcFlag;
        if ([self.dataSource respondsToSelector:@selector(drawArcFlagForChartView:atIndex:)]) {
            drawArcFlag = [self.dataSource drawArcFlagForChartView:self atIndex:i];
        }
        
        if (chartType == eDYChartTypeCurve ||
            chartType == eDYChartTypeArea) {
            DYChartCurveView* curveView = [[DYChartCurveView alloc] initWithFrame:self.higherCanvasRect];
            curveView.calcRect = self.canvasRect;
            curveView.yAxisOffset = -self.yTop;
            
            [curveView setTag:i];
            curveView.drawSmoothCurveFlag = NO;
            curveView.fillFlag = chartType == eDYChartTypeArea;
            curveView.fillToXZero = self.dataAdapter.yZeroInMiddle;
            curveView.dataSource = self;
            curveView.lineWidth = 1.5;
            curveView.drawArcFlag = drawArcFlag;
            curveView.lineColor = [self.dataSource lineColorForChartView:self atIndex:i];
            curveView.fillColor = [self.dataSource fillColorForChartView:self atIndex:i];
            [self insertSubview:curveView belowSubview:self.leftYAxisView];
            [mArray addObject:curveView];
            
            [self.maskView addDataSource:curveView];
        }
        else if (chartType == eDYChartTypeBar) {
            DYChartBarView* barView = [[DYChartBarView alloc] initWithFrame:self.canvasRect];
            
            [barView setTag:i];
            barView.dataSource = self;
            barView.barDataSource = self;
            barView.fillToXZero = self.dataAdapter.yZeroInMiddle;
            barView.lineColor = [self.dataSource lineColorForChartView:self atIndex:i];
            barView.fillColor = [self.dataSource fillColorForChartView:self atIndex:i];
            [self insertSubview:barView belowSubview:self.leftYAxisView];
            [mArray addObject:barView];
            
            [self.maskView addDataSource:barView];
        }
        else if (chartType == eDYChartTypeGroupBar) {
            DYChartGroupBarView* barView = [[DYChartGroupBarView alloc] initWithFrame:self.canvasRect];
            
            [barView setTag:i];
            barView.dataSource = self;
            barView.barDataSource = self;
            barView.barCountInGroup = self.barCountInGroup;
            barView.fillToXZero = self.dataAdapter.yZeroInMiddle;
            barView.lineColor = [self.dataSource lineColorForChartView:self atIndex:i];
            barView.fillColor = [self.dataSource fillColorForChartView:self atIndex:i];
            [self insertSubview:barView belowSubview:self.leftYAxisView];
            [mArray addObject:barView];
            
            [self.maskView addDataSource:barView];
        }
        else if (chartType == eDYChartTypeCandle) {
            DYChartCandleView* candleView = [[DYChartCandleView alloc] initWithFrame:self.canvasRect];
            
            [candleView setTag:i];
            candleView.dataSource = self;
            candleView.riseColor = [UIColor redColor];
            candleView.fallColor = [UIColor greenColor];
            [self insertSubview:candleView belowSubview:self.leftYAxisView];
            [mArray addObject:candleView];
            
            [self.maskView addDataSource:candleView];
        }
    }
    
    self.chartItemViews = mArray;
    
    [self resetDataAdapter];
    [self redrawChartItemViews];
    [self reloadDataForFixedSubViews];
}

- (void)setFillFlag:(BOOL)fillFlag
{
    _fillFlag = fillFlag;
    
    for (DYChartItemView* itemView in self.chartItemViews) {
        if ([itemView isKindOfClass:[DYChartCurveView class]]) {
            DYChartCurveView* curveView = (DYChartCurveView*)itemView;
            curveView.fillFlag = fillFlag;
        }
    }
}

- (void)redrawChartItemWithZoomX:(CGFloat)zoomX
{
    CGPoint point = CGPointMake(self.maskView.bounds.size.width/2, self.maskView.bounds.size.height/2);
    CGFloat increaseZoomX = 1.0f;
    if (self.xAxisView.zoomValue != .0f) {
        increaseZoomX = zoomX/self.xAxisView.zoomValue;
    }
    [self zoomForMaskView:self.maskView atPoint:point withZoomValue:increaseZoomX];
    
    [self.maskView redrawMaskView];
}

- (CGFloat)xZoomTimes {
    if (self.dataAdapter.originalZoomX == .0f) {
        return 1.0f;
    }
    return self.xAxisView.zoomValue/self.dataAdapter.originalZoomX;
}

- (void)redrawChartItemViews
{
    NSUInteger chartItemCount = [self.dataSource countOfChartItemViewForChartView:self];
    [self reCalcChartItemViewsXOffset];
    
    for (NSUInteger i = 0 ; i < chartItemCount; i ++) {
        if (i < [self.chartItemViews count]) {
            DYChartItemView* chartItemView = self.chartItemViews[i];
            chartItemView.zoomForXAxis = [self.dataAdapter xZoomValueForChartItemViewAtIndex:i];
            chartItemView.originalZoomForXAxis = [self.dataAdapter xZoomValueForChartItemViewAtIndex:i];
            chartItemView.zoomForYAxis = [self.dataAdapter yZoomValueForChartItemViewAtIndex:i];
            chartItemView.yAxisOffset = [self.dataAdapter yOffsetForChartItemViewAtIndex:i];
            if ([chartItemView isKindOfClass:[DYChartCurveView class]]) {
                chartItemView.yAxisOffset -= self.yTop;
            }
            chartItemView.minX = self.dataAdapter.minX;
            if (self.dataAdapter.adapterType == twoUnitsReverseAdapter) {
                if (i != chartItemCount - 1) {
                    chartItemView.minY = [self.dataAdapter yMinValueForChartItemViewAtIndex:i];
                }
                else
                {
                    chartItemView.minY = [self.dataAdapter yRightMinValueForChartItemViewAtIndex:i];
                }
            }
            else if ([self.dataAdapter adapterType] != twoUnitsWith1_2_X) {
                if (i == 0) {
                    chartItemView.minY = [self.dataAdapter yMinValueForChartItemViewAtIndex:i];
                }
                else
                {
                    chartItemView.minY = [self.dataAdapter yRightMinValueForChartItemViewAtIndex:i];
                }
            }
            else {
                if (i == 0) {
                    chartItemView.minY = [self.dataAdapter yMinValueForChartItemViewAtIndex:i];
                }
                else
                {
                    chartItemView.minY = [self.dataAdapter yRightMinValueForChartItemViewAtIndex:i];
                }
            }
            
            [chartItemView setNeedsDisplay];
        }
    }
    
    [self.maskView setNeedsDisplay];
//    [self setNeedsDisplay];
}

- (void)reCalcChartItemViewsXOffset
{
    NSUInteger chartItemCount = [self.dataSource countOfChartItemViewForChartView:self];
    CGFloat curveViewOffset = -1.0f;
    
    for (NSUInteger i = 0 ; i < chartItemCount; i ++) {
        if (i < [self.chartItemViews count]) {
            DYChartItemView* chartItemView = self.chartItemViews[i];
            if ([chartItemView isKindOfClass:[DYChartBarView class]] ||
                [chartItemView isKindOfClass:[DYChartCandleView class]]) {
                
                [chartItemView calcPointWidth];
                CGFloat offset = chartItemView.pointWidth/2;
                if (offset > curveViewOffset) {
                    curveViewOffset = offset;
                }
            }
            else if ([chartItemView isKindOfClass:[DYChartCurveView class]]) {
                chartItemView.xAxisOffset = 0;
            }
        }
    }
    
    if (!self.dataAdapter.xAxisIsNotContinueIntIndex) {
        if (curveViewOffset > .0f) {
            for (NSUInteger i = 0 ; i < chartItemCount; i ++) {
                if (i < [self.chartItemViews count]) {
                    DYChartItemView* chartItemView = self.chartItemViews[i];
                    if ([chartItemView isKindOfClass:[DYChartCurveView class]]) {
                        chartItemView.xAxisOffset = curveViewOffset;
                    }
                }
            }
        }
    }
}

- (void)setGestureConflictView:(UIScrollView*)conflictView
{
    if (self.maskView != nil) {
        self.maskView.gestureConflictView = conflictView;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    DDLogInfo(@"layoutSubviews...");
    [self.loadingView setFrame:self.bounds];
    [self.tipsView setFrame:self.bounds];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayLayoutSubViews) object:nil];
    [self performSelector:@selector(delayLayoutSubViews) withObject:nil afterDelay:.3];
}

- (void)delayLayoutSubViews
{
//    DDLogInfo(@"delayLayoutSubViews...");
    static BOOL resizeing = NO;
    if (!resizeing) {
        resizeing = YES;
        
        [self resizeSubViews];
        
        resizeing = NO;
    }
}

- (void)resizeSubViews
{
    [self setupFixedSubViews];
    
    for (DYChartItemView* itemView in self.chartItemViews) {
        if ([itemView isKindOfClass:[DYChartCurveView class]]) {
            [itemView setFrame:self.higherCanvasRect];
            itemView.yAxisOffset = -self.yTop;
            itemView.calcRect = self.canvasRect;
        }
        else {
            [itemView setFrame:self.canvasRect];
        }
    }
    
    [self resetDataAdapter];
    [self redrawChartItemViews];
    [self reloadDataForFixedSubViews];
}

- (void)showLoading:(BOOL)show withText:(NSString*)loadingString
{
    NSString* string = @"正在加载...";
    if ([loadingString length] > 0) {
        string = loadingString;
    }
    
    if (show) {
        if ([self.loadingView superview] == nil) {
            [self addSubview:self.loadingView];
        }
        else {
            //
        }
        
        if ([self.loadingView isKindOfClass:[UILabel class]]) {
            UILabel* loadingLabel = (UILabel*)self.loadingView;
            loadingLabel.text = string;
        }
        
        [self.loadingView setHidden:NO];
    }
    else {
        if ([self.loadingView superview] == nil) {
            //
        }
        else {
            [self.loadingView removeFromSuperview];
        }
        
        [self.loadingView setHidden:YES];
    }
}

- (void)showTipsView:(BOOL)show withText:(NSString*)tipsString
{
    NSString* string = @"抱歉，您暂无权限查看数据";
    if ([tipsString length] > 0) {
        string = tipsString;
    }
    
    if (show) {
        if ([self.tipsView superview] == nil) {
            [self addSubview:self.tipsView];
        }
        else {
            //
        }
        
        if ([self.tipsView isKindOfClass:[UILabel class]]) {
            UILabel* tipsView = (UILabel*)self.tipsView;
            tipsView.text = string;
        }
        
        [self.tipsView setHidden:NO];
    }
    else {
        if ([self.tipsView superview] == nil) {
            //
        }
        else {
            [self.tipsView removeFromSuperview];
        }
        
        [self.tipsView setHidden:YES];
    }
}

- (void)setXDescriptionBeginIndex:(NSInteger)xDescriptionBeginIndex
{
    _xDescriptionBeginIndex = xDescriptionBeginIndex;
    
    CGRect rect = [self canvasRect];
    
    // 每根柱子有多宽
    NSUInteger maxCount = [self maxCountOfDataInChartView];
    
    if (maxCount > 0) {
        CGFloat distanceForXAxis = rect.size.width/maxCount;
        NAN_OR_INF_2_ZERO(distanceForXAxis)
        
        if (xDescriptionBeginIndex == 0) {
            self.xAxisView.offset = /*(self.yWidth - self.xLeft)*/0;
        }
        else
        {
            self.xAxisView.offset = /*(self.yWidth - self.xLeft)*/0 + (-.5 + xDescriptionBeginIndex)*distanceForXAxis;
        }
    }
    
    [self.xAxisView resetLabelPosition];
}

- (NSUInteger)maxCountOfDataInChartView
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
    
    return maxCount;
}

#pragma mark - view life functions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupBasicProperty];
        [self setupFixedSubViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setupBasicProperty];
    
    [self setupFixedSubViews];
}

- (void)setupBasicProperty
{
    self.clipsToBounds = YES;
    
    self.autoResizeYZoom = YES;
    self.drawXDashedLines = YES;
    self.drawYDashedLines = YES;
    self.maxXZoomValue = 5;
    self.minXZoomValue = 1;
    
    self.yWidth = 30;
    self.xHeight = 20;
    self.yTop = 20;
    self.yBottom = 20;
    self.xLeft = 30;
    self.xRight = 28;
    self.barCountInGroup = 3;
}

/**
 *	@brief	构建固定的几个子View：纵轴、横轴、maskView
 */
- (void)setupFixedSubViews
{
    [self setMultipleTouchEnabled:YES];
    [self setUserInteractionEnabled:YES];
    
    
    // X轴
    DYXAxisView* xAxisView = nil;
    if (self.xAxisView == nil) {
        xAxisView = [[DYXAxisView alloc] initWithFrame:self.xAxisRect];
        self.xAxisView = xAxisView;
        [self addSubview:xAxisView];
    }
    else {
        xAxisView = self.xAxisView;
        [xAxisView setFrame:self.xAxisRect];
    }
    xAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
    xAxisView.dataSource = self;
    self.xDescriptionBeginIndex = self.xDescriptionBeginIndex;
    [xAxisView setTextAlignment:NSTextAlignmentCenter];
    xAxisView.textEdgeOffset = 0;
//    [xAxisView setDrawContentFlag:eDrawMajorScaleText | eDrawAxis];
    
    
    // 左边Y轴
    DYYAxisView* yAxisView = nil;
    if (self.leftYAxisView == nil) {
        yAxisView = [[DYYAxisView alloc] initWithFrame:self.leftYAxisRect];
        yAxisView.axisPosition = eAxisPositionLeft;
        yAxisView.textAlignment = NSTextAlignmentLeft;
        self.leftYAxisView = yAxisView;
        [self addSubview:yAxisView];
    }
    else {
        yAxisView = self.leftYAxisView;
        [yAxisView setFrame:self.leftYAxisRect];
    }
    yAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
    yAxisView.dataSource = self;
    [yAxisView setOffset:self.xHeight - self.yBottom];
//    [yAxisView setDrawContentFlag:eDrawMajorScaleText | eDrawMajorScale | eDrawAxis];
    
    
    // 右边Y轴
    if (self.rightYAxisView == nil) {
        yAxisView = [[DYYAxisView alloc] initWithFrame:self.rightYAxisRect];
        yAxisView.axisPosition = eAxisPositionRight;
        yAxisView.textAlignment = NSTextAlignmentRight;
        self.rightYAxisView = yAxisView;
        [self addSubview:yAxisView];
    }
    else {
        yAxisView = self.rightYAxisView;
        [yAxisView setFrame:self.rightYAxisRect];
    }
    yAxisView.axisColor = DYAppearanceColor(@"H2", 1.0);
    yAxisView.dataSource = self;
    [yAxisView setOffset:self.xHeight - self.yBottom];
//    [yAxisView setTextEdgeOffset:-self.yWidth + 6];
//    [yAxisView setDrawContentFlag:eDrawMajorScaleText | eDrawMajorScale | eDrawAxis];
    
    
    // maskView
    DYMaskView* maskView = nil;
    if (self.maskView == nil) {
        maskView = [[DYMaskView alloc] initWithFrame:self.maskViewRect];
        self.maskView = maskView;
        [self addSubview:maskView];
    }
    else {
        maskView = self.maskView;
        [maskView setFrame:self.maskViewRect];
    }

    maskView.mydelegate = self;
    maskView.beginX = 0;
    maskView.endX = self.canvasRect.size.width;
    maskView.beginY = 0;
    maskView.endY = self.canvasRect.size.height;
    maskView.showMask = eDYMaskViewShowVerticalDashedLine|eDYMaskViewShowHitCircle;
    if (self.notDrawMaskArcFlag) {
        maskView.showMask = eDYMaskViewShowVerticalDashedLine;
    }
    maskView.lineColor = DYAppearanceColor(@"H13", 1.0);
//    [maskView setTouchEventsMask:eDYTouchStatePan | eDYTouchStateOneFingerLongPress | eDYTouchStateOneFingerSingleTap];
}

- (void)resetDataAdapter
{
    CGRect rect = self.canvasRect;
    
    self.dataAdapter.canvasWidth = rect.size.width;
    self.dataAdapter.canvasHeight = rect.size.height;
    
    [self.dataAdapter adapterData];
}

- (void)reloadDataForFixedSubViews
{
    // 当要求显示Y为0的中轴线时，将X轴移到中间
    CGRect xAxisViewFrame = [self xAxisRect];
    if (self.dataAdapter.yZeroInMiddle) {
        CGRect leftYAxisViewFrame = self.leftYAxisView.frame;
        xAxisViewFrame.origin.y = leftYAxisViewFrame.origin.y + leftYAxisViewFrame.size.height/2;
        self.xAxisView.frame = xAxisViewFrame;
    }
    else if (self.dataAdapter.yZeroPosition <= self.canvasRect.size.height) {
        CGRect leftYAxisViewFrame = self.canvasRect;
        xAxisViewFrame.origin.y = leftYAxisViewFrame.origin.y + self.dataAdapter.yZeroPosition;
        self.xAxisView.frame = xAxisViewFrame;
        self.xAxisView.textEdgeOffset = self.canvasRect.size.height - self.dataAdapter.yZeroPosition;
        
        for (DYChartItemView* chartItemView in self.chartItemViews) {
            chartItemView.fillToXZero = YES;
        }
    }
    
    self.xAxisView.frame = xAxisViewFrame;
    self.xAxisView.zoomValue = self.dataAdapter.originalZoomX;
    self.xAxisView.originalZoomValue = self.dataAdapter.originalZoomX;
    [self.xAxisView reloadData];
    
    self.leftYAxisView.frame = [self leftYAxisRect];
    self.leftYAxisView.zoomValue = self.dataAdapter.originalZoomY;
    self.leftYAxisView.originalZoomValue = self.dataAdapter.originalZoomX;
    [self.leftYAxisView reloadData];
    
    self.rightYAxisView.frame = [self rightYAxisRect];
    self.rightYAxisView.zoomValue = self.dataAdapter.originalRightZoomY;
    self.rightYAxisView.originalZoomValue = self.dataAdapter.originalZoomX;
    [self.rightYAxisView reloadData];
    
    [self.maskView setFrame:self.maskViewRect];
    self.maskView.beginX = 0;
    self.maskView.endX = self.canvasRect.size.width;
    self.maskView.beginY = 0;
    self.maskView.endY = self.canvasRect.size.height;
}

#pragma mark - 子类重载决定X轴、左Y轴、右Y轴、画布的位置
- (CGRect)canvasRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(self.xLeft,
                      self.yTop,
                      parentBounds.size.width - self.xLeft - self.xRight,
                      parentBounds.size.height - self.xHeight - self.yTop);
}

- (CGRect)higherCanvasRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(self.xLeft,
                      0,
                      parentBounds.size.width - self.xLeft - self.xRight,
                      parentBounds.size.height);
}

- (CGRect)xAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(self.xLeft,
                      parentBounds.size.height - self.xHeight,
                      parentBounds.size.width - self.xLeft - self.xRight,
                      self.xHeight);
}

- (CGRect)leftYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(0,
                      self.yTop,
                      self.yWidth,
                      parentBounds.size.height - self.yTop - self.yBottom);
}

- (CGRect)rightYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(parentBounds.size.width - self.yWidth*2,
                      self.yTop,
                      self.yWidth,
                      parentBounds.size.height - self.yTop - self.yBottom);
}

- (CGRect)maskViewRect
{
    return self.canvasRect;
}

- (UIView*)loadingView
{
    if (_loadingView == nil) {
        UILabel* loadingLabel = [[UILabel alloc] initWithFrame:self.bounds];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.backgroundColor = DYAppearanceColor(@"W1", 1.0);
        loadingLabel.font = DYAppearanceFont(@"T4");
        loadingLabel.textColor = DYAppearanceColor(@"H5", 1.0);
        [loadingLabel setHidden:YES];
        
        loadingLabel.text = @"正在加载...";
        
        _loadingView = loadingLabel;
    }
    
    return _loadingView;
}

- (UIView*)tipsView
{
    if (_tipsView == nil) {
        UILabel* loadingLabel = [[UILabel alloc] initWithFrame:self.bounds];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.backgroundColor = DYAppearanceColor(@"W1", 1.0);
        loadingLabel.font = DYAppearanceFont(@"T4");
        loadingLabel.textColor = DYAppearanceColor(@"H5", 1.0);
        [loadingLabel setHidden:YES];
        
        loadingLabel.text = @"抱歉，您暂无权限查看数据";
        
        _tipsView = loadingLabel;
    }
    
    return _tipsView;
}

#pragma mark - HBAxisViewDelegate functions

// 大刻度的个数
- (NSInteger)numberOfScaleSections:(DYAxisView*)axisView
{
    if (axisView == self.leftYAxisView) {
        return self.dataAdapter.yPartCount;
    }
    else if (axisView == self.rightYAxisView) {
        return self.dataAdapter.yRightPartCount;
    }
    else if (axisView == self.xAxisView) {
        NSUInteger maxCount = [self maxCountOfDataInChartView];
        
        if (maxCount <= 0) {
            return .0f;
        }
        
        if (maxCount <= self.dataAdapter.xPartCount*[self xZoomTimes]) {
            return maxCount;
        }
        return self.dataAdapter.xPartCount*[self xZoomTimes];
    }
    
    return 1;
}

// 每个大刻度里小刻度的个数
- (NSInteger)numberOfScaleForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    if (axisView == self.leftYAxisView) {
        return self.dataAdapter.ySubPartCount;
    }
    else if (axisView == self.rightYAxisView) {
        return self.dataAdapter.yRightSubPartCount;
    }
    else if (axisView == self.xAxisView) {
        return self.dataAdapter.xSubPartCount;
    }
    return 0;
}

- (CGFloat)positionOfScaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset
{
    if (axisView == self.xAxisView) {
        if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
            return [self positionForXAxisViewAtSection:section withOffset:offset];
        }
        else {
            NSInteger dataIndex = [self dataIndexForAxisView:axisView atSection:section];
            dataIndex += offset;
            if (dataIndex < [self maxCountOfDataInChartView]) {
                for (DYChartItemView* chartView in self.chartItemViews) {
                    return [chartView fixXPositionOfMaskView:self.maskView atIndex:dataIndex] - chartView.xAxisOffset;
                }
            }
        }
    }
    return .0f;
}

- (NSInteger)dataIndexForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    NSUInteger maxCount = [self maxCountOfDataInChartView];
    
    if (maxCount <= 0) {
        return 0;
    }
    
    NSInteger numberOfScale = [self numberOfScaleSections:axisView];
    NSInteger dataIndex = 0;
    if (numberOfScale > 0) {
        NSInteger jumpCountPerSection = maxCount/numberOfScale + (maxCount%numberOfScale == 0 ? 0 : 1);
        dataIndex = section*jumpCountPerSection;
    }
    
    return dataIndex;
}

- (CGFloat)positionForXAxisViewAtSection:(NSInteger)section withOffset:(NSInteger)offset
{
    NSInteger numberOfScale = [self numberOfScaleSections:self.xAxisView];
    if (numberOfScale > 0) {
        CGFloat sectionPosition = self.canvasRect.size.width/numberOfScale*section;
        CGFloat allDays = (self.dataAdapter.maxX - self.dataAdapter.minX)/(1000*60*60*24) + 1;
        CGFloat offsetPosition = offset/allDays*self.canvasRect.size.width;
        return (sectionPosition + offsetPosition)*[self xZoomTimes];
    }
    return .0f;
}

// 大刻度上显示的文字
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset
{
    CGFloat value = 0;
    if (axisView == self.xAxisView) {
        NSString* string = @"";
        
        if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
            NSInteger numberOfScale = [self numberOfScaleSections:self.xAxisView];
            if (numberOfScale > 0) {
                CGFloat xZoomTimes = [self xZoomTimes];
                if (isnan(xZoomTimes) || isinf(xZoomTimes)) {
                    xZoomTimes = 1;
                }
                int64_t timestamp = self.dataAdapter.minX + (self.dataAdapter.maxX - self.dataAdapter.minX)*section/numberOfScale + offset*1000*60*60*24/xZoomTimes;
                string = [self.dataSource xDescriptionForChartView:self atIndex:timestamp];
            }
            else {
                int64_t timestamp = self.dataAdapter.minX + (self.dataAdapter.maxX - self.dataAdapter.minX)*section + offset*1000*60*60*24;
                string = [self.dataSource xDescriptionForChartView:self atIndex:timestamp];
            }
        }
        else {
            NSInteger dataIndex = [self dataIndexForAxisView:axisView atSection:section];
            dataIndex += offset;
            NSInteger maxCountOfDataInChartView = [self maxCountOfDataInChartView];
            if (dataIndex < maxCountOfDataInChartView) {
                string = [self.dataSource xDescriptionForChartView:self atIndex:dataIndex];
            }
        }
        
        
        return string;
    }
    else if (axisView == self.leftYAxisView)
    {
        CGFloat distance = self.dataAdapter.maxY - self.dataAdapter.minY;
        value = self.dataAdapter.minY + distance/self.dataAdapter.yPartCount*section;
        CGFloat gap = self.dataAdapter.yPartCount == 0 ? 1 : distance/self.dataAdapter.yPartCount;
        NSString* string = [DYTools formatingToShortStringWithNumber:value andGap:gap leftDecimalNumber:2];
        return [string isEqualToString:@"nan"] ? @"0.0" : string;
//        return [DYTools formattingNum:value leftDecimalNumber:2];//[NSString stringWithFormat:@"%.0f", value];
    }
    else
    {
        CGFloat distance = self.dataAdapter.maxRightY - self.dataAdapter.minRightY;
        value = self.dataAdapter.minRightY + distance/self.dataAdapter.yRightPartCount*section;
        CGFloat gap = self.dataAdapter.yRightPartCount == 0 ? 1 : distance/self.dataAdapter.yRightPartCount;
        NSString* string = [DYTools formatingToShortStringWithNumber:value andGap:gap leftDecimalNumber:2];
        return [string isEqualToString:@"nan"] ? @"0.0" : string;
//        return [DYTools formattingNum:value leftDecimalNumber:2];//[NSString stringWithFormat:@"%.0f", value];
    }
}

// 小刻度上显示的文字
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath
{
    CGFloat value = 0;
    if (axisView == self.xAxisView) {
        CGFloat distance = self.dataAdapter.maxX - self.dataAdapter.minX;
        value = self.dataAdapter.minX +
        distance/self.dataAdapter.xPartCount*indexPath.section +
        distance/self.dataAdapter.xPartCount/(self.dataAdapter.xSubPartCount + 1)*(indexPath.row + 1);
        
        if (axisView.zoomValue > 3) {
            value = floorf(value);
            int nValue = (int)value;
            nValue += self.xDescriptionBeginIndex;
            NSString* string = [self.dataSource xDescriptionForChartView:self atIndex:nValue];
            return string;
        }
        return @"";
    }
    else if (axisView == self.leftYAxisView)
    {
        CGFloat distance = self.dataAdapter.maxY - self.dataAdapter.minY;
        value = self.dataAdapter.minY +
        distance/self.dataAdapter.yPartCount*indexPath.section +
        distance/self.dataAdapter.yPartCount/(self.dataAdapter.ySubPartCount + 1)*(indexPath.row + 1);
        return [NSString stringWithFormat:@"%.2f", value];
    }
    else
    {
        CGFloat distance = self.dataAdapter.maxRightY - self.dataAdapter.minRightY;
        value = self.dataAdapter.minRightY +
        distance/self.dataAdapter.yRightPartCount*indexPath.section +
        distance/self.dataAdapter.yRightPartCount/(self.dataAdapter.yRightSubPartCount + 1)*(indexPath.row + 1);
        return [NSString stringWithFormat:@"%.2f", value];
    }
}

- (CGFloat)distanceForAxisView:(DYAxisView*)axisView forOffset:(NSInteger)offset
{
    NSUInteger maxCount = [self maxCountOfDataInChartView];
    
    if (maxCount <= 0) {
        return 1;
    }
    else {
        return offset*(self.dataAdapter.maxX - self.dataAdapter.minX)/maxCount/[self xZoomTimes];
    }
}

// 大刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    if (axisView == self.xAxisView) {
        if (self.dataAdapter.xPartCount > 0) {
            return (self.dataAdapter.maxX - self.dataAdapter.minX)/self.dataAdapter.xPartCount/[self xZoomTimes];
        }
    }
    else if (axisView == self.leftYAxisView)
    {
        if (self.dataAdapter.yPartCount > 0) {
            return (self.dataAdapter.maxY - self.dataAdapter.minY)/self.dataAdapter.yPartCount;
        }
    }
    else
    {
//        CGFloat chartHeight = (1 - self.dataAdapter.bottomGapPercent - self.dataAdapter.topGapPercent)*self.dataAdapter.canvasHeight;
//        return chartHeight/self.dataAdapter.yPartCount;
        if (self.dataAdapter.yRightPartCount > 0) {
            return (self.dataAdapter.maxRightY - self.dataAdapter.minRightY)/self.dataAdapter.yRightPartCount;
        }
    }
    
    return .0f;
}

// 小刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath
{
    if (axisView == self.xAxisView) {
        CGFloat xPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return xPartDistance/(self.dataAdapter.xSubPartCount + 1);
    }
    else if (axisView == self.leftYAxisView)
    {
        CGFloat yPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return yPartDistance/(self.dataAdapter.ySubPartCount + 1);
    }
    else
    {
        CGFloat yPartDistance = [self distanceForAxisView:axisView atSection:indexPath.section];
        return yPartDistance/(self.dataAdapter.yRightPartCount + 1);
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
    NSUInteger maxCount = [self maxCountOfDataInChartView];
    
    if (maxCount <= 0) {
        return 0;
    }
    
    CGFloat originalWidth = self.canvasRect.size.width/maxCount;
    
    if (self.dataAdapter.originalZoomX <= 0) {
        return 0;
    }
    
    return originalWidth*self.xAxisView.zoomValue/self.dataAdapter.originalZoomX;
}

#pragma mark - DYChartItemViewDataSource functions

- (NSUInteger)countOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
        // 非连续数据时，有多少天，就有多少个点
        if ([chartItemView isKindOfClass:[DYChartBarView class]]) {
            return (self.dataAdapter.maxX - self.dataAdapter.minX)/1000/60/60/24 + 1;
        }
        return (self.dataAdapter.maxX - self.dataAdapter.minX)/1000/60/60/24;
    }
    else if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfDataForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource countOfDataForChartView:self atIndex:tag];
    }
    
    return 0;
}

- (NSUInteger)validCountOfChartItemView:(DYChartItemView *)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfValidDataForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource countOfValidDataForChartView:self atIndex:tag];
    }
    
    return 0;
}

- (NSRange)rangeOfValidCountOfChartItemView:(DYChartItemView *)chartItemView
{
    NSRange range;
    range.location = 0;
    range.length = [self validCountOfChartItemView:chartItemView];
    return range;
}

- (CGPoint)pointOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    CGFloat x = index;
    if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(dataXValueForChartView:atIndexPath:)]) {
            NSInteger tag = chartItemView.tag;
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:tag];
            id xValue = [self.dataSource dataXValueForChartView:self atIndexPath:indexPath];
            x = [xValue floatValue];
        }
    }
    
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(dataValueForChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:tag];
        id yValue = [self.dataSource dataValueForChartView:self atIndexPath:indexPath];
        
        return CGPointMake(x, [yValue floatValue]);
    }
    
    return CGPointMake(x, 0);
}

- (id)dataOfChartItemView:(DYChartItemView *)chartItemView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(dataValueForChartView:atIndexPath:)]) {
        NSInteger tag = chartItemView.tag;
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:tag];
        return [self.dataSource dataValueForChartView:self atIndexPath:indexPath];
    }
    
    return nil;
}

- (NSString*)xTipsOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(xDescriptionForChartView:atIndex:)]) {
        return [self.dataSource xDescriptionForChartView:self atIndex:index];
    }
    
    return @"";
}

- (NSString*)xTipsOfChartItemView:(DYChartItemView*)chartItemView atPosition:(CGFloat)position
{
    if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(xDescriptionForChartView:atIndex:)]) {
            int64_t timestamp = [chartItemView getTimestampFromXPosition:position fromView:self.maskView];
            return [self.dataSource xDescriptionForChartView:self atIndex:timestamp];
        }
    }
    else {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(xDescriptionForChartView:atIndex:)]) {
            NSInteger index = [chartItemView getIndexFromXPosition:position fromView:self.maskView];
            return [self.dataSource xDescriptionForChartView:self atIndex:index];
        }
    }
    
    return @"";
}

- (NSString*)yTipsOfChartItemView:(DYChartItemView *)chartItemView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yDescriptionForChartView:atIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:chartItemView.tag];
        return [self.dataSource yDescriptionForChartView:self atIndexPath:indexPath];
    }
    
    return @"";
}

- (NSString*)yTipsOfChartItemView:(DYChartItemView*)chartItemView atPosition:(CGFloat)position
{
    if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(yDescriptionForChartView:atIndexPath:)]) {
            int64_t timestamp = [chartItemView getTimestampFromXPosition:position fromView:self.maskView];
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:timestamp inSection:chartItemView.tag];
            return [self.dataSource yDescriptionForChartView:self atIndexPath:indexPath];
        }
    }
    else {
        if (self.dataSource != nil &&
            [self.dataSource respondsToSelector:@selector(yDescriptionForChartView:atIndexPath:)]) {
            NSInteger index = [chartItemView getIndexFromXPosition:position fromView:self.maskView];
            DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:chartItemView.tag];
            return [self.dataSource yDescriptionForChartView:self atIndexPath:indexPath];
        }
    }
    
    return @"";
}

- (UIFont*)yColorTipsFontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsFontForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource yColorTipsFontForChartView:self atIndex:tag];
    }
    
    return DYAppearanceFont(@"T1");
}

- (NSArray*)yColorTipsColorOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yColorTipsColorForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource yColorTipsColorForChartView:self atIndex:tag];
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
        [self.dataSource respondsToSelector:@selector(ifDrawPointBeforeYColorTipsForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource ifDrawPointBeforeYColorTipsForChartView:self atIndex:tag];
    }
    
    return NO;
}

- (UIFont*)yTipsFontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsFontForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource yTipsFontForChartView:self atIndex:tag];
    }
    
    return DYAppearanceFont(@"T1");
}

- (NSArray*)yTipsColorOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(yTipsColorForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource yTipsColorForChartView:self atIndex:tag];
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
        [self.dataSource respondsToSelector:@selector(colorOfTipsForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource colorOfTipsForChartView:self atIndex:tag];
    }
    
    return DYAppearanceColor(@"W1", 1.0);
}

- (UIFont*)fontOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(fontForChartView:atIndex:)]) {
        NSInteger tag = chartItemView.tag;
        return [self.dataSource fontForChartView:self atIndex:tag];
    }
    
    return DYAppearanceFont(@"T15");
}

- (NSDictionary *)dictionaryForShowViewValue:(DYChartItemView*)chartItemView
                                 atIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(dictionaryForShowViewValue:atIndex:)]) {
                return [self.dataSource dictionaryForShowViewValue:self atIndex:index];
     }
    return @{};
}

#pragma mark - HBChartItemViewDelegate functions

- (void)oneFingerInChartView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    //
}

- (void)twoFingerInChartView:(DYChartItemView*)chartItemView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    //
}

#pragma mark - HBMaskViewDelegate 函数

// 当前手指移动的位置
- (void)maskView:(DYMaskView*)maskView movedTo:(CGFloat)xToPos from:(CGFloat)xFromPos
{
    if (maskView.eTouchState == eDYTouchStatePan || maskView.eTouchState == eDYTouchStateTwoFingersLongPress) {
        CGFloat offset = 0;
        for (DYChartItemView* chartView in self.chartItemViews) {
            // 更新图
            if (chartView.xAxisOffset - xFromPos + xToPos > 0) {
                chartView.xAxisOffset = 0;
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(panChartViewToLeftTop:)]) {
                    [self.delegate panChartViewToLeftTop:self];
                }
            }
            else if (chartView.xAxisOffset - xFromPos + xToPos <
                     - (chartView.bounds.size.width)*(chartView.zoomForXAxis/self.dataAdapter.originalZoomX - 1))
            {
                chartView.xAxisOffset = - chartView.bounds.size.width*(chartView.zoomForXAxis/self.dataAdapter.originalZoomX - 1);
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(panChartViewToRightTop:)]) {
                    [self.delegate panChartViewToRightTop:self];
                }
            }
            else
            {
                chartView.xAxisOffset -= xFromPos - xToPos;
            }
            
            offset = chartView.xAxisOffset;
            [chartView setNeedsDisplay];
        }
        
        // 更新X轴
        self.xAxisView.offset = offset;
        [self.xAxisView resetLabelPosition];
        
//        [self autoRecalculationYAxisNow];
    }
    else if (maskView.eTouchState == eDYTouchStateOneFingerLongPress)
    {
        int count = 0;
        for (DYChartItemView* chartView in self.chartItemViews) {
            if (chartView.isFixXPosition) {
                NSInteger index = [chartView getIndexFromXPosition:xToPos
                                                          fromView:maskView];
//                DDLogInfo(@"pcyan-position:%ld", (long)index);
                
                [self.delegate oneFingerInChartView:self atIndex:count ++
                                    pressAtPosition:index];
                break;
            }
        }
    }
}

// 在某个位置上缩放
- (void)zoomForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point withZoomValue:(CGFloat)zoomValue
{
    BOOL hit = NO;
    CGFloat offset = 0;
    CGFloat zoom = 0;
    
    if (self.xAxisView.zoomValue * zoomValue / self.dataAdapter.originalZoomX > self.maxXZoomValue) {
        zoomValue = self.maxXZoomValue*self.dataAdapter.originalZoomX/self.xAxisView.zoomValue;
    }
    else if (self.xAxisView.zoomValue * zoomValue / self.dataAdapter.originalZoomX < self.minXZoomValue)
    {
        zoomValue = self.minXZoomValue*self.dataAdapter.originalZoomX/self.xAxisView.zoomValue;
    }
    
    // 更新图
    for (DYChartItemView* chartView in self.chartItemViews) {
        CGPoint chartViewPoint = [maskView convertPoint:point toView:chartView];
        
        CGFloat oldStartPosition = chartView.xAxisOffset;
        CGFloat newStartPosition = chartViewPoint.x - zoomValue*(chartViewPoint.x - oldStartPosition);
        
        // 防止图像左边、右边的边界滑到屏幕中间来
        // 先看看左边界有没有问题
        if (newStartPosition > 0) {
            newStartPosition = 0;
            
            // 再检查右边界
            if (newStartPosition < - chartView.bounds.size.width*(chartView.zoomForXAxis*zoomValue/self.dataAdapter.originalZoomX - 1)) {
                break;
            }
        }
        // 再看看右边界有没有问题
        else if (newStartPosition <  - chartView.bounds.size.width*(chartView.zoomForXAxis*zoomValue/self.dataAdapter.originalZoomX - 1))
        {
            // 再检查左边界
            newStartPosition = - chartView.bounds.size.width*(chartView.zoomForXAxis*zoomValue/self.dataAdapter.originalZoomX - 1);
            
            if (newStartPosition > 0) {
                break;
            }
        }
        
        chartView.zoomForXAxis *= zoomValue;
        chartView.xAxisOffset = newStartPosition;
        hit = YES;
        offset = chartView.xAxisOffset;
        zoom = chartView.zoomForXAxis;
    }
    
//    [self reCalcChartItemViewsXOffset];
    
    for (DYChartItemView* chartView in self.chartItemViews) {
        [chartView setNeedsDisplay];
    }
    
    // 更新X轴
    if (hit) {
        self.xAxisView.offset = offset;
        self.xAxisView.zoomValue = zoom;
        [self.xAxisView reloadData];
        
        
        if (self.delegate != nil &&
            [self.delegate respondsToSelector:@selector(chartView:xZoomOutLevelChanged:)]) {
            [self.delegate chartView:self xZoomOutLevelChanged:zoom/self.dataAdapter.originalZoomX];
        }
//        [self autoRecalculationYAxisNow];
    }
}

// 单指双击
- (void)oneFingerDoubleClickForMaskView:(DYMaskView*)maskView atPoint:(CGPoint)point
{
    BOOL hit = NO;
    CGFloat offset = 0;
    CGFloat zoom = 0;
    
    // 更新图
    for (DYChartItemView* chartView in self.chartItemViews) {
        if (chartView.zoomForXAxis != self.dataAdapter.originalZoomX) {
            chartView.xAxisOffset = 0;
            chartView.zoomForXAxis = self.dataAdapter.originalZoomX;
        }
        else
        {
            CGPoint chartViewPoint = [maskView convertPoint:point toView:chartView];
            
            CGFloat oldStartPosition = chartView.xAxisOffset;
            CGFloat newStartPosition = chartViewPoint.x - AUTO_ZOOM_VALUE*(chartViewPoint.x - oldStartPosition);
            
            chartView.zoomForXAxis *= AUTO_ZOOM_VALUE;
            chartView.xAxisOffset = newStartPosition;
        }
        
        hit = YES;
        offset = chartView.xAxisOffset;
        zoom = chartView.zoomForXAxis;
        
        [chartView setNeedsDisplay];
    }
    
    // 更新X轴
    if (hit) {
        self.xAxisView.offset = offset;
        self.xAxisView.zoomValue = zoom/self.dataAdapter.originalZoomX;
        [self.xAxisView resetLabelPosition];
        
//        [self autoRecalculationYAxisNow];
    }
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
    int count = 0;
    for (DYChartItemView* chartView in self.chartItemViews) {
        [chartView.delegate twoFingerInChartView:chartView
                                       fromIndex:[chartView getIndexFromXPosition:fromPos fromView:maskView]
                                         toIndex:[chartView getIndexFromXPosition:toPos fromView:maskView]];
        
        [self.delegate twoFingerInChartView:self atIndex:count ++
                               fromPosition:[chartView getIndexFromXPosition:fromPos fromView:maskView]
                                 toPosition:[chartView getIndexFromXPosition:toPos fromView:maskView]];
    }
}

// 退出绘图操作
- (void)touchEnded:(DYMaskView*)maskView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(touchEndedAtChartView:)]) {
        [self.delegate touchEndedAtChartView:self];
    }
    [maskView redrawMaskView];
}

- (void)oneFingerSingleTap:(DYMaskView *)maskView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(oneFingerSingleTapInChartView:)]) {
        [self.delegate oneFingerSingleTapInChartView:self];
    }
}

#pragma mark - DYDataAdapterDataSource functions

- (NSUInteger)countOfChartItemViewForDataAdapter:(DYDataAdapterBase *)dataAdapter
{
    return [self.dataSource countOfChartItemViewForChartView:self];
}

- (NSUInteger)countOfDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                atIndex:(NSUInteger)index
{
    return [self.dataSource countOfDataForChartView:self atIndex:index];
}

- (NSRange)rangeOfValidDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                  atIndex:(NSUInteger)index
{
    DYChartItemView* chartItemView = [self.chartItemViews count] > index ? self.chartItemViews[index] : nil;
    return [self rangeOfValidCountOfChartItemView:chartItemView];
}

- (id)dataValueForDataAdapter:(DYDataAdapterBase*)dataAdapter
                  atIndexPath:(DYIndexPath*)indexPath
{
    return [self.dataSource dataValueForChartView:self atIndexPath:indexPath];
}

- (id)dataXValueForDataAdapter:(DYDataAdapterBase*)dataAdapter
                   atIndexPath:(DYIndexPath*)indexPath
{
    if (self.dataAdapter.xAxisIsNotContinueIntIndex) {
        if ([self.dataSource respondsToSelector:@selector(dataXValueForChartView:atIndexPath:)]) {
            return [self.dataSource dataXValueForChartView:self atIndexPath:indexPath];
        }
    }
    return @(indexPath.row);
}

- (NSString *)dataUUIDForDataAdapter:(DYDataAdapterBase*)dataAdapter atIndex:(NSUInteger)index
{
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(dataUUIDForDataAdapter:atIndex:)]) {
        return [self.dataSource dataUUIDForForChartView:self atIndex:index];
    }
    return nil;
}

#pragma mark - DYChartBarViewDataSource functions

- (UIColor*)lineColorForBarView:(DYChartBarView*)barView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(lineColorForChartView:atIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:barView.tag];
        return [self.dataSource lineColorForChartView:self atIndexPath:indexPath];
    }
    else
    {
        return [self.dataSource lineColorForChartView:self atIndex:index];
    }
}

- (UIColor*)fillColorForBarView:(DYChartBarView*)barView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(fillColorForChartView:atIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:barView.tag];
        return [self.dataSource fillColorForChartView:self atIndexPath:indexPath];
    }
    else
    {
        return [self.dataSource fillColorForChartView:self atIndex:index];
    }
}

- (CGPoint)getDrawPointForChartViewAtIndexPath:(NSIndexPath *)indexPath
{
    DYChartItemView *subChartView = self.chartItemViews[indexPath.section];
    CGPoint point = [self pointOfChartItemView:subChartView atIndex:indexPath.row];
    CGFloat x = (point.x - subChartView.minX)*subChartView.zoomForXAxis + subChartView.xAxisOffset;
    CGFloat y = subChartView.calcRect.size.height - (point.y - subChartView.minY)*subChartView.zoomForYAxis - subChartView.yAxisOffset;
    
    CGPoint returnPoint = CGPointMake(x, y);
    return [subChartView convertPoint:returnPoint toView:self];
}

@end
