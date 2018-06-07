//
//  AFNetworkingUtil.m
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/7.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "AFNetworkingUtil.h"
#import  <AFNetworking/AFNetworking.h>
#import "NetworkingEnumModel.h"
#import "AFHTTPSessionManagerUtil.h"

@implementation AFNetworkingUtil


//一般请求调用
+(void)requestWithModel:(NetworkingEnumModel *)model Success:(NetSuccessBlock)success Fail:(NetErrorBlock)fail{
    //创建请求manage
    AFHTTPSessionManager *manager = [AFHTTPSessionManagerUtil managerWithModel:model];
    
    [self requestWithManager:manager Model:model Success:^(id data) {
        success(data);
    } Fail:^(NSError *error) {
        fail(error);
    }];
}


//manage根据请求方式请求
+(void)requestWithManager:(AFHTTPSessionManager *)manager Model:(NetworkingEnumModel *)model Success:(NetSuccessBlock)success Fail:(NetErrorBlock)fail{
    NSString *urlStr = model.urlStr;
    id param = model.param;
    
    switch (model.requestType) {
        case afRequestTypePost:{//post
            [manager POST:urlStr parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(responseObject){
                    success(responseObject);
                } else {
                    fail(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                fail(error);
            }];
        }
            break;
            
            
        case afRequestTypePut:{//put
            
            [manager PUT:urlStr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(responseObject){
                    success(responseObject);
                } else {
                    fail(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                fail(error);
            }];
        }
            break;
           
            
        case afRequestTypeDelete:{//delete
            
            [manager DELETE:urlStr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(responseObject){
                    success(responseObject);
                } else {
                    fail(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                fail(error);
            }];
        }
            break;
            
            
        default:{//get
            [manager GET:urlStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {//请求进度
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {// 请求成功
                if(responseObject){
                    success(responseObject);
                } else {
                    fail(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {//请求失败
                fail(error);
            }];
        }
            break;
    }

}

@end
