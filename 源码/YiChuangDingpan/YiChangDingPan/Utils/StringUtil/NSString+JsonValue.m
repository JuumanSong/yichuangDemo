//
//  NSString+JsonValue.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/25.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "NSString+JsonValue.h"

@implementation NSString (JsonValue)

-(NSDictionary *) dictionaryValue{
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

- (NSArray *)arrayValue {
    NSError *errorArray;
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorArray];
    if (errorArray != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorArray);
#endif
    }
    return result;
}

@end
