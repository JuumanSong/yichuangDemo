//
//  NSString+JsonValue.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/25.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonValue)

-(NSDictionary *) dictionaryValue;
- (NSArray *)arrayValue;

@end
