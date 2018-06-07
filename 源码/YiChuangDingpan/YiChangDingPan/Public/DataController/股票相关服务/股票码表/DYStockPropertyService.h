//
//  DYStockPropertyService.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/10/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYStockPropertyItem.h"

/**
 自选股-码表管理类
 */
@interface DYStockPropertyService : NSObject

/**
 app启动增量获取码表
 */
+ (void)getNewsestStocksProperty;


/**
 *    @brief    按优先级查询股票
 *
 *    @param     keyword     查询关键字
 *    @param     priority     优先级
 *    @param     resultBlock     resultBlock description
 */
+ (void)findSortedStocksByKeyword:(NSString*)keyword WithPriority:(NSInteger)priority WithArray:(NSArray *)resultArray withResultBlock:(DataBlock)resultBlock;


/**
 根据股票secId获取item
 
 @param secId  600063.XSHG
 @return 名称
 */
+ (DYStockPropertyItem *)getPropertyItemBySecId:(NSString *)secId;

/**
 根据股票ticker(沪深股票)获取item
 
 @param ticker  600063
 @return 名称
 */
+ (DYStockPropertyItem *)getPropertyItemByTicker:(NSString *)ticker;



@end
