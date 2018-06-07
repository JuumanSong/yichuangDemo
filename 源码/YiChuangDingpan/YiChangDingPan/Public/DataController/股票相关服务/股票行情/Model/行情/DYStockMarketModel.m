//
//  DYStockMarketModel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/7.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStockMarketModel.h"

@implementation DYStockMarketModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"lastPrice":@"p",@"ticker":@"t",@"changePct":@"c"};
}

-(NSString *)secId {
    return [NSString stringWithFormat:@"%@.%@",self.ticker,self.exchangeCD];
}

@end
