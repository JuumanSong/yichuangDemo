//
//  DYChartBarView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYChartItemView.h"

#define MAX_BAR_WIDTH   128

@class DYChartBarView;
@protocol DYChartBarViewDataSource <NSObject>

/**
 *	@brief	返回指定游标位置的线颜色
 *
 *	@param 	index 	游标位置
 *
 *	@return	返回指定游标位置的线颜色
 */
- (UIColor*)lineColorForBarView:(DYChartBarView*)barView atIndex:(NSUInteger)index;

/**
 *	@brief	返回指定游标位置的填充颜色
 *
 *	@param 	index 	游标位置
 *
 *	@return	返回指定游标位置的填充颜色
 */
- (UIColor*)fillColorForBarView:(DYChartBarView*)barView atIndex:(NSUInteger)index;

@end

@interface DYChartBarView : DYChartItemView

/**
 *	@brief	建议的bar宽度
 */
@property (nonatomic)CGFloat barWidth;

/**
 *	@brief	数据源
 */
@property (nonatomic, weak)id<DYChartBarViewDataSource> barDataSource;

/**
 *	@brief	图层
 */
@property (nonatomic, strong)NSArray* layersArray;

@end
