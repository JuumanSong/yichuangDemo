//
//  DYAxisView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYIndexPath.h"

// 刻度最大数目
#define MAX_SCALE_COUNT         10000
typedef enum _EDYDrawContentFlag_
{
    eDrawNothing            = 0x0,      // nothing
    eDrawMajorScaleText     = 0x1,      // 主刻度上对应的文字
    eDrawMinorScaleText     = 0x2,      // 次刻度上对应的文字
    eDrawAxis               = 0x4,      // 轴线
    eDrawMajorScale         = 0x8,      // 主刻度
    eDrawMinorScale         = 0x10,     // 次刻度
    eDrawAll = 0xFFFFFFFF               // 全画
}DYDrawContentFlag;

typedef NS_ENUM(NSUInteger, EAxisPosition) {
    eAxisPositionUnkown = 0,
    eAxisPositionLeft = eAxisPositionUnkown,    // 左侧Y轴
    eAxisPositionRight,                         // 右侧Y轴
    eAxisPositionTop,                           // 上方X轴
    eAxisPositionBottom,                        // 下方X轴
};

@class DYAxisView;

@protocol DYAxisViewDataSource <NSObject>

// 大刻度的个数
- (NSInteger)numberOfScaleSections:(DYAxisView*)axisView;
// 每个大刻度里小刻度的个数
- (NSInteger)numberOfScaleForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section;
// 指定序号的刻度的位置（section为刻度的index，offset为index需要做的偏移）
- (CGFloat)positionOfScaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset;
// 大刻度上显示的文字（section为刻度的index，offset为index需要做的偏移）
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section withOffset:(NSInteger)offset;
// 小刻度上显示的文字
- (NSString*)scaleStringForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath;
// 大刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section;
// offset偏移的distance
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView forOffset:(NSInteger)offset;
// 小刻度占有的空间
- (CGFloat)distanceForAxisView:(DYAxisView*)axisView atIndexPath:(DYIndexPath*)indexPath;
// 大刻度上显示的文字的字体
- (UIFont*)fontForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section;
// 小刻度上显示的文字的字体
- (UIFont*)fontForAxisView:(DYAxisView *)axisView atIndexPath:(DYIndexPath*)indexPath;
// 大刻度上显示文字的颜色
- (UIColor*)colorForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section;
// 小刻度上显示文字的颜色
- (UIColor*)colorForAxisView:(DYAxisView *)axisView atIndexPath:(DYIndexPath*)indexPath;
// 返回底部View
- (UIView *)bottomViewForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section;
// 两个点之间的距离
- (CGFloat)pointsGapForAxisView:(DYAxisView*)axisView;

@optional
// 显示的最小值
- (CGFloat)minValueForAxisView:(DYAxisView* )axisView;
// 显示的最大值
- (CGFloat)maxValueForAxisView:(DYAxisView* )axisView;

@end

@interface DYAxisView : UIView

#pragma mark - 变量
@property (nonatomic, strong)NSArray* labelViewsArray;                  // 显示刻度描述的控件数组
@property (nonatomic, weak)id<DYAxisViewDataSource> dataSource;         // 刻度参数的数据源


@property (nonatomic)EAxisPosition axisPosition;                        // 轴在图中所处的位置
@property (nonatomic)CGFloat offset;                                    // 第一个刻度相对原点的偏移
@property (nonatomic)CGFloat zoomValue;                                 // 缩放系数
@property (nonatomic)CGFloat originalZoomValue;                         // 原始缩放系数
@property (nonatomic)NSUInteger drawContentFlag;                        // 显示哪些内容的控制标志
@property (nonatomic)CGFloat textEdgeOffset;                            // 文字离控件边缘的偏移（Y轴是离左、右边轴线距离，X轴是离上边轴线的距离）
@property (nonatomic)CGFloat textTransform;                             // 文字旋转角度
@property (nonatomic)NSTextAlignment textAlignment;                     // 文字对齐方式
@property (nonatomic)UIColor* textBackgroundColor;                      // 文字背景色

@property (nonatomic)CGFloat majorScaleWidth;                           // 主刻度线宽
@property (nonatomic)CGFloat majorScaleLength;                          // 主刻度线长
@property (nonatomic)UIColor* majorScaleColor;                          // 主刻度颜色

@property (nonatomic)CGFloat minorScaleWidth;                           // 次刻度线宽
@property (nonatomic)CGFloat minorScaleLength;                          // 次刻度线长
@property (nonatomic)UIColor* minorScaleColor;                          // 次刻度颜色

@property (nonatomic)CGFloat axisWidth;                                 // 轴线宽度
@property (nonatomic)UIColor* axisColor;                                // 轴线颜色

@property (nonatomic)BOOL showMoreMajorText;                            // 多现实一个主刻度文字
@property (nonatomic)BOOL autoCalcMajorTextPosition;                    // 自己管理主刻度文字的显示位置

@property (nonatomic)BOOL justShowMinAndMaxValue;                       // 只显示最大最小值（K线）

#pragma mark - 函数

- (void)reloadData;
- (void)resetLabelPosition;
- (void)drawLineFromPoint:(CGPoint)fromPoint
                  toPoint:(CGPoint)toPoint
                withColor:(UIColor*)color
             andLineWidth:(CGFloat)lineWidth;
- (BOOL)isZoomed;   // 当前是否被缩放

@end
