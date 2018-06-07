//
//  DYTools.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYTools : NSObject

/**
 *	@brief	如果字符串为nil时，将nil转换成空串；否则返回原值
 *
 *	@param 	str 	需要转换的字符串
 *
 *	@return	返回转换后的字符串
 */
+ (NSString*)nilToEmptyString:(NSString*)str;

/**
 *	@brief	保存一个值到keychain
 *
 *	@param 	key 	值对应的key
 *	@param 	value 	值
 *
 *	@return	保存成功返回YES，保存失败返回NO
 */
//+ (BOOL)saveInfoIntoKeychainForKey:(NSString*)key withValue:(NSString*)value;
//
///**
// *    @brief    从keychain获取一个值
// *
// *    @param     key     值对应的key
// *
// *    @return    返回值
// */
//+ (NSString*)getInfoFromKeychainForKey:(NSString*)key;
//
///**
// *    @brief    从keychain删除一个值
// *
// *    @param     key     值对应的key
// *
// *    @return    删除成功返回YES，删除成功返回NO
// */
//+ (BOOL)clearInfoFromKeychainForKey:(NSString*)key;

@end
