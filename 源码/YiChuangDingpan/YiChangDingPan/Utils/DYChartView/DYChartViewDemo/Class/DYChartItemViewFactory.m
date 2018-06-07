//
//  DYChartItemViewFactory.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/9.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYChartItemViewFactory.h"
#import "DYChartCurveView.h"
#import "DYChartBarView.h"
#import "DYChartGroupBarView.h"
#import "DYChartCandleView.h"

@implementation DYChartItemViewFactory

+ (DYChartItemView*)createChartItemViewByType:(EDYChartItemViewType)chartType inFrame:(CGRect)rect
{
    if (chartType == eDYChartTypeCurve) {
        DYChartCurveView* curveView = [[DYChartCurveView alloc] initWithFrame:rect];
        curveView.fillFlag = NO;
        return curveView;
    }
    else if (chartType == eDYChartTypeArea) {
        DYChartCurveView* curveView = [[DYChartCurveView alloc] initWithFrame:rect];
        curveView.fillFlag = YES;
        return curveView;
    }
    else if (chartType == eDYChartTypeBar) {
        DYChartBarView* barView = [[DYChartBarView alloc] initWithFrame:rect];
        return barView;
    }
    else if (chartType == eDYChartTypeGroupBar) {
        DYChartGroupBarView* barView = [[DYChartGroupBarView alloc] initWithFrame:rect];
        return barView;
    }
    else if (chartType == eDYChartTypeCandle) {
        DYChartCandleView* candleView = [[DYChartCandleView alloc] initWithFrame:rect];
        return candleView;
    }
    
    return nil;
}

@end
