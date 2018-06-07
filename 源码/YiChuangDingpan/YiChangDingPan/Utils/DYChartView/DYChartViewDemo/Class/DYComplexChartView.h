//
//  DYComplexChartView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/25.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYXAxisView.h"
#import "DYYAxisView.h"
#import "DYMaskView.h"
#import "DYChartItemView.h"
#import "DYDataAdapterBase.h"
#import "DYIndexPath.h"

@class DYComplexChartView;

@protocol DYComplexChartViewDelegate <NSObject>

@optional
/**
 *	@brief	单个手指在滑动时的回调
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定图形的序号
 *	@param 	position 	对应指定的图形数据的位置
 */
- (void)oneFingerInChartView:(DYComplexChartView*)chartView
                     atIndex:(NSUInteger)index
             pressAtPosition:(NSUInteger)position;

/**
 *	@brief	双指滑动时的回调
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定图形的需要
 *	@param 	fromPosition 	对应指定图形起点的数据的位置
 *	@param 	toPosition 	对应指定图形终点的数据位置
 */
- (void)twoFingerInChartView:(DYComplexChartView*)chartView
                     atIndex:(NSUInteger)index
                fromPosition:(NSUInteger)fromPosition
                  toPosition:(NSUInteger)toPosition;

/**
 *	@brief	触摸事件结束时的回调
 *
 *	@param 	chartView 	指定chartView
 */
- (void)touchEndedAtChartView:(DYComplexChartView*)chartView;

/**
 *	@brief	单指单击chartView
 *
 *	@param 	chartView 	指定chartView
 */
- (void)oneFingerSingleTapInChartView:(DYComplexChartView *)chartView;

/**
 *	@brief	图形已滚动到最左侧
 *
 *	@param 	chartView 	指定chartView
 */
- (void)panChartViewToLeftTop:(DYComplexChartView *)chartView;

/**
 *	@brief	图形已滚动到最右侧
 *
 *	@param 	chartView 	指定chartView
 */
- (void)panChartViewToRightTop:(DYComplexChartView *)chartView;

/**
 *	@brief	手指捏合时，缩放在原比例上的放大倍数
 *
 *	@param 	chartView 	指定chartView
 *	@param 	zoomLevel 	缩放系数
 */
- (void)chartView:(DYComplexChartView *)chartView xZoomOutLevelChanged:(CGFloat)zoomLevel;

@end

@protocol DYComplexChartViewDataSource <NSObject>

/**
 *	@brief	在某个chartView上需要绘制图形的个数
 *
 *	@param 	chartView 	指定chartView
 *
 *	@return	返回绘制图形的个数
 */
- (NSUInteger)countOfChartItemViewForChartView:(DYComplexChartView*)chartView;

/**
 *	@brief	在某个chartView上指定序号图形的类型
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	返回图形的类型
 */
- (EDYChartItemViewType)chartItemViewTypeForChartView:(DYComplexChartView*)chartView
                                            atIndex:(NSUInteger)index;

/**
 *	@brief	指定某个chartView上指定需要图形数据值显示在左侧或右侧的Y轴上
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	eShowAtLeft显示在左侧；eShowAtRight显示在右侧
 */
- (EDYShowValueSide)valueBasedOnSideForChartView:(DYComplexChartView*)chartView
                                       atIndex:(NSUInteger)index;

/**
 *	@brief	在某个chartView上指定序号图形最终需要展示的数据条目总数
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	返回最终需要展示的数据条目总数
 */
- (NSUInteger)countOfDataForChartView:(DYComplexChartView*)chartView
                              atIndex:(NSUInteger)index;

/**
 *	@brief	在某个chartView上指定序号图形当前能展示的有效数据条目数
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	返回当前能展示的有效数据条目数
 */
- (NSUInteger)countOfValidDataForChartView:(DYComplexChartView*)chartView
                                   atIndex:(NSUInteger)index;

/**
 *	@brief	在某个chartView上指定图形指定位置的值
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定图形的指定位置
 *
 *	@return	返回数据值
 */
- (id)dataValueForChartView:(DYComplexChartView*)chartView
                atIndexPath:(DYIndexPath*)indexPath;

@optional
/**
 *	@brief	在某个chartView上指定位置的x方向上的值
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定图形的指定位置
 *
 *	@return	返回数据x方向上的值
 */
- (id)dataXValueForChartView:(DYComplexChartView*)chartView
                 atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	返回数据唯一标识，用户缓存运算结果
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定图形
 *
 *	@return	返回数据唯一标识
 */
- (NSString *)dataUUIDForForChartView:(DYComplexChartView*)chartView atIndex:(NSInteger)index;

/**
 *	@brief	在某个chartView上指定序号图形的线颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	返回指定chartView上指定序号图形的线颜色
 */
@required
- (UIColor*)lineColorForChartView:(DYComplexChartView*)chartView
                          atIndex:(NSUInteger)index;
@optional
/**
 *	@brief	在某个chartView上指定序号图形指定位置的线颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定图形，指定位置
 *
 *	@return	返回线颜色
 */
- (UIColor*)lineColorForChartView:(DYComplexChartView*)chartView
                      atIndexPath:(DYIndexPath*)indexPath;

@required
/**
 *	@brief	在某个chartView上指定序号图形的填充颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定序号
 *
 *	@return	返回指定chartView上指定序号图形的填充颜色
 */
- (UIColor*)fillColorForChartView:(DYComplexChartView*)chartView
                          atIndex:(NSUInteger)index;

@optional
/**
 *	@brief	在某个chartView上指定序号图形指定位置的填充颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定序号
 *
 *	@return	返回指定chartView上指定序号图形的填充颜色
 */
- (UIColor*)fillColorForChartView:(DYComplexChartView*)chartView
                      atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	在某个chartView上指定位置的X轴显示的内容(大刻度)
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定的位置
 *
 *	@return	返回显示的内容
 */
- (NSString*)xDescriptionForChartView:(DYComplexChartView*)chartView
                              atIndex:(NSUInteger)index;

/**
 *	@brief	在某个chartView上指定位置的Y轴显示的内容(大刻度)
 *
 *	@param 	chartView 	指定chartView
 *	@param 	indexPath 	指定的位置
 *
 *	@return	返回显示的内容
 */
- (NSString*)yDescriptionForChartView:(DYComplexChartView*)chartView
                          atIndexPath:(DYIndexPath*)indexPath;

@optional
/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的字体数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回字体数组
 */
- (UIFont*)yColorTipsFontForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的颜色数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回图形数组
 */
- (NSArray*)yColorTipsColorForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中提示文字前是否显示标识颜色的小圆圈的开关
 *
 *	@param 	chartView 	指定chartV
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回YES标识显示小圆圈，返回NO标识不显示小圆圈
 */
- (BOOL)ifDrawPointBeforeYColorTipsForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的字体
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回颜色数组
 */
- (UIFont*)yTipsFontForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的颜色数组
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回颜色数组
 */
- (NSArray*)yTipsColorForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中日期字段的颜色
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回颜色
 */
- (UIColor*)colorOfTipsForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定图形POP提示框中日期字段的字体
 *
 *	@param 	chartView 	指定chartView
 *	@param 	index 	指定chartItemView
 *
 *	@return	返回字体
 */
- (UIFont*)fontForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;


- (NSDictionary *)dictionaryForShowViewValue:(DYComplexChartView*)chartView
                                     atIndex:(NSUInteger)index;

/**
 *    @brief    获取指定图形数值点上是否画圆圈
 *
 *    @param     chartView     指定chartView
 *    @param     index     指定chartItemView
 *
 *    @return    返回是否画圆圈
 */
- (BOOL)drawArcFlagForChartView:(DYComplexChartView*)chartView atIndex:(NSUInteger)index;

@end

@class DYDataAdapterBase;
@interface DYComplexChartView : UIView <DYDataAdapterDataSource>

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

/**
 *	@brief	遮罩层
 */
@property (nonatomic, strong)DYMaskView* maskView;

/**
 *	@brief	事件处理代理
 */
@property (nonatomic, weak)id<DYComplexChartViewDelegate> delegate;

/**
 *	@brief	数据源
 */
@property (nonatomic, weak)id<DYComplexChartViewDataSource> dataSource;

/**
 *	@brief	专门用于处理数据使得图形满足需求的数据适配器
 */
@property (nonatomic, strong)DYDataAdapterBase* dataAdapter;

/**
 *	@brief	画 Y 方向的虚线
 */
@property (nonatomic)BOOL drawYDashedLines;

/**
 *	@brief	画 X 方向的虚线
 */
@property (nonatomic)BOOL drawXDashedLines;

/**
 *	@brief	是否动态调整Y轴比例使得当前显示区域的振幅保持最大
 */
@property (nonatomic)BOOL autoResizeYZoom;

/**
 *	@brief	是否填充曲线图数据
 */
@property (nonatomic)BOOL fillFlag;

/**
 *	@brief	是否画曲线图上数据圆点
 */
@property (nonatomic)BOOL drawArcFlag;

/**
 *	@brief	是否画手势线上的圆圈
 */
@property (nonatomic)BOOL notDrawMaskArcFlag;

/**
 *	@brief	展示右边Y轴
 */
@property (nonatomic)BOOL showRightYAxisFlag;

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

/**
 *	@brief	手指捏合的时候，最大的X轴方向上的最大放大倍数
 */
@property (nonatomic)CGFloat maxXZoomValue;

/**
 *	@brief	手指捏合的时候，最大的X轴方向上的最小放大倍数
 */
@property (nonatomic)CGFloat minXZoomValue;

/**
 *	@brief	一个分组里bar的个数
 */
@property (nonatomic)NSInteger barCountInGroup;

/**
 *	@brief	x描述开始的位置
 */
@property (nonatomic)NSInteger xDescriptionBeginIndex;

/**
 *	@brief	存放chartItemView的数组
 */
@property (nonatomic, strong)NSArray* chartItemViews;

#pragma mark - functions

/**
 *	@brief	重新加载数据，默认显示动画
 */
- (void)reloadData;

/**
 *	@brief	重新加载数据，可选择是否显示动画
 *
 *	@param 	animation 	YES表示有动画，NO表示没有动画
 */
- (void)reloadDataWithAnimation:(BOOL)animation;

/**
 *	@brief	x方向上放大数据
 *
 *	@param 	zoomX 	放大比
 */
- (void)redrawChartItemWithZoomX:(CGFloat)zoomX;

/**
 *	@brief	设置手势冲突ScrollView
 *
 *	@param 	conflictView 	手势冲突的ScrollView
 */
- (void)setGestureConflictView:(UIScrollView*)conflictView;

/**
 *	@brief	重新计算子View的frame
 */
- (void)resizeSubViews;

/**
 *	@brief	显示正在加载的浮层
 *
 *	@param 	show 	YES为显示，NO为不显示
 *	@param 	loadingString 	浮层显示文字的内容，传nil时显示"正在加载..."
 */
- (void)showLoading:(BOOL)show withText:(NSString*)loadingString;

- (void)showTipsView:(BOOL)show withText:(NSString*)tipsString;

/**
 *    @brief    获取某一个图形的某一个点在ChartView上的位置
 *
 *    @param     indexPath     indexPath.section表示第几个图，index.row表示图上第几个点
 *
 *    @return    返回点的Point
 */
- (CGPoint)getDrawPointForChartViewAtIndexPath:(NSIndexPath *)indexPath;

///private Method
@property (nonatomic)CGRect canvasRect;

- (void)setupBasicProperty;
- (void)setupFixedSubViews;

- (NSInteger)numberOfScaleSections:(DYAxisView*)axisView;

@end
