//
//  DYYC_SiftStock.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYC_SiftStock : NSObject
+ (instancetype)shareInstance;

-(BOOL)siftStockWithTicker:(NSString *)tickerId sct:(NSString *)sct bt:(NSString *)bt;
-(void)clearCache;
@end
