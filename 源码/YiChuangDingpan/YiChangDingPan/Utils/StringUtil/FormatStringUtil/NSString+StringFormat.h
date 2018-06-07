//
//  NSString+StringFormat.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/2/6.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringFormat)

/**
 清空字符串中的空白字符

 @param string  原字符串
 @return        返回去除空白后的字符串
 */
+ (NSString *)trimmingCharactersForString:(NSString *)string;

/**
 删除str内的标签

 @param tags    标签，如<em></em> 或其他标签等
 @param str     带标签的原字符串
 @return        返回删除标签了的新字符串
 */
+ (NSString *)deleteTags:(NSString *)tags fromString:(NSString *)str;

/**
 判断字符串中是否有中文

 @param str     原字符串
 @return        有中文，返回YES；没有则返回NO
 */
+ (BOOL)isContainChineseWithString:(NSString *)str;


/**
 正则表达验证

 @param regex 正则
 @return 是否符合规范
 */
- (BOOL)match:(NSString *)regex;

@end
