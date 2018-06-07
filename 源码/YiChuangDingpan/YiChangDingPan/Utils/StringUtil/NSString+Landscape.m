//
//  NSString+Landscape.m
//  IntelligenceResearchReport
//
//  Created by 鄢彭超 on 2017/7/20.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "NSString+Landscape.h"

@implementation NSString (Landscape)

- (instancetype)transformToLandscape
{
    NSMutableString *content = [self mutableCopy];
    
    [content replaceOccurrencesOfString:@"(" withString:@"︵" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@")" withString:@"︶" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"<" withString:@"︿" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@">" withString:@"﹀" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"[" withString:@"︹" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"]" withString:@"︺" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    
    [content replaceOccurrencesOfString:@"（" withString:@"︵" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"）" withString:@"︶" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"《" withString:@"︽" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"》" withString:@"︾" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"【" withString:@"︻" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"】" withString:@"︼" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    
    [content replaceOccurrencesOfString:@"{" withString:@"︷" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"}" withString:@"︸" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    
    [content replaceOccurrencesOfString:@":" withString:@" ¨ " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    [content replaceOccurrencesOfString:@"：" withString:@" ¨ " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    
    return content;
}

@end
