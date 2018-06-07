//
//  DYResourceLoader.m
//  YiChangDingPan
//
//  Created by 宋骁俊 on 2018/5/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYResourceLoader.h"

@implementation DYResourceLoader

+(UIImage *)imgWithName:(NSString *)name bundleName:(NSString *)bundleName{
    if(bundleName){
        NSBundle *bundle = [self bundleName:bundleName];
        if (@available(iOS 8.0, *)) {
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            NSString *file = [bundle pathForResource:name ofType:@"png"];
            UIImage *img = [UIImage imageWithContentsOfFile:file];
            return img;
        }
    }
    else{
        return [UIImage imageNamed:name];
    }
}

+(NSBundle *)bundleName:(NSString *)bundleName{
    if(bundleName){
        NSString *dyAppearanceBundlePath;
        dyAppearanceBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        if(!dyAppearanceBundlePath){//在pod中是取不到上面路径的
            NSString *subName = [NSString stringWithFormat:@"Frameworks/%@.framework/%@.bundle",bundleName,bundleName];
            dyAppearanceBundlePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:subName];
        }
        NSBundle *bundle = [NSBundle bundleWithPath:dyAppearanceBundlePath];
        return bundle;
    }
    else{
        return nil;
    }
}

@end
