//
//  DYResourceLoader.h
//  YiChangDingPan
//
//  Created by 宋骁俊 on 2018/5/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DY_BundleLoader(bn)  ([DYResourceLoader bundleName:bn])
#define DY_ImgLoader(n,bn)   ([DYResourceLoader imgWithName:n bundleName:bn])

@interface DYResourceLoader : NSObject

+(NSBundle *)bundleName:(NSString *)bundleName;

+(UIImage *)imgWithName:(NSString *)name bundleName:(NSString *)bundleName;

@end
