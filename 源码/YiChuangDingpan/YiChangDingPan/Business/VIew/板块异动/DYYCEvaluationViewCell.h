//
//  DYYCEvaluationViewCell.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

@class DYYC_AreaShakeModel;


static NSString *const DYYCEvaluationViewCellId = @"DYYCEvaluationViewCellIdentifier";

@interface DYYCEvaluationViewCell : DYBorderViewCell

- (void)configCellWithDict:(NSDictionary *)dict
                clickBlock:(DataBlock)clickBlock;

+ (CGFloat)getCellHeightWhihData:(NSString *)detail;


@end
