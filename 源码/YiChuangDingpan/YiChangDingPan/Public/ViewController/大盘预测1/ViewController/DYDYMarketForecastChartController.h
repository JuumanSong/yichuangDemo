//
//  DYDYMarketForecastChartController.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/4/27.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYViewController.h"
#import "DYMarketForecastChartModel.h"

@interface DYDYMarketForecastChartController :DYViewController

- (void)setChartData:(DYMarketForecastChartModel*)fenshiModel;

- (void)tipClickBlock:(DataBlock)block;

@end
