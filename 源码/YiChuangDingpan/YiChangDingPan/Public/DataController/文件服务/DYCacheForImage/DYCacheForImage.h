//
//  DYCacheForImage.h
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/11/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CFIImageCommon= 0,
    CFIImageONE_PIC,
} CFIImageTypeEnum;//可缓存的图片来源

static NSString *CFIimgArr[2] = {
    @"Common",
    @"ONE_PIC"
};

@interface DYCacheForImage : NSObject
//读取缓存图片
+(void)loadImgByUrl:(NSString *)imgUrl withType:(CFIImageTypeEnum)type imgData:(void(^)(id data))imgData;

//删除缓存图片
+(BOOL)deleteCacheByType:(CFIImageTypeEnum)type;

//删除所有缓存图片
+(BOOL)deleteAllCache;

@end
