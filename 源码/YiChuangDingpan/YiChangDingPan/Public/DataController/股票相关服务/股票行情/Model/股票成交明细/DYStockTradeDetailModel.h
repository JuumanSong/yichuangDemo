//
//  DYStockTradeDetailModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 股票成交明细
 */
@interface DYStockTradeDetailModel : NSObject
@property (nonatomic,copy) NSString *ticker;//证券在证券市场通用的交易代码
@property (nonatomic,copy) NSString *exchangecd;//通联编制的证券市场编码
@property (nonatomic,copy) NSString *datatime;//交易时间
@property (nonatomic,assign) double volume;//分笔成交量
//@property (nonatomic,assign) CGFloat lastPrice;//最后成交价
@property (nonatomic,assign) double price;//成交价
@property (nonatomic,assign) CGFloat deltaShare;

@end
