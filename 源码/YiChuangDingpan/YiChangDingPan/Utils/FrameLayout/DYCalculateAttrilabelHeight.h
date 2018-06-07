//
//  DYCalculateAttrilabelHeight.h
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/19.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYAttributedLabel/TYAttributedLabel.h>
@interface DYCalculateAttrilabelHeight : NSObject
@property (nonatomic,strong) TYAttributedLabel *attrTextLabel;
+(instancetype)sharedInstance;

-(CGFloat)rowHeightWithDetailStr:(NSString *)str width:(NSInteger)width font:(CGFloat)font lineNum:(CGFloat)lineNum;
@end
