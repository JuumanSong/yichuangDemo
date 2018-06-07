//
//  DYStocksMoveViewController.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/4.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYViewController.h"

@interface DYStocksMoveViewController : DYViewController

// 搜索框调用方法

- (void)searchStockDidSelectTradeCode:(NSString *)code;

- (void)executeCancelFiltrateEvent;
@end
