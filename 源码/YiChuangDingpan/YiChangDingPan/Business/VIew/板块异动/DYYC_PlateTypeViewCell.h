//
//  DYYC_PlateTypeViewCell.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

static NSString *const DYYC_PlateTypeViewCellId = @"DYYC_PlateTypeViewCellIdentifier";

@interface DYYC_PlateTypeViewCell : DYBorderViewCell

- (void)configCellWithDict:(NSDictionary *)dict
                clickBlock:(DataBlock)clickBlock;

+ (CGFloat)getCellHeightWhihData:(NSString *)detail;
@end
