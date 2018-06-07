//
//  DYMaskView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYMaskView;

@protocol DYMaskViewDataSource <NSObject>

@optional

// 校正X方向的位置
- (CGFloat)fixXPositionOfMaskView:(DYMaskView*)maskView
                       atPosition:(CGFloat)xPosition;
// 获取Y方向的位置
- (CGFloat)getYPositionOfMaskView:(DYMaskView*)maskView
                       atPosition:(CGFloat)xPosition;
// X方向上提示文字的位置
- (CGRect)xTipsRectOfMaskView:(DYMaskView*)maskView
                   atPosition:(CGFloat)xPos
                withTipString:(NSString*)tipString;
// X方向上提醒文字
- (NSString*)xTipsOfMaskView:(DYMaskView*)maskView
                  atPosition:(CGFloat)xPos;
// Y方向上提示文字的位置
- (CGRect)yTipsRectOfMaskView:(DYMaskView*)maskView
                   atPosition:(CGFloat)xPos
                withTipString:(NSString*)tipString
                     withFont:(UIFont*)font;
// Y方向上提醒文字
- (NSString*)yTipsOfMaskView:(DYMaskView*)maskView
                  atPosition:(CGFloat)xPos;

// Y方向上带颜色的提醒文字的字体数组
- (UIFont*)yColorTipsFontOfMaskView:(DYMaskView*)maskView;
// Y方向上带颜色的提醒文字的颜色数组
- (NSArray*)yColorTipsColorOfMaskView:(DYMaskView*)maskView;
// 是否在带颜色的提醒文字的前面显示带颜色的小圆圈
- (BOOL)ifDrawPointBeforeYColorTipsOfMaskView:(DYMaskView*)maskView;
// Y方向上提醒文字的字体
- (UIFont*)yTipsFontOfMaskView:(DYMaskView*)maskView;
// Y方向上提醒文字的颜色
- (NSArray*)yTipsColorOfMaskView:(DYMaskView*)maskView;
// 提示文字的颜色-这是日期区域文字的颜色
- (UIColor*)colorOfTipsForMaskView:(DYMaskView*)maskView;
// 提示文字的字体-这是日期区域文字的字体
- (UIFont*)fontOfTipsForMask:(DYMaskView*)maskView;

// 选中区间的X方向上的提示文字
- (NSString*)xSelectTipsOfMaskView:(DYMaskView*)maskView
                      fromPosition:(CGFloat)fromPos
                        toPosition:(CGFloat)toPos;
// 选中区间提示文字的范围
- (CGRect)xSelectTipsRectOfMaskView:(DYMaskView*)maskView
                       fromPosition:(CGFloat)fromPos
                         toPosition:(CGFloat)toPos
                      withTipString:(NSString*)tipString;

// 单个浮层的值
- (NSDictionary *)dictionaryForShowViewValue:(DYMaskView*)maskView
                                  atPosition:(CGFloat)xPosition;

/**
 *	@brief	是否由我来绑定maskView（绑定maskView表示maskView上的浮层由这个chartView来指定）
 *
 *	@param 	maskView 	需要绑定的maskView
 *
 *	@return	返回YES表示绑定，返回NO表示不绑定
 */
- (BOOL)isBindMaskView:(DYMaskView*)maskView;

@end

@protocol DYMaskViewDelegate <NSObject>

// 当前手指移动的位置
- (void)maskView:(DYMaskView*)maskView
         movedTo:(CGFloat)xToPos
            from:(CGFloat)xFromPos;
// 在某个位置上缩放
- (void)zoomForMaskView:(DYMaskView*)maskView
                atPoint:(CGPoint)point
          withZoomValue:(CGFloat)zoomValue;
// 单指双击
- (void)oneFingerDoubleClickForMaskView:(DYMaskView*)maskView
                                atPoint:(CGPoint)point;
// 双指单击
- (void)twoFingerSingleClickForMaskView:(DYMaskView*)maskView
                                atPoint:(CGPoint)point;
// 双指双击
- (void)twoFingerDoubleClickForMaskView:(DYMaskView*)maskView
                                atPoint:(CGPoint)point;
// 选中区域变化
- (void)selectAreaChangedForMaskView:(DYMaskView*)maskView
                            fromXPos:(CGFloat)fromPos
                              toXPos:(CGFloat)toPos;
// 退出绘图操作
- (void)touchEnded:(DYMaskView*)maskView;

// 单指单击
- (void)oneFingerSingleTap:(DYMaskView*)maskView;

@end

typedef enum _EDYMaskViewShowFlag_
{
    eDYMaskViewShowNone = 0x00,                     // 不显示
    eDYMaskViewShowVerticalLine = 0x01,             // 竖线
    eDYMaskViewShowHorizontalLine = 0x02,           // 横线
    eDYMaskViewShowVerticalDashedLine = 0x04,       // 竖虚线
    eDYMaskViewShowHAndVerticalDashedLine =0x08,    // 横竖虚线
    eDYMaskViewShowHitCircle = 0x10,                // 显示小圆圈
    eDYMaskViewShowAll = 0x7FFFFFFF                 // 显示所有
}EDYMaskViewShowFlag;

typedef enum _EDYTouchState_  // 手势状态
{
    eDYTouchStateNone = 0,                        // 不支持手势
    eDYTouchStatePan = 0x01,                      // 滑动
    eDYTouchStateOneFingerSingleTap = 0x02,       // 单指单击
    eDYTouchStateOneFingerDoubleTap = 0x04,       // 单指双击
    eDYTouchStateTwoFingersSingleTap = 0x10,      // 双指单击
    eDYTouchStateTwoFingersDoubleTap = 0x20,      // 双指双击
    eDYTouchStateOneFingerLongPress = 0x40,       // 单指长按
    eDYTouchStateTwoFingersLongPress = 0x100,     // 双指长按
    eDYTouchStatePinch = 0x200,                   // 双指缩放
    eDYTouchStateAll = 0x7FFFFFFF                 // 所有手势
}EDYTouchState;

typedef NS_OPTIONS(NSUInteger, EDYCurrentTipsShowType) {
    eDYShowTipsNothing = 0x00,                        // 不显示
    eDYShowTipsAtYLine = 1 << 0,                      // Y轴上显示
    eDYShowTipsAtXLine = 1 << 1,                      // X轴上显示
    eDYShowTipsAtFingerPoint = 1 << 2,                // 跟着手指显示
    eDYShowTipsAtFingerHotPoint =1<<3,                // 热度的显示
    eDYShowTipsAtFingerRongZiPoint =1<<4,             //融资融券的显示
    eDYShowTipsAtFingerStockDetail=1<<5,              //股票详情的显示

};

typedef NS_ENUM(NSInteger, EMaskViewRectSide) {
    eSideAll = 0,       // 所有侧
    eSideLeft,          // 左侧
    eSideRight,         // 右侧
    eSideTop,           // 上方
    eSideBottom         // 下方
};

#define KShowTIpsTitleKey @"KShowTIpsTitleKey"
#define KShowTIpsValueKey @"KShowTIpsValueKey"
#define KShowTIpsDateKey @"KShowTIpsDateKey"
#define KShowTIpsWidthKey @"KShowTIpsWidthKey"
@interface DYMaskView : UIView <UIGestureRecognizerDelegate>

@property (atomic, strong)NSArray* myDataSources;                       // 数据源
@property (atomic, weak)id<DYMaskViewDelegate> mydelegate;              // 事件通知
@property (nonatomic)CGFloat xPosition;                                 // 当前手指在X轴方向位置

@property (nonatomic)CGFloat beginX;                                    // 最小能绘制的X坐标位置
@property (nonatomic)CGFloat beginY;                                    // 最小能绘制的Y坐标位置
@property (nonatomic)CGFloat endX;                                      // 最大能绘制的X坐标位置
@property (nonatomic)CGFloat endY;                                      // 最大能绘制的Y坐标位置

@property (nonatomic, strong)UIColor* lineColor;                        // 线颜色
@property (nonatomic, strong)UIColor* pointColor;                       // 线与曲线交点的颜色

@property (nonatomic)EDYTouchState eTouchState;                         // 当前处理的触摸事件
@property (nonatomic)EDYCurrentTipsShowType tipsShowType;               // 显示提示的类型
@property (nonatomic)NSUInteger showMask;                               // 显示标志位
@property (nonatomic)NSUInteger touchEventsMask;                        // 需要处理的触摸事件
@property (nonatomic)BOOL onlyBottomPanFlag;                            // 底部拖动
@property (nonatomic,assign)NSUInteger boottomHeight;                   // 底部拖动高度

@property (nonatomic)NSArray* allGestureRecognizers;                    // 所有的手势识别器

@property (nonatomic, strong)UIScrollView* gestureConflictView;         // 手势冲突的View

@property (nonatomic)BOOL fingerLeaveFlag;                              // 手指离开时回调开关

@property (nonatomic, strong)UIColor* tipsColor;                        // 提示文字的颜色
@property (nonatomic, strong)UIFont* tipsFont;                          // 提示文字的字体
@property (nonatomic, strong)UIColor* tipsBackgroundColor;              // 提示文字的背景颜色
@property (nonatomic)CGFloat tipTextGap;                                // 提示文字指间的间隔
@property (nonatomic)BOOL tipNotShowWithFixedChartItemView;             // 提示以Fixed的chartItemView为坐标

//跟手指显示的View 只有一个
@property (nonatomic)BOOL tipInOneFlag;
// 返回tag
- (int)addDataSource:(id<DYMaskViewDataSource>)dataSource;
- (void)deleteDataSourceByTag:(int)tag;
- (void)deleteAllDataSource;
- (void)redrawMaskView;

@end
