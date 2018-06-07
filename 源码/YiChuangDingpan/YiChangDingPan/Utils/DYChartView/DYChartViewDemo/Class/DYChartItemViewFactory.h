//
//  DYChartItemViewFactory.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/9.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DYChartItemView;

typedef NS_ENUM(NSUInteger, EDYChartItemViewType)
{
    eDYChartTypeUnknown = 0,
    eDYChartTypeCurve,              // 曲线
    eDYChartTypeArea,               // 面积图
    eDYChartTypeBar,                // 柱状图
    eDYChartTypeCandle,             // 蜡烛图
    eDYChartTypeGroupBar,           // 分组柱状图
};

@interface DYChartItemViewFactory : NSObject

/**
 *	@brief	根据类型创建chartItemView
 *
 *	@param 	chartType 	chartType 	指定chartItemView的类型
 *	@param 	rect 	指定控件位置
 *
 *	@return	返回创建好的chartItemView
 */
+ (DYChartItemView*)createChartItemViewByType:(EDYChartItemViewType)chartType inFrame:(CGRect)rect;

@end
