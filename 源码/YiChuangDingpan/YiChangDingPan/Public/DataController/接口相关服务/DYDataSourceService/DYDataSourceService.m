//
//  DYDataSourceService.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/10/10.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYDataSourceService.h"
#import "DYBaseDataSource.h"
//#import "DYYCInterface.h"

@implementation DYDataSourceService

+(NSDictionary *)getHttpHeaderWithToken{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *deviceId = [[DYYCInterface shareInstance].delegate deviceId];
    if(deviceId && deviceId.length>0){
        [dic setObject:deviceId forKey:@"DatayesPrincipalName"];
    }
    NSString *userCert = [[DYYCInterface shareInstance].delegate token];
    if(userCert && userCert.length>0){
        [dic setObject:userCert forKey:@"userCert"];
    }
    NSString *opUser = [[DYYCInterface shareInstance].delegate userId];
    if(opUser && opUser.length>0){
        [dic setObject:opUser forKey:@"opUser"];
    }
    return dic;
}

//可能token会过期的请求,发现过期了要重拉token再刷
/*block代码逻辑
     判断：用户token存在，返回结果-403"Need login"，请求头里包含token
         true： 判断：请求头token和当前token是否一致来
                    true：将请求塞到缓冲区，刷新token后，重新执行请求
                    false：更新请求token后直接重新发起
         false: 直接返回结果
 */
+(DYDSHandleBlock)getDefultHandleBlock{
    DYDSHandleBlock handleBlock = ^(id request ,id data , NSError *error) {
//        if(data && !error){
//
//            BOOL ifNeedRefreshToken = [DYDataSourceService checkIfNeedLoginWith:data];//是否需要刷新token
//            NSDictionary *dic = request;
//            DYDataSourceModel *dModel = dic[@"m"];
//            NSString *requestASToken = dModel.headerDic[@"Authorization"];
//            ifNeedRefreshToken = ifNeedRefreshToken && requestASToken;
//
//            if(ifNeedRefreshToken){
//
//                NSString *rfToken = [DYLoginService sharedInstance].tokenModel.refresh_token;
//                NSString *asToken = [DYLoginService sharedInstance].tokenModel.access_token;
//                if([requestASToken isEqualToString:[NSString stringWithFormat:@"Bearer %@",asToken]]){//如果请求的token和当前的一样
//                    [[DYLoginService sharedInstance].requestBuffer addObject:request];
//                    if(rfToken && rfToken.length>0){
//                        //刷新token
//                        [[DYLoginService sharedInstance] loginWithRefreshToken:rfToken success:^(id data) {} fail:^(id data) {}];
//                    }
//                }
//                else{//如果不一样，更新下token,直接重新发一遍
//                    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:dModel.headerDic];
//                    [mdic setObject:[NSString stringWithFormat:@"Bearer %@",asToken] forKey:@"Authorization"];
//                    dModel.headerDic = mdic;
//                    NetSuccessBlock success = dic[@"s"];
//                    NetErrorBlock fail = dic[@"f"];
//                    [DYBaseDataSource requestWithModel:dModel Success:success Fail:fail];
//                }
//                return (id)nil;
//            }
//            else{
//                return data;
//            }
//        }
//        else{
            return (id)nil;
//        }
    };
    return handleBlock;
}


+ (BOOL)checkIfNeedLoginWith:(id)data
{
//    NSDictionary *tmp = data;
//    BOOL check = [data isKindOfClass:[NSDictionary class]];
//
//    @try {
//        if([data isKindOfClass:[NSData class]]){
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            if(dic){
//                check = YES;
//                tmp = dic;
//            }
//        }
//    }
//    @catch (NSException *exception){
//
//    }
//
//    if (check && HasLogin) {
//        if ([tmp[@"errorcode"] intValue] == -403 || [tmp[@"code"] intValue] == -403) {
//
//            NSString* message = tmp[@"message"];
//            /*
//             需要刷新token的返回值：
//             {
//             code = "-403";
//             data = "<null>";
//             message = "Need login";
//             }
//             需要提醒用户没有权限的返回值：
//             {
//             code = "-403";
//             data = "<null>";
//             message = "Need privilege";
//             }
//             */
//            if (message != nil && [message isKindOfClass:[NSString class]] && [message isEqualToString:@"Need login"]) {
//                return YES;
//            }
//        }
//    }
    return NO;
}

@end
