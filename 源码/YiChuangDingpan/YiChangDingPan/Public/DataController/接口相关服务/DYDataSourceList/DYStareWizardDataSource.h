//
//  DYStareWizardDataSource.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 盯盘精灵相关dataSource
#import "DYBaseDataSource.h"

@interface DYStareWizardDataSource : DYBaseDataSource

/**
 获取用户到价提醒配置
 */
+ (void)getStareWizardPriceRulesWithSuccess:(DYDSSuccessBlock)success
                                       fail:(DYDSErrorBlock)fail;

/**
 设置用户到价提醒

 @param param   id: 配置的唯一ID,（如果是新加提醒, 则不需要该字段）
                e: {t:资产代码, e:交易市场, a:证券类型};
                cp: 提醒涨价值
                cr: 提醒涨价幅度
                fp: 提醒跌价值
                fr: 提醒跌价幅度
 @param success success
 @param fail    fail
 */
+ (void)setStareWizardPriceRuleWithParam:(NSDictionary *)param
                                 success:(DYDSSuccessBlock)success
                                    fail:(DYDSErrorBlock)fail;

/**
 获取用户普通盯盘配置
 */
+ (void)getStareWizardGeneralRulesWithSuccess:(DYDSSuccessBlock)success
                                         fail:(DYDSErrorBlock)fail;

/**
 设置用户普通盯盘提醒

 @param param   ct:规则一级分类，PriceRule(1, "到价提醒"), DailyBS(2, "日内B/S点"),
                                BigDeal(3, "主力大单"), PriceShake(4, "价格异动"),
                                ImportantAnn(5, "重要公告"), SimilarK(6, "相似K线"),
                                AreaUp(7, "板块异动"), PersonalRes(8, "分析师研报"),
                                InstRes(9, "机构调研"), TD(10, "龙虎榜"),
                                TechSignal(11, "技术信号"), MultiDays(12, "盘后多日信号"),
                                IdxUp(14, "指数异动") ；
                sct:规则二级分类，1至6同上，AreaUp(7, "板块拉升")，8至12同上，
                                AreaDown(13, "板块跳水"), IdxUp(14, "指数大涨"),
                                IdxDown(15, "指数大跌") ；
                s:状态, 0: 未启用, 1: 启用
 @param success success
 @param fail    fail
 */
+ (void)setStareWizardGeneralRuleWithParam:(NSDictionary *)param
                                   success:(DYDSSuccessBlock)success
                                      fail:(DYDSErrorBlock)fail;


/**
 获取用户监控的个股列表
 */
+ (void)getStareWizardStockListWithSuccess:(DYDSSuccessBlock)success
                                      fail:(DYDSErrorBlock)fail;

/**
 添加用户盯盘股票

 @param param   [{t:个股Ticker, e:交易市场, a:证券类型, status:1,自选股添加;2,手工添加;3,持仓股}]
 @param success success
 @param fail    fail
 */
+ (void)addStareWizardStockListWithParam:(NSArray *)param
                                 success:(DYDSSuccessBlock)success
                                    fail:(DYDSErrorBlock)fail;

/**
 删除用户盯盘股票

 @param param   [{t:个股Ticker, e:交易市场, a:证券类型, status:1,自选股添加;2,手工添加;3,持仓股}]
 @param success success
 @param fail    fail
 */
+ (void)deleteStareWizardStockListWithParam:(NSArray *)param
                                    success:(DYDSSuccessBlock)success
                                       fail:(DYDSErrorBlock)fail;
///**
// 个股行情AI盯盘
// */
//+ (void)getStareWizardAIDataWithSuccess:(DYDSSuccessBlock)success
//                                        fail:(DYDSErrorBlock)fail;
@end
