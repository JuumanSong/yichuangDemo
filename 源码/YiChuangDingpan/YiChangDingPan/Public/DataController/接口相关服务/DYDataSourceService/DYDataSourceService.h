//
//  DYDataSourceService.h
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/10/10.
//  Copyright © 2017年 datayes. All rights reserved.
//  为datasource提供公共服务，会调用其他公共服务的方法

#import <Foundation/Foundation.h>
#import "DYDataSourceModel.h"
//#import "Result.pb.h"
//#import "PopWebMail.pb.h"
//#import "Webmail.pb.h"


@interface DYDataSourceService : NSObject

//登录header
+(NSDictionary *)getHttpHeaderWithToken;

//可能token会过期的请求，发现过期了要重拉token再刷
+(DYDSHandleBlock)getDefultHandleBlock;


@end
