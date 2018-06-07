//
//  DYStareGeneralSwitchSettingModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareGeneralSwitchSettingModel.h"

@implementation DYStareGeneralSwitchSettingModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cardType": @"ct",
             @"subCardType": @"sct",
             @"switchFlag": @"s"};
}

@end
