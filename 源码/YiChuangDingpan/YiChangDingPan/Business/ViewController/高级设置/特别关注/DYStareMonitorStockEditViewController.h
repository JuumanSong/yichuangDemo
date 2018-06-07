//
//  DYStareMonitorStockEditViewController.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 监控股票controller
#import "DYViewController.h"
typedef void(^ReloadDataBlock)(void);
@interface DYStareMonitorStockEditViewController : DYViewController
@property (nonatomic,assign)  BOOL isChildVC;
@property (nonatomic,copy)ReloadDataBlock Block;
// 改变右上角按钮状态
- (void)changeRightButtonWithEdit:(BOOL)isEdit;
@end
