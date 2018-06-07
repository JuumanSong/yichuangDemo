//
//  DYPriceRulesModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesModel.h"

@implementation DYPriceRulesModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rulesId" : @"id",
             @"state" : @"s",
             @"tickerModel" : @"e"};
}

@end


@implementation DYPriceStockModel

@end
