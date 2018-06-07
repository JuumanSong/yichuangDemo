//
//  DYPopViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//
#import "DYPopViewCell.h"
#import "DYItem.h"

@interface DYPopViewCell()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIconView;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIImageView *focusImgView;

@end

@implementation DYPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.editButton setImage:DY_ImgLoader(@"YC_edit", @"YiChuangLibrary") forState:UIControlStateNormal];
    self.backgroundColor = DYAppearanceColorFromHex(0xF4F5F9, 1);
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = DYAppearanceColorFromHex(0xCEA76E, 1).CGColor;
    
    _focusLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
    
    _itemLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
    _itemLabel.font = [UIFont systemFontOfSize:14];
    _itemLabel.backgroundColor = [UIColor clearColor];
}

- (IBAction)editAction:(id)sender {
//    !self.EditBlock ?: self.EditBlock();
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Push_DYStareMonitorStockEditViewController" object:nil];
}


- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect {
    if ([title isEqualToString:@"特别关注"]) {
        _editButton.hidden = NO;
        _focusLabel.hidden = NO;
        _focusDetailLab.hidden = NO;
        _leftIconView.hidden = YES;
        _itemLabel.hidden = YES;
        
        if (isSelect) {
            _focusImgView.hidden = NO;
            self.layer.borderWidth = 1.0f;
            self.backgroundColor = [UIColor whiteColor];
            _focusLabel.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
        }
        else {
            _focusImgView.hidden = YES;
            self.layer.borderWidth = 0;
            _focusLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
            self.backgroundColor = DYAppearanceColorFromHex(0xF4F5F9, 1);
        }
    }
    else {
        _focusImgView.hidden = YES;
        _editButton.hidden = YES;
        _focusLabel.hidden = YES;
        _focusDetailLab.hidden = YES;
        _itemLabel.hidden = NO;
        _itemLabel.text = title;
        _leftIconView.hidden = isSelect ?  NO : YES;
        
    if (isSelect) {
        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        _itemLabel.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
    }
    else {
        self.layer.borderWidth = 0;
        _itemLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
        self.backgroundColor = DYAppearanceColorFromHex(0xF4F5F9, 1);
    }
    }
    
}

@end
