//
//  NSString+Hash.h
//  IntelligenceResearchReport
//
//  Created by 鄢彭超 on 2017/12/5.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

- (NSString *) sha1;
- (NSString *) sha224;
- (NSString *) sha256;
- (NSString *) sha384;
- (NSString *) sha512;

@end
