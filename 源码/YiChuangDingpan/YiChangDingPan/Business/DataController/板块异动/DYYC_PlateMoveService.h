//
//  DYYC_PlateMoveService.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYC_PlateMoveService : NSObject

@property (nonatomic,strong) NSMutableDictionary *expandDict;


/**
 获取板块异动列表数据
 */
+ (void)getNewAreaMsgsWithLastId:(NSInteger)count success:(void(^)(id data))success fail:(void(^)(id data))fail;

/**
 获取板块异动分时图

 @param secId 板块id
 */
+ (void)getIdxMktPriceGraphWithSecId:(NSString *)secId success:(void(^)(id data))success fail:(void(^)(id data))fail;

// 过滤字符串
+ (NSDictionary *)getMatchesDictAdapterOfString:(NSString *)string;
@end
