//
//  AFNetworkingUtil.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingEnumModel.h"

@interface AFNetworkingUtil : NSObject

//一般请求调用
+(void)requestWithModel:(NetworkingEnumModel *)model Success:(NetSuccessBlock)success Fail:(NetErrorBlock)fail;

@end
