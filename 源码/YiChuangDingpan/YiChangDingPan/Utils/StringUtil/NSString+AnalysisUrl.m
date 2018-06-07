//
//  NSString+AnalysisUrl.m
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/3/14.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "NSString+AnalysisUrl.h"

@implementation NSString (AnalysisUrl)

-(NSDictionary *)analysisUrlParameters{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    NSArray *array = [self componentsSeparatedByString:@"?"];
    NSString *lastStr = self;
    if (array.count >1) {
        lastStr = array.lastObject;
    }
    NSArray *parameters = [lastStr componentsSeparatedByString:@"&"];
    for (NSInteger i = 0; i<parameters.count; i++) {
        NSString *tempStr = [parameters objectAtIndex:i];
        NSArray *tempArr = [tempStr componentsSeparatedByString:@"="];
        if (tempArr.count == 2) {
            [paramsDic setObject:[[tempArr objectAtIndex:1] urlDecodedString] forKey:[tempArr objectAtIndex:0]];
        }
        // 多个等号的情况，可能是由于参数没有encode
        else {
            NSRange range = [tempStr rangeOfString:@"="];
            if (range.location!=NSNotFound) {
                NSString *key = [tempStr substringToIndex:range.location];
                NSString *value = [tempStr substringFromIndex:range.location +1];
                value = [value urlDecodedString];
                [paramsDic setObject:value forKey:key];
            }
        }
    }
    return paramsDic;
}

- (NSString *)urlDecodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, CFSTR("")));
}

@end
