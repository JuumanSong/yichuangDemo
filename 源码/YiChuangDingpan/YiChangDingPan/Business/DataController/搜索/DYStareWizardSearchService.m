//
//  DYStareWizardSearchService.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardSearchService.h"
//#import "DYStockInterface.h"

@implementation DYStareWizardSearchService

#pragma mark 用户相关
//获取用户股票

+ (NSArray <DYStockPropertyItem*>*)getAllStockMarket{
    NSArray *array= [DYYCInterface shareInstance].delegate.userStockArr;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *tickerId in array) {
        DYStockPropertyItem * item =[DYStockPropertyService getPropertyItemByTicker:tickerId];
        if (item) {
              [tempArray addObject:item];
        }
    }
    return tempArray;
}

#pragma mark 历史记录

+ (NSArray *)getHistoryData {
    NSArray *array = loadFromCacheWithType(CK_StareSearch,JMDataTypeEnumObject);
    return array;
}

+ (void)saveHistoryModel:(DYStockPropertyItem *)model {
    if (!model) {
        return;
    }
    NSMutableArray *array = [[self getHistoryData] mutableCopy];
    if (array) {
        for (NSInteger i =0; i<array.count; i++) {
            DYStockPropertyItem *temp = array[i];
            if (temp.secId.length >0 && [temp.secId isEqualToString:model.secId]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
        [array insertObject:model atIndex:0];
    }else {
        array = [NSMutableArray arrayWithObject:model];
    }
    [self saveHistoryModelList:array];
}

+ (void)saveHistoryModelList:(NSArray<DYStockPropertyItem *>*)list {
    if (list.count >10) {
        list = [list subarrayWithRange:NSMakeRange(0, 9)];
    }
    saveToCacheWithType(CK_StareSearch,list, JMDataTypeEnumObject);
}


+ (void)deleteModel:(DYStockPropertyItem *)model {
    if (!model) {
        return;
    }
    NSMutableArray *array = [[self getHistoryData] mutableCopy];
    if (array) {
        for (NSInteger i =0; i<array.count; i++) {
            DYStockPropertyItem *temp = array[i];
            if (temp.secId.length >0 && [temp.secId isEqualToString:model.secId]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
    }
    [self saveHistoryModelList:array];
}

+ (void)deleteAllHistory {
    [self saveHistoryModelList:nil];
}

@end
