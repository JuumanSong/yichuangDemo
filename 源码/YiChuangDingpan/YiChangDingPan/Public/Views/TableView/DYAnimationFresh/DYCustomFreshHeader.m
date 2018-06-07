/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYCustomFreshHeader.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/6/20.
//

#import "DYCustomFreshHeader.h"

@implementation DYCustomFreshHeader

+ (DYGifFreshHeader *)loadingYanFreshHeaderWithBolck:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshHeader *header = [DYGifFreshHeader headerWithRefreshingBlock:bolck];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.gifInCenter = YES;

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }

    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return header;
}

+ (DYGifFreshHeader *)loadingRoboFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshHeader *header = [DYGifFreshHeader headerWithRefreshingBlock:bolck];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.gifInCenter = YES;

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return header;

}

+ (DYGifFreshHeader *)loadingWriteFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshHeader *header = [DYGifFreshHeader headerWithRefreshingBlock:bolck];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.gifInCenter = YES;

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return header;

}

+ (DYGifFreshHeader *)loadingBookFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshHeader *header = [DYGifFreshHeader headerWithRefreshingBlock:bolck];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return header;

}


+ (DYGifFreshHeader *)loadingIcon:(BOOL)blue FreshHeader:(MJRefreshComponentRefreshingBlock)bolck {
    DYGifFreshHeader *header = [DYGifFreshHeader headerWithRefreshingBlock:bolck];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.hideStatusLab = YES;
    header.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    NSString *suffix = blue?@"_b":@"";
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"iir_head_load%zd%@",i,suffix];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
//    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages duration:1 forState:MJRefreshStateRefreshing];
    return header;
}

@end

@implementation DYCustomFreshFooter
+ (DYGifFreshFooter *)loadingYanFreshHeaderWithBolck:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshFooter *footer = [DYGifFreshFooter footerWithRefreshingBlock:bolck];
    footer.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:idleImages forState:MJRefreshStatePulling];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return footer;
    
}

+ (DYGifFreshFooter *)loadingRoboFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshFooter *footer = [DYGifFreshFooter footerWithRefreshingBlock:bolck];
    footer.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:idleImages forState:MJRefreshStatePulling];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return footer;
}

+ (DYGifFreshFooter *)loadingWriteFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshFooter *footer = [DYGifFreshFooter footerWithRefreshingBlock:bolck];
    footer.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:idleImages forState:MJRefreshStatePulling];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return footer;
}

+ (DYGifFreshFooter *)loadingBookFreshHeader:(MJRefreshComponentRefreshingBlock)bolck
{
    DYGifFreshFooter *footer = [DYGifFreshFooter footerWithRefreshingBlock:bolck];
    footer.gifInCenter = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=16; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"loading%zd", i];
        UIImage *image = DY_ImgLoader(tmpStr, @"YiChuangLibrary");
        [idleImages addObject:image];
    }
    
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:idleImages forState:MJRefreshStatePulling];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    
    return footer;
}

@end
