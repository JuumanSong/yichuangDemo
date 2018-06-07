//
//  DYStareWizardSeachStockCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardSeachStockCell.h"

@interface DYStareWizardSeachStockCell()
@property (nonatomic, strong) DataBlock addBlock;
@property (nonatomic, strong) DataBlock delBlock;
@end

@implementation DYStareWizardSeachStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor= DYAppearanceColor(@"H9", 1);
    self.titleLabel.font = DYAppearanceFont(@"T4");
    
    self.contentLabel.textColor= DYAppearanceColor(@"H5", 1);
    self.contentLabel.font = DYAppearanceFont(@"T0");
    self.borderOption = kDYBorderOptionBottom;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.addBtn.hidden = YES;
    self.deleteBtn.hidden=YES;
    self.deleteWidth.constant = 0;
}


- (void)addBtnIsAdded:(BOOL)addedFlag {
    
    [self.addBtn setImage:DY_ImgLoader((addedFlag?@"dy_stare_added": @"dy_stare_add"), @"YiChuangLibrary") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)addedClick:(id)sender {
    if (self.addBlock) {
        self.addBlock(nil);
    }
}
- (IBAction)deleteClick:(id)sender {
    if (self.delBlock) {
        self.delBlock(nil);
    }
}

- (void)addBtnClickBlock:(DataBlock)block {
    self.addBtn.hidden = NO;
    self.addBlock = block;
}

- (void)deleteBtnClickBlock:(DataBlock)block {
    self.deleteBtn.hidden= NO;
    self.deleteWidth.constant = 40;
    self.delBlock = block;
}

@end
