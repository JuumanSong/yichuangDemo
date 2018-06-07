//
//  DYStareWizardDataSource.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardDataSource.h"

@implementation DYStareWizardDataSource

+ (void)handleResultToDictData:(id)data Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail{
    NSDictionary *dic = data;
    if(DYIsKindOfDictionaryClass(dic) && [dic[@"success"] boolValue]){
        success(1,NilToEmptyDictionary(dic[@"data"]),nil);
    }else{
        fail([[NSError alloc]init]);
    }
}

+ (void)handleResultToArrayData:(id)data Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail{
    NSDictionary *dic = data;
    if(DYIsKindOfDictionaryClass(dic) && [dic[@"success"] boolValue]){
        success(1,NilToEmptyArray(dic[@"data"]),nil);
    }else{
        fail([[NSError alloc]init]);
    }
}

// 获取用户到价提醒配置
+ (void)getStareWizardPriceRulesWithSuccess:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取用户到价提醒配置";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getPriceRules"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    WS(weakSelf);
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        [weakSelf handleResultToArrayData:data Success:success Fail:fail];
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

// 设置用户到价提醒
+ (void)setStareWizardPriceRuleWithParam:(NSDictionary *)param success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"设置用户到价提醒";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/setPriceRule"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        NSDictionary *dict = NilToEmptyDictionary(data);
        success(1, NullToNil(dict[@"success"]), nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

// 获取用户普通盯盘配置
+ (void)getStareWizardGeneralRulesWithSuccess:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取用户普通盯盘配置";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getGeneralRules"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    WS(weakSelf);
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        [weakSelf handleResultToArrayData:data Success:success Fail:fail];
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

// 设置用户普通盯盘提醒
+ (void)setStareWizardGeneralRuleWithParam:(NSDictionary *)param success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"设置用户普通盯盘提醒";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/setGeneralRule"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        NSDictionary *dict = NilToEmptyDictionary(data);
        success(1, NullToNil(dict[@"success"]), nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}


// 获取用户监控的个股列表
+ (void)getStareWizardStockListWithSuccess:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取用户监控的个股列表";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getStaringAssets"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    WS(weakSelf);
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        [weakSelf handleResultToArrayData:data Success:success Fail:fail];
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

// 添加用户盯盘股票
+ (void)addStareWizardStockListWithParam:(NSArray *)param success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"添加用户盯盘股票";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/setStaringAssets"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        NSDictionary *dict = NilToEmptyDictionary(data);
        success(1, NullToNil(dict[@"success"]), nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

// 删除用户盯盘股票
+ (void)deleteStareWizardStockListWithParam:(NSArray *)param success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"删除用户盯盘股票";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/unStaringAssets"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        NSDictionary *dict = NilToEmptyDictionary(data);
        success(1, NullToNil(dict[@"success"]), nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

@end
