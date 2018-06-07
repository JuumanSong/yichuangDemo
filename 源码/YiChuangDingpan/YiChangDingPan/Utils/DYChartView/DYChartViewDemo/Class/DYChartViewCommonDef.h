//
//  DYChartViewCommonDef.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/2/23.
//  Copyright © 2016年 datayes. All rights reserved.
//

#ifndef DYChartViewCommonDef_h
#define DYChartViewCommonDef_h

#define NAN_OR_INF_POINT_2_ZERO(a) if(isnan(a.x)||isinf(a.x)){a.x=0;}if(isnan(a.y)||isinf(a.y)){a.y=0;}
#define NAN_OR_INF_2_ZERO(a) if(isnan(a)||isinf(a)){a=0;}

#define EMPTY_VALUE (-MAXFLOAT)                     // 无效数据
#define JUDGE_EMPTY_VALUE(a) a<EMPTY_VALUE/2        // 判断数据是否为无效数据

#define DYMAX_TIPS_WIDTH            320             // 提示文字最大宽度
#define DYTIPS_TEXT_GAP             6               // 文字和文字，文字和外面边框间的间隙
#define DYTIPS_CYCLE_POINT_WIDTH    4               // 小圆圈的大小

#endif /* DYChartViewCommonDef_h */
