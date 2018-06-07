//
//  DYStareOptionalMonitorSetService.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 自选监控设置页service
#import <Foundation/Foundation.h>
#import "DYStareOptionalMonitorSetModel.h"
#import "DYStareWizardDataSource.h"
#import "DYStareWizardStockInfoModel.h"

#import "DYStockPropertyService.h"

@interface DYStareOptionalMonitorSetService : NSObject
@property (nonatomic, strong) NSArray *modelArray; //列表数据源
@property (nonatomic, strong) NSMutableArray *stockArray; //
+ (instancetype)shareInstance;

// 获取用户监控的个股列表
+ (void)getStareWizardStockListWithSuccess:(void(^)(id data))success
                                      fail:(void(^)(id data))fail;

// 获取用户普通盯盘配置
- (void)getStareWizardGeneralRulesWithSuccess:(void(^)(id data))success
                                         fail:(void(^)(id data))fail;

// 设置用户普通盯盘提醒
+ (void)setStareWizardGeneralRuleWithParam:(DYStareGeneralSwitchSettingModel *)model
                                   success:(void(^)(id data))success
                                      fail:(void(^)(id data))fail;

// 添加用户盯盘股票
+ (void)addStareWizardStockListWithArray:(NSArray<DYStareWizardStockInfoModel *>*)array
                                 success:(void(^)(id data))success
                                    fail:(void(^)(id data))fail;

// 删除用户盯盘股票
+ (void)deleteStareWizardStockListWithArray:(NSArray<DYStareWizardStockInfoModel *>*)array success:(void(^)(id data))success fail:(void(^)(id data))fail;

// 查询消息推送配置
+ (void)getMsgStatusWithSuccess:(void(^)(id data))success
                           fail:(void(^)(id data))fail;

// 消息推送开关设置
+ (void)setMsgStatusWithParam:(NSDictionary *)dict
                      Success:(void(^)(id data))success
                         fail:(void(^)(id data))fail;


 //首次上传用户自选股到高级关注
+ (void)firstTimeAddUserStock;
@end
