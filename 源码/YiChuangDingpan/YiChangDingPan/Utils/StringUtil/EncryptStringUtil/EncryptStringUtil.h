//
//  EncryptStringUtil.h
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/29.
//  Copyright © 2017年 datayes. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "NSString+Hash.h"

@interface EncryptStringUtil : NSObject

//base64
+(NSString *)base64:(NSData *)data;

//base64
+(NSString *)base64WithStr:(NSString *)string;

//Des加密
+(NSString *) encryptUseDES:(NSString *)string key:(NSString *)key;

//Des解密
+(NSString *)decryptUseDES:(NSString *)string key:(NSString *)key;

//md5加密
+ (NSString *)md5:(NSString *)str;

//中文url转码
+ (NSString *)verifyChineseUrlStr:(NSString *)chineseStr;

//Hash
+ (NSString *)sha256;

@end
