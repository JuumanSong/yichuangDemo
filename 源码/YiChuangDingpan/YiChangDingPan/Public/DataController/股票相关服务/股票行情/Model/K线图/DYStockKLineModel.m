//
//  DYStockKLineModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/22.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStockKLineModel.h"

@implementation DYStockKLineModel

+ (instancetype)initWithDic:(NSDictionary *)dic {
    DYStockKLineModel *model = [DYStockKLineModel yy_modelWithJSON:dic];
    if ([dic[@"macd"] isKindOfClass:[NSNull class]]) {
        model.noMACD = YES;
    }
    return model;
}

@end
