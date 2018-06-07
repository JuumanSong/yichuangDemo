//
//  DYMarketForecastPointModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYMarketForecastPointModel : NSObject

@property (nonatomic,copy) NSString *barTime;
@property (nonatomic,assign) CGFloat value;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) long timestamp;

@end
