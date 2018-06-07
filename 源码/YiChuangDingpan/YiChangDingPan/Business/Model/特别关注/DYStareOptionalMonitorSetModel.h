//
//  DYStareOptionalMonitorSetModel.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 自选监控model
#import <Foundation/Foundation.h>
#import "DYStareGeneralSwitchSettingModel.h"

@interface DYStareOptionalMonitorSetModel : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) NSArray *dataArray;

@end
