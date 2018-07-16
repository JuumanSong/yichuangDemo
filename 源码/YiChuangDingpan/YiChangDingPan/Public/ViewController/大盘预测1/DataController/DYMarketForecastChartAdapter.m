//
//  DYMarketForecastChartAdapter.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/4/27.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMarketForecastChartAdapter.h"
//#import "DYMFTipView.h"
#import "DYMFTipPopView.h"
#import "DYMaskView.h"
#import "DYMarketForeShowChartModel.h"

@interface DYMarketForecastChartAdapter()<DYKLineChartViewDataSource, DYKLineChartViewDelegate,DYMaskViewDataSource>
@property (nonatomic, strong) DYDataAdapterBase *baseAdapter;
@property (nonatomic, copy) DataBlock tipBlock;

@end

@implementation DYMarketForecastChartAdapter

#pragma mark - Init
- (instancetype)initWithChartView:(DYMFChartView *)chartView
{
    
    self = [super init];
    
    if (self) {
        self.chartView = chartView;
        [self setupAdapterWithSlotChartView:chartView];
    }
    
    return self;
}

#pragma mark - setup
- (void)setupAdapterWithSlotChartView:(DYMFChartView *)chartView
{
    chartView.lineWidth = 1.0;
//    chartView.delegate = self;
    chartView.dataSource = self;
    chartView.kLineFlag = YES;
    chartView.drawYDashedLines = YES;
//    chartView.maskView.touchEventsMask = eDYTouchStateOneFingerSingleTap|eDYTouchStateOneFingerLongPress;
//    chartView.maskView.tipsShowType = eDYShowTipsAtFingerPoint;
//    chartView.isTimeLine = YES;
//    chartView.maskView.showMask = eDYMaskViewShowVerticalLine;
//    chartView.maskView.fingerLeaveFlag = YES;
//    chartView.maskView.lineColor = DYAppearanceColor(@"H5", 1);
    [chartView setBackgroundColor:DYAppearanceColor(@"W1", 1.0)];
    _baseAdapter = [DYDataAdapterFactory createDataAdapterByType:fixedCentralLineDataAdapter];
    _baseAdapter.notFixDataWith125Rule = YES;
    _baseAdapter.chartView = chartView;
    _baseAdapter.yPartCount = 2;
}

- (void)setAdapterWithData:(DYMarketForecastChartModel *)orgModel
{
    self.chartModel = orgModel;
    self.chartDataArray = [NSMutableArray arrayWithCapacity:0];
    self.colorArray = [NSMutableArray arrayWithCapacity:0];
    if (orgModel.timeShareModel.pointsArray.count >0) {
        self.baseAdapter.reserveValue = orgModel.timeShareModel.prevClosePrice;
        NSMutableArray *pArray = [[NSMutableArray alloc]init];
        for (NSInteger i=0;i < 241;i++) {
            if (i < orgModel.timeShareModel.pointsArray.count) {
                DYTimeSharePointModel *pModel = orgModel.timeShareModel.pointsArray[i];
                [pArray addObject:pModel];
            }else {
                DYTimeSharePointModel *emptyModel = [[DYTimeSharePointModel alloc]init];
                emptyModel.closePrice = - MAXFLOAT;
                [pArray addObject:emptyModel];
            }
        }
        DYMarketForeShowChartModel *showModel1 = [[DYMarketForeShowChartModel alloc]init];
        showModel1.pointsArray = pArray;
        showModel1.tipModel = nil;
        [self.chartDataArray addObject:showModel1];
        
        [self.colorArray addObject:DYAppearanceColor(@"B1", 1)];
        NSMutableArray *emptyArray = [NSMutableArray arrayWithCapacity:0];
        for (DYTimeSharePointModel *pModel in orgModel.timeShareModel.pointsArray) {
            for (NSInteger k=orgModel.tipModelArr.count-1;k>=0;k--) {
                DYMarketForecastPointModel *tipModel = orgModel.tipModelArr[k];
                if (tipModel.barTime && [tipModel.barTime isEqualToString:pModel.barTime]) {
                    NSMutableArray *lineArray = [NSMutableArray arrayWithCapacity:0];
                    [lineArray addObjectsFromArray:[emptyArray copy]];
                    [lineArray addObject:pModel];
                    DYMarketForeShowChartModel *showModel = [[DYMarketForeShowChartModel alloc]init];
                    showModel.pointsArray = lineArray;
                    showModel.tipModel = tipModel;
                    [self.chartDataArray addObject:showModel];
                    [self.colorArray addObject:DYAppearanceColor(@"R1", 1)];
                    break;
                }
            }
            DYTimeSharePointModel *emptyModel = [[DYTimeSharePointModel alloc]init];
            emptyModel.closePrice = - MAXFLOAT;
            [emptyArray addObject:emptyModel];
        }
        [self.chartView reloadData];
        [self showExtraMaxRetracement];
    }
}

#pragma mark - DYKLineChartViewDataSource functions

- (NSUInteger)sectionCountInKLineChartView:(DYKLineChartView*)chartView
{
    return 1;
}
- (DYDataAdapterBase*)dataAdapterForKLineChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index;
{
    return self.baseAdapter;
}

- (CGRect)frameOfSectionInKLineChartView:(DYKLineChartView*)chartView
                                 atIndex:(NSUInteger)index
{
    return CGRectMake(0, 0, CGRectGetWidth(chartView.frame), CGRectGetHeight(chartView.frame));
}
- (SectionPositionInfo*)sectionPositionInKLineChartView:(DYKLineChartView*)chartView
                                                atIndex:(NSUInteger)index
{
    SectionPositionInfo* info = [SectionPositionInfo new];
    info.xLeft = 10;
    info.xRight = 10;
    info.xHeight = 0;
    info.yTop = 1;
    info.yWidth = 10;
    info.yBottom = -5;
    return info;
}

- (NSUInteger)countOfChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index
{
    return self.chartDataArray.count;
}

- (EDYChartItemViewType)viewTypeInKLineChartView:(DYKLineChartView*)chartView
                                     atIndexPath:(DYIndexPath*)indexPath
{
    if (indexPath.row ==0) {
        return eDYChartTypeArea;
    }
    return eDYChartTypeCurve;
}

- (NSUInteger)countOfDataForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath
{
    DYMarketForeShowChartModel *model = self.chartDataArray[indexPath.row];
    return model.pointsArray.count;
}


- (NSRange)rangeOfValidDataForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                                atIndexPath:(DYIndexPath*)indexPath
{
    DYMarketForeShowChartModel *model = self.chartDataArray[indexPath.row];
    return NSMakeRange(0, model.pointsArray.count);
}

- (id)dataValueForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                    atIndexPath:(DYIndexPath*)indexPath
                                    atDataIndex:(NSUInteger)index
{
    if (indexPath.row < [self.chartDataArray count]) {
        DYMarketForeShowChartModel *model = self.chartDataArray[indexPath.row];
        if (index < model.pointsArray.count) {
            DYTimeSharePointModel *data =  model.pointsArray[index];
            return @(data.closePrice);
        }
    }
    return @(.0f);
}

- (NSString*)xDescriptionForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath
{
    return @"";
}

- (NSString*)yDescriptionForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath
{
    return @"";
}



- (CGFloat)minValueForKLineChartView:(DYKLineChartView* )axisView
{
    return self.baseAdapter.minY;
}

- (CGFloat)maxValueForKLineChartView:(DYKLineChartView* )axisView
{
    return self.baseAdapter.maxY;
}

- (CGFloat)minRangeValueForKLineChartView:(DYKLineChartView* )axisView
{
    CGFloat lowChange = 0;
    if (self.baseAdapter.reserveValue != 0) {
        lowChange = (self.baseAdapter.minY - self.baseAdapter.reserveValue)/self.baseAdapter.reserveValue;
    }
    return lowChange*100;
}

- (CGFloat)maxRangeValueForKLineChartView:(DYKLineChartView* )axisView
{
    CGFloat highChange = 0;
    if (self.baseAdapter.reserveValue != 0) {
        highChange = (self.baseAdapter.maxY - self.baseAdapter.reserveValue)/self.baseAdapter.reserveValue;
    }
    return highChange*100;
}


- (BOOL)drawArcFlagForChartView:(DYKLineChartView *)chartView atIndexPath:(DYIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }else {
        return YES;
    }
}

- (void)oneFingerInChartView:(DYKLineChartView*)chartView
                 atIndexPath:(DYIndexPath*)indexPath
             pressAtPosition:(NSUInteger)position {
    
}

#pragma mark - Reload
- (void)reloadData
{
    [self.chartView reloadData];
}

- (void)showExtraMaxRetracement
{
    for (UIView *view in [self.chartView subviews]) {
        if ([view isKindOfClass:[DYMFTipPopView class]]) {
            [view removeFromSuperview];
        }
    }
 
    NSMutableArray *tsArr = [[NSMutableArray alloc]init];
    
    NSInteger index = 0;
    for (DYMarketForeShowChartModel *model in self.chartDataArray) {
        if (index !=0) {
            BOOL add = YES;
            for (NSNumber *preTs in tsArr) {
                if (llabs([preTs longLongValue] - model.tipModel.timestamp) < 30*60000 ) {
                    add = NO;
                }
            }
            if (add) {
                [tsArr addObject:@(model.tipModel.timestamp)];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                CGPoint point = [self.chartView getDrawPointForChartViewAtIndexPath:indexPath index:model.pointsArray.count-1];
                if (model.tipModel.content.length >0) {
                    CGRect tipSize = [model.tipModel.content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:DYAppearanceFont(@"T15")} context:nil];
                    
                    BOOL imgUp = NO;
                    if (tipSize.size.width > self.chartView.frame.size.width/2) {
                        tipSize.size.width = 100;
                    }
                    CGRect frame = CGRectMake(point.x - tipSize.size.width/2, point.y - 22, tipSize.size.width, 20);
                    if (frame.origin.x < 0) {
                        frame.origin.x = 0;
                    }
                    if (frame.origin.y <= 0) {
                        frame.origin.y = point.y + 5;
                        imgUp = YES;
                    }
                    if (frame.origin.x + frame.size.width > self.chartView.frame.size.width) {
                        frame.origin.x = self.chartView.frame.size.width - frame.size.width;
                    }
                    if (frame.origin.y + frame.size.height > self.chartView.frame.size.height) {
                        frame.origin.y = self.chartView.frame.size.height - frame.size.height;
                    }
                    DYMFTipPopView *popView = [[DYMFTipPopView alloc]init];
                    popView.alpha = 0.8;
                    popView.tag = index;
                    [popView.titleLabel setText:NilToLineString(model.tipModel.content)];
                    [popView addTarget:self action:@selector(popClick:) forControlEvents:UIControlEventTouchUpInside];
                    popView.frame = frame;
                    if (point.x < frame.origin.x+frame.size.width/2) {
                        [popView setArrowLeftMargin:frame.origin.x+frame.size.width/2-point.x arrowUp:imgUp];
                    }else if (point.x > frame.origin.x+frame.size.width/2) {
                        [popView setArrowLeftMargin:point.x arrowUp:imgUp];
                    }else {
                        [popView setArrowLeftMargin:0 arrowUp:imgUp];
                    }
                    [self.chartView addSubview:popView];
                }
                
            }
        }
        index++;
    }
}


- (void)popClick:(UIControl *)control {
    if (self.tipBlock) {
        DYMarketForeShowChartModel *model = self.chartDataArray[control.tag];
        self.tipBlock(model.tipModel);
    }
}

- (void)tipClickBlock:(DataBlock)block {
    self.tipBlock = block;
}
@end
