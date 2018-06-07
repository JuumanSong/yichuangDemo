//
//  DYYCDataSourceList.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCDataSourceList.h"

@implementation DYYCDataSourceList
+(void)saveSettingWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"保存个人配置";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/saveSetting"];
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
+(void)getSettingWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取个人配置";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getSetting"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getNewMsgsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取最新个股异动消息";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getNewMsgs"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];

//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getSWIndustriesWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取行业分类列表";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getSWIndustries"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getEquIndustriesWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取个股对应行业分类列表";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getEquIndustries"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.param = param;
//    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
//    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)unStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"删除用户盯盘股票";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/unStaringAssets"];
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
+(void)setStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"添加用户盯盘股票";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/setStaringAssets"];
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
+(void)getStaringAssetsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取用户盯盘个股列表";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getStaringAssets"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    model.dsHandleBlock = [DYDataSourceService getDefultHandleBlock];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getNewAreaMsgsWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取最新板块异动消息";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getNewAreaMsgs"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getIdxMktPriceGraphWithParam:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取板块分时图";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/idxMktPriceGraph"];
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
        
    } Fail:^(NSError *error) {
        fail(error);
    }];
}
/**
 获取指定标的的指定行情信息
 t        资产代码
 */
+ (void)getStockMarketInfo:(NSDictionary *)param
                   Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail {
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取指定标的的指定行情信息";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.param = param;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getRTSnapshot"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
         success(1, data, nil);
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

/**
 查询消息推送配置
 */
+ (void)getMsgStatusParams:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"查询消息推送配置";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/getMsgStatus"];
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

/**
 配置消息推送
 */
+ (void)setMsgStatusParams:(NSDictionary *)param Success:(DYDSSuccessBlock)success fail:(DYDSErrorBlock)fail {
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"配置消息推送";
    model.requestType = dyRequestTypePost;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.param = param;
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"staring/setMsgStatus"];
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        success(1, data, nil);
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

@end
