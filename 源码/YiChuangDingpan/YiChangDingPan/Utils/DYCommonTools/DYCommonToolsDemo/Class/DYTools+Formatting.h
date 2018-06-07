//
//  DYTools+Formatting.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools.h"
#import <UIKit/UIKit.h>

@interface DYTools (Formatting)
/*
 *金额格式化1,222.00
 */
+ (NSString *)formattingNum:(NSString *)str;

/**
 *	@brief	按照指定的小数位数，格式化一个浮点数（该函数去除浮点数后面的0尾数）
 *
 *	@param 	number 	浮点数
 *	@param 	decimalNumber 	保留小数点位数
 *
 *	@return	返回格式化好的字符串
 */
+ (NSString*)formattingNum:(CGFloat)number leftDecimalNumber:(NSUInteger)decimalNumber;

/**
 *	@brief	格式化数字成短字串
 *
 *	@param 	number 	要格式化的数字
 *	@param 	gap 	相邻两个number之间的间隔
 *	@param 	decimalNumber 	保留小数点位数
 *
 *	@return	返回短字串
 */
+ (NSString*)formatingToShortStringWithNumber:(CGFloat)number andGap:(CGFloat)gap leftDecimalNumber:(NSUInteger)decimalNumber;

/**
 *	@brief	将数字转换为带单位的字符串
 *
 *	@param 	count 	数字
 *
 *	@return	返回带单位的字符串
 */
+ (NSString *)readTimeCount:(int64_t)count;

/**
 *	@brief	测试
 */
+ (void)testFormatingToShortStringWithNumber;

@end
