//
//  DYYC_AreaShakeModel.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_AreaShakeModel.h"
#import "DYTimeTransformUtil.h"
#import "DYCalculateAttrilabelHeight.h"
#import "NSString+UILableAdjustment.h"

@implementation DYYC_AreaShakeModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"lastId":@"id"};
}

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"data":[DYYC_AreaShakeDataModel class]};
}


@end


@implementation DYYC_AreaShakeDataModel

-(NSString *)dateStr{
    if (_dateStr) return _dateStr;
    return [DYTimeTransformUtil translateToHHMMWithTime:self.ts/1000];
}



- (CGFloat)height {

//    if (_height) return _height;
    if (_type == DYYCPlateMoveTypeDefult) {
//        if (_showType == DYYCPlateMoveShowTypeExpand) {
//        CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
//            _height += detailHeight;
//        }
//        else {
//            CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:3];
//            _height += detailHeight;
//        }
        CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
        _height =  detailHeight + 15;
        _height = _height>44?_height:44;
    }
    else if (_type == DYYCPlateMoveTypeTheme) {
        CGFloat topHeight = [@"主题" getStringHeightInLabSize:CGSizeMake(MAXFLOAT, MAXFLOAT) AndFont:[UIFont systemFontOfSize:14]];
        _height = topHeight + 15;
        if (_detail.length != 0) {
            if (_showType == DYYCPlateMoveShowTypeExpand) {
            CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
            _height += detailHeight;
            }
            else {
                CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:3];
                _height += detailHeight;
            }
        }
        _height += 5 + ([self isNeedAddTipLabel] ? 0 : 30);
        _height = _height>44?_height:44;
    }
    else {
        
        CGFloat topHeight = [_a getStringHeightInLabSize:CGSizeMake(DYScreenWidth - 65, MAXFLOAT) AndFont:[UIFont systemFontOfSize:14]];
        _height = topHeight + 15;
        if (_detail.length != 0) {
            if (_showType == DYYCPlateMoveShowTypeExpand) {
            CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
            _height += detailHeight;
            }
            else {
                CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:3];
                _height += detailHeight;
            }
        }
        _height += 5 + ([self isNeedAddTipLabel] ? 0 : 30);
        _height = _height>44?_height:44;
    }
    return _height;
}

- (BOOL)isTip {
    _isTip = [self isNeedAddTipLabel];
    return _isTip;
}

- (BOOL)isNeedAddTipLabel {
    CGFloat expandHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
    CGFloat normalHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:_detail width:DYScreenWidth - 55 - 10 font:14 lineNum:3];
    
    return expandHeight == normalHeight;
}

@end

