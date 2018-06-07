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
//  DYCustomFreshHeader.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/6/20.
//

#import <Foundation/Foundation.h>
#import "DYGifFreshHeader.h"
@interface DYCustomFreshHeader : NSObject

+ (DYGifFreshHeader *)loadingYanFreshHeaderWithBolck:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshHeader *)loadingRoboFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshHeader *)loadingWriteFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshHeader *)loadingBookFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
//iir icon load
+ (DYGifFreshHeader *)loadingIcon:(BOOL)blue FreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
@end


@interface DYCustomFreshFooter : NSObject

+ (DYGifFreshFooter *)loadingYanFreshHeaderWithBolck:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshFooter *)loadingRoboFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshFooter *)loadingWriteFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;
+ (DYGifFreshFooter *)loadingBookFreshHeader:(MJRefreshComponentRefreshingBlock)bolck;

@end
