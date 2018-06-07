//
//  DYStockFiveGearModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYStockFiveBookModel.h"

/**
 股票五档信息类
 */
@interface DYStockFiveGearModel : NSObject<YYModel>
@property (nonatomic,copy) NSString *dataDate;
@property (nonatomic,copy) NSString *dataTime;
@property (nonatomic,copy) NSString *ticker;
@property (nonatomic,copy) NSString *shortNM;
@property (nonatomic,copy) NSString *exchangeCD;
@property (nonatomic,assign) Float64 prevClosePrice;
@property (nonatomic,assign) Float64 openPrice;
@property (nonatomic,assign) Float64 lastPrice;
@property (nonatomic,assign) Float64 highPrice;
@property (nonatomic,assign) Float64 lowPrice;
@property (nonatomic,assign) Float64 volume;
@property (nonatomic,assign) Float64 value;
@property (nonatomic,assign) Float64 change;
@property (nonatomic,assign) Float64 changePct;
@property (nonatomic,assign) int64_t timestamp;
@property (nonatomic,assign) Float64 suspension;
@property (nonatomic,assign) Float64 marketValue;

@property (nonatomic,copy) NSArray<DYStockFiveBookModel*> *askBook;
@property (nonatomic,copy) NSArray<DYStockFiveBookModel*> *bidBook;

@end
