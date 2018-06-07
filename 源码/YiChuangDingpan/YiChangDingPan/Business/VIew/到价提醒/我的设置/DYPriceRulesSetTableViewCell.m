//
//  DYPriceRulesTableViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/17.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesSetTableViewCell.h"
@interface DYPriceRulesSetTableViewCell()
@property (nonatomic, strong) DataBlock block;

@end
@implementation DYPriceRulesSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = DYAppearanceColor(@"H1", 1);
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.shadowOpacity = 1.0;                        // 阴影透明度
    self.bgView.layer.shadowColor = DYAppearanceColor(@"H2", 1.0).CGColor;  // 阴影的颜色
    self.bgView.layer.shadowRadius = 4;                          // 阴影扩散的范围控制
    self.bgView.layer.shadowOffset = CGSizeMake(0, 2);           // 阴影的范围
    self.remindView.clipsToBounds = YES;
    
    self.nameLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.nameLabel.font = DYAppearanceFont(@"T5");
    self.codeLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.codeLabel.font = DYAppearanceFont(@"T2");
    self.daojiaLabel.textColor = DYAppearanceColor(@"B14", 1.0);
    self.daojiaLabel.font = DYAppearanceFont(@"T5");
    
    self.lastPriceLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.lastPriceLabel.font = DYAppearanceFont(@"T3");
    self.priceRiseLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.priceRiseLabel.font = DYAppearanceFont(@"T3");
    
    self.remindLabel1.textColor = DYAppearanceColor(@"H8", 1.0);
    self.remindLabel1.font = DYAppearanceFont(@"T5");
    self.remindLabel2.textColor = DYAppearanceColor(@"H8", 1.0);
    self.remindLabel2.font = DYAppearanceFont(@"T5");
    self.remindLabel3.textColor = DYAppearanceColor(@"H8", 1.0);
    self.remindLabel3.font = DYAppearanceFont(@"T5");
    self.remindLabel4.textColor = DYAppearanceColor(@"H8", 1.0);
    self.remindLabel4.font = DYAppearanceFont(@"T5");
    
}
- (IBAction)editClick:(id)sender {
    if (self.block) {
        self.block(nil);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)editBlock:(DataBlock)block {
    self.block = block;
}
@end
