//
//  DYYCNewMsgsModel.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCNewMsgsModel.h"
#import "NSString+JsonValue.h"
#import "DYTimeTransformUtil.h"
#import "DYYCStockHelper.h"
#import "NSString+NumberFormat.h"

@implementation DYYCNewMsgsModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"stockId":@"id"};
}

@end
@implementation DYYCNewMsgsDataModel
- (NSString *)moveMsg {
    if (_moveMsg) return _moveMsg;
    if (self.sct.integerValue == 12) { // 盘后多日信号类型
        _moveMsg = _n;
    }
    else if (self.sct.integerValue == 5) {// 重要公告
        _moveMsg = @"重要公告";
    }
    else if (self.sct.integerValue == 6) { //相似K线
        _moveMsg = @"相似K线";
    }
    else {
        NSString *key = [self.sct stringByAppendingString:self.bt];
        _moveMsg = [[DYYCStockHelper shareInstance] getMoveMsgWithCode:key];
    }
    return _moveMsg;
}

- (NSString *)time {
    if (_time) return _time;
    if (_ts.length) {
        _time = [DYTimeTransformUtil translateToHHMMSSWithTime:[self.ts doubleValue]/1000];
    }
    return _time;
}
- (NSString *)value {
    if (_value) return _value;
    switch (_sct.integerValue) {
        case 1:
        {
            _value = [NSString stringWithFormat:@"%@元",[NSString convertToNumber:_v.doubleValue withUnit:YES]];
        }
            break;
        case 4:
        case 11:
        case 12:
        {
            if (_bt.integerValue == 11 && _sct.integerValue == 12)
            {
                _value = [NSString stringWithFormat:@"%@元",[NSString convertToNumber:_v.doubleValue withUnit:YES]];
            }
            else
            {
                _value = [NSString stringWithFormat:@"%@%%",[NSString convertToNumber:_v.doubleValue * 100 withUnit:NO]];
            }
        }
            break;
        case 16:
        {
            if (_bt.integerValue == 1) {
                
                _value = [NSString stringWithFormat:@"%@手",[DYYCNewMsgsDataModel convertToNumber:_v.intValue / 100 withUnit:YES]];
                
            }
            else {
                _value = [NSString stringWithFormat:@"%@%%",[NSString convertToNumber:_v.doubleValue * 100 withUnit:NO]];
            }
            
        }
            break;
        case 3:
        {
            _value = [NSString stringWithFormat:@"%@手",[DYYCNewMsgsDataModel convertToNumber:_v.intValue / 100 withUnit:YES]];
            
        }
            break;
//        case 5: //
//        {
//            NSString *key = [_sct stringByAppendingString:_bt];
//            _value = [[DYYCStockHelper shareInstance] getMoveMsgWithCode:key];
//        }
//            break;
        case 6: // 相似k线
        {
            if (_f.integerValue == 1) {
                _value = [NSString stringWithFormat:@"后续上涨%@%%",[NSString convertToNumber:_v.doubleValue * 100 withUnit:NO]];
            }
            else {
                NSString *value = [NSString convertToNumber:_v.doubleValue * 100 withUnit:NO];
                _value = [NSString stringWithFormat:@"后续下跌%@%%", [value stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            }
        }
            break;
        default:
        {
            _value = _v;
        }
            break;
    }
    return _value;
}

// 数字超过1万，显示单位"xx万"；超过1亿，显示单位"xx亿"
+ (NSString *)convertToNumber:(float)number withUnit:(BOOL)unit {
    //·1万以下（不包括1万）不显示单位
    //  case：数据9999.12显示为“9999.12”
    //·1万以上（包括1万）1亿以下（不包括1亿）换算成以“万”为单位的计数方式，并且显示单位“万”
    //  case：数据99991234.01显示成“9999.12万”
    //·1亿以上（包括1亿），换算成以“亿”为单位的计数方式，并且显示单位“亿”
    //  case：999912341234显示成“9999.12亿”
    if (!isnan(number)) {
        number = [self getFloatValue:number];
    }
    
    if (fabsf(number) / 100000000 >= 1) {
        
        return unit ? [NSString stringWithFormat:@"%0.2f%@",number / 100000000,@"亿"] :
        [NSString stringWithFormat:@"%0.2f",number / 100000000];
        
    } else if (fabsf(number) / 10000 >= 1) {
        
        return unit ? [NSString stringWithFormat:@"%0.1f%@",number / 10000,@"万"] :
        [NSString stringWithFormat:@"%0.2f",number / 10000];
        
    } else {
        
        if (fabs(number)*100 < 1) {
            
            return [NSString stringWithFormat:@"%0.0f",number];
            
        } else {
            
            return [NSString stringWithFormat:@"%0.0f",number];
        }
    }
}

+ (float)getFloatValue:(float)f {
    if (f > LLONG_MAX/1000001.0) {
        return f;
    }
    else if(f) {
        long long int i = 1000000 * f;
        return (float)i/1000000.0 + 1/1000000.0;
    }
    else{
        return 0.0f;
    }
}

@end

