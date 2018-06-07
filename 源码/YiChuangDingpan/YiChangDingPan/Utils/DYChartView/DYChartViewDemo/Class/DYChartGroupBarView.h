//
//  DYChartGroupBarView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/2/15.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYChartBarView.h"


@interface DYChartGroupBarView : DYChartBarView

/**
 *	@brief	分组间间隔的宽度
 */
@property (nonatomic)CGFloat groupGapWidth;

/**
 *	@brief	一个分组里bar的个数
 */
@property (nonatomic)NSInteger barCountInGroup;

@end
