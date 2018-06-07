//
//  DYSimpleChartView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/25.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYSimpleChartView.h"
#import "DYChartCurveView.h"
#import "DYChartBarView.h"
#import "DYAppearance.h"
#import "DYIndexPath.h"

@interface DYSimpleChartView ()

@property (nonatomic, strong)DYChartItemView* chartItemView;
@property (nonatomic)CGFloat zoomForXAxis;
@property (nonatomic)CGFloat zoomForYAxis;
@property (nonatomic)CGFloat minX;
@property (nonatomic)CGFloat minY;
@property (nonatomic)BOOL drawXDashedLines; // 横的虚线
@property (nonatomic)BOOL drawYDashedLines; // 竖的虚线
@property (nonatomic)BOOL drawXYLines;      // 画x，y轴

@end

@implementation DYSimpleChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupBasicProperty];
    }
    return self;
}

- (void)setupBasicProperty
{
    [self setBackgroundColor:DYAppearanceColor(@"W1", 1.0)];
    self.bottomGapPercent = 0.2;
    self.topGapPercent = 0.1;
    self.drawXDashedLines = YES;
    self.drawYDashedLines = NO;
    self.drawXYLines = YES;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    // 填充背景
    CGContextFillRect(context, self.bounds);
    
    // 画虚线
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [DYAppearance colorWithRGBA:0xe5e5e533].CGColor);
    CGFloat lengths[] = {1, 1};
    CGContextSetLineDash(context, 0, lengths, 2.5);
    
    CGFloat width = self.bounds.size.width - 3;
    CGFloat height = self.bounds.size.height - 3;
    
    // 横的虚线
    if (self.drawXDashedLines) {
        CGPoint yPointLeft = CGPointMake(2, height);
        CGPoint yPointRight = CGPointMake(width, height);
        
        NSUInteger separateCount = 5;
        for (int i = 0 ; i < separateCount; i ++) {
            yPointLeft.y -=  (height + 2)/(separateCount - 1);
            yPointRight.y -= (height + 2)/(separateCount - 1);
            
            CGContextMoveToPoint(context, yPointLeft.x, yPointLeft.y);
            CGContextAddLineToPoint(context, yPointRight.x, yPointRight.y);
        }
    }
    
    // 竖的虚线
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, DYAppearanceColor(@"H2", 1.0).CGColor);
    if (self.drawYDashedLines) {
        CGPoint xPointTop  = CGPointMake(0, 0);
        CGPoint xPointBottom = CGPointMake(0, self.bounds.size.height);
        
        NSUInteger separateCount = 5;
        for (int i = 0 ; i < separateCount + 1; i ++) {
            xPointTop.x += (width + 2)/separateCount;
            xPointBottom.x += (width + 2)/separateCount;
            
            CGContextMoveToPoint(context, xPointTop.x, xPointTop.y);
            CGContextAddLineToPoint(context, xPointBottom.x, xPointBottom.y);
        }
    }
    
    CGContextStrokePath(context);
    
    // 画Y值为0的线
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [DYAppearance colorWithRGB:0xcccccc].CGColor);
    CGFloat lengths2[] = {1,0};
    CGContextSetLineDash(context,0, lengths2, 2);
    if (self.drawXYLines) {
        CGContextMoveToPoint(context, 2, 0);
        CGContextAddLineToPoint(context, 2, height + 2);
        CGContextAddLineToPoint(context, width + 3, height + 2);
    }
    CGContextStrokePath(context);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBasicProperty];
}

- (void)reloadDataWithAnimation:(BOOL)animation
{
    // 移除所有子View
    [self.chartItemView removeFromSuperview];
    
    if (![self calcZoom]) {
        return;
    }
    
    EDYChartItemViewType chartItemType = [self.dataSource chartItemType];
    switch (chartItemType) {
        case eDYChartTypeCurve:
        case eDYChartTypeArea:
        {
            DYChartCurveView* curveView = [[DYChartCurveView alloc] initWithFrame:[self chartItemViewFrame]];
            curveView.zoomForXAxis = self.zoomForXAxis;
            curveView.zoomForYAxis = self.zoomForYAxis;
            curveView.xAxisOffset = 0;
            curveView.yAxisOffset = self.bounds.size.height*self.bottomGapPercent;
            curveView.minX = self.minX;
            curveView.minY = self.minY;
            curveView.drawSmoothCurveFlag = NO;
            curveView.fillFlag = chartItemType == eDYChartTypeArea;
            curveView.dataSource = self;
            
            if ([self.dataSource countOfData] > 0) {
                curveView.lineColor = [self.dataSource lineColorAtIndex:0];
                curveView.fillColor = [self.dataSource fillColorAtIndex:0];
            }
            
            [self addSubview:curveView];
            self.chartItemView = curveView;
            
            if (animation) {
                [curveView showAnimation];
            }
        }
            break;
        case eDYChartTypeBar:
        {
            DYChartBarView* barView = [[DYChartBarView alloc] initWithFrame:[self chartItemViewFrame]];
            barView.zoomForXAxis = self.zoomForXAxis;
            barView.zoomForYAxis = self.zoomForYAxis;
            barView.xAxisOffset = self.bounds.size.width/2/[self.dataSource countOfData];
            barView.yAxisOffset = self.bounds.size.height*self.bottomGapPercent;
            barView.minX = self.minX;
            barView.minY = self.minY;
            barView.dataSource = self;
            barView.barDataSource = self;
            
            [self addSubview:barView];
            self.chartItemView = barView;
            
            if (animation) {
                [barView showAnimation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)reloadData
{
    [self reloadDataWithAnimation:NO];
}

- (CGRect)chartItemViewFrame
{
    CGRect drawRect = self.bounds;
    return CGRectMake(2, 2, drawRect.size.width - 4, drawRect.size.height - 4);
}

- (BOOL)calcZoom
{
    CGFloat minX = MAXFLOAT;
    CGFloat maxX = -MAXFLOAT;
    CGFloat minY = MAXFLOAT;
    CGFloat maxY = -MAXFLOAT;
    
    BOOL hit = YES;
    NSUInteger dataCount = [self.dataSource countOfData];
    minX = 0;
    maxX = dataCount - 1;
    if ([self.dataSource chartItemType] == eDYChartTypeBar) {
        maxX = dataCount;
    }
    
    for (NSUInteger i = 0 ; i < dataCount; i ++) {
        hit = YES;
        
        CGFloat value = [self.dataSource dataValueAtIndex:i];
        if (value > maxY) {
            maxY = value;
        }
        
        if (value < minY) {
            minY = value;
        }
    }
    
    if (!hit) {
        return NO;
    }
    
    CGFloat chartHeight = (1 - self.bottomGapPercent - self.topGapPercent)*(self.bounds.size.height - 4);
    CGFloat chartWidth = (self.bounds.size.width - 4);
    self.zoomForXAxis = chartWidth/(maxX - minX);
    self.zoomForYAxis = chartHeight/(maxY - minY);
    self.minX = minX;
    self.minY = minY;
    
    return YES;
}

#pragma mark - HBChartItemViewDataSource 函数

- (NSUInteger)countOfChartItemView:(DYChartItemView*)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfData)]) {
        return [self.dataSource countOfData];
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

- (NSUInteger)validCountOfChartItemView:(DYChartItemView *)chartItemView
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfData)]) {
        return [self.dataSource countOfData];
    }
    
    return 0;
}

- (CGPoint)pointOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index
{
    CGFloat x = index;
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(dataValueAtIndex:)]) {
        CGFloat y = [self.dataSource dataValueAtIndex:index];
        
        CGPointMake(x, y);
    }
    
    return CGPointMake(x, 0);
}

-(NSInteger)countOfYAxisData
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(countOfData)]) {
        return [self.dataSource countOfData];
    }
    
    return 0;
}

#pragma mark - HBChartBarViewDataSource functions

- (UIColor*)lineColorForBarView:(DYChartBarView *)barView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(lineColorAtIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:0];
        return [self.dataSource lineColorAtIndexPath:indexPath];
    }
    else if (self.dataSource != nil &&
             [self.dataSource respondsToSelector:@selector(lineColorAtIndex:)]) {
        return [self.dataSource lineColorAtIndex:index];
    }
    
    return DYAppearanceColor(@"H13", 1.0);
}

- (UIColor*)fillColorForBarView:(DYChartBarView *)barView atIndex:(NSUInteger)index
{
    if (self.dataSource != nil &&
        [self.dataSource respondsToSelector:@selector(fillColorAtIndexPath:)]) {
        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:index inSection:0];
        return [self.dataSource fillColorAtIndexPath:indexPath];
    }
    else if (self.dataSource != nil &&
             [self.dataSource respondsToSelector:@selector(fillColorAtIndex:)]) {
        return [self.dataSource fillColorAtIndex:index];
    }
    
    return DYAppearanceColor(@"H13", 1.0);
}


@end
