//
//  DYMarketForecastChartModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYMarketForecastPointModel.h"
#import "DYTimeShareModel.h"
/**
 大盘预测画图model
 */
@interface DYMarketForecastChartModel : NSObject
//分时数据
@property (nonatomic, strong) DYTimeShareModel *timeShareModel;

@property (nonatomic, strong) NSArray<DYMarketForecastPointModel*> *tipModelArr;

@end
