//
//  DYStareMonitorSetHeaderView.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorSetHeaderView.h"

@implementation DYStareMonitorSetHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.countLabel.textColor = DYAppearanceColor(@"R3", 1.0);
    
    self.editButton.layer.cornerRadius = 2;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.backgroundColor = DYAppearanceColor(@"Y4", 1.0);
}

// 获取个股数目
- (void)reloadCountLabelText {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockCount)]) {
        NSInteger count = [self.delegate getStockCount];
        self.countLabel.text = [NSString stringWithFormat:@"%ld只", (long)count];;
    }
}

- (IBAction)editButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editStockClick)]) {
        [self.delegate editStockClick];
    }
}

@end
