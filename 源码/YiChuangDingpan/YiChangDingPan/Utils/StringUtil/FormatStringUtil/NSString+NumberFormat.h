//
//  NSString+NumberFormat.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/2/6.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NumberFormat)

// 根据数值获取相应的单位"亿/万"
+ (NSString *)unitOfNumber:(float)number;

// 保留两位小数的百分比
+ (NSString *)stringWithPecent:(double)pecent;

// 不保留小数位
+ (NSString *)stringWithPriceDigit0:(double)price;

// 保留1位小数
+ (NSString *)stringWithPriceDigit1:(double)price;

// 保留2位小数
+ (NSString *)stringWithPriceDigit2:(double)price;

/**
 保留两位小数，根据unit判断是否显示单位
 数字超过1万，显示单位"x.xx万"；超过1亿，显示单位"x.xx亿"

 @param number      数值
 @param unit        数字单位，YES:显示单位，NO:不显示
 @return            返回数值字符串
 */
+ (NSString *)convertToNumber:(float)number withUnit:(BOOL)unit;

/**
 根据数字获取带有颜色的字符串 (红、绿、灰)

 @param ratio       数值
 @return            返回带有颜色的字符串
 */
+ (NSAttributedString *)getAttriButedStrWithNumber:(Float64)ratio;

/**
 根据数字获取大小
 */
+(NSString *)sizeTostring:(long long int)size;

@end
