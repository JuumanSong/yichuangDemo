//
//  DYMarketForeShowChartModel.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/5/2.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYMarketForecastPointModel.h"
#import "DYTimeShareModel.h"

@interface DYMarketForeShowChartModel : NSObject

@property (nonatomic, strong) DYMarketForecastPointModel *tipModel;

@property (nonatomic, strong) NSArray<DYTimeSharePointModel*> *pointsArray;
@end
