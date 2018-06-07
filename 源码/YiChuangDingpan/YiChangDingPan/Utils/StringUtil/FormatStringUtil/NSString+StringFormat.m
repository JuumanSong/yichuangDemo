//
//  NSString+StringFormat.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/2/6.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "NSString+StringFormat.h"

@implementation NSString (StringFormat)

// 清空字符串中的空白字符
+ (NSString *)trimmingCharactersForString:(NSString *)string {
    NSString *trimStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimStr;
}

// 删除str内的标签,如：<em>，</em>等
+ (NSString *)deleteTags:(NSString *)tags fromString:(NSString *)str {
    if(str){
        NSMutableString *string = [[NSMutableString alloc]initWithString:str];
        [string replaceOccurrencesOfString:tags
                                withString:@""
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [string length])];
        return string;
    }
    else{
        return str;
    }
}

// 判断字符串中是否有中文
+ (BOOL)isContainChineseWithString:(NSString *)str {
    for (int i = 0; i < str.length; i++) {
        int a = [str characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)match:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


@end
