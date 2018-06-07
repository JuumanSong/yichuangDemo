//
//  DYTimeShareModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 分时图model
 */


@interface DYTimeSharePriceModel :NSObject

@property (nonatomic,copy) NSString *dataDate;
@property (nonatomic,assign) CGFloat highPrice;
@property (nonatomic,assign) CGFloat lowPrice;
@property (nonatomic,assign) CGFloat prevClosePrice;

@end


@interface DYTimeSharePointModel:NSObject

@property (nonatomic,copy) NSString *barTime;
@property (nonatomic,assign) NSInteger totalVolume;
@property (nonatomic,assign) CGFloat closePrice;
@property (nonatomic,assign) CGFloat openPrice;
@property (nonatomic,assign) CGFloat totalValue;

@end

@interface DYTimeShareModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *dataDate;
@property (nonatomic,assign) CGFloat highPrice;
@property (nonatomic,assign) CGFloat lowPrice;
@property (nonatomic,assign) CGFloat prevClosePrice;
//@property (nonatomic, strong) DYTimeSharePriceModel *priceModel;
@property (nonatomic, strong) NSArray<DYTimeSharePointModel *>*pointsArray;

@end
