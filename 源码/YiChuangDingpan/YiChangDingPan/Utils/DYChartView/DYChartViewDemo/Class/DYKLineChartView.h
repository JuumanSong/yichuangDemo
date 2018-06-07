//
//  DYKLineChartView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/6.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYChartItemViewFactory.h"
#import "DYDataAdapterBase.h"
#import "DYIndexPath.h"

@class DYKLineChartView;
@class DYYAxisView;
@class DYXAxisView;
@class DYMaskView;

typedef NS_OPTIONS(NSUInteger, EFixedViewItemType) {
    eFixedViewItemNone              = 0,                // 啥都不显示
    eFixedViewItemLeftYAxis         = 1 << 0,           // 左侧Y轴
    eFixedViewItemRightYAxis        = 1 << 1,           // 右侧Y轴
    eFixedViewItemXAxis             = 1 << 2,           // X轴
};

@interface SectionPositionInfo : NSObject

/**
 *	@brief	y轴的宽度
 */
@property (nonatomic)CGFloat yWidth;

/**
 *	@brief	y轴顶部在y方向上的偏移
 */
@property (nonatomic)CGFloat yTop;

/**
 *	@brief	y轴底部在y方向上的偏移
 */
@property (nonatomic)CGFloat yBottom;

/**
 *	@brief	x轴的高度
 */
@property (nonatomic)CGFloat xHeight;

/**
 *	@brief	x轴左侧在x方向上的偏移
 */
@property (nonatomic)CGFloat xLeft;

/**
 *	@brief	x轴右侧在x方向上的偏移
 */
@property (nonatomic)CGFloat xRight;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SectionFixedSubViewsInfo : NSObject

/**
 *	@brief	左侧的Y轴
 */
@property (nonatomic, strong)DYYAxisView* leftYAxisView;

/**
 *	@brief	右侧的Y轴
 */
@property (nonatomic, strong)DYYAxisView* rightYAxisView;

/**
 *	@brief	X轴
 */
@property (nonatomic, strong)DYXAxisView* xAxisView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol DYKLineChartViewDelegate <NSObject>

@optional
/**
 *	@brief	单个手指在滑动时的回调
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定图形的序号
 *	@param 	position 	对应指定的图形数据的位置
 */
- (void)oneFingerInChartView:(DYKLineChartView*)chartView
                 atIndexPath:(DYIndexPath*)indexPath
             pressAtPosition:(NSUInteger)position;

/**
 *	@brief	双指滑动时的回调
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定图形的需要
 *	@param 	fromPosition 	对应指定图形起点的数据的位置
 *	@param 	toPosition 	对应指定图形终点的数据位置
 */
- (void)twoFingerInChartView:(DYKLineChartView*)chartView
                 atIndexPath:(DYIndexPath*)indexPath
                fromPosition:(NSUInteger)fromPosition
                  toPosition:(NSUInteger)toPosition;

/**
 *	@brief	触摸事件结束时的回调
 *
 *	@param 	chartView 	指定chartView
 */
- (void)touchEndedAtChartView:(DYKLineChartView*)chartView;

/**
 *	@brief	图形已滚动到最左侧
 *
 *	@param 	chartView 	指定chartView
 */
- (void)panChartViewToLeftTop:(DYKLineChartView *)chartView;

/**
 *	@brief	图形已滚动到最右侧
 *
 *	@param 	chartView 	指定chartView
 */
- (void)panChartViewToRightTop:(DYKLineChartView *)chartView;

/**
 *	@brief	手指捏合时，缩放在原比例上的放大倍数
 *
 *	@param 	chartView 	指定chartView
 *	@param 	zoomLevel 	缩放系数
 */
- (void)chartView:(DYKLineChartView *)chartView xZoomOutLevelChanged:(CGFloat)zoomLevel;

/**
 *	@brief	单指单击chartView
 *
 *	@param 	chartView 	指定chartView
 */
- (void)oneFingerSingleTapInChartView:(DYKLineChartView *)chartView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol DYKLineChartViewDataSource <NSObject>

/**
 *	@brief	获取指定K线图一共分几个块
 *
 *	@param 	chartView 	指定K线图
 *
 *	@return	返回分块个数
 */
- (NSUInteger)sectionCountInKLineChartView:(DYKLineChartView*)chartView;

/**
 *	@brief	获取指定K线图上指定分块的数据适配器
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回分块个数
 */
- (DYDataAdapterBase*)dataAdapterForKLineChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定分块的frame
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定分块的frame
 */
- (CGRect)frameOfSectionInKLineChartView:(DYKLineChartView*)chartView
                                 atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定分块的位置参数
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定分块的位置参数
 */
- (SectionPositionInfo*)sectionPositionInKLineChartView:(DYKLineChartView*)chartView
                                                atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定section上chartItemView的个数
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定section上chartItemView的个数
 */
- (NSUInteger)countOfChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定位置的chartItemView在指定K线图上的类型
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定位置
 *
 *	@return	返回指定位置的chartItemView在指定K线图上的类型
 */
- (EDYChartItemViewType)viewTypeInKLineChartView:(DYKLineChartView*)chartView
                                     atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	指定K线图上指定位置的chartItemView在需要展示的数据条数
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定位置
 *
 *	@return	返回K线图上指定位置的chartItemView在需要展示的数据条数
 */
- (NSUInteger)countOfDataForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取有效数据所在的区间
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定位置
 *
 *	@return	返回有效数据所在的区间
 */
- (NSRange)rangeOfValidDataForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                                atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取K线图上指定位置的chartView在指定位置上的数据值
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定chartView的位置
 *	@param 	index 	指定数据位置
 *
 *	@return	返回K线图上指定位置的chartView在指定位置上的数据值(K线图返回DYChartCandleDataItem条目，其他返回NSNumber)
 */
- (id)dataValueForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                    atIndexPath:(DYIndexPath*)indexPath
                                    atDataIndex:(NSUInteger)index;

/**
 *	@brief	在某个chartView上指定位置的X轴显示的内容(大刻度)
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定的位置
 *
 *	@return	返回显示的内容
 */
- (NSString*)xDescriptionForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	在某个chartView上指定位置的Y轴显示的内容(大刻度)
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定的位置
 *
 *	@return	返回显示的内容
 */
- (NSString*)yDescriptionForChartItemViewInKLineChartView:(DYKLineChartView*)chartView
                                              atIndexPath:(DYIndexPath*)indexPath;

@optional
/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的字体数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回字体数组
 */
- (UIFont*)yColorTipsFontInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的颜色数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回图形数组
 */
- (NSArray*)yColorTipsColorInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中提示文字前是否显示标识颜色的小圆圈的开关
 *
 *	@param 	chartView 	指定chartV
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回YES标识显示小圆圈，返回NO标识不显示小圆圈
 */
- (BOOL)ifDrawPointBeforeYColorTipsInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的字体
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回颜色数组
 */
- (UIFont*)yTipsFontInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的颜色数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回颜色数组
 */
- (NSArray*)yTipsColorInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中日期字段的颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回颜色
 */
- (UIColor*)colorOfTipsInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定图形POP提示框中日期字段的字体
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定chartItemView
 *
 *	@return	返回字体
 */
- (UIFont*)fontInKLineChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;

// 显示的最小值
- (CGFloat)minValueForKLineChartView:(DYKLineChartView* )axisView;
// 显示的最大值
- (CGFloat)maxValueForKLineChartView:(DYKLineChartView* )axisView;
// 显示的最小幅度
- (CGFloat)minRangeValueForKLineChartView:(DYKLineChartView* )axisView;
// 显示的最大幅度
- (CGFloat)maxRangeValueForKLineChartView:(DYKLineChartView* )axisView;
// 获取指定图形数值点上是否画圆圈
- (BOOL)drawArcFlagForChartView:(DYKLineChartView*)chartView atIndexPath:(DYIndexPath*)indexPath;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DYKLineChartView : UIView <DYDataAdapterDataSource>

/**
 *	@brief	加载数据
 */
- (void)reloadData;

/**
 *	@brief	数据源
 */
@property (nonatomic, weak)IBOutlet id<DYKLineChartViewDataSource> dataSource;

/**
 *	@brief	时间处理delegate
 */
@property (nonatomic, weak)IBOutlet id<DYKLineChartViewDelegate> delegate;

/**
 *	@brief	maskView手势冲突View
 */
@property (nonatomic, weak)IBOutlet UIScrollView* gestureConflictView;


/**
 *	@brief	画 Y 方向的虚线
 */
@property (nonatomic)BOOL drawYDashedLines;

/**
 *	@brief	画 X 方向的虚线
 */
@property (nonatomic)BOOL drawXDashedLines;

/**
 *	@brief	在第一个section上，画一根中间的实线
 */
@property (nonatomic)BOOL drawXLineInMiddle;

/**
 *	@brief	K线图为YES，分时图为NO
 */
@property (nonatomic)BOOL kLineFlag;
/**
 *    @brief    线的宽度
 */
@property (nonatomic)CGFloat lineWidth;
/**
 *	@brief	遮罩层
 */
@property (nonatomic, strong)DYMaskView* maskView;

/**
 *	@brief	手指捏合的时候，最大的X轴方向上的最大放大倍数
 */
@property (nonatomic)CGFloat maxXZoomValue;

/**
 *	@brief	手指捏合的时候，最大的X轴方向上的最小放大倍数
 */
@property (nonatomic)CGFloat minXZoomValue;

/**
 *	@brief	当前的缩放值
 */
@property (nonatomic)CGFloat zoomValue;

/**
 *	@brief	存放每个section的固定的subView的数组
 */
@property (nonatomic, strong)NSArray* fixedSubViewsArray;

/**
 *	@brief	存放所有添加的chartItemView的数组
 */
@property (nonatomic, strong)NSArray* chartItemViewsArray;

/**
 *	@brief	x轴上显示刻度的偏移
 */
@property (nonatomic)NSInteger xMajorTextOffset;

/**
 *	@brief	YES为分钟线；NO为日K、周K或者月K
 */
@property (nonatomic)BOOL isTimeLine;

#pragma mark - 子类可覆盖实现的接口

/**
 *	@brief	获取指定K线图上指定位置的分块有那几个固定的View
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定位置的分块有那几个固定的View
 */
- (EFixedViewItemType)fixedViewItemTypeInChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定位置的分块的画布位置
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定位置的分块的画布位置
 */
- (CGRect)canvasRectOfSectionInChartView:(DYKLineChartView*)chartView
                                 atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定位置的分块的X轴位置
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定位置的分块的X轴位置
 */
- (CGRect)xAxisRectOfSectionInChartView:(DYKLineChartView*)chartView
                                atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定位置的分块的左侧Y轴位置
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定位置的分块的左侧Y轴位置
 */
- (CGRect)leftYAxisRectOfSectionInChartView:(DYKLineChartView*)chartView
                                    atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上指定位置的分块的右侧Y轴位置
 *
 *	@param 	chartView 	指定K线图
 *	@param 	index 	指定分块位置
 *
 *	@return	返回指定K线图上指定位置的分块的右侧Y轴位置
 */
- (CGRect)rightYAxisRectOfSectionInChartView:(DYKLineChartView*)chartView
                                     atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定K线图上遮罩层的位置
 *
 *	@param 	chartView 	指定K线图
 *
 *	@return	返回指定K线图上遮罩层的位置
 */
- (CGRect)maskViewRectOfSectionInChartView:(DYKLineChartView*)chartView;

/**
 *	@brief	获取指定K线图指定位置chartItemView的图形填充属性
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定chartItemView的位置
 *
 *	@return	返回指定K线图指定位置chartItemView的图形填充属性
 */
- (BOOL)fillFlagInChartView:(DYKLineChartView*)chartView
                atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定K线图指定位置chartItemView的线颜色
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定chartItemView的位置
 *
 *	@return	返回指定K线图指定位置chartItemView的线颜色
 */
- (UIColor*)lineColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取指定K线图指定位置chartItemView的填充颜色
 *
 *	@param 	chartView 	指定K线图
 *	@param 	indexPath 	指定chartItemView的位置
 *
 *	@return	返回指定K线图指定位置chartItemView的填充颜色
 */
- (UIColor*)fillColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath;

- (CGPoint)getDrawPointForChartViewAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;
@end
