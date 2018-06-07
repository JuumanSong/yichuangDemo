//
//  DYTimeShareModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTimeShareModel.h"

@implementation DYTimeSharePointModel

@end

@implementation DYTimeSharePriceModel

@end


@implementation DYTimeShareModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pointsArray" : [DYTimeSharePointModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dataDate" : @"price.dataDate",
             @"highPrice" : @"price.highPrice",
             @"lowPrice" : @"price.lowPrice",
             @"prevClosePrice" : @"price.prevClosePrice",
             @"pointsArray" : @"points"};
}

@end

