//
//  DYBaseDataSource.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkingUtil.h"
#import "DYDataSourceModel.h"
//#import "DYLoginService.h"
//#import "DYBaseUrlService.h"
#import "DYDataSourceService.h"


typedef void (^DYInterfaceResultBlock)(id data, NSError *error);

typedef void (^DYDSSuccessBlock)(NSInteger code,id data,NSString *message); // 访问成功block
typedef void (^DYDSErrorBlock)(NSError *error); // 访问失败block



@interface DYBaseDataSource : NSObject

+(void)requestWithModel:(DYDataSourceModel *)dModel Success:(NetSuccessBlock)success Fail:(NetErrorBlock)fail;

@end
