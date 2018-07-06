//
//  DYStareOptionalMonitorSetService.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareOptionalMonitorSetService.h"
#import "DYYCDataSourceList.h"
#import "DYAdvancedSetService.h"
static DYStareOptionalMonitorSetService *monitorService = nil;

@implementation DYStareOptionalMonitorSetService

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitorService = [[DYStareOptionalMonitorSetService alloc]init];
        
    });
    return monitorService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        DYStareOptionalMonitorSetModel *setModel1 = [self getOneSectionModel];
        DYStareOptionalMonitorSetModel *setModel2 = [self getSecondSectionModel];
        DYStareOptionalMonitorSetModel *setModel3 = [self getThirdSectionModel];
        self.modelArray = @[setModel1, setModel2, setModel3];
    }
    return self;
}

#pragma mark - 获取列表数据源
// 第一个section
- (DYStareOptionalMonitorSetModel *)getOneSectionModel {
    DYStareOptionalMonitorSetModel *setModel = [[DYStareOptionalMonitorSetModel alloc]init];
    setModel.headerTitle = @"盘中信号";
    
    DYStareGeneralSwitchSettingModel *model1 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model1.leftImg = @"stare_price";
    model1.title = @"价格异动";
    model1.contentTitle = @"价格快速拉升/下跌；股价创新高/低；早盘/尾盘异动";
    model1.cardType = 4;
    model1.subCardType = 4;
    
    DYStareGeneralSwitchSettingModel *model2 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model2.leftImg = @"stare_remind";
    model2.title = @"涨跌停提醒";
    model2.contentTitle = @"涨跌停/开板提醒/预期开板提醒";
    model2.cardType = 16;
    model2.subCardType = 16;
    
    DYStareGeneralSwitchSettingModel *model3 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model3.leftImg = @"stare_price_da";
    model3.title = @"主力大单";
    model3.contentTitle = @"大单买入/卖出";
    model3.cardType = 3;
    model3.subCardType = 3;
    
    DYStareGeneralSwitchSettingModel *model4 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model4.leftImg = @"stare_signal";
    model4.title = @"技术信号";
    model4.contentTitle = @"KDJ金叉/KDJ死叉/boll突破上轨/突破5日均线等";
    model4.cardType = 11;
    model4.subCardType = 11;
    
    setModel.dataArray = @[model1, model2, model3, model4];
    return setModel;
}

// 第二个section
- (DYStareOptionalMonitorSetModel *)getSecondSectionModel {
    DYStareOptionalMonitorSetModel *setModel = [[DYStareOptionalMonitorSetModel alloc]init];
    setModel.headerTitle = @"盘后信号";
    
    DYStareGeneralSwitchSettingModel *model1 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model1.leftImg = @"stare_yang";
    model1.title = @"盘后多日信号";
    model1.contentTitle = @"连阳/连续n日创新高/连续放量/连续资金流入流出";
    model1.cardType = 12;
    model1.subCardType = 12;
    
    /*
    DYStareGeneralSwitchSettingModel *model2 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model2.leftImg = @"stare_k";
    model2.title = @"相似K线";
    model2.contentTitle = @"历史上出现相似K线，未来涨跌幅较大";
    model2.cardType = 11;
    model2.subCardType = 11;
     */
    
    setModel.dataArray = @[model1];
    return setModel;
}

// 第三个section
- (DYStareOptionalMonitorSetModel *)getThirdSectionModel {
    DYStareOptionalMonitorSetModel *setModel = [[DYStareOptionalMonitorSetModel alloc]init];
    setModel.headerTitle = @"重大事项";
    
    DYStareGeneralSwitchSettingModel *model1 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model1.leftImg = @"stare_notice";
    model1.title = @"重要公告";
    model1.contentTitle = @"业绩预增/预减；高管增减持；限售股解禁；高管离职；资产重组；重大合同；股票增发；分红送转";
    model1.cardType = 5;
    model1.subCardType = 5;
    
    /*
    DYStareGeneralSwitchSettingModel *model2 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model2.leftImg = @"stare_report";
    model2.title = @"分析师研报";
    model2.contentTitle = @"新发布的研报";
     model2.cardType = 8;
     model2.subCardType = 8;
    
    DYStareGeneralSwitchSettingModel *model3 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model3.leftImg = @"stare_mechanism";
    model3.title = @"机构调研";
    model3.contentTitle = @"机构调研，访谈纪要";
     model3.cardType = 9;
     model3.subCardType = 9;
    
    DYStareGeneralSwitchSettingModel *model4 = [[DYStareGeneralSwitchSettingModel alloc]init];
    model4.leftImg = @"stare_billboard";
    model4.title = @"龙虎榜";
    model4.contentTitle = @"登上龙虎榜";
    model4.cardType = 10;
    model4.subCardType = 10;
    setModel.dataArray = @[model1, model2, model3, model4];
     */
    
    setModel.dataArray = @[model1];
    return setModel;
}

#pragma mark - 接口
// 获取用户监控的个股列表
+ (void)getStareWizardStockListWithSuccess:(void(^)(id data))success
                                      fail:(void(^)(id data))fail {
    
    [DYStareWizardDataSource getStareWizardStockListWithSuccess:^(NSInteger code, id data, NSString *message) {
        
        NSArray *dataArr = data;
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        if (dataArr && [dataArr isKindOfClass:[NSArray class]] && dataArr.count > 0) {
            tempArr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[DYStareWizardStockInfoModel class] json:dataArr];
        }
        [DYStareOptionalMonitorSetService shareInstance].stockArray = tempArr;
        success(tempArr);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 获取用户普通盯盘配置
- (void)getStareWizardGeneralRulesWithSuccess:(void(^)(id data))success
                                         fail:(void(^)(id data))fail {
    
    WS(weakSelf);
    
    [DYStareWizardDataSource getStareWizardGeneralRulesWithSuccess:^(NSInteger code, id data, NSString *message) {
        NSArray *dataArr = (NSArray *)data;
        NSArray *tempArr = [[NSArray alloc]init];
        if (dataArr && dataArr.count > 0 && [dataArr isKindOfClass:[NSArray class]]) {
            
            tempArr = [NSArray yy_modelArrayWithClass:[DYStareGeneralSwitchSettingModel class] json:dataArr];
            
            for (int i = 0; i < tempArr.count; i++) {
                DYStareGeneralSwitchSettingModel *tempM = tempArr[i];
                
                for (DYStareOptionalMonitorSetModel *setM in weakSelf.modelArray) {
                    
                    for (DYStareGeneralSwitchSettingModel *subM in setM.dataArray) {
                        if (subM.cardType == tempM.cardType && subM.subCardType == tempM.subCardType) {
                            subM.switchFlag = tempM.switchFlag;
                            break;
                        }
                    }
                }
            }
        }
        success(weakSelf.modelArray);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 设置用户普通盯盘提醒
+ (void)setStareWizardGeneralRuleWithParam:(DYStareGeneralSwitchSettingModel *)model
                                   success:(void(^)(id data))success
                                      fail:(void(^)(id data))fail {
    int s = model.switchFlag ? 1 : 0;
    
    NSDictionary *dict = @{@"ct": @(model.cardType),
                           @"sct": @(model.subCardType),
                           @"s": @(s)};
    
    [DYStareWizardDataSource setStareWizardGeneralRuleWithParam:dict success:^(NSInteger code, id data, NSString *message) {
        
        BOOL successFlag = [data boolValue];
        success(@(successFlag));
        
    } fail:^(NSError *error) {
        fail(@NO);
    }];
}

// 添加用户盯盘股票
+ (void)addStareWizardStockListWithArray:(NSArray<DYStareWizardStockInfoModel *>*)array
                                 success:(void(^)(id data))success
                                    fail:(void(^)(id data))fail  {
    if (array.count <= 0) {
        fail([[NSError alloc]init]);
        return;
    }
    
    NSMutableArray *paramArr = [self getParamArrayWithArray:array];

    [DYStareWizardDataSource addStareWizardStockListWithParam:paramArr success:^(NSInteger code, id data, NSString *message) {
        
        for (int i = 0; i < array.count; i++) {
            DYStareWizardStockInfoModel *model = array[i];
            NSArray *tmp = [DYStareOptionalMonitorSetService shareInstance].stockArray;
            BOOL hasMOdel = NO;
            for (int k=0; k<tmp.count; k++) {
                DYStareWizardStockInfoModel *tmpModel = tmp[k];
                if([tmpModel.tickerId isEqualToString:model.tickerId]){
                    hasMOdel = YES;
                    break;
                }
            }
            if(!hasMOdel){
                [[DYStareOptionalMonitorSetService shareInstance].stockArray insertObject:model atIndex:0];
            }
        }
    
        success(@(YES));
        
    } fail:^(NSError *error) {
        fail(@NO);
    }];
}

// 删除用户盯盘股票
+ (void)deleteStareWizardStockListWithArray:(NSArray<DYStareWizardStockInfoModel *>*)array success:(void(^)(id data))success fail:(void(^)(id data))fail {
    
    if (array.count <= 0) {
        fail([[NSError alloc]init]);
        return;
    }

    NSArray *tempArr = [array copy];
    NSMutableArray *paramArr = [self getParamArrayWithArray:array];
    
    [DYStareWizardDataSource deleteStareWizardStockListWithParam:paramArr success:^(NSInteger code, id data, NSString *message) {
        
        for (int i = 0; i < tempArr.count; i++) {
            DYStareWizardStockInfoModel *model = tempArr[i];
            NSArray *arr = [DYStareOptionalMonitorSetService shareInstance].stockArray;
            for (DYStareWizardStockInfoModel *info in arr) {
                if ([model.tickerId isEqualToString:info.tickerId]) {
                    [[DYStareOptionalMonitorSetService shareInstance].stockArray removeObject:info];
                    break;
                }
            }
            
        }
        success(@(YES));
        
    } fail:^(NSError *error) {
        fail(@NO);
    }];
}

// 获取添加/删除盯盘股票的参数
+ (NSMutableArray *)getParamArrayWithArray:(NSArray<DYStareWizardStockInfoModel *>*)array {
    NSMutableArray *paramArr = [[NSMutableArray alloc]init];
    
//    for (DYStareWizardStockInfoModel *model in array) {
//        NSDictionary *dict = @{@"t": NilToEmptyString(model.tickerId),
//                               @"status": @(model.status),
//                               @"e": NilToEmptyString(model.exchangeCD),
//                               @"a": NilToEmptyString(model.assetType)
//                               };
//        [paramArr addObject:dict];
//    }
    for (NSInteger i = 0; i < array.count; i++) {
        DYStareWizardStockInfoModel *model = array[i];
        NSDictionary *dict = @{@"t": NilToEmptyString(model.tickerId),
                               @"status": @(model.status),
                               @"e": NilToEmptyString(model.exchangeCD),
                               @"a": NilToEmptyString(model.assetType)
                               };
        [paramArr addObject:dict];
    }
    return paramArr;
}

// 查询消息推送配置
+ (void)getMsgStatusWithSuccess:(void(^)(id data))success
                           fail:(void(^)(id data))fail {
    [DYYCDataSourceList getMsgStatusParams:nil Success:^(NSInteger code, id data, NSString *message) {
        NSLog(@"--------data==%@",data);
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

// 消息推送开关设置
+ (void)setMsgStatusWithParam:(NSDictionary *)dict
                      Success:(void(^)(id data))success
                         fail:(void(^)(id data))fail {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:dict];
    id<DYYCInterfaceDelegate> delegate = [DYYCInterface shareInstance].delegate;
    [tmp setObject:[delegate appKey] forKey:@"appKey"];
    [tmp setObject:[delegate appType] forKey:@"appType"];
    [DYYCDataSourceList setMsgStatusParams:tmp Success:^(NSInteger code, id data, NSString *message) {
        NSLog(@"--------data==%@",data);
        success(data);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//首次上传用户自选股到高级关注
+ (void)firstTimeAddUserStock {
    if ([DYAdvancedSetService shareInstance].personSettingModel.s == 1) {
        if ([DYYCInterface shareInstance].delegate && [[DYYCInterface shareInstance].delegate respondsToSelector:@selector(userStockArr)]) {
            NSArray *tickers = [[DYYCInterface shareInstance].delegate userStockArr];
            NSMutableArray *stockArray = [[NSMutableArray alloc]init];
            for (NSString *ticker in tickers) {
                DYStockPropertyItem *item = [DYStockPropertyService getPropertyItemByTicker:ticker];
                DYStareWizardStockInfoModel *model = [[DYStareWizardStockInfoModel alloc]init];
                model.stockName = item.secName;
                model.tickerId = item.tradeCode;
                model.assetType = item.secType;
                model.status = 1;
                model.exchangeCD = item.tradeMarket;
                [stockArray addObject:model];
            }
            [DYStareOptionalMonitorSetService addStareWizardStockListWithArray:stockArray success:^(id data) {
            } fail:^(id data) {
            }];
        }
    }
}

@end
