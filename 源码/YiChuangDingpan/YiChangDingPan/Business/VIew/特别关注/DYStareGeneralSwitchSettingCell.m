//
//  DYStareWizardGeneralSwitchCell.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/14.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareGeneralSwitchSettingCell.h"
#import "NSString+UILableAdjustment.h"

@implementation DYStareGeneralSwitchSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = DYAppearanceFont(@"T5");
    self.titleLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    
    self.contentLabel.font = DYAppearanceFont(@"T1");
    self.contentLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    
    // 缩放switch的size
    self.switchButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.switchButton.onTintColor = DYAppearanceColor(@"B14", 1.0);
}

// cell赋值，左侧无图片
- (void)configCellWithTitle:(NSString *)title
                    content:(NSString *)content
                 switchIsOn:(BOOL)isOn
                switchBlock:(IntegerBlock)block {
    
    [self configCellWithImage:nil
                        title:title
                      content:content
                   switchIsOn:isOn
                  switchBlock:block];
}

// cell赋值，左侧含有图片
- (void)configCellWithImage:(NSString *)imageName
                      title:(NSString *)title
                    content:(NSString *)content
                 switchIsOn:(BOOL)isOn
                switchBlock:(IntegerBlock)block {
    
    if (imageName && imageName.length > 0) {
        self.leftImageView.hidden = NO;
        self.titleLeftConstraint.constant = 38;
        
        self.leftImageView.image = DY_ImgLoader(imageName, @"YiChuangLibrary");
    }else {
        self.leftImageView.hidden = YES;
        self.titleLeftConstraint.constant = 15;
    }
    
    self.titleLabel.text = title;

    //设置contentLabel的行间距
    CGSize titleSize = CGSizeMake(DYScreenWidth - 40, 1000);
    int lines = [content getStringlinesInLabSize:titleSize AndFont:DYAppearanceFont(@"T1")];
    
    if (lines > 1) { // 行数大于1，需要设置行间距
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
        paraStyle.lineSpacing = 4;
        NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:content attributes:@{NSParagraphStyleAttributeName : paraStyle}];
        self.contentLabel.attributedText = attriStr;
        
    }else {
        self.contentLabel.text = content;
    }
    
    self.switchButton.on = isOn;
    
    self.switchBlock = block;
}

- (IBAction)switchButtonClick:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.on);
    }
}

@end
