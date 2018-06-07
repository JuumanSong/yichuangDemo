//
//  DYChartItemView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYMaskView.h"
#import "DYChartItemViewFactory.h"

typedef NS_ENUM(NSUInteger, EDYShowValueSide) {
    eDYShowAtLeft = 0,            // 值以左侧Y轴单位为准
    eDYShowAtRight,               // 值以右侧Y轴单位为准
};

@class DYChartItemView;

@protocol DYChartItemViewDataSource <NSObject>

/**
 *	@brief	返回指定图形最多要显示的数据条数
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回指定图形最多要显示的数据条数
 */
- (NSUInteger)countOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	返回指定图形最多要显示的数据里有效的数据条数
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回指定图形最多要显示的数据里有效的数据条数
 */
- (NSRange)rangeOfValidCountOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	返回指定图形指定位置的值
 *
 *	@param 	chartItemView 	指定图形
 *	@param 	index 	指定位置
 *
 *	@return	返回指定图形指定位置的值
 */
@optional
- (CGPoint)pointOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index;

/**
 *	@brief	返回指定图形指定位置的值(适用于复杂的值)
 *
 *	@param 	chartItemView 	指定图形
 *	@param 	index 	指定位置
 *
 *	@return	返回指定图形指定位置的值(适用于复杂的值)
 */
@optional
- (id)dataOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index;

/**
 *	@brief	返回指定图形指定位置的x描述
 *
 *	@param 	chartItemView 	指定图形
 *	@param 	index 	指定位置
 *
 *	@return	返回描述
 */
@optional
- (NSString*)xTipsOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index;

@optional
- (NSString*)xTipsOfChartItemView:(DYChartItemView*)chartItemView atPosition:(CGFloat)position;

/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的字体数组
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回字体
 */
- (UIFont*)xColorTipsFontOfChartItemView:(DYChartItemView*)chartItemView;


/**
 *	@brief	返回指定图形POP提示框中指定位置的y描述
 *
 *	@param 	chartItemView 	指定图形
 *	@param 	index 	指定位置
 *
 *	@return	返回描述
 */
- (NSString*)yTipsOfChartItemView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index;

/**
 *	@brief	返回指定图形POP提示框中指定位置的y描述
 *
 *	@param 	chartItemView 	指定图形
 *	@param 	position 	指定位置
 *
 *	@return	返回描述
 */
@optional
- (NSString*)yTipsOfChartItemView:(DYChartItemView*)chartItemView atPosition:(CGFloat)position;

/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的字体数组
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回字体数组
 */
- (UIFont*)yColorTipsFontOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中带颜色的提示文字的颜色数组
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回图形数组
 */
- (NSArray*)yColorTipsColorOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中提示文字前是否显示标识颜色的小圆圈的开关
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回YES标识显示小圆圈，返回NO标识不显示小圆圈
 */
- (BOOL)ifDrawPointBeforeYColorTipsOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的字体
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回颜色数组
 */
- (UIFont*)yTipsFontOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中不带颜色文字的颜色数组
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回颜色数组
 */
- (NSArray*)yTipsColorOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中日期字段的颜色
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回颜色
 */
- (UIColor*)colorOfTipsOfChartItemView:(DYChartItemView*)chartItemView;

/**
 *	@brief	获取指定图形POP提示框中日期字段的字体
 *
 *	@param 	chartItemView 	指定图形
 *
 *	@return	返回字体
 */
- (UIFont*)fontOfChartItemView:(DYChartItemView*)chartItemView;

- (NSDictionary *)dictionaryForShowViewValue:(DYChartItemView*)maskView
                                     atIndex:(NSUInteger)index;
@end

@protocol DYChartItemViewDelegate <NSObject>

/**
 *	@brief	指定ChartItemView上的指定位置有单指触摸事件
 *
 *	@param 	chartItemView 	指定的chartItemView
 *	@param 	index 	指定位置
 */
- (void)oneFingerInChartView:(DYChartItemView*)chartItemView atIndex:(NSUInteger)index;

/**
 *	@brief	指定ChartItemView上的指定区域有双指触摸事件
 *
 *	@param 	chartItemView 	指定的chartItemView
 *	@param 	fromIndex 	指定区域的起始位置
 *	@param 	toIndex 	指定区域的结束位置
 */
- (void)twoFingerInChartView:(DYChartItemView*)chartItemView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

@interface DYChartItemView : UIView  <DYMaskViewDataSource>

@property (nonatomic)EDYChartItemViewType viewType;
@property (nonatomic, weak)id<DYChartItemViewDataSource> dataSource;
@property (nonatomic, weak)id<DYChartItemViewDelegate> delegate;
@property (nonatomic, strong)UIColor* lineColor;    // 线颜色
@property (nonatomic, strong)UIColor* fillColor;    // 填充颜色
@property (nonatomic)BOOL fillToXZero;  // YES fill到X轴，NO fill到最小值
@property (nonatomic, assign)CGFloat lineWidth;

@property (nonatomic)CGFloat zoomForXAxis;              // X方向上图像的缩放系数
@property (nonatomic)CGFloat zoomForYAxis;              // Y方向上图像的缩放系数
@property (nonatomic)CGFloat xAxisOffset;               // X轴方向上图的偏移
@property (nonatomic)CGFloat yAxisOffset;               // Y轴方向上图的偏移
@property (nonatomic)CGFloat minX;                      // X 最小值
@property (nonatomic)CGFloat minY;                      // Y 最小值
@property (nonatomic)BOOL showingAnimation;             // 是否显示动画
@property (nonatomic)CGRect calcRect;                   // 计算矩形（用于计算图形缩放系数的矩形）
@property (nonatomic)CGFloat originalZoomForXAxis;      // 原始放大倍率
@property (nonatomic)CGFloat pointWidth;                // 画其中某一个点的宽度（目前主要用来记录bar和groupbar里某一条bar的宽度）
@property (nonatomic)BOOL isFixXPosition;               // 当前是否由我来决定浮层位置（避免引起多个位置）
@property (nonatomic)BOOL bindMaskView;                 // 是否由我来指定maskView浮层上的数据
@property (nonatomic)BOOL tipRectFollowWithFinger;      // 提示框跟随手指（用于分钟线提示）

- (void)showAnimation;
- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atPosition:(CGFloat)xPosition;
- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView atIndex:(NSInteger)index;
- (NSInteger)getIndexFromXPosition:(CGFloat)xPosition fromView:(UIView*)fromView;
- (int64_t)getTimestampFromXPosition:(CGFloat)xPosition fromView:(UIView*)fromView;
- (CGFloat)calcPointWidth;

@end
