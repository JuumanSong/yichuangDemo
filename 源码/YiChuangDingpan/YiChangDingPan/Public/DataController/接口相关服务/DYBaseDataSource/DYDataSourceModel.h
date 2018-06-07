//
//  DYDataSourceModel.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DYDSSuccessBlock)(NSInteger code,id data,NSString *message); // 访问成功block
typedef void (^DYDSErrorBlock)(NSError *error); // 访问失败block

//请求类型
typedef NS_ENUM(NSInteger, DYRequestType) {
    dyRequestTypeUnkown = 0,                        // 0 未知类型
    dyRequestTypeGet = dyRequestTypeUnkown,         // 0 GET方式
    dyRequestTypePost,                              // 1 POST方式
    dyRequestTypePut,                               // 2 PUT方式
    dyRequestTypeDelete,                            // 3 DELETE方式
};

//请求数据类型
typedef NS_ENUM(NSInteger, DYRequestSerializerType) {
    dyRequestSerializerTypeUnkown = 0,                                  // 未知格式
    dyRequestSerializerTypeData = dyRequestSerializerTypeUnkown,        // Data格式
    dyRequestSerializerTypeJson,                                        // JSON格式
};

//返回数据类型
typedef NS_ENUM(NSInteger, DYResponseSerializerType) {
    dyResponseSerializerTypeUnkown = 0,                             // 未知格式
    dyResponseSerializerTypeData = dyResponseSerializerTypeUnkown,  // Data格式
    dyResponseSerializerTypeJson ,                                  // JSON格式
    dyResponseSerializerTypeXml,                                    // XML格式
    dyResponseSerializerTypeGPB,                                    // Protobuffer格式
};

//数据执行完成
typedef id (^DYDSHandleBlock)(id request ,id data , NSError *error);//请求相关，成功，失败


@interface DYDataSourceModel : NSObject

@property(nonatomic,assign)DYRequestType requestType;//请求方式
@property(nonatomic,assign)DYRequestSerializerType requestSerializerType;//请求数据类型
@property(nonatomic,assign)DYResponseSerializerType responseSerializerType;//返回数据类型
@property(nonatomic,strong)NSString *urlStr;//请求url
@property(nonatomic,strong)NSDictionary *headerDic;//请求头
@property(nonatomic,strong)id param;//请求参数
@property(nonatomic,assign)NSTimeInterval timeOutInterval;//超时时间

@property(nonatomic,assign)NSString *logDescription;//描述，log日志用
@property(nonatomic,strong)DYDSHandleBlock dsHandleBlock;//请求完后可能会需要一些特殊处理

@end
