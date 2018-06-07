//
//  NSString+NumberFormat.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/2/6.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "NSString+NumberFormat.h"

@implementation NSString (NumberFormat)

// 根据数值获取相应的单位"亿/万"
+ (NSString *)unitOfNumber:(float)number {
    if (!isnan(number)) {
        number = [self getFloatValue:number];
    }
    
    if (fabsf(number) / 100000000 >= 1) {
        return @"亿";
    } else if (fabsf(number) / 10000 >= 1) {
        return @"万";
    } else {
        return @"";
    }
}

// 获取保留两位小数的百分比
+ (NSString *)stringWithPecent:(double)pecent {
    return [NSString stringWithFormat:@"%.2f%%", [self getFloatValue:pecent] * 100];
}

// 不保留小数位
+ (NSString *)stringWithPriceDigit0:(double)price {
    return [NSString stringWithFormat:@"%.0f", [self getFloatValue:price]];
}

// 保留1位小数
+ (NSString *)stringWithPriceDigit1:(double)price {
    return [NSString stringWithFormat:@"%.1f", [self getFloatValue:price]];
}

// 保留2位小数
+ (NSString *)stringWithPriceDigit2:(double)price {
    price = [self getFloatValue:price];
    
    NSString* string3 = [NSString stringWithFormat:@"%.3f", price];
    NSString* string2 = [NSString stringWithFormat:@"%.2f", price];
    
    if (string3.length > 3 &&
        string2.length > 3) {
        NSString* subString3 = [string3 substringFromIndex:(string3.length - 3)];
        NSString* subString2 = [string2 substringFromIndex:(string2.length - 2)];
        
        if ([[subString3 substringFromIndex:2] compare:@"5"] != NSOrderedAscending) {
            if ([[subString3 substringToIndex:2] isEqualToString:subString2]) {
                if (price >= 0) {
                    return [NSString stringWithFormat:@"%.2f", price + 0.01];
                } else {
                    return [NSString stringWithFormat:@"%.2f", price - 0.01];
                }
            } else {
                return [NSString stringWithFormat:@"%.2f", price];
            }
        } else {
            return [NSString stringWithFormat:@"%.2f", price];
        }
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

// 数字超过1万，显示单位"xx万"；超过1亿，显示单位"xx亿"
+ (NSString *)convertToNumber:(float)number withUnit:(BOOL)unit {
    //·1万以下（不包括1万）不显示单位
    //  case：数据9999.12显示为“9999.12”
    //·1万以上（包括1万）1亿以下（不包括1亿）换算成以“万”为单位的计数方式，并且显示单位“万”
    //  case：数据99991234.01显示成“9999.12万”
    //·1亿以上（包括1亿），换算成以“亿”为单位的计数方式，并且显示单位“亿”
    //  case：999912341234显示成“9999.12亿”
    if (!isnan(number)) {
        number = [self getFloatValue:number];
    }
    
    if (fabsf(number) / 100000000 >= 1) {
        
        return unit ? [NSString stringWithFormat:@"%0.2f%@",number / 100000000,@"亿"] :
        [NSString stringWithFormat:@"%0.2f",number / 100000000];
        
    } else if (fabsf(number) / 10000 >= 1) {
        
        return unit ? [NSString stringWithFormat:@"%0.2f%@",number / 10000,@"万"] :
        [NSString stringWithFormat:@"%0.2f",number / 10000];
        
    } else {
        
        if (fabs(number)*100 < 1) {
            
            return [NSString stringWithFormat:@"%0.2f",number];
            
        } else {
            
            return [NSString stringWithFormat:@"%0.2f",number];
        }
    }
}

+ (float)getFloatValue:(float)f {
    if (f > LLONG_MAX/1000001.0) {
        return f;
    }
    else if(f) {
        long long int i = 1000000 * f;
        return (float)i/1000000.0 + 1/1000000.0;
    }
    else{
        return 0.0f;
    }
}

// 根据数字获取带有颜色的字符串 (红、绿、灰)
+ (NSAttributedString *)getAttriButedStrWithNumber:(Float64)ratio {
    
    if (fabs(ratio) == MAXFLOAT) {
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@"--"];
        
        return attrText;
    }
    
    UIColor *color;
    NSString *value;
    
    if (ratio > 0) {
        value = [NSString stringWithFormat:@"+%.2f%%",ratio*100];
        color = DYAppearanceColor(@"R3", 1.0);
        
    } else if (ratio < 0){
        value = [NSString stringWithFormat:@"%.2f%%",ratio*100];
        color = DYAppearanceColor(@"G1", 1.0);
        
    } else {
        value = [NSString stringWithFormat:@"%.2f%%",ratio*100];
        color = DYAppearanceColor(@"H9", 1.0);
    }
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:value];
    NSInteger attrLenth = [attrText length];
    
    [attrText addAttribute:NSFontAttributeName
                     value:DYAppearanceBoldFont(@"T2")
                     range:NSMakeRange(0, attrLenth)];
    
    [attrText addAttribute:NSForegroundColorAttributeName
                     value:color
                     range:NSMakeRange(0, attrLenth)];
    
    return attrText;
}

+(NSString *)sizeTostring:(long long int)size{
    NSString *sizeStr = @"";
    if(size>1024*1024*1024){
        sizeStr=[NSString stringWithFormat:@"%.2f G",size/1024.0/1024.0/1024.0];
    }
    else if(size>1024*1024){
        sizeStr=[NSString stringWithFormat:@"%.2f M",size/1024.0/1024.0];
    }
    else if(size>1024){
        sizeStr=[NSString stringWithFormat:@"%.2f K",size/1024.0];
    }
    else{
        sizeStr=[NSString stringWithFormat:@"%lli B",size];
    }
    return sizeStr;
}

@end
