//
//  DYYC_SiftStock.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_SiftStock.h"
#import "DYStareOptionalMonitorSetService.h"
#import "DYStockPropertyService.h"
#import "DYAdvancedSetService.h"
#import "DYPersonSettingModel.h"

static DYYC_SiftStock *dYYC_SiftStock = nil;
@interface DYYC_SiftStock()
@property(nonatomic,strong)NSMutableDictionary * cache;//缓存筛选值；
@end
@implementation DYYC_SiftStock
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dYYC_SiftStock = [[DYYC_SiftStock alloc]init];
    });
    return dYYC_SiftStock;
}
/**
 针对长链接个股筛选--获取本地数据，通过tickerId获取相应的股票市场行业等信息，再与本地个人配置比较筛选

 @param tickerId tickerId description
 @param sct sct 通过个股的sct定位本地个人配置中的bt，然后比较筛选
 @param bt bt description
 */
-(BOOL)siftStockWithTicker:(NSString *)tickerId sct:(NSString *)sct bt:(NSString *)bt{
    
    //首先根据sct获取当前个人配置bt，市场e，行业in
    NSString * key =[NSString stringWithFormat:@"%@%@%@",tickerId,sct,bt];
    if ([[_cache objectForKey:key] isKindOfClass:[NSNumber class]]) {
        
        return [[_cache objectForKey:key] boolValue];
    }else{
        
        DYStockPropertyItem * item = [DYStockPropertyService getPropertyItemByTicker:tickerId];
        
        if([self isContainTheBt:sct bt:bt] && [self isInIndustryWithIndustry:item.classifyId] && [self isOfWhichMarketWithE:item.tradeMarket withTickerId:tickerId]){
            [_cache setObject:@1 forKey:key];
            return YES;
        }else{
            [_cache setObject:@0 forKey:key];
            return NO;
        }
    }

}

/**
 行业筛选

 @param industry 行业名称
 @return yes代表属于筛选通过
 */
-(BOOL)isInIndustryWithIndustry:(NSString*)industry{
    
    NSArray * industryArray =[DYAdvancedSetService shareInstance].personSettingModel.industryArray;
    if ([industryArray containsObject:industry] || industryArray.count == 0) {
        
        return YES;
    }else{
        
        return NO;
    }

    return YES;
}
/**
 市场筛选
 目前只对沪深处理
 */
-(BOOL)isOfWhichMarketWithE:(NSString*)e withTickerId:tickerId{
    
    NSInteger category = [DYAdvancedSetService shareInstance].personSettingModel.category;
    switch (category) {
        case 0:
        {
            //
            return YES;
        }
            break;
        case 1:
        {
            return YES;//全A
        }
            break;
        case 2:
        {
            if ([e isEqualToString:@"XSHG"]) {
                
                return YES;
            }else{
                
                return NO;
            }
        }
            break;
        case 3:
        {
            if ([e isEqualToString:@"XSHE"]) {
                
                return YES;
            }else{
                
                return NO;
            }
        }
            break;
        case 4:
        {
            //自选股
            if ([[DYYCInterface shareInstance].delegate.userStockArr containsObject:tickerId]) {
                return YES;
            }else{
                
                return NO;
            }
            
        }
            break;
        case 5:
        {
            for (DYStareWizardStockInfoModel * model in [DYStareOptionalMonitorSetService shareInstance].stockArray) {
                
                if (model.tickerId==tickerId) {
                    
                    return YES;
                }
            }
            return NO;
         
        }
            break;
        default:
        {
            return NO;
        }
            break;
    }
    
    return NO;
}

/**
 设置筛选

 @param sct 二级卡片
 @param bt 三级子类设置0111
 @return yes代表通过筛选
 */
-(BOOL)isContainTheBt:(NSString*)sct bt:(NSString*)bt{
    
    NSString * bt_setting = @"";
    NSArray * modelArray =[DYAdvancedSetService shareInstance].personSettingModel.modelArray;
    for (DYAdvancedModel * model in modelArray) {
        
        if ([sct isEqualToString:model.sct]) {
            
            bt_setting =model.bt;
            break;
        }
    }
    NSString *  str =   [bt_setting substringWithRange:NSMakeRange(bt.length, 1)];
    return ([str integerValue]==1)?YES:NO;
}

/**
清空缓存
 */
-(void)clearCache{
    
    [_cache removeAllObjects];
}
@end
