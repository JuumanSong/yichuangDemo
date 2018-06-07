//
//  DYPriceRulesHeadView.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesHeadView.h"

@interface DYPriceRulesHeadView()
@property (nonatomic, strong) IntegerBlock block;
@property (nonatomic, strong) DataBlock chooseBlock;
@end

@implementation DYPriceRulesHeadView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.titleContentView.layer.cornerRadius = 4;
    self.titleContentView.backgroundColor = DYAppearanceColorFromHex(YC_Y1, 0.1);
    
    self.stockKeyLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.stockKeyLabel.font = DYAppearanceFont(@"T5");
    self.chufaKeyLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.chufaKeyLabel.font = DYAppearanceFont(@"T5");
    
    self.inputNameLabel.textColor = DYAppearanceColor(@"H3", 1.0);
    self.inputNameLabel.font = DYAppearanceFont(@"T5");

    self.stockNameLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.stockNameLabel.font = DYAppearanceBoldFont(@"T4");
    self.stockTickerLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.stockTickerLabel.font = DYAppearanceFont(@"T0");
    self.stockLastPriceKeyLabel.textColor = DYAppearanceColor(@"H8", 1.0);
    self.stockLastPriceKeyLabel.font = DYAppearanceFont(@"T1");
    self.stockLastPriceLabel.textColor = DYAppearanceColor(@"H8", 1.0);
    self.stockLastPriceLabel.font = DYAppearanceFont(@"T1");
    self.stockLastPriceRiseLabel.textColor = DYAppearanceColor(@"H8", 1.0);
    self.stockLastPriceRiseLabel.font = DYAppearanceFont(@"T1");
    self.segmentView.delegate = self;
    [self.segmentView reloadSegmentStyle];
}


#pragma mark - DYSegmentControlViewDelegate
- (NSArray *)segmentControlItems {
    return @[@"按股价", @"按涨跌幅"];
}

- (void)segmentControlClickWithIndex:(NSInteger)index {
    if (self.block) {
        self.block(index);
    }
}

// 设置选中时的背景颜色，默认系统蓝色
- (UIColor *)segmentSelectBackColor {
    return DYAppearanceColor(@"B2", 1.0);
}


// 设置选中时的文字颜色，默认白色
- (UIColor *)segmentSelectTitleColor {
    return DYAppearanceColor(@"B14", 1.0);
}

// 设置未选中时的文字颜色，默认系统蓝色
- (UIColor *)segmentTitleColor {
    return DYAppearanceColor(@"H8", 0.7);
}

// 设置border的颜色
- (UIColor *)segmentBorderLayerColor {
    return DYAppearanceColor(@"B2", 1.0);
}

// 设置字体大小，默认T3
- (UIFont *)segmentTitleFont {
    return DYAppearanceFont(@"T1");
}

- (void)segementBlock:(IntegerBlock)block {
    self.block = block;
}

- (void)chooseBlock:(DataBlock)block {
    self.chooseBlock = block;
}

- (IBAction)rightChooseClick:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(nil);
    }
}

@end
