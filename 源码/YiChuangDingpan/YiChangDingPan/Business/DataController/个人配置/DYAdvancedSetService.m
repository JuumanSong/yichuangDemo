//
//  DYAdvancedSetService.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYAdvancedSetService.h"
#import "DYYCDataSourceList.h"
static DYAdvancedSetService *dYAdvancedSetService = nil;
@implementation DYAdvancedSetService
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dYAdvancedSetService = [[DYAdvancedSetService alloc]init];
        dYAdvancedSetService.personSettingModel=[self getDefaultGeneralRulesInfo];
    });
    return dYAdvancedSetService;
}
//获取个人配置
-(void)getGeneralRulesWithSuccess:(void (^)(id))success fail:(void (^)(id))fail{

    [DYYCDataSourceList getSettingWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //请求成功，更新本地设置
            DYPersonSettingModel *model = [DYPersonSettingModel yy_modelWithJSON:data[@"data"]];
            //需要对model中的消息类型数组过滤排序
            NSMutableArray * array =[NSMutableArray arrayWithArray:[DYAdvancedSetService getDefaultGeneralRulesInfoDictArray]];
            for (DYAdvancedModel * advanceModel in model.modelArray) {
                
                switch ([advanceModel.sct integerValue]) {
                    case 1:
                        [array replaceObjectAtIndex:0 withObject:advanceModel];
                        break;
                    case 4:
                    {
                         [array replaceObjectAtIndex:1 withObject:advanceModel];
                    }
                        break;
                    case 3:
                    {
                        [array replaceObjectAtIndex:2 withObject:advanceModel];
                    }
                        break;
                    case 11:
                    {
                        [array replaceObjectAtIndex:3 withObject:advanceModel];
                    }
                        break;
                    case 16:
                    {
                        [array replaceObjectAtIndex:4 withObject:advanceModel];
                    }
                        break;
                    case 6:
                    {
                        [array replaceObjectAtIndex:5 withObject:advanceModel];
                    }
                        break;
                    case 12:
                    {
                        [array replaceObjectAtIndex:6 withObject:advanceModel];
                    }
                        break;
                    case 5:
                    {
                        [array replaceObjectAtIndex:7 withObject:advanceModel];
                    }
                        break;
                    default:
                        break;
                }
            }
            [DYAdvancedSetService shareInstance].personSettingModel = model;
            [DYAdvancedSetService shareInstance].personSettingModel.modelArray = array;
            
        }
    } fail:^(NSError *error) {
        
    }];
}
//设置个人配置
-(void)setGeneralRuleWithDataModel:(DYPersonSettingModel *)model Success:(void (^)(id))success fail:(void (^)(id))fail{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    //需要将model转化为字典
    for (DYAdvancedModel * advancedModel in model.modelArray) {
        NSDictionary * dict =[self returnToDictionaryWithModel:advancedModel];
        [array addObject:dict];
    }
    
    NSDictionary * param =@{@"g":array,
                            @"c":@(model.category),
                            @"i":model.industryArray ?: @[]
                            };
    [DYYCDataSourceList saveSettingWithParam:param Success:^(NSInteger code, id data, NSString *message) {
        //设置成功后，更新本地内存设置
        success(@1);

    } fail:^(NSError *error) {
        fail(error);
    }];
}
//设置本地默认数据
+(DYPersonSettingModel*)getDefaultGeneralRulesInfo {
    
    NSArray *infoArray = @[
                           @{
                               @"ct": @1,
                               @"sct": @1,
                               @"s": @1,
                               @"bt": @"011",//到价
                               },
                           @{
                               @"ct": @4,
                               @"sct": @4,
                               @"s": @1,
                               @"bt": @"01111",//价格异动
                               },
                           @{
                               @"ct": @3,
                               @"sct": @3,
                               @"s": @1,
                               @"bt": @"011",//主力大单
                               },
                           @{
                               @"ct": @11,
                               @"sct": @11,
                               @"s": @1,
                               @"bt": @"01111111",//技术信号
                               },
                           @{
                               @"ct": @16,//涨跌停未知
                               @"sct": @16,
                               @"s": @1,
                               @"bt": @"01111111",
                               },
                           @{
                               @"ct": @6,
                               @"sct": @6,
                               @"s": @1,
                               @"bt": @"0111",//相似K线
                               },
                           @{
                               @"ct": @12,
                               @"sct": @12,
                               @"s": @1,
                               @"bt": @"0111111111111111111",//盘后监控
                               },
                           @{
                               @"ct": @5,
                               @"sct": @5,
                               @"s": @1,
                               @"bt": @"01111111111",//重要公告
                               },


    
                           ];
    NSDictionary * dict =@{@"g":infoArray,
                           @"c":@1,
                           @"i":@[] //@"01030306",@"01030305"
                           };
    return [DYPersonSettingModel yy_modelWithDictionary:dict];
}
//model转化为字典
-(NSMutableDictionary *)returnToDictionaryWithModel:(DYAdvancedModel *)model {
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([DYAdvancedModel class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
            
        }
        
    }
    free(properties);
    return userDic;
}

+(NSArray*)getDefaultGeneralRulesInfoDictArray{
    NSArray *infoArray = @[
                           @{
                               @"ct": @1,
                               @"sct": @1,
                               @"s": @1,
                               @"bt": @"011",//到价
                               },
                           @{
                               @"ct": @4,
                               @"sct": @4,
                               @"s": @1,
                               @"bt": @"011",//价格异动
                               },
                           @{
                               @"ct": @3,
                               @"sct": @3,
                               @"s": @1,
                               @"bt": @"011",//主力大单
                               },
                           @{
                               @"ct": @11,
                               @"sct": @11,
                               @"s": @1,
                               @"bt": @"01111111",//技术信号
                               },
                           @{
                               @"ct": @16,//涨跌停未知
                               @"sct": @16,
                               @"s": @1,
                               @"bt": @"01111111",
                               },
                           @{
                               @"ct": @6,
                               @"sct": @6,
                               @"s": @1,
                               @"bt": @"0111",//相似K线
                               },
                           @{
                               @"ct": @12,
                               @"sct": @12,
                               @"s": @1,
                               @"bt": @"0111111111111111111",//盘后监控
                               },
                           @{
                               @"ct": @5,
                               @"sct": @5,
                               @"s": @1,
                               @"bt": @"011111111",//重要公告
                               },
                           
                           
                           
                           ];
    
    NSMutableArray * array =[[NSMutableArray alloc]init];
    for (NSDictionary * dict in infoArray) {
        
    DYAdvancedModel * model = [DYAdvancedModel yy_modelWithJSON:dict];
        [array addObject:model];
    }
    return array;
}
@end
