//
//  DYNetBlockModel.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/12.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYNetSuccessModel,DYNetErrorModel;

typedef void (^DYNetSuccessBlock)(DYNetSuccessModel *success); // 访问成功block
typedef void (^DYNetErrorBlock)(DYNetErrorModel *fail); // 访问失败block

@interface DYNetSuccessModel : NSObject

@property(nonatomic,strong)id data;//网络返回的源数据
@property(nonatomic,strong)id result;//接口返回数据
@property(nonatomic,assign)NSInteger code;//状态代码

@end


@interface DYNetErrorModel : NSObject

@property(nonatomic,strong)NSError *error;

@end
