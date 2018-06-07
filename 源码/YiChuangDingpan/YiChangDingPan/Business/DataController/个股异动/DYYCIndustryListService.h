//
//  DYYCIndustryListService.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//  行业列表

#import <Foundation/Foundation.h>


@interface DYYCIndustryListService : NSObject

+ (instancetype)shareInstance;
/**
 获取行业分类列表--需要存本地
 */
- (void)loadIndustryListDataWithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail;

///**
// 获取个股对应行业列表--需要存本地
// */
//- (void)loadEquIndustriesDataWithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail;

// 根据行业ID返回行业名称
- (NSString *)getIndustryNameWithID:(NSString *)ID;

@end
