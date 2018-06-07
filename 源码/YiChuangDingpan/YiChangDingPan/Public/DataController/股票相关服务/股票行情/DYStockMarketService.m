//
//  DYStockMarketService.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/17.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStockMarketService.h"
#import "DYStockPropertyService.h"
#import "DYFlowOFStockModel.h"
#import "DYYCDataSourceList.h"

@implementation DYStockMarketService

//返回当前是否交易时间
//周一至周五 8:55~11:35&12:55~15:05
+(BOOL)checkIsMarketTime {
    NSDateComponents *com=[[DYAdjustTimeService shareInstance]getCurrentTimeComponentsOfBeiJing];
    if(com.weekday==1||com.weekday==7){//周六周日
        return NO;
    }
    else{
        NSInteger nowMins = com.hour*60 + com.minute;
        NSInteger mins8_55 = 8*60 + 55;
        NSInteger mins11_35 = 11*60 + 35;
        NSInteger mins12_55 = 12*60 + 55;
        NSInteger mins15_05 = 15*60 + 5;
        if((nowMins>=mins8_55 && nowMins<=mins11_35)||(nowMins>=mins12_55 && nowMins<=mins15_05)){
            return YES;
        }
        else{
            return NO;
        }
    }
}

//获取股票列表行情
+ (void)getStockMarketInfo:(NSArray <DYStockMarketModel*>*)array withSuccess:(void(^)(id data))success fail:(void(^)(id data))fail {
    if (array.count >0) {
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        for (DYStockMarketModel *model in array) {
//            [resultArray addObject:@{@"t":NilToEmptyString(model.ticker),
//                                     @"e":NilToEmptyString(model.exchangeCD),
//                                     @"a":NilToEmptyString(model.secType)
//                                     }];
            [resultArray addObject:NilToEmptyString(model.ticker)
                                ];
        }
        NSString * str =[resultArray componentsJoinedByString:@","];
        [DYYCDataSourceList getStockMarketInfo:@{@"t":str} Success:^(NSInteger code, id data, NSString *message) {
            if (data) {
                NSArray *array =  [NSArray yy_modelArrayWithClass:[DYStockMarketModel class] json:data[@"data"]];
                for (DYStockMarketModel *model in array) {
                    DYStockPropertyItem *item = [DYStockPropertyService getPropertyItemBySecId:model.secId];
                    model.secType = item.secType;
                }
                success(array);
            }else {
                success(nil);
            }
        } Fail:^(NSError *error) {
            if (fail) {
                fail(error);
            }
        }];
    }
}


@end
