//
//  DYPriceRulesService.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesService.h"
#import "DYStareWizardDataSource.h"
#import "DYStockMarketService.h"
#import "NSString+NumberFormat.h"

@implementation DYPriceRulesService


- (DYStareWizardPriceRuleModel *)stockModel {
    if (_stockModel==nil) {
        _stockModel = [[DYStareWizardPriceRuleModel alloc]init];
    }
    return _stockModel;
}


-(NSArray *)rulesArray {
    if (!_rulesArray) {
        _rulesArray = [NSArray new];
    }
    return _rulesArray;
}


// 获取用户到价提醒配置
- (void)getStareWizardPriceRulesWithResultBlock:(void(^)(id data))block {
    WS(weakSelf)
    [DYStareWizardDataSource getStareWizardPriceRulesWithSuccess:^(NSInteger code, id data, NSString *message) {
        NSArray *dataArr = data;
        NSArray *tempArr = [[NSArray alloc]init];
        if (dataArr && [dataArr isKindOfClass:[NSArray class]] && dataArr.count > 0) {
            tempArr = [NSArray yy_modelArrayWithClass:[DYStareWizardPriceRuleModel class] json:dataArr];
            //监控中
            NSMutableArray *monitorArray = [[NSMutableArray alloc]init];
            //完成监控
            NSMutableArray *finishArray = [[NSMutableArray alloc]init];
            for (DYStareWizardPriceRuleModel *model in tempArr) {
                DYStockPropertyItem *item = [DYStockPropertyService getPropertyItemBySecId:[NSString stringWithFormat:@"%@.%@",model.stockInfo.tickerId,model.stockInfo.exchangeCD]];
                model.stockInfo.stockName= item.secName;
                if (model.state ==0) {
                    [monitorArray addObject:model];
                }else {
                    [finishArray addObject:model];
                }
            }
            weakSelf.rulesArray = @[monitorArray,finishArray];
        }
        if (block) {
            block(weakSelf.rulesArray);
        }
    } fail:^(NSError *error) {
        if (block) {
            block(weakSelf.rulesArray);
        }
    }];
}

// 设置用户到价提醒
+ (void)setStareWizardPriceRuleWithInfo:(DYStareWizardPriceRuleModel *)model resultBlock:(void(^)(id data))block {
    if (model == nil) {
        if (block) {
            block(@NO);
        }
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (model.cId.length >0) {
        [dic setObject:NilToEmptyString(model.cId) forKey:@"id"];
    }
    NSDictionary *tickerInfo = @{@"t":NilToEmptyString(model.stockInfo.tickerId),
                                 @"e":NilToEmptyString(model.stockInfo.exchangeCD),
                                 @"a":NilToEmptyString(model.stockInfo.assetType)
                                 };
    [dic setObject:tickerInfo forKey:@"e"];
    if (model.cp >0) {
        NSString * cp =[NSString stringWithFormat:@"%.2f",model.cp];
        [dic setObject:@([cp floatValue]) forKey:@"cp"];
    }
    if (model.cr >0) {
        [dic setObject:@(model.cr) forKey:@"cr"];
        NSString * cp =[NSString stringWithFormat:@"%.2f",model.stockInfo.lastPrice*(1+model.cr)];
        [dic setObject:@([cp floatValue]) forKey:@"cp"];
    }
    if (model.fp >0) {
        NSString * fp =[NSString stringWithFormat:@"%.2f",model.fp];
        [dic setObject:@([fp floatValue]) forKey:@"fp"];
    }
    if (model.fr >0) {
        [dic setObject:@(model.fr) forKey:@"fr"];
        NSString * fp =[NSString stringWithFormat:@"%.2f",model.stockInfo.lastPrice*(1-model.fr)];
        [dic setObject:@([fp floatValue]) forKey:@"fp"];
    
    }
    [dic setObject:@(1) forKey:@"ct"];
    [dic setObject:@(1) forKey:@"sct"];
    
    [DYStareWizardDataSource setStareWizardPriceRuleWithParam:dic success:^(NSInteger code, id data, NSString *message) {
        BOOL successFlag = [data boolValue];
        if (block) {
            block(@(successFlag));
        }
    } fail:^(NSError *error) {
        if (block) {
            block(@NO);
        }
    }];
}

//获取股票行情
- (void)getStockMarket:(NSArray *)array WithSuccess:(void(^)(id data))success fail:(void(^)(id data))fail  {
    
    NSMutableArray *requestArray = [NSMutableArray arrayWithCapacity:0];
    for (DYStareWizardPriceRuleModel *ruleModel in array) {
        DYStareWizardStockInfoModel *info = ruleModel.stockInfo;
        DYStockMarketModel *model = [[DYStockMarketModel alloc]init];
        model.ticker = info.tickerId;
//        model.exchangeCD = info.exchangeCD;
//        model.secType = info.assetType;
        [requestArray addObject:model];
    }
    [DYStockMarketService getStockMarketInfo:requestArray withSuccess:^(id data) {
        if (data) {
            NSArray *tempArray = data;
            if (tempArray.count ==requestArray.count) {
                for (NSInteger i=0; i<tempArray.count; i++) {
                    DYStockMarketModel *resultModel = tempArray[i];
                    DYStareWizardPriceRuleModel *priceModel = array[i];
                    priceModel.stockInfo.lastPrice = resultModel.lastPrice;
                    priceModel.stockInfo.changePct = resultModel.changePct;
                }
            }
        }
        success(data);
    } fail:^(id data) {
        fail(data);
    }];
}


//添加股票
- (void)rePlaceChooseStock:(DYStockPropertyItem *)item {
    if (item) {
        self.stockModel = [[DYStareWizardPriceRuleModel alloc]init];
        NSString *ruleId = [self getExistDataIdByTicker:item.tradeCode];
        if (ruleId.length >0) {
            self.stockModel.cId = ruleId;
        }
        DYStareWizardStockInfoModel *info = [[DYStareWizardStockInfoModel alloc]init];
        info.tickerId = item.tradeCode;
        info.exchangeCD = item.tradeMarket;
        info.assetType = item.secType;
        info.stockName = item.secName;
        self.stockModel.stockInfo = info;
    }
}

//添加股票
- (void)rePlaceChooseStockCode:(NSString *)secId {
    if (secId) {
        [self rePlaceChooseStock:[DYStockPropertyService getPropertyItemBySecId:secId]];
    }
}


//设置输入的值
- (void)setValue:(NSString *)str withPrice:(BOOL)isPrice withRise:(BOOL)isRise {
    if (str.length>0) {
        if (!self.stockModel.stockInfo) {
            self.stockModel.stockInfo = [[DYStareWizardStockInfoModel alloc]init];
        }
        if (isPrice) {
            if (isRise) {
                self.stockModel.cp = [str floatValue];
                self.stockModel.cr = 0;
            }else {
                self.stockModel.fp = [str floatValue];
                self.stockModel.fr = 0;
            }
        }else {
            if (isRise) {
                self.stockModel.cr = [str floatValue]/100;
                self.stockModel.cp = 0;
            }else {
                self.stockModel.fr = [str floatValue]/100;
                self.stockModel.fp = 0;
            }
        }
    }
}

//输入变化的值，返回数据
- (NSDictionary *)textChangeValue:(CGFloat)value withPrice:(BOOL)isPrice withRise:(BOOL)isRise {
    
    CGFloat lastPrice = self.stockModel.stockInfo.lastPrice;
//    CGFloat changePct = self.stockModel.stockInfo.changePct;
    
    CGFloat priceHight = lastPrice*20;
    if (lastPrice<=0) {
        return @{@"warning":@"正在获取最新价",@"requestInfo":@(YES)};
    }
    if (isPrice) {
        if (isRise) {
            if (lastPrice>value) {
                return @{@"warning":@"必须高于现价"};
            }else if (value>priceHight) {
                return @{@"warning":@"价格过高"};
            }else{
                CGFloat rise = (value -lastPrice)/lastPrice;
                NSString *str = [NSString stringWithPecent:rise];
                return  @{@"key":[NSString stringWithFormat:@"涨幅%@",str]};
            }
        }else {
            if (lastPrice<value) {
                return @{@"warning":@"必须低于现价"};
            }else if (value==0) {
                return @{@"warning":@"必须大于零"};
            }else {
                CGFloat rise = (lastPrice-value)/lastPrice;
                NSString *str = [NSString stringWithPecent:rise];
                return  @{@"key":[NSString stringWithFormat:@"跌幅%@",str]};
            }
        }
    }else {
        if (isRise) {
            CGFloat temp = lastPrice*(1+value/100);
            if (temp>priceHight) {
                return @{@"warning":@"涨幅过高"};
            }else if (value==0) {
                return @{@"warning":@"必须大于零"};
            }else {
                NSString *str = [NSString stringWithPriceDigit2:temp];
                return  @{@"key":[NSString stringWithFormat:@"股价%@",str]};
            }
        }else {
            if (value>=100) {
                return @{@"warning":@"跌幅过高"};
            }else if (value==0) {
                return @{@"warning":@"必须大于零"};
            }else {
                CGFloat temp = lastPrice*(1-value/100);
                NSString *str = [NSString stringWithPriceDigit2:temp];
                return  @{@"key":[NSString stringWithFormat:@"股价%@",str]};
            }
        }
    }
}

//获取已存在的用户ID
- (NSString *)getExistDataIdByTicker:(NSString *)ticker {
    if (ticker) {
        for (int i = 0; i < self.rulesArray.count; i++) {
            NSArray *array = self.rulesArray[i];
            for (DYStareWizardPriceRuleModel *model in array) {
                if ([model.stockInfo.tickerId isEqualToString:ticker] && model.state==0) {
                    return model.cId;
                }
            }
        }
    }
    return nil;
}
@end

