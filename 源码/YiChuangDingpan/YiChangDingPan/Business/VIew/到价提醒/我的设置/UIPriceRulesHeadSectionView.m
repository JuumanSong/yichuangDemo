//
//  UIPriceRulesHeadSectionView.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/17.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "UIPriceRulesHeadSectionView.h"

@implementation UIPriceRulesHeadSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = DYAppearanceColor(@"H1", 1);
    self.titleLabel.textColor = DYAppearanceColor(@"W1", 1);
    self.titleLabel.font = DYAppearanceFont(@"T1");
    self.titleLabel.backgroundColor = DYAppearanceColor(@"R3", 1);
    self.titleLabel.layer.cornerRadius = 10;
    self.titleLabel.clipsToBounds = YES;
}
@end
