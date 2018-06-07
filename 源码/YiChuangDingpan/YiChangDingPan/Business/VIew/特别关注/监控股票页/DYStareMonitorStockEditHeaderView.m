//
//  DYStareMonitorStockEditHeaderView.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorStockEditHeaderView.h"

@implementation DYStareMonitorStockEditHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rootContentView.layer.cornerRadius = 4;
    self.rootContentView.layer.masksToBounds = YES;
    self.rootContentView.backgroundColor = DYAppearanceColorFromHex(YC_Y1,0.1);
    
    self.addButton.layer.cornerRadius = 2;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.backgroundColor = DYAppearanceColorFromHex(YC_Y1, 1.0);
    
    self.leftLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.countLabel.textColor = DYAppearanceColor(@"R3", 1.0);
    self.rightLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    
    self.bottomView.backgroundColor = DYAppearanceColor(@"H1", 1.0);
    self.titleLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.sourceLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.bottonLine.backgroundColor = DYAppearanceColor(@"H2", 1.0);
}

// 赋值
- (void)configStockCount:(NSString *)count
              clickBlock:(DataBlock)block {
    self.countLabel.text = count;
    
    self.clickBlock = block;
}

- (IBAction)addButtonClick:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(nil);
    }
}

// height
+ (CGFloat)getHeaderHeight {
    return 128;
}

@end
