/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  NSObject+Representation.h
//  Object
//
//  Created by tianyouhui on 7/17/15.
//

#import <Foundation/Foundation.h>

#define REP_COLLECTION_TYPE(class_type)  @protocol class_type @end

#if !__has_feature(objc_arc)
#error "We must use in arc!"
#endif

@interface NSObject (Representation)

// representation is NSDictionary or NSArray
// if representation is NSDictionary, return object, else array.
// module name used in swift. Note that we only support class inherited from NSObject.
+ (id)objectWithRepresentation:(id)representation;
+ (id)objectWithRepresentation:(id)representation inModule:(NSString *)moduleName;

// Only plist or json.
+ (id)objectWithContentsOfFile:(NSString *)file;
+ (id)objectWithContentsOfFile:(NSString *)file inModule:(NSString *)moduleName;

// return NSDictionary or NSArray
- (id)representation;

// Used for unknown array types, such as swift or objc generic. @{@"key": @"Class"}
+ (void)setArrayClassType:(NSDictionary *)type;

// Need be override by subclass.
// If dictionary key is distinct with property.
// Dictionary key from property.
+ (NSString *)keyWithPropertyName:(NSString *)propertyName;

// We only supply date convert method.
// If value is NSString, format is such as "yyyyMMdd" and so on, if format is nil,
// the default format is RFC3339, which is "yyyy-MM-dd'T'HH:mm:ssZZZ".
// If value is NSNumber, it should be be milliseconds, and the format should be one
// selector of [@"dateWithTimeIntervalSinceNow:",
// @"dateWithTimeIntervalSinceReferenceDate:", @"dateWithTimeIntervalSince1970:"].
// If format is nil, the default is @"dateWithTimeIntervalSince1970:".
+ (NSDate *)dateWithValue:(id)value format:(NSString *)format;

@end
