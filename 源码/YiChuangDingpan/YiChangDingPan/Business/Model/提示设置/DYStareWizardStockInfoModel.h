//
//  DYStockInfoModel.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 股票信息model
#import <Foundation/Foundation.h>

@interface DYStareWizardStockInfoModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *tickerId;     // 股票id
@property (nonatomic, copy) NSString *exchangeCD;   // 交易市场
@property (nonatomic, copy) NSString *assetType;    // 证券类型
@property (nonatomic, copy) NSString *stockName;    // 股票名称
@property (nonatomic, assign) CGFloat lastPrice;    // 最新股价
@property (nonatomic, assign) CGFloat changePct;    // 最新变动
@property (nonatomic,copy)NSString *secId;//证券Id


@property (nonatomic, assign) NSInteger status;     // 1,自选股添加; 2,手工添加; 3,持仓股
@property (nonatomic, copy) NSString *source;       // 来源

@end
