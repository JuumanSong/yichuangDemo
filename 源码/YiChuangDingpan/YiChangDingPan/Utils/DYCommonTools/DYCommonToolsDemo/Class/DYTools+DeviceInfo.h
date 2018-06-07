//
//  DYTools+DeviceInfo.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools.h"

@interface DYTools (DeviceInfo)

/**
 *	@brief	获得deviceId
 *
 *	@return	返回deviceId
 */
//+ (NSString *)deviceId;

/**
 *	@brief	返回设备类型
 *
 *	@return	返回设备类型
 */
+ (NSString *)subPhoneType;

/**
 *	@brief	返回当前系统版本
 *
 *	@return	返回当前系统版本
 */
+ (NSString *)osVersion;

/**
 *	@brief	生成唯一ID
 *
 *	@return	返回唯一ID
 */
+ (NSString *)searchSessionId;

/**
 *	@brief	构造一个新uuid
 *
 *	@return	返回新uuid
 */
+ (NSString *)createUUID;

@end
