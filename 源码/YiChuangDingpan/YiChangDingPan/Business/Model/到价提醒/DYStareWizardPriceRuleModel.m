//
//  DYStareWizardPriceRuleModel.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardPriceRuleModel.h"

@implementation DYStareWizardPriceRuleModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cId": @"id",
             @"state": @"s",
             @"stockInfo": @"e"};
}

@end
