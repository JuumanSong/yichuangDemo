//
//  DYStocksMoveHeaderView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStocksMoveHeaderView.h"

@interface DYStocksMoveHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;


@end

@implementation DYStocksMoveHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = DYAppearanceColorFromHex(0xF8F8F8, 1);
    
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = DYAppearanceColorFromHex(0x7E7E7E, 1);
    
    self.moveDesLabel.font = [UIFont systemFontOfSize:13];
    self.moveDesLabel.textColor = DYAppearanceColorFromHex(0x7E7E7E, 1);
    
    self.moveNumLabel.font = [UIFont systemFontOfSize:13];
    self.moveNumLabel.textColor = DYAppearanceColorFromHex(0x7E7E7E, 1);
    
    self.stockLabel.font = [UIFont systemFontOfSize:13];
    self.stockLabel.textColor = DYAppearanceColorFromHex(0x7E7E7E, 1);
}

@end
