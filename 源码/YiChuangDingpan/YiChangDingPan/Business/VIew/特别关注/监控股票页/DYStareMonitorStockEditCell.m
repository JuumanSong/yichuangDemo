//
//  DYStareMonitorStockEditCell.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorStockEditCell.h"
#import "Masonry.h"

@implementation DYStareMonitorStockEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.nameLabel.font = DYAppearanceFont(@"T4");
    
    self.codeLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.codeLabel.font = DYAppearanceFont(@"T0");
    
    self.sourceLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.sourceLabel.font = DYAppearanceFont(@"T4");
}

// cell赋值
- (void)configCellName:(NSString *)name
                  code:(NSString *)codeStr
                source:(NSString *)source
                isEdit:(BOOL)isEdit
              isSelect:(BOOL)isSelect {
    
    self.nameLabel.text = NilToLineString(name);
    self.codeLabel.text = NilToLineString(codeStr);
    self.sourceLabel.text =NilToLineString(source);
    
//    if (isEdit) {
//        self.rootContentLeadingConstraint.constant = 46;
//    }else {
//        self.rootContentLeadingConstraint.constant = 15;
//    }
    
    if (_isEdit != isEdit) {
        _isEdit = isEdit;
        [self layoutSubviews];
    }
    
    if (isSelect) {
        self.selectButton.image = DY_ImgLoader(@"dy_img_checkboxsel", @"YiChuangLibrary");
    }else {
        self.selectButton.image = DY_ImgLoader(@"dy_img_checkbox_h", @"YiChuangLibrary");
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftOffset = 15;
    
    if (_isEdit) {
        leftOffset = 46;
    }
    
    [_rootContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(leftOffset);
    }];
}

+ (CGFloat)rowHeight {
    return 65;
}

@end
