//
//  DYSystemDataSource.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYBaseDataSource.h"

@interface DYSystemDataSource : DYBaseDataSource

/*
 获取系统时间戳
 param:nil
 */
+(void)getServerTimeInterval:(NSDictionary *)param Success:(DYDSSuccessBlock)success Fail:(DYDSErrorBlock)fail;


@end
