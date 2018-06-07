//
//  DYUserDefaultUtil.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/28.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSUserDefaults工具
 */
@interface DYUserDefaultUtil : NSObject

+ (void)setObject:(id _Nullable )value forKey:(NSString *_Nonnull)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *_Nonnull)defaultName;

+ (void)setInteger:(NSInteger)value forKey:(NSString *_Nonnull)defaultName;

+ (void)setFloat:(float)value forKey:(NSString *_Nonnull)defaultName;

+ (nullable id)objectForKey:(NSString *_Nonnull)defaultName;

+ (BOOL)boolForKey:(NSString *_Nonnull)defaultName;

+ (NSInteger)integerForKey:(NSString *_Nonnull)defaultName;

+ (float)floatForKey:(NSString *_Nonnull)defaultName;


+ (void)removeObjectForKey:(NSString *_Nonnull)defaultName;

@end
