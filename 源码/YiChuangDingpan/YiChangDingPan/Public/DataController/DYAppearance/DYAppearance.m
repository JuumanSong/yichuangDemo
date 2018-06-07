//
//  DYAppearance.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYAppearance.h"

static DYAppearance* dyAppearance = nil;

@implementation DYAppearance


//---------------新方法------------------

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dyAppearance = [[DYAppearance alloc] init];
        
        NSString *dyAppearanceBundlePath;
        dyAppearanceBundlePath = [[NSBundle mainBundle] pathForResource:@"DYAppearance" ofType:@"bundle"];
        if(!dyAppearanceBundlePath){//在pod中是取不到上面路径的
            dyAppearanceBundlePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/DYAppearance.framework/DYAppearance.bundle"];
        }
        
        NSString *plistPath = [[NSBundle bundleWithPath:dyAppearanceBundlePath] pathForResource:@"DYAppearance" ofType:@"plist"];
        dyAppearance.appearanceDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    });
    return dyAppearance;
}

- (UIColor *)DYAppearanceColorWithKey:(NSString *)key AndAlpha:(CGFloat)alpha{
    NSDictionary *color = self.appearanceDic[@"Color"];
    NSString *str = color[key];
    unsigned long rgb = strtoul([str UTF8String],0,16);
    UIColor *dycolor=[DYAppearance colorWithRGB:rgb andAlpha:alpha];
    return dycolor;
}

- (UIFont *)DYAppearanceFontWithKey:(NSString *)key IsBold:(BOOL)bold{
    NSDictionary *font=self.appearanceDic[@"Font"];
    NSString *str=font[key];
    CGFloat size=[str floatValue];
    if(bold){
        return [UIFont boldSystemFontOfSize:size];
    }
    else{
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIColor *)colorWithRGB:(NSInteger)rgb
{
    return [self colorWithRGB:rgb andAlpha:1.0];
}

+ (UIColor *)colorWithRGB:(NSInteger)rgb andAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0
                           green:((float)((rgb & 0xFF00) >> 8))/255.0
                            blue:((float)(rgb & 0xFF))/255.0
                           alpha:alpha];
}
+ (UIColor *)colorWithRGBA:(NSInteger)rgba
{
    return [UIColor colorWithRed:((float)((rgba & 0xFF000000) >> 24))/255.0
                           green:((float)((rgba & 0xFF0000) >> 16))/255.0
                            blue:((float)((rgba & 0xFF00) >> 8))/255.0 alpha:((float)(rgba & 0xFF))/255.0];
}
@end




