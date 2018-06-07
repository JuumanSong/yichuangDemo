//
//  DYBaseDataSource.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYBaseDataSource.h"
#import "NetworkingEnumModel.h"
//#import "Result.pb.h"


@implementation DYBaseDataSource

+(void)requestWithModel:(DYDataSourceModel *)dModel Success:(NetSuccessBlock)success Fail:(NetErrorBlock)fail{
    //请求
    NetworkingEnumModel *nModel = [self transformModel:dModel];
    
    NSLog(@"\nRequest:【%@】%@\nURL:%@\nHeader:%@\nParam:%@\n",@[@"GET",@"POST",@"PUT",@"DELETE"][nModel.requestType],dModel.logDescription,nModel.urlStr,nModel.headerDic,nModel.param);
    
    [AFNetworkingUtil requestWithModel:nModel Success:^(id data) {
        if(dModel.dsHandleBlock){
            NSDictionary *dic = @{@"m":dModel,@"s":success,@"f":fail};
            data = dModel.dsHandleBlock(dic,data,nil);
            if(data){
                success(data);
            }
            else{
                //被dsHandleBlock处理了，不需要再返回回去
            }
        }
        else{
            success(data);
        }
    } Fail:^(NSError *error) {
        fail(error);
    }];
}

//转换成网络层需要的数据
+(NetworkingEnumModel *)transformModel:(DYDataSourceModel *)dataSourceModel{
    NetworkingEnumModel *model = [[NetworkingEnumModel alloc]init];
    
    NSMutableDictionary *headDic = [[NSMutableDictionary alloc]initWithDictionary:dataSourceModel.headerDic];
    
    switch (dataSourceModel.requestType) {//请求方式
        case dyRequestTypePost:{
            model.requestType = afRequestTypePost;
        }
            break;
        case dyRequestTypeGet:{
            model.requestType = afRequestTypeGet;
        }
            break;
        case dyRequestTypePut:{
            model.requestType = afRequestTypePut;
        }
            break;
        case dyRequestTypeDelete:{
            model.requestType = afRequestTypeDelete;
        }
            break;
        default:{//默认get
            model.requestType = afRequestTypeGet;
        }
            break;
    }
    
    switch (dataSourceModel.requestSerializerType) {//请求数据类型
        case dyRequestSerializerTypeData:{
            model.requestSerializerType = afRequestSerializerTypeData;
        }
            break;
        case dyRequestSerializerTypeJson:{
            model.requestSerializerType = afRequestSerializerTypeJson;
        }
            break;
        default:{//默认Json
            model.requestSerializerType = afRequestSerializerTypeJson;
        }
            break;
    }
    
    switch (dataSourceModel.responseSerializerType) {//返回数据类型
        case dyResponseSerializerTypeData:{
            model.responseSerializerType = afResponseSerializerTypeData;
        }
            break;
        case dyResponseSerializerTypeJson:{
            model.responseSerializerType = afResponseSerializerTypeJson;
            [headDic setObject:@"application/json" forKey:@"Accept"];
        }
            break;
        case dyResponseSerializerTypeXml:{
            model.responseSerializerType = afResponseSerializerTypeXml;
        }
        case dyResponseSerializerTypeGPB:{
            model.responseSerializerType = afResponseSerializerTypeData;
            [headDic setObject:@"application/x-protobuf" forKey:@"Accept"];
        }
            break;
        default:{//默认Data
            model.responseSerializerType = afResponseSerializerTypeData;
        }
            break;
    }
    
    model.urlStr = dataSourceModel.urlStr;
    
    //设备信息
    if(!headDic[@"userAgent"]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:headDic];
        #if TARGET_OS_IOS
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
        [dic setObject:userAgent forKey:@"User-Agent"];
        #endif
        headDic = dic;
    }
    
    //语言设置
    if(!headDic[@"Accept-Language"]){
        [headDic setObject:@"zh-Hans-CN;q=1" forKey:@"Accept-Language"];
    }
    
    model.headerDic = headDic;
    model.param = dataSourceModel.param;
    model.timeOutInterval = dataSourceModel.timeOutInterval;
    
    return model;
}

@end
