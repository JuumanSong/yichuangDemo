//
//  DYTools+DeviceInfo.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools+DeviceInfo.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
//#import <SSKeychain/SSKeychain.h>

@implementation DYTools (DeviceInfo)

//+ (NSString *)deviceId
//{
//    NSString *deviceIdString = [SSKeychain passwordForService:@"com.datayes.iia" account:@"deviceId"];
//    
//    if ([deviceIdString length] <= 0) {
//        deviceIdString = [DYTools createUUID];
//        [SSKeychain setPassword:deviceIdString forService:@"com.datayes.iia" account:@"deviceId"];
//    }
//    
//    return deviceIdString;
//}

+ (NSString *)searchSessionId
{
    NSString* uuid = [DYTools createUUID];
    
    return uuid;
}

+ (NSString *)createUUID
{
    NSString *uuid = nil;
    
    CFUUIDRef uniqueIdRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uniqueIdStringRef = CFUUIDCreateString(kCFAllocatorDefault, uniqueIdRef);
    CFRelease(uniqueIdRef);
    uuid = (__bridge NSString *)(uniqueIdStringRef);
    CFRelease(uniqueIdStringRef);
    
    return uuid;
}

+ (NSString *)subPhoneType
{
#if TARGET_IPHONE_SIMULATOR
    return @"iPhone5,1";
#else
    static struct utsname model;
    uname(&model);
    return [NSString stringWithUTF8String:model.machine];
#endif
}

+ (NSString *)osVersion
{
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

@end
