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
//  UITableView+fresh.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "DYCustomFreshHeader.h"

typedef void (^freshBlock)(void);

@interface UITableView (fresh)
/**
 * @author zhizhong.zhou
 *
 * 下拉刷新，上拉刷新
 *
 * @param block 加载数据
 */
- (void)addHeadFreshWithBlock:(freshBlock)block;
- (void)addFootFreshWithBlock:(freshBlock)block;

//没有更多数据
- (void)noMoreData;
- (void)hasMoreData;

/**
 * @author zhizhong.zhou
 *
 * 结束刷新
 */
- (void)endHeadFreshing;
- (void)endFooterFreshing;
- (void)endFreshing;

@end



/**
 *	@brief	talbeView上无数据提示
 */
@interface UITableView (NoneDataShow)

/**
 *	@brief	为空时展示文字
 *
 *	@param 	emptyFlag 是否为空的标志
 *	@param 	string    为空时显示的文字
 */
- (void)reloadWithEmpty:(BOOL)emptyFlag
         withShowString:(NSString*)string;


@end

@interface UITableView (CustomGIF)

#pragma mark - head动画刷新
//带研字旋转的head动画刷新
- (void)addHeadYanFreshWithBlock:(freshBlock)block;
//带吃萝卜的head动画刷新
- (void)addHeadRoboFreshWithBlock:(freshBlock)block;
//带写字的head动画刷新
- (void)addHeadWriteFreshWithBlock:(freshBlock)block;
//带本子的head动画刷新
- (void)addHeadBookFreshWithBlock:(freshBlock)block;
//icon动画刷新
- (void)addHeadIcon:(BOOL)blue FreshWithBlock:(freshBlock)block;

#pragma mark - foot动画刷新
//带研字旋转的foot动画刷新
- (void)addFootYanFreshWithBlock:(freshBlock)block;
//带吃萝卜的foot动画刷新
- (void)addFootRoboFreshWithBlock:(freshBlock)block;
//带写字的foot动画刷新
- (void)addFootWriteFreshWithBlock:(freshBlock)block;
//带本子的foot动画刷新
- (void)addFootBookFreshWithBlock:(freshBlock)block;
@end

