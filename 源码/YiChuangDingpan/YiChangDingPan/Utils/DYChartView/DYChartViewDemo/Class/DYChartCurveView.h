//
//  DYChartCurveView.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYChartItemView.h"

@interface DYChartCurveView : DYChartItemView

@property (nonatomic)BOOL drawSmoothCurveFlag;
@property (nonatomic)BOOL fillFlag;
@property (nonatomic, strong)UIColor* coverColor;
@property (nonatomic)BOOL drawArcFlag;   //是否画空心圆
@property (nonatomic, strong)CAShapeLayer* lineLayer;   // 线路绘制层
@property (nonatomic)BOOL showLastPoint;    // 最后一个点着重显示

- (void)setupLineLayer;

@end
