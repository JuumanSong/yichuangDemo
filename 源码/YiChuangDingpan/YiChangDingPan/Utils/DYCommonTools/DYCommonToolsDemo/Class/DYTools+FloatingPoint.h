//
//  DYTools+FloatingPoint.h
//  DYCommonToolsDemo
//
//  Created by 鄢彭超 on 16/8/15.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYTools.h"

#define DEFAULT_PRECISION   5

typedef NS_ENUM(NSUInteger, EFloatingPointValueAttribute) {
    eZeroNumber = 0,            // 0
    ePositiveNumber,            // 正数
    eNegativeNumber             // 负数
};

typedef NS_ENUM(NSInteger, EFloatingPointCompareResult) {
    eSmaller = -1,          // 第一个数字更小
    eEqual = 0,             // 相等
    eBigger = 1,            // 第二个数字更大
};

@interface DYTools (FloatingPoint)

/**
 *	@brief	获取浮点数的正负属性（单精度）
 *
 *	@param 	number 	被判断的浮点数
 *
 *	@return	返回枚举类型分别表示0，正、负数
 */
+ (EFloatingPointValueAttribute)valueAttributeOfFloatNumber:(float)number;

/**
 *	@brief	获取浮点数的正负属性（双精度）
 *
 *	@param 	number 	被判断的浮点数
 *
 *	@return	返回枚举类型分别表示0，正、负数
 */
+ (EFloatingPointValueAttribute)valueAttributeOfDoubleNumber:(double)number;

/**
 *	@brief	比较两个数字大小（单精度）
 *
 *	@param 	number1 	第一个数
 *	@param 	number2 	第二个数
 *
 *	@return	第一个比第二个小：eSmaller；第一个跟第二个相等：eEqual；第一个比第二个大：eBigger
 */
+ (EFloatingPointCompareResult)compareFloatNumber1:(float)number1 withFloatNumber2:(float)number2;

/**
 *	@brief	比较两个数字大小（双精度）
 *
 *	@param 	number1 	第一个数
 *	@param 	number2 	第二个数
 *
 *	@return	第一个比第二个小：eSmaller；第一个跟第二个相等：eEqual；第一个比第二个大：eBigger
 */
+ (EFloatingPointCompareResult)compareDoubleNumber1:(double)number1 withDoubleNumber2:(double)number2;

/**
 *	@brief	比较两个数字大小（单精度）
 *
 *	@param 	number1 	第一个数
 *	@param 	number2 	第二个数
 *	@param 	precision 	精度：x表示两者相差小于两者的平均数除以x
 *
 *	@return	第一个比第二个小：eSmaller；第一个跟第二个相等：eEqual；第一个比第二个大：eBigger
 */
+ (EFloatingPointCompareResult)compareFloatNumber1:(float)number1 withFloatNumber2:(float)number2 withPrecision:(NSUInteger)precision;

/**
 *	@brief	比较两个数字大小（双精度）
 *
 *	@param 	number1 	第一个数
 *	@param 	number2 	第二个数
 *	@param 	precision 	精度：x表示两者相差小于两者的平均数除以x
 *
 *	@return	第一个比第二个小：eSmaller；第一个跟第二个相等：eEqual；第一个比第二个大：eBigger
 */
+ (EFloatingPointCompareResult)compareDoubleNumber1:(double)number1 withDoubleNumber2:(double)number2 withPrecision:(NSUInteger)precision;

@end
