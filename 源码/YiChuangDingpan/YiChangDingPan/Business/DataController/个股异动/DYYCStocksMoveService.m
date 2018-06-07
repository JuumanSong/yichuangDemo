//
//  DYYCStocksMoveService.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCStocksMoveService.h"
#import "DYYCDataSourceList.h"
#import "DYYCStockHelper.h"
#import "DYYCNewMsgsModel.h"
#import "DYTimeTransformUtil.h"
#import "DYYCIndustryListService.h"
#import "DYItem.h"
#import "DYAdvancedSetService.h"
#import "DYPersonSettingModel.h"
#import "DYStareOptionalMonitorSetService.h"
#import "DYYCInterface.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_cache) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

static DYYCStocksMoveService *stocksMoveService = nil;

@interface DYYCStocksMoveService()

@end

@implementation DYYCStocksMoveService {
    dispatch_semaphore_t _lock;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        stocksMoveService = [[DYYCStocksMoveService alloc] init];
    });
    return stocksMoveService;
}

- (instancetype)init {
    INIT(_cache = [[NSMutableArray alloc] init]);
}

- (void)loadNewMsgsDataOfStockId:(NSString *)stockId isUp:(BOOL)up success:(void(^)(id data,BOOL isMore))success fail:(void(^)(id data))fail {
    if (up) {
        [_cache removeAllObjects];
    }
    
    DYPersonSettingModel *model = [DYAdvancedSetService shareInstance].personSettingModel;
    NSMutableArray *sc = [NSMutableArray array];
    NSMutableArray *bts = [NSMutableArray array];
    // 消息类型数据解析
    for (DYAdvancedModel *advancedModel in model.modelArray) {
        for (int i=0; i<advancedModel.bt.length-1; i++) {
            NSString * str =[advancedModel.bt substringWithRange:NSMakeRange(i+1, 1)];
            if ([str integerValue]==1) {
                
                NSString *f = [NSString stringWithFormat:@"%@-%d",advancedModel.sct,i+1];
                [bts addObject:f];
                if (![sc containsObject:@([advancedModel.sct integerValue])]) {
                    
                     [sc addObject:@([advancedModel.sct integerValue])];
                }
                
            }
        }
        
    }
    
    NSMutableDictionary *param = @{
                            @"i": model.industryArray ?: @[],
                            @"sc": sc,
                            @"f": bts,
                          }.mutableCopy;
    
    if (model.category == 5) {// 特别关注
        NSMutableArray *result = [NSMutableArray array];
        NSArray *arr = [DYStareOptionalMonitorSetService shareInstance].stockArray;
        for (DYStareWizardStockInfoModel *tmp in arr) {

            [result addObject:tmp.tickerId];
        }

        [param setValue:result forKey:@"t"];
    }
    
    if (model.category == 4) { // 自选股
        NSArray *result = [DYYCInterface shareInstance].delegate.userStockArr;
        [param setValue:result forKey:@"t"];
    }
    
    
    switch (model.category) {
        case 2:
        {
            [param setValue:@"XSHG" forKey:@"e"];
        }
            break;
        case 3:
        {
             [param setValue:@"XSHE" forKey:@"e"];
        }
            break;
        case 4:
        { // 自选股
            NSArray *result = [DYYCInterface shareInstance].delegate.userStockArr;
            [param setValue:result forKey:@"t"];
        }
            break;
        case 5:
        {// 特别关注
            NSMutableArray *result = [NSMutableArray array];
            NSArray *arr = [DYStareOptionalMonitorSetService shareInstance].stockArray;
            for (DYStareWizardStockInfoModel *tmp in arr) {
                
                [result addObject:tmp.tickerId];
            }
            
            [param setValue:result forKey:@"t"];
        }
        default:
            break;
    }
    
    //个股筛选
    if (stockId) {
        [param setValue:@[stockId] forKey:@"t"];
        [param removeObjectForKey:@"e"];
    }
    if (!up) {
        DYYCNewMsgsModel *model = _cache.lastObject;
        if (model && model.stockId) [param setValue:model.stockId forKey:@"l"];
    }
    WS(weakSelf);
    [DYYCDataSourceList getNewMsgsWithParam:param Success:^(NSInteger code, id data, NSString *message) {
        if (data && [data isKindOfClass:[NSDictionary class]] && data[@"data"]) {

        NSArray *modelArray = [NSArray yy_modelArrayWithClass:[DYYCNewMsgsModel class] json:data[@"data"]];
            for (DYYCNewMsgsModel * model in modelArray) {
                
               model.dataModel =[DYYCNewMsgsDataModel yy_modelWithJSON:model.data];
                
            }
            if (modelArray.count > 0) {
                [weakSelf.cache addObjectsFromArray:modelArray];
                success(weakSelf.cache,YES);
            }
            else {
                success(weakSelf.cache,NO);
            }
        
    }
    else {
        success(nil,NO);
    }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)loadSettingMessageListBlock:(void(^)(NSArray *arr))Block {
    
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *firstArr = @[
                          @"全A股",
                          @"自选股",
                          @"沪A",
                          @"特别关注",
                          @"深A"
                          ];
    
    NSArray *messageImgArr = @[
                               @"YC_daojia",
                               @"YC_jiakeyidong",
                               @"YC_Group",
                               @"YC_jishuxihao",
                               @"YC_zhangdieting",
                               @"yc_kline",
                               @"YC_panhou",
                               @"yc_gonggao"
                               ];
    
    NSArray *msgTitleArr = @[
                             @"到价提醒",
                             @"价格异动",
                             @"主力大单",
                             @"技术信号",
                             @"涨跌停提醒",
                             @"相似K线",
                             @"盘后多日信号",
                             @"重要公告"
                             ];
    
    NSArray *msgDetailArr = @[
                              @"到达指定的价格或者涨跌停",
                              @"价格快速拉升/下跌",
                              @"大单买入/卖出",
                              @"KDJ金叉/KDJ突破上轨/突破5日均线等",
                              @"涨跌停/开板提醒/预期开板提醒",
                              @"相似度80%以上，未来20日平均收益率涨跌幅达到15%以上",
                              @"连阳/连续n日创新高/连续放量/连续资金流入流出",
                              @"业绩预增/预减；高管增减持；限售股解禁；高管离职；资产重组；重大合同；股票增发；分红送转"
                              ];
    
    DYItem *rootItem1 = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeNormal titleName:@"全A股" industryId:nil];
    rootItem1.childrenNodes = [NSMutableArray array];
    for (NSInteger i = 0;i < firstArr.count;i++) {
        NSString *title = firstArr[i];
        DYItem *subItem = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeNormal titleName:title industryId:nil];
        
        [rootItem1.childrenNodes addObject:subItem];
    }
    
    DYItem *rootItem2 = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeindustry titleName:@"行业板块" industryId:nil];
    rootItem2.childrenNodes = [NSMutableArray array];
    
    DYItem *rootItem3 = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeMessage titleName:@"消息类型" industryId:nil];
    rootItem3.childrenNodes = [NSMutableArray array];
    
    for (NSInteger i = 0;i < msgTitleArr.count;i++) {
        NSString *title = msgTitleArr[i];
        DYItem *subItem = [DYItem itemWithItemType:DYItemMarkTypeUnselected titleName:title leftImg:messageImgArr[i] detail:msgDetailArr[i]];
        
        [rootItem3.childrenNodes addObject:subItem];
    }
    
    DYItem *rootItem4 = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeNormal titleName:@"高级设置" industryId:nil];
    
    [resultArr addObject:rootItem1];
    [resultArr addObject:rootItem2];
    [resultArr addObject:rootItem3];
    [resultArr addObject:rootItem4];
    
    Block(resultArr.copy);
    // 获取行业列表
    [[DYYCIndustryListService shareInstance] loadIndustryListDataWithSuccess:^(id data) {
        
        
        if (data) {
            NSArray *tmpArr = (NSArray *)data;
        DYItem *rootItem2 = resultArr[1];
        
        for (NSInteger i = 0;i < tmpArr.count;i++) {
            NSDictionary *dict = tmpArr[i];
            DYItem *subItem = [DYItem itemWithItemType:DYItemMarkTypeViewDisplayTypeindustry titleName:dict[@"name1"] industryId:dict[@"id1"]];
            
            [rootItem2.childrenNodes addObject:subItem];
        }
        }
//        Block(YES,resultArr.copy);
    } fail:^(id data) {
       
    }];
    
}

- (id)getLocalSaveSettingDataType:(DYItemMarkTypeViewDisplayType)type {

    if (type == DYItemMarkTypeViewDisplayTypeNormal) {
        NSInteger category = [DYAdvancedSetService shareInstance].personSettingModel.category;
        
        NSDictionary *dict = @{
                               @"1":@"全A股",
                               @"2":@"沪A",
                               @"3":@"深A",
                               @"4":@"自选股",
                               @"5":@"特别关注"
                               };
        return dict[@(category).stringValue];
        
    }
    else {
        // 用于保存选中的行业名称
        
        NSArray *industryArr = [DYAdvancedSetService shareInstance].personSettingModel.industryArray.copy;

        return industryArr;
    }
    
}

- (DYPersonSettingModel *)setSelectSettingDataWithType:(DYItemMarkTypeViewDisplayType)type data:(id)data {
    
    DYPersonSettingModel *model = [DYAdvancedSetService shareInstance].personSettingModel;
    if (type == DYItemMarkTypeViewDisplayTypeNormal) {
        NSString *selectName = (NSString *)data;
        NSDictionary *dict = @{
                               
                               @"全A股": @"1",
                               @"沪A": @"2",
                               @"深A": @"3",
                               @"自选股": @"4",
                               @"特别关注": @"5"
                               };
        NSString *value = dict[selectName];
        if (value) model.category = value.integerValue;
        
    }
    else {
        NSArray *industryArr = (NSArray *)data;
        
        if (industryArr.count == 0) {
            model.industryArray = [NSMutableArray array];
            return model;
        }
        [model.industryArray removeAllObjects];
        model.industryArray = [NSMutableArray array];
        [model.industryArray addObjectsFromArray:industryArr];
    }
    return model;
    
}

@end
