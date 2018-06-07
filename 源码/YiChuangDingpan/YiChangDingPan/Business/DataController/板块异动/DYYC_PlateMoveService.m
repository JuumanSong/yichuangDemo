//
//  DYYC_PlateMoveService.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_PlateMoveService.h"
#import "DYYCDataSourceList.h"
#import "DYYC_AreaShakeModel.h"
#import "DYYCInterface.h"

@implementation DYYC_PlateMoveService

- (id)init {
    if (self == [super init]) {
        if (!_expandDict) {
            _expandDict = [[NSMutableDictionary alloc] init];
            
        }
    }
    return self;
}

+(void)getNewAreaMsgsWithLastId:(NSInteger)count success:(void (^)(id))success fail:(void (^)(id))fail{
    
    NSDictionary *dic = @{};
    if(count == 1){
        dic = @{@"count":@(count),@"noComments":@"true"};
    }
    
    [DYYCDataSourceList getNewAreaMsgsWithParam:dic Success:^(NSInteger code, id data, NSString *message) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary * dict in data[@"data"]) {
                    @autoreleasepool {
                        DYYC_AreaShakeModel * model =[DYYC_AreaShakeModel yy_modelWithJSON:dict];
                        DYYC_AreaShakeDataModel *dataModel = [DYYC_AreaShakeDataModel yy_modelWithJSON:dict[@"data"]];
                        DYYCPlateMoveType type;
                        switch (model.subCardType.integerValue) {
                            case 7:
                            case 13:
                                type = DYYCPlateMoveTypeTheme;
                                break;
                            case 17:
                            case 18:
                            {
                                type = DYYCPlateMoveTypeDefult;
                            }
                                break;
                            default:
                                type = DYYCPlateMoveTypeComment;
                                break;
                        }
                        NSDictionary *dic = [DYYC_PlateMoveService getMatchesDictAdapterOfString:dataModel.abs];
                        dataModel.optionalArr = dic[@"optional"];
                        dataModel.highlightArr = dic[@"highlight"];
                        dataModel.detail = dic[@"result"];
                        dataModel.type = type;
                        model.data = dataModel;
                        [arr addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(arr.copy);
                });
                
            });
            
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}
+(void)getIdxMktPriceGraphWithSecId:(NSString *)secId success:(void (^)(id))success fail:(void (^)(id))fail{
    
    [DYYCDataSourceList getIdxMktPriceGraphWithParam:nil Success:^(NSInteger code, id data, NSString *message) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            success(data[@"data"]);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (NSDictionary *)getMatchesDictAdapterOfString:(NSString *)string {
    NSMutableArray *optionalArr = [NSMutableArray array];
    NSMutableArray *highlightArr = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *firstArr = [string componentsSeparatedByString:@"</stock>"];
    NSString *result = [NSString string];
    for (NSInteger i = 0; i < firstArr.count; i++) {
        @autoreleasepool {
            NSString *iTmp = firstArr[i];
            NSArray *secondArr = [iTmp componentsSeparatedByString:@"<stock>"];
            for (NSInteger j = 0; j < secondArr.count; j++) {
                NSString *jTmp = secondArr[j];
                
                if ([jTmp rangeOfString:@"<"].location != NSNotFound) {
                    NSRange range;
                    range.location = [jTmp rangeOfString:@"<"].location + 1;
                    range.length = [jTmp rangeOfString:@">"].location - range.location;
                    NSString *stock = [jTmp substringToIndex:[jTmp rangeOfString:@"<"].location];
                    NSString *numStr = [jTmp substringWithRange:range];
                    
                    NSDictionary *dict = @{
                                           @"stock": stock ?: @"",
                                           @"stockNum": numStr ?: @""
                                           };
                    
                    NSArray *userArr = [[DYYCInterface shareInstance].delegate userStockArr];
                    __block BOOL isOptional = NO;
                    [userArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isEqualToString:numStr]) {
                            isOptional = YES;
                            [optionalArr addObject:dict];
                        }
                    }];
                    
                    if (!isOptional) {[highlightArr addObject:dict];}
                    result = [result stringByAppendingString:stock];
                }
                else {
                    result = [result stringByAppendingString:jTmp];
                }
            }
        }
    }
    [dict setValue:result ?: @"" forKey:@"result"];
    [dict setValue:highlightArr forKey:@"highlight"];
    [dict setValue:optionalArr forKey:@"optional"];
    return dict;
}

@end

