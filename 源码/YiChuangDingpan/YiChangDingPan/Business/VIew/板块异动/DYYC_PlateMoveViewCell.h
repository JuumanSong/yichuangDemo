//
//  DYYC_PlateMoveViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

static NSString *const DYYC_PlateMoveViewCellId = @"DYYC_PlateMoveViewCellIdentifier";

@interface DYYC_PlateMoveViewCell : DYBorderViewCell

- (void)configCellShowUp:(BOOL)isShowUp
                showDown:(BOOL)isShowDown
                    time:(NSString *)time
                  detail:(NSString *)detail
            highlightArr:(NSArray *)highlightArr
             optionalArr:(NSArray *)optionalArr
              clickBlock:(DataBlock)clickBlock;

+(CGFloat)getCellHeightWhihData:(NSString *)detail;

@end

