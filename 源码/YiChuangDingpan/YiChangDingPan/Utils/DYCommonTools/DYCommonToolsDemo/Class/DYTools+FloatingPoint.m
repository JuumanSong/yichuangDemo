//
//  DYTools+FloatingPoint.m
//  DYCommonToolsDemo
//
//  Created by 鄢彭超 on 16/8/15.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYTools+FloatingPoint.h"

@implementation DYTools (FloatingPoint)

+ (EFloatingPointValueAttribute)valueAttributeOfFloatNumber:(float)number
{
    EFloatingPointCompareResult compareResult = [DYTools compareFloatNumber1:number withFloatNumber2:.0f];
    switch (compareResult) {
        case eEqual:
            return eZeroNumber;
            break;
        case eBigger:
            return ePositiveNumber;
            break;
        case eSmaller:
            return eNegativeNumber;
            break;
        default:
            break;
    }
    
    return eZeroNumber;
}

+ (EFloatingPointValueAttribute)valueAttributeOfDoubleNumber:(double)number
{
    EFloatingPointCompareResult compareResult = [DYTools compareDoubleNumber1:number withDoubleNumber2:.0f];
    switch (compareResult) {
        case eEqual:
            return eZeroNumber;
            break;
        case eBigger:
            return ePositiveNumber;
            break;
        case eSmaller:
            return eNegativeNumber;
            break;
        default:
            break;
    }
    
    return eZeroNumber;
}

+ (EFloatingPointCompareResult)compareFloatNumber1:(float)number1 withFloatNumber2:(float)number2
{
    return [DYTools compareFloatNumber1:number1 withFloatNumber2:number2 withPrecision:DEFAULT_PRECISION];
}

+ (EFloatingPointCompareResult)compareDoubleNumber1:(double)number1 withDoubleNumber2:(double)number2
{
    return [DYTools compareDoubleNumber1:number1 withDoubleNumber2:number2 withPrecision:DEFAULT_PRECISION];
}

+ (EFloatingPointCompareResult)compareFloatNumber1:(float)number1 withFloatNumber2:(float)number2 withPrecision:(NSUInteger)precision
{
    float precisionDivisor = 1.0f;
    while (precision -- > 0) {
        precisionDivisor *= 10;
    }
    
    float presitionNumber = (fabsf(number1) + fabsf(number2))/2/precisionDivisor;
    if (fabsf(number1 - number2) <= presitionNumber) {
        return eEqual;
    }
    
    if (number1 > number2) {
        return eBigger;
    }
    else {
        return eSmaller;
    }
}

+ (EFloatingPointCompareResult)compareDoubleNumber1:(double)number1 withDoubleNumber2:(double)number2 withPrecision:(NSUInteger)precision
{
    double precisionDivisor = 1.0f;
    while (precision -- > 0) {
        precisionDivisor *= 10;
    }
    
    double presitionNumber = (fabs(number1) + fabs(number2))/2/precisionDivisor;
    if (fabs(number1 - number2) <= presitionNumber) {
        return eEqual;
    }
    
    if (number1 > number2) {
        return eBigger;
    }
    else {
        return eSmaller;
    }
}

@end
