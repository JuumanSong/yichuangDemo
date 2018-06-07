//
//  DYTools.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools.h"

@implementation DYTools

+ (NSString*)nilToEmptyString:(NSString*)str
{
    if (str == nil) {
        return @"";
    }
    
    return str;
}

//+ (BOOL)saveInfoIntoKeychainForKey:(NSString*)key withValue:(NSString*)value
//{
//    return [SSKeychain setPassword:value forService:key account:@"com.datayes.ira"];
//}
//
//+ (NSString*)getInfoFromKeychainForKey:(NSString*)key
//{
//    return [SSKeychain passwordForService:key account:@"com.datayes.ira"];
//}
//
//+ (BOOL)clearInfoFromKeychainForKey:(NSString*)key
//{
//    return [SSKeychain deletePasswordForService:key account:@"com.datayes.ira"];
//}

@end
