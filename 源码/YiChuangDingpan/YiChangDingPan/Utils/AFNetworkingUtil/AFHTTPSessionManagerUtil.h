//
//  AFHTTPSessionManagerUtil.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@class NetworkingEnumModel;

@interface AFHTTPSessionManagerUtil : NSObject

//创建默认请求manage
+(AFHTTPSessionManager *)defultManager;

//根据model创建请求manage
+(AFHTTPSessionManager *)managerWithModel:(NetworkingEnumModel *)model;

@end
