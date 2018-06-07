//
//  DYTools+Formatting.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools+Formatting.h"

@implementation DYTools (Formatting)

+ (NSString *)formattingNum:(NSString *)str{
    NSRange  range= [str rangeOfString:@"."];
    NSString * num;
    NSString * end;
    if (range.length!=0) {
        num =[str substringToIndex:range.location];
        end = [str substringFromIndex:range.location];
    }else
        num = str;
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
        
    }
    [newstring insertString:string atIndex:0];
    if(end!=nil)
        [newstring insertString:end atIndex:newstring.length];
    
    return newstring;
}

+ (NSString*)formattingNum:(CGFloat)number leftDecimalNumber:(NSUInteger)decimalNumber
{
    double calcNumber = number > 0 ? floorf(number) : ceilf(number);
    double calcNumber2 = number;
    
    if (decimalNumber >= 10) {
        return [NSString stringWithFormat:@"%.6f", calcNumber];
    }
    else
    {
        // 去除浮点精度的影响
        NSString* formatterString = [NSString stringWithFormat:@"%%.%luf", (unsigned long)decimalNumber];
        NSString* sNumber = [NSString stringWithFormat:formatterString, number];
        number = [sNumber doubleValue];
        
        calcNumber = number > 0 ? floorf(number) : ceilf(number);
        calcNumber2 = number;
    }
    
    NSUInteger count = 1;
    for (NSUInteger i = 0 ; i < decimalNumber ; i ++) {
        calcNumber *= 10;
        calcNumber2 *= 10;
        count *= 10;
    }
    
    NSUInteger hasDecimalNumberCount = 0;
    NSUInteger nDecimalNumber = (NSUInteger)fabs(calcNumber2 - calcNumber);
    for (NSUInteger i = 0 ; i < decimalNumber ; i ++) {
        if (nDecimalNumber % count > 0) {
            hasDecimalNumberCount ++;
            count /= 10;
        }
        else
            break;
    }
    
    NSString* formatterString = [NSString stringWithFormat:@"%%.%luf", (unsigned long)hasDecimalNumberCount];
    return [NSString stringWithFormat:formatterString, number];
}

+ (void)testFormatingToShortStringWithNumber
{
    NSLog(@"0.000005 : %@", [self formatingToShortStringWithNumber:-0.000005 andGap:1 leftDecimalNumber:2]);
    NSLog(@"0.02 : %@", [self formatingToShortStringWithNumber:-0.02 andGap:1 leftDecimalNumber:2]);
    NSLog(@"1.234 : %@", [self formatingToShortStringWithNumber:-1.234 andGap:1 leftDecimalNumber:2]);
    NSLog(@"1024 : %@", [self formatingToShortStringWithNumber:-1024 andGap:1 leftDecimalNumber:2]);
    NSLog(@"1024666 : %@", [self formatingToShortStringWithNumber:-1024666 andGap:1 leftDecimalNumber:2]);
    NSLog(@"1024666666 : %@", [self formatingToShortStringWithNumber:-1024666666 andGap:1 leftDecimalNumber:2]);
}

+ (NSString*)formatingToShortStringWithNumber:(CGFloat)number andGap:(CGFloat)gap leftDecimalNumber:(NSUInteger)decimalNumber
{
    CGFloat absNumber = fabs(number);
    
    NSString* formatingString = nil;
    if (absNumber == 0) {
        formatingString = @"0";
    }
    else if (absNumber < .01) {
        if (absNumber / gap < 0.01) {
            formatingString = @"0";
        }
        else
        {
            NSString* format = [NSString stringWithFormat:@"%%.%lue", (unsigned long)decimalNumber];
            formatingString = [NSString stringWithFormat:format, number];
            
            formatingString = [self eValueString:formatingString withLeftDecimalNumber:decimalNumber];
        }
    }
    else if (absNumber < 1) {
        formatingString = [DYTools formattingNum:number leftDecimalNumber:decimalNumber];
    }
    else if (absNumber < 1000) {
        formatingString = [DYTools formattingNum:number leftDecimalNumber:decimalNumber];
    }
    else if (absNumber < 1000*1000) {
        formatingString = [DYTools formattingNum:number/1000 leftDecimalNumber:decimalNumber];
        formatingString = [NSString stringWithFormat:@"%@K", formatingString];
    }
    else if (absNumber < 1000*1000*1000) {
        formatingString = [DYTools formattingNum:number/(1000*1000) leftDecimalNumber:decimalNumber];
        formatingString = [NSString stringWithFormat:@"%@M", formatingString];
    }
    else {
        NSString* format = [NSString stringWithFormat:@"%%.%lue", (unsigned long)decimalNumber];
        formatingString = [NSString stringWithFormat:format, number];
        
        formatingString = [self eValueString:formatingString withLeftDecimalNumber:decimalNumber];
    }
    
    return formatingString;
}

+ (NSString*)eValueString:(NSString*)eValueString withLeftDecimalNumber:(NSUInteger)decimalNumber
{
    NSArray* array = [eValueString componentsSeparatedByString:@"e"];
    if ([array count] > 1) {
        NSString* valueString = array[0];
        CGFloat valueFloat = [valueString floatValue];
        
        valueString = [self formattingNum:valueFloat leftDecimalNumber:decimalNumber];
        return [NSString stringWithFormat:@"%@e%@", valueString, array[1]];
    }
    
    return eValueString;
}

+ (NSString *)readTimeCount:(int64_t)count{
    if (count <1000 ) {
        return [NSString stringWithFormat:@"%lld",count];
    }
    else if (count <10000){
        count = count /1000;
        return [NSString stringWithFormat:@"%lld千+",count];
    }
    else if (count<100000){
        count = count/10000;
        return [NSString stringWithFormat:@"%lld万+",count];
    }
    else if (count >=100000){
        return @"10万+";
    }
    else
        return @"0";
}
@end
