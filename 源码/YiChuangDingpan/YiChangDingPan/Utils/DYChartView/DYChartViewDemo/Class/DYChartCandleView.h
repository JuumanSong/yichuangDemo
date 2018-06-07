//
//  DYChartCandleView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/5.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYChartItemView.h"

@interface DYChartCandleDataItem : NSObject

/**
 *	@brief	对应X轴的点
 */
@property (nonatomic)CGFloat xPosition;

/**
 *	@brief	开盘价格
 */
@property (nonatomic)CGFloat openValue;

/**
 *	@brief	收盘价格
 */
@property (nonatomic)CGFloat closeValue;

/**
 *	@brief	最低成交价
 */
@property (nonatomic)CGFloat lowValue;

/**
 *	@brief	最高成交价
 */
@property (nonatomic)CGFloat highValue;

/**
 *	@brief	成交量
 */
@property (nonatomic)CGFloat VOL;

@end

@interface DYChartCandleView : DYChartItemView

/**
 *	@brief	表示涨的颜色
 */
@property (nonatomic, strong)UIColor* riseColor;

/**
 *	@brief	表示跌得颜色
 */
@property (nonatomic, strong)UIColor* fallColor;

/**
 *	@brief	蜡烛实体线宽度
 */
@property (nonatomic)CGFloat barWidth;

@end
