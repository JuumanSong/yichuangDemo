//
//  DYCacheForImage.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/11/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYCacheForImage.h"
#import "EncryptStringUtil.h"
#import "DYBaseCacheData.h"

@implementation DYCacheForImage


+(void)loadImgByUrl:(NSString *)imgUrl withType:(CFIImageTypeEnum)type imgData:(void(^)(id data))imgData{
    NSString *imgType = CFIimgArr[type];
    if(imgUrl && imgUrl.length>0){
        NSString *trueUrl = [EncryptStringUtil verifyChineseUrlStr:imgUrl];
        NSString *urlMD5 = [EncryptStringUtil md5:trueUrl];
        NSString *key = [NSString stringWithFormat:@"%@/%@/%@",CK_NetImage,imgType,urlMD5];
        __block NSData *data = loadFromCache(key);
        if(data){
            imgData(data);
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imgurl = [NSURL URLWithString:trueUrl];
                NSData *idata = [NSData dataWithContentsOfURL:imgurl];
                if(idata){
                    saveToCache(key, idata);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgData(idata);
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgData(nil);
                    });
                }
            });
        }
    }
}

+(BOOL)deleteCacheByType:(CFIImageTypeEnum)type{
    NSString *imgType = CFIimgArr[type];
    NSString *path = [NSString stringWithFormat:@"%@/%@",CK_NetImage,imgType];
    NSString *filePath = [DYBaseCacheData getPathBySubpath:path];
    return [JMCacheUtil removeDataAtPath:filePath];
}

+(BOOL)deleteAllCache{
    NSString *filePath = [DYBaseCacheData getPathBySubpath:CK_NetImage];
    return [JMCacheUtil removeDataAtPath:filePath];
}

@end
