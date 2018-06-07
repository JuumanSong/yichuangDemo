//
//  DYYCStockPHelper.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/25.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYCStockHelper : NSObject

+ (instancetype)shareInstance;

- (NSString *)getMoveMsgWithCode:(NSString *)code;

@end
