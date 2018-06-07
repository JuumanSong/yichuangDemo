//
//  DYCalculateAttrilabelHeight.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/19.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYCalculateAttrilabelHeight.h"
static DYCalculateAttrilabelHeight* instance = nil;
@implementation DYCalculateAttrilabelHeight
// 单例
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DYCalculateAttrilabelHeight alloc] init];
        
    });
    return instance;
}
-(TYAttributedLabel *)attrTextLabel{
    if (!_attrTextLabel) {
        
        _attrTextLabel =[[TYAttributedLabel alloc]init];
        
    }
    return _attrTextLabel;
}

-(CGFloat)rowHeightWithDetailStr:(NSString *)str width:(NSInteger)width font:(CGFloat)font lineNum:(CGFloat)lineNum {
    _attrTextLabel.font = [UIFont systemFontOfSize:font];
    _attrTextLabel.numberOfLines = lineNum;
    self.attrTextLabel.text=str;
    CGFloat attrHeight = [self.attrTextLabel getHeightWithWidth:width];
    
    return attrHeight;
}
@end
