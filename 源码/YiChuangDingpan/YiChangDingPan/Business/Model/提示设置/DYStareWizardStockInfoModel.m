//
//  DYStockInfoModel.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardStockInfoModel.h"
#import "DYStockPropertyService.h"
@implementation DYStareWizardStockInfoModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"tickerId": @"t",
             @"exchangeCD": @"e",
             @"assetType": @"a",
             };
}

- (NSString *)stockName{
    _stockName = [DYStockPropertyService getPropertyItemByTicker:self.tickerId].secName;
    return _stockName;
}
- (NSString *)secId {
    _secId = [DYStockPropertyService getPropertyItemByTicker:_tickerId].secId;
    return _secId;
}
- (NSString *)source {
    // 1,自选股添加; 2,手工添加; 3,持仓股
    switch (_status) {
        case 1:
            return _source = @"自选";
            break;
        case 2:
            return _source = @"主动添加";
            break;
        case 3:
            return _source = @"持仓";
            break;
        default:
            return _source = @"";
            break;
    }
}

@end
