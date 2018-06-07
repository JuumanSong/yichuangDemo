//
//  DYAdvancedSetService.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYPersonSettingModel.h"

@interface DYAdvancedSetService : NSObject
@property (nonatomic, strong) DYPersonSettingModel*orginModel;
@property (nonatomic, strong) DYPersonSettingModel*personSettingModel; //消息设置数据源,可改变
+ (instancetype)shareInstance;
+(DYPersonSettingModel*)getDefaultGeneralRulesInfo;

/**
  @param success 获取消息配置
 @param fail fail description
 */
-(void)getGeneralRulesWithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail;

/**
 设置消息配置
 @param success success description
 @param fail fail description
 */
-(void)setGeneralRuleWithDataModel:(DYPersonSettingModel*)model Success:(void(^)(id data))success fail:(void(^)(id data))fail;


@end
