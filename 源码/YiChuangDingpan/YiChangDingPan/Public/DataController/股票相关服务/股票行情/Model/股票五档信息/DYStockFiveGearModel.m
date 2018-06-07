//
//  DYStockFiveGearModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStockFiveGearModel.h"

@implementation DYStockFiveGearModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"askBook" : [DYStockFiveBookModel class],
             @"bidBook" : [DYStockFiveBookModel class]};
}

@end
