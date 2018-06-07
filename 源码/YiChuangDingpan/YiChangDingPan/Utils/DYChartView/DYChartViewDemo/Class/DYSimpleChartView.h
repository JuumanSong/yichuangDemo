//
//  DYSimpleChartView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/25.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYChartItemView.h"
#import "DYChartBarView.h"
#import "DYIndexPath.h"

@protocol DYSimpleChartViewDataSource <NSObject>

/**
 *	@brief	返回图的种类
 *
 *	@return	返回图的种类
 */
- (EDYChartItemViewType)chartItemType;

/**
 *	@brief	返回数据条目数
 *
 *	@return	返回条目数
 */
- (NSUInteger)countOfData;

/**
 *	@brief	返回指定游标位置的数据值
 *
 *	@param 	index 	游标位置
 *
 *	@return	返回指定游标位置的数据值
 */
- (CGFloat)dataValueAtIndex:(NSUInteger)index;

/**
 *	@brief	返回指定游标位置的线颜色
 *
 *	@param 	index 	游标位置
 *
 *	@return	返回指定游标位置的线颜色
 */
- (UIColor*)lineColorAtIndex:(NSUInteger)index;

@optional
- (UIColor*)lineColorAtIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	返回指定游标位置的填充颜色
 *
 *	@param 	index 	游标位置
 *
 *	@return	返回指定游标位置的填充颜色
 */
- (UIColor*)fillColorAtIndex:(NSUInteger)index;
@optional
- (UIColor*)fillColorAtIndexPath:(DYIndexPath*)indexPath;

@end

@interface DYSimpleChartView : UIView <DYChartItemViewDataSource, DYChartBarViewDataSource>

/**
 *	@brief	数据源
 */
@property (nonatomic, weak)id<DYSimpleChartViewDataSource> dataSource;

/**
 *	@brief	图底部与最低点之间的区域占整个图的比例
 */
@property (nonatomic)CGFloat bottomGapPercent;

/**
 *	@brief	图顶部与最高点之间的区域占整个图的比例
 */
@property (nonatomic)CGFloat topGapPercent;

/**
 *	@brief	是否画分隔线
 */
@property (nonatomic)BOOL drawSeparateLines;

/**
 *	@brief	手动重新加载数据，设置dataSource时，会自动重新加载
 */
- (void)reloadData;

/**
 *	@brief	可设置动画标记的重新加载数据
 *
 *	@param 	animation 	YES为展示动画；NO为不展示动画
 */
- (void)reloadDataWithAnimation:(BOOL)animation;

@end
