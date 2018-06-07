//
//  DYUserDefaultUtil.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/28.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYUserDefaultUtil.h"

@implementation DYUserDefaultUtil

+ (void)setObject:(id _Nullable )value forKey:(NSString *_Nonnull)defaultName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *_Nonnull)defaultName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *_Nonnull)defaultName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *_Nonnull)defaultName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:value forKey:defaultName];
    [userDefaults synchronize];
}

+ (nullable id)objectForKey:(NSString *_Nonnull)defaultName {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *_Nonnull)defaultName {
    return  [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *_Nonnull)defaultName {
    return  [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *_Nonnull)defaultName {
    return  [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (void)removeObjectForKey:(NSString *_Nonnull)defaultName {
    return  [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}

@end
