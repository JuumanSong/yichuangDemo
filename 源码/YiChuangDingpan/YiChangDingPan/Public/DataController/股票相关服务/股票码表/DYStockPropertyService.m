//
//  DYStockPropertyService.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/10/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYStockPropertyService.h"
#import "DYSystemDataSource.h"
#import "SEDatabase.h"
#import "NSString+StringFormat.h"
#import "DYYCDataSourceList.h"
#define kJustNumberRegex                @"^[0-9]+$"         // 纯数字
#define kJustCharRegex                  @"^[A-Za-z]+$"      // 纯字母


@implementation DYStockPropertyService


+ (void)getNewsestStocksProperty {
  
    [DYYCDataSourceList getEquIndustriesWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
        NilToEmptyDictionary(data);
        if (data) {
            NSDictionary *dic = data;
            BOOL successFlag = [dic[@"success"] boolValue];
            if (successFlag) {
                [DYStockPropertyService insertOrReplaceStocks:NilToEmptyArray(dic[@"data"])];
            }
        }
    } fail:^(NSError *error) {
        
    }];

}

/**
 *    @brief    插入或替换原来的股票条目
 {
 "t": "000001", #个股代码
 "e": "XSHE", #个股市场
 "sn": "万科A", #中文名
 "c": "WKA", #拼音
 "f": "W", #拼音首字母
 "ii": "01030321", #行业一级分类ID
 "in": "银行" #行业一级分类名
 }
 */
+ (void)insertOrReplaceStocks:(NSArray*)stocksArray {
    if (stocksArray.count <= 0) {
        return;
    }
    [[SEDatabase sharedDatabase] inDeferredTransaction:^(BOOL *rollback) {
        NSString *sql;
        for (NSDictionary *info in stocksArray) {
            
            NSString *ticker = info[@"t"];
            NSString *market = info[@"e"];
            if (ticker && market) {
                NSString *secId = [NSString stringWithFormat:@"%@.%@",ticker,market];
                
                sql = [NSString stringWithFormat:@"insert or replace into dyyc_stockproperty "
                       "(secId, tradeCode, secName, pinyin, tradeMarket, pyInital, classifyId, classifyName) "
                       "values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                       NilToEmptyString(secId),
                       NilToEmptyString(ticker),
                       NilToEmptyString(info[@"sn"]),
                       NilToEmptyString(info[@"c"]),
                       NilToEmptyString(market),
                       NilToEmptyString(info[@"f"]),
                       NilToEmptyString(info[@"ii"]),
                       NilToEmptyString(info[@"in"])];
                [[SEDatabase sharedDatabase] updateWithQuery:sql error:nil];
            }
           
        }
    }];
}

/**
 根据股票code获取item
 
 @param secId  600063.XSHG
 @return 名称
 */
+ (DYStockPropertyItem *)getPropertyItemBySecId:(NSString *)secId {
    NSString* sqlStr = [NSString stringWithFormat:@"select * from dyyc_stockproperty where secId='%@'",
                        secId];
    NSArray *array = [[SEDatabase sharedDatabase] fetchWithQuery:sqlStr
                                                        regClass:[DYStockPropertyItem class]];
    if (array.count > 0) {
        DYStockPropertyItem *item = array[0];
        return item;
    }
    return nil;
}


/**
 根据股票ticker获取item
 
 @param ticker  600001
 @return 名称
 */
+ (DYStockPropertyItem *)getPropertyItemByTicker:(NSString *)ticker {
    NSString* sqlStr = [NSString stringWithFormat:@"select * from dyyc_stockproperty where tradeCode='%@'",
                        ticker];
    NSArray *array = [[SEDatabase sharedDatabase] fetchWithQuery:sqlStr
                                                        regClass:[DYStockPropertyItem class]];
    if (array.count > 0) {
        DYStockPropertyItem *item = array[0];
        return item;
    }
    return nil;
}



+ (void)findSortedStocksByKeyword:(NSString*)keyword WithPriority:(NSInteger)priority WithArray:(NSArray *)resultArray withResultBlock:(DataBlock)resultBlock {
    NSAssert([keyword length] > 0, @"搜索时关键字为空");
    
    if ([[SEDatabase sharedDatabase] isQueryExcutingWithTag:SearchStockPropertyInfo])
    {
        [[SEDatabase sharedDatabase] cancelQueryWithTag:SearchStockPropertyInfo];
    }
    
    // 搜索的表
    NSMutableString *sqlStr = @"select * from dyyc_stockproperty where secType='E' ".mutableCopy;
    
    // 搜索的条件
    if ([keyword match:kJustNumberRegex]) {
        //数字优先右匹配
        switch (priority) {
            case 0:
                [sqlStr appendFormat:@"and tradeCode like '%%%@' ", keyword];
                break;
            case 1:
                [sqlStr appendFormat:@"and tradeCode like '%@%%' ", keyword];
                break;
                
            case 2:
                [sqlStr appendFormat:@"and tradeCode like '%%%@%%' ", keyword];
                break;
            default:
                break;
        }
        
    }
    else if ([keyword match:kJustCharRegex])
    {
        //字符串优先左匹配
        switch (priority) {
            case 0://左侧匹配
                [sqlStr appendFormat:@"and pinyin like '%@%%' ", keyword];
                break;
                
            case 1://右侧匹配
                [sqlStr appendFormat:@"and pinyin like '%%%@' ", keyword];
                break;
                
            case 2://中间匹配
                [sqlStr appendFormat:@"and pinyin like '%%%@%%' ", keyword];
                break;
            default:
                break;
        }
    }
    else
    {
        //汉字优先左匹配
        switch (priority) {
            case 0://左侧匹配
                [sqlStr appendFormat:@"and secName like '%@%%' ", keyword];
                break;
            case 1://右侧匹配
                [sqlStr appendFormat:@"and secName like '%%%@' ", keyword];
                break;
                
            case 2://中间匹配
                [sqlStr appendFormat:@"and secName like '%%%@%%' ", keyword];
                break;
            default:
                break;
        }
    }
    
    // 搜索结果排序
    [sqlStr appendString:@"order by pinyin asc, tradeCode asc"];
    
    // 执行搜索
    WS(weakSelf);
    [[SEDatabase sharedDatabase] fetchAsyncWithQuery:sqlStr
                                            regClass:[DYStockPropertyItem class]
                                   completionHandler:^(NSArray *data) {
                                       NSMutableArray *array = [[NSMutableArray alloc] init];
                                       if ([resultArray count] > 0) {
                                           array = [resultArray mutableCopy];
                                       }
                                       if ([data count] > 0) {
                                           //去重复选项
                                           if ([resultArray count] > 0) {
                                               for (DYStockPropertyItem *dataItem in data) {
                                                   for (DYStockPropertyItem *resultItem in resultArray) {
                                                       if ([resultItem.tradeCode isEqualToString:dataItem.tradeCode]) {
                                                           break;
                                                       }else if ([resultItem isEqual:[resultArray lastObject]]){
                                                           [array insertObject:dataItem atIndex:[array count]];
                                                       }
                                                   }
                                               }
                                           }else{
                                               [array addObjectsFromArray:data];
                                           }
                                       }
                                       if ([array count] > 30) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               resultBlock(array);
                                           });
                                       }else{
                                           if (priority >= 2) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   resultBlock(array);
                                               });
                                           }else{
                                               [weakSelf findSortedStocksByKeyword:keyword WithPriority:priority+1  WithArray:array withResultBlock:resultBlock];
                                           }
                                       }
                                   }];
}



@end
