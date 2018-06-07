//
//  DYAppearance.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//标准颜色
#define DYAppearanceColor(key,alpha)   [[DYAppearance shareInstance] DYAppearanceColorWithKey:key AndAlpha:alpha]
//标准字体
#define DYAppearanceFont(key)          [[DYAppearance shareInstance] DYAppearanceFontWithKey:key IsBold:NO]
//标准加粗字体
#define DYAppearanceBoldFont(key)      [[DYAppearance shareInstance] DYAppearanceFontWithKey:key IsBold:YES]
//十六进制颜色转换（临时添加）
#define DYAppearanceColorFromHex(s,a)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

@interface DYAppearance : NSObject{
}
@property (nonatomic,strong)NSDictionary *appearanceDic;


//----------------新方法--------------
//单例
+ (instancetype)shareInstance;
//返回key所指的颜色
- (UIColor *)DYAppearanceColorWithKey:(NSString *)key AndAlpha:(CGFloat)alpha;
//返回key所指的Font
- (UIFont *)DYAppearanceFontWithKey:(NSString *)key IsBold:(BOOL)bold;
//返回uicolor
+ (UIColor *)colorWithRGB:(NSInteger)rgb andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithRGBA:(NSInteger)rgba;
+ (UIColor *)colorWithRGB:(NSInteger)rgb;
@end

