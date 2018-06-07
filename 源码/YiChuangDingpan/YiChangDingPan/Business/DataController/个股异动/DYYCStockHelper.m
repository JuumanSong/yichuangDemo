//
//  DYYCStockPHelper.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/25.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCStockHelper.h"

static DYYCStockHelper *instance = nil;

@interface DYYCStockHelper()

@property (nonatomic,strong)NSDictionary *plistCache;

@end

@implementation DYYCStockHelper
//单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[DYYCStockHelper alloc] init];
        NSString *plistPath = [DY_BundleLoader(@"YiChuangLibrary") pathForResource:@"stockList" ofType:@"plist"];
        instance.plistCache = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    });
    return instance;
}

- (NSString *)getMoveMsgWithCode:(NSString *)code {
    NSString *msg = [_plistCache objectForKey:code];
    if (msg.length) {
        return msg;
    }
    return @"";
}



@end
