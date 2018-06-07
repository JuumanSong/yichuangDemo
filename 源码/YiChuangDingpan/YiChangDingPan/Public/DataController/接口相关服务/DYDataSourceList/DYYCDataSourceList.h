//
//  DYYCDataSourceList.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBaseDataSource.h"

@interface DYYCDataSourceList : DYBaseDataSource
/**
保存个人配置
 */
+ (void)saveSettingWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取个人配置
 */
+ (void)getSettingWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取最新个股异动消息
 */
+ (void)getNewMsgsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取行业分类列表--需要存本地
 */
+ (void)getSWIndustriesWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取个股对应行业列表--需要存本地
 */
+ (void)getEquIndustriesWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 删除用户盯盘股票
 */
+ (void)unStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 添加用户盯盘股票（特别关注）
 */
+ (void)setStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取用户盯盘个股列表（特别关注）
 */
+ (void)getStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取最新板块异动消息
 */
+ (void)getNewAreaMsgsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 获取板块分时图
 */
+ (void)getIdxMktPriceGraphWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
/**
 到价提醒最新价格
 */
+ (void)getStockMarketInfo:(NSDictionary *)param
                   Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail;

/**
 查询消息推送配置--特别关注
 */
+ (void)getMsgStatusParams:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;

/**
 配置消息推送
 */
+ (void)setMsgStatusParams:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail;
@end
