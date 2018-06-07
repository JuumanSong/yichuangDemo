//
//  DYMarketForecastChartAdapter.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/4/27.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYMFChartView.h"
#import "DYMarketForecastChartModel.h"

@interface DYMarketForecastChartAdapter : NSObject

@property (nonatomic, strong) DYMFChartView *chartView;
@property (nonatomic, strong) NSMutableArray <UIColor *> *colorArray;
@property (nonatomic, strong) DYMarketForecastChartModel *chartModel;
@property (nonatomic, strong) NSMutableArray *chartDataArray;

#pragma mark - Init
- (instancetype)initWithChartView:(DYMFChartView *)chartView;

- (void)setAdapterWithData:(DYMarketForecastChartModel *)model;

- (void)tipClickBlock:(DataBlock)block;

/**
 刷新图表
 */
- (void)reloadData;

@end
