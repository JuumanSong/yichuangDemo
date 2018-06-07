//
//  DYSystemDataSource.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYSystemDataSource.h"

@implementation DYSystemDataSource


/*
 获取系统时间戳
 param:nil
 */

+(void)getServerTimeInterval:(NSDictionary *)param Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail{
    
    DYDataSourceModel *model = [[DYDataSourceModel alloc]init];
    model.logDescription = @"获取系统时间戳";
    model.requestType = dyRequestTypeGet;
    model.requestSerializerType = dyRequestSerializerTypeJson;
    model.responseSerializerType = dyResponseSerializerTypeJson;
    model.urlStr = [NSString stringWithFormat:@"%@%@",YCBaseUrl,@"system/systemTime"];
    model.headerDic = [DYDataSourceService getHttpHeaderWithToken];
    
    [DYBaseDataSource requestWithModel:model Success:^(id data) {
        NSDictionary *dic = data;
        if (DYIsKindOfDictionaryClass(dic) && [dic[@"success"] boolValue]) {
            success(1,NullToNil(dic[@"data"]),nil);
        }
        else{
            fail([[NSError alloc]init]);
        }
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

@end
