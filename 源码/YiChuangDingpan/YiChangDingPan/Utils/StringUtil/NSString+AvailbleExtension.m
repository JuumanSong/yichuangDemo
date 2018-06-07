//
//  NSString+AvailbleExtension.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/3.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "NSString+AvailbleExtension.h"

@implementation NSString (AvailbleExtension)
/****
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0)

{
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
     return NO;
    
}
 */
-(BOOL)isContainsString:(NSString *)aString{
    
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}
@end
