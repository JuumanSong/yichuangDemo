//
//  DYDataAdapterBase.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/26.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DYDataAdapterFactory.h"
#import "DYIndexPath.h"

typedef NS_OPTIONS(NSUInteger, DataAdapterAdjustMethod) {
    adjustByTranslation = 1 << 0,           // 通过平移实现
    adjustByZoom        = 1 << 1,           // 通过缩放实现
};

@class DYDataAdapterBase;

@protocol DYDataAdapterDataSource <NSObject>

/**
 *	@brief	在某个chartView上需要绘制图形的个数
 *
 *	@param 	dataAdapter 	指定chartView
 *
 *	@return	返回绘制图形的个数
 */
- (NSUInteger)countOfChartItemViewForDataAdapter:(DYDataAdapterBase*)dataAdapter;

/**
 *	@brief	在某个dataAdapter上指定序号图形最终需要展示的数据条目总数
 *
 *	@param 	dataAdapter 	指定dataAdapter
 *	@param 	index 	指定序号
 *
 *	@return	返回最终需要展示的数据条目总数
 */
- (NSUInteger)countOfDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                atIndex:(NSUInteger)index;

/**
 *	@brief	获取指定dataAdapter中指定chartItemView的有效数据的范围
 *
 *	@param 	dataAdapter 	指定dataAdapter
 *	@param 	index 	指定chartItemView的位置
 *
 *	@return	返回指定dataAdapter中指定chartItemView的有效数据的范围
 */
- (NSRange)rangeOfValidDataForDataAdapter:(DYDataAdapterBase*)dataAdapter
                                  atIndex:(NSUInteger)index;

/**
 *	@brief	获取dataAdapter在指定位置上的数据值
 *
 *	@param 	dataAdapter 	指定dataAdapter
 *	@param 	indexPath 	指定图形的指定位置
 *
 *	@return	返回dataAdapter在指定位置上的数据值(K线图返回DYChartCandleDataItem条目，其他返回NSNumber)
 */
- (id)dataValueForDataAdapter:(DYDataAdapterBase*)dataAdapter
                  atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	获取dataAdapter在指定位置上的X方向上的数据值
 *
 *	@param 	dataAdapter 	指定dataAdapter
 *	@param 	indexPath 	指定图形的指定位置
 *
 *	@return	返回dataAdapter在指定位置上的X方向上的数据值
 */
@optional
- (id)dataXValueForDataAdapter:(DYDataAdapterBase*)dataAdapter
                   atIndexPath:(DYIndexPath*)indexPath;

/**
 *	@brief	数据唯一标识
 *
 *	@param 	dataAdapter 	指定dataAdapter
 *	@param 	index 	指定位置
 *
 *	@return	返回数据唯一标识
 */
- (NSString *)dataUUIDForDataAdapter:(DYDataAdapterBase*)dataAdapter atIndex:(NSUInteger)index;

@end

@interface DY125RuleInputParameters : NSObject

@property (nonatomic)CGFloat minValue;              // 输入的最小值
@property (nonatomic)CGFloat maxValue;              // 输入的最大值
@property (nonatomic)NSInteger yPartCount;          // 推荐的Y轴方向的分区数目
@property (nonatomic)BOOL isFix;                    // 是否允许调整Y轴方向的分区数目（如果允许，则可以更大程度上保证图形的Y轴方向上的振幅）
@property (nonatomic)BOOL isYZeroInMiddleFlag;      // y轴上0值是否在中间
@property (nonatomic)CGFloat canvasHeight;          // 整个绘制区域的高度

@end

@interface DYFixDataBy125RuleResult : NSObject

/**
 *	@brief	计算后得到的最小值
 */
@property (nonatomic)CGFloat minValue;

/**
 *	@brief	计算后的到的最大值
 */
@property (nonatomic)CGFloat maxValue;

/**
 *	@brief	计算后得到的y为0的位置
 */
@property (nonatomic)CGFloat yZeroPosition;

/**
 *	@brief	计算后得到的y方向的分块数
 */
@property (nonatomic)CGFloat yPartCount;

@end

@interface DY125InputAndResultPair : NSObject

@property (nonatomic, strong)DY125RuleInputParameters *inputParam;
@property (nonatomic, strong)DYFixDataBy125RuleResult *result;

@end

@class DYComplexChartView;
@interface DYDataAdapterBase : NSObject

#pragma mark - in property

/**
 *	@brief	标识
 */
@property (nonatomic)NSInteger tag;

/**
 *	@brief	这个适配器的类型
 */
@property (nonatomic, readonly)DataAdapterType adapterType;

/**
 *	@brief	适配器附着在的chartView
 */
@property (nonatomic, weak)UIView<DYDataAdapterDataSource>* chartView;

/**
 *	@brief	画布宽度
 */
@property (nonatomic)CGFloat canvasWidth;

/**
 *	@brief	画布高度
 */
@property (nonatomic)CGFloat canvasHeight;

/**
 *	@brief	图底部与最低点之间的区域占整个图的比例
 */
@property (nonatomic)CGFloat bottomGapPercent;

/**
 *	@brief	图顶部与最高点之间的区域占整个图的比例
 */
@property (nonatomic)CGFloat topGapPercent;

/**
 *	@brief	是否画Y值为0的线
 */
@property (nonatomic)BOOL drawYZeroLines;

/**
 *	@brief	y轴为0时，x轴在左侧y轴上的偏移
 */
@property (nonatomic)CGFloat yZeroPosition;

/**
 *	@brief	y轴为0时，x轴在右侧y轴上的偏移
 */
@property (nonatomic)CGFloat yRightZeroPosition;

/**
 *	@brief	Y值为0的X方向的虚线是否在中间
 */
@property (nonatomic)BOOL yZeroInMiddle;

/**
 *	@brief	X 轴上分几格
 */
@property (nonatomic)NSUInteger xPartCount;

/**
 *	@brief	Y 轴上分几格
 */
@property (nonatomic)NSUInteger yPartCount;

/**
 *	@brief	右侧Y轴上分几格
 */
@property (nonatomic)NSUInteger yRightPartCount;

/**
 *	@brief	X 轴上一个大格分几个小格
 */
@property (nonatomic)NSUInteger xSubPartCount;

/**
 *	@brief  Y 轴上一个大格分几个小格
 */
@property (nonatomic)NSUInteger ySubPartCount;

/**
 *	@brief	右侧Y轴上分几格
 */
@property (nonatomic)NSUInteger yRightSubPartCount;

/**
 *	@brief	通过平移还是缩放实现数据的适配
 */
@property (nonatomic)DataAdapterAdjustMethod adjustMethod;

/**
 *	@brief	不使用125法则
 */
@property (nonatomic)BOOL notFixDataWith125Rule;

/**
 *	@brief	右侧Y轴只显示整数（会影响yRightPartCount）
 */
@property (nonatomic)BOOL yRightJustShowIntegerNumber;

/**
 *	@brief	左侧Y轴只显示整数（会影响yPartCount）
 */
@property (nonatomic)BOOL yLeftJustShowIntegerNumber;

#pragma mark - out property

/**
 *	@brief	x方向的最小值
 */
@property (nonatomic)CGFloat minX;

/**
 *	@brief	x方向的最大值
 */
@property (nonatomic)CGFloat maxX;

/**
 *	@brief	y方向的最小值
 */
@property (nonatomic)CGFloat minY;

/**
 *	@brief	y方向的最大值
 */
@property (nonatomic)CGFloat maxY;

/**
 *	@brief	右侧y方向的最小值
 */
@property (nonatomic)CGFloat minRightY;

/**
 *	@brief	右侧y方向的最大值
 */
@property (nonatomic)CGFloat maxRightY;

/**
 *	@brief	计算出来X方向上的原始缩放比
 */
@property (nonatomic)CGFloat originalZoomX;

/**
 *	@brief	计算出来左侧Y轴上的原始缩放比
 */
@property (nonatomic)CGFloat originalZoomY;

/**
 *	@brief	计算出来右侧Y轴上的原始缩放比
 */
@property (nonatomic)CGFloat originalRightZoomY;

/**
 *	@brief	保留字段
 */
@property (nonatomic)CGFloat reserveValue;

/**
 *	@brief	放每个chartItemView X 方向最小值的容器，按序存放
 */
@property (nonatomic, strong)NSMutableArray* minYArray;

/**
 *	@brief	放每个chartItemView Y 方向最大值的容器，按序存放
 */
@property (nonatomic, strong)NSMutableArray* maxYArray;

/**
 *	@brief	放每个chartItemView X 方向最小值的容器，按序存放
 */
@property (nonatomic, strong)NSMutableArray* minXArray;

/**
 *	@brief	放每个chartItemView X 方向最大值的容器，按序存放
 */
@property (nonatomic, strong)NSMutableArray* maxXArray;


/**
 *	@brief	第一个起始点的Y值，为合并起始点做准备
 */
@property (nonatomic, strong)NSMutableArray* startYArray;

/**
 *	@brief	重新计算X最大值，使得X轴上的描述值恰好吻合坐标
 */
@property (nonatomic)BOOL redesignMaxX;

/**
 *	@brief	x轴是否不是连续的整数，如果是连续整数，最大最小值就不用计算了
 */
@property (nonatomic)BOOL xAxisIsNotContinueIntIndex;

/**
 *	@brief	数据适配
 */
- (void)adapterData;

/**
 *	@brief	在特定区域调整Y轴方向缩放比例时需要调用的方法
 *
 *	@param 	startIndex 	区域的起始Index
 *	@param 	endIndex 	区域的结束Index
 */
- (void)adapterDataWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex;

/**
 *	@brief	计算指定区域的最大最小值
 *
 *	@param 	startIndex 	区域的起始Index
 *	@param 	endIndex 	区域的结束Index
 *
 *	@return	返回YES表示计算有效；返回NO表示计算无效，计算有效时计算出来的数据才有参考意义
 */
- (BOOL)calcMinMaxValueWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex;

/**
 *	@brief	根据当前数据的最大最小值在间隔满足125法则的情况下，重新计算最大最小值
 *
 *	@param 	minValue 	输入的最小值
 *	@param 	maxValue 	输入的最大值
 *	@param 	yPartCount 	推荐的Y轴方向的分区数目
 *	@param 	isFix 	是否允许调整Y轴方向的分区数目（如果允许，则可以更大程度上保证图形的Y轴方向上的振幅）
 *	@param 	isYZeroInMiddleFlag 	y轴上0值是否在中间
 *	@param 	canvasHeight 	整个绘制区域的高度
 *
 *	@return	返回运算后的结果
 */
+ (DYFixDataBy125RuleResult*)fixDataBy125RuleWithMinValue:(CGFloat)minValue
                                              andMaxValue:(CGFloat)maxValue
                                     andDefaultYPartCount:(NSInteger)yPartCount
                                      andFixPartCountFlag:(BOOL)isFix
                                       andIsYZeroInMiddle:(BOOL)isYZeroInMiddleFlag
                                          andCanvasHeight:(CGFloat)canvasHeight;

/**
 *	@brief	获取X方向上最佳最大值
 *
 *	@param 	minValue 	当前最小值
 *	@param 	maxValue 	当前最大值
 *
 *	@return	返回X方向上最佳最大值
 */
- (CGFloat)getMaxXDataWithMinX:(CGFloat)minValue andMaxV:(CGFloat)maxValue;

#pragma mark - 子类可覆盖这些函数

/**
 *	@brief	获取指定序号图形在X方向的缩放系数
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号图形在X方向的缩放系数
 */
- (CGFloat)xZoomValueForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号图形在左侧Y方向的缩放系数
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号图形在左侧Y方向的缩放系数
 */
- (CGFloat)yZoomValueForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号的以左侧Y轴为单位的图形的偏移
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号的以左侧Y轴为单位的图形的偏移
 */
- (CGFloat)yOffsetForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号图形在右侧Y方向的缩放系数
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号图形在右侧Y方向的缩放系数
 */
- (CGFloat)yRightZoomValueForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号的以右侧Y轴为单位的图形的偏移
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号的以右侧Y轴为单位的图形的偏移
 */
- (CGFloat)yRightOffsetForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号的以左侧Y轴为单位的图形的最小值
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号的以左侧Y轴为单位的图形的最小值
 */
- (CGFloat)yMinValueForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	获取指定序号的以右侧Y轴为单位的图形的最小值
 *
 *	@param 	index 	指定序号
 *
 *	@return	返回指定序号的以右侧Y轴为单位的图形的最小值
 */
- (CGFloat)yRightMinValueForChartItemViewAtIndex:(NSUInteger)index;

/**
 *	@brief	只设置yPartCount，供子类调用
 *
 *	@param 	yPartCount 	需要设置的值
 */
- (void)setJustYPartCount:(NSInteger)yPartCount;

/**
 *	@brief	只设置yRightPartCount，供子类调用
 *
 *	@param 	yRightPartCount 	需要设置的值
 */
- (void)setJustYRightPartCount:(NSInteger)yRightPartCount;

@end
