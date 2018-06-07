//
//  DYMessgePopViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMessgePopViewCell.h"
@interface DYMessgePopViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *botttomLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectSwitch;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation DYMessgePopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
    self.topLabel.font = [UIFont systemFontOfSize:16];
    self.backgroundColor = [UIColor whiteColor];
    self.botttomLabel.font = [UIFont systemFontOfSize:12];
    self.bottomLine.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    self.selectSwitch.onTintColor = DYAppearanceColorFromHex(0xCEA76E, 1);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configLeftImage:(NSString *)leftImg
                  title:(NSString *)title
                 detail:(NSString *)detail
             isSelected:(BOOL)isSelect withSwitchBlock:(SwitchBlock)switchBlock{
    self.leftImg.image = DY_ImgLoader(leftImg, @"YiChuangLibrary");
    self.topLabel.text = title;
    self.botttomLabel.text = detail;
    self.selectSwitch.on = isSelect;
    self.switchBlock = switchBlock;
}
- (IBAction)touchSwitchAction:(UISwitch *)sender {

    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

@end
