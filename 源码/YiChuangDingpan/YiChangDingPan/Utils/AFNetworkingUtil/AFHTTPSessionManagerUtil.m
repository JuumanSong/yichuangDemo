//
//  AFHTTPSessionManagerUtil.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "AFHTTPSessionManagerUtil.h"
#import  <AFNetworking/AFNetworking.h>
#import "NetworkingEnumModel.h"

#define minTimeOutInterval 5     // 最小请求超时的时间
#define defultTimeOutInterval 30 // 默认请求超时的时间

@implementation AFHTTPSessionManagerUtil

//创建默认请求manage
+(AFHTTPSessionManager *)defultManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = defultTimeOutInterval;
    
    //声明上传的是json格式的参数
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    return manager;
}


//根据model创建请求manage
+(AFHTTPSessionManager *)managerWithModel:(NetworkingEnumModel *)model{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 超时时间
    if(model.timeOutInterval<minTimeOutInterval){//小于1秒则默认
        manager.requestSerializer.timeoutInterval = defultTimeOutInterval;
    }
    else{
        manager.requestSerializer.timeoutInterval = model.timeOutInterval;
    }
    
    // 声明上传的参数格式
    switch (model.requestSerializerType) {
        case afRequestSerializerTypeJson:// 上传JSON格式
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
            
        default:// 上传普通格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
    }
    
    //head参数
    if(model.headerDic){
        for (NSString *key in [model.headerDic allKeys]) {
            [manager.requestSerializer setValue:model.headerDic[key] forHTTPHeaderField:key];
        }
    }
    
    // 声明获取到的数据格式
    switch (model.responseSerializerType) {
        case afResponseSerializerTypeJson://JSON
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
           
        case afResponseSerializerTypeXml://XML
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
            
        default://DATA
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
    }
    
    return manager;
}

@end
