//
//  NetworkingEnumModel.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//  请求数据类型

#import <Foundation/Foundation.h>

typedef void (^NetSuccessBlock)(id data); // 访问成功block
typedef void (^NetErrorBlock)(NSError *error); // 访问失败block

//请求类型
typedef NS_ENUM(NSInteger, AFRequestType) {
    afRequestTypeUnkown = 0,                        // 0 未知类型
    afRequestTypeGet = afRequestTypeUnkown,         // 0 GET方式
    afRequestTypePost,                              // 1 POST方式
    afRequestTypePut,                               // 2 PUT方式
    afRequestTypeDelete,                            // 3 DELETE方式
};

//请求数据类型
typedef NS_ENUM(NSInteger, AFRequestSerializerType) {
    afRequestSerializerTypeUnkown = 0,                                  // 未知格式
    afRequestSerializerTypeData = afRequestSerializerTypeUnkown,        // Data格式
    afRequestSerializerTypeJson,                                        // JSON格式
};

//返回数据类型
typedef NS_ENUM(NSInteger, AFResponseSerializerType) {
    afResponseSerializerTypeUnkown = 0,                             // 未知格式
    afResponseSerializerTypeData = afResponseSerializerTypeUnkown,  // Data格式
    afResponseSerializerTypeJson ,                                  // JSON格式
    afResponseSerializerTypeXml,                                    // XML格式
};

@interface NetworkingEnumModel : NSObject

@property(nonatomic,assign)AFRequestType requestType;//请求方式
@property(nonatomic,assign)AFRequestSerializerType requestSerializerType;//请求数据类型
@property(nonatomic,assign)AFResponseSerializerType responseSerializerType;//返回数据类型
@property(nonatomic,strong)NSString *urlStr;//请求url
@property(nonatomic,strong)NSDictionary *headerDic;//请求头
@property(nonatomic,strong)id param;//请求参数
@property(nonatomic,assign)NSTimeInterval timeOutInterval;//超时时间

@end
