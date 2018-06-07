//
//  DYStareWizardGeneralSwitchCell.h
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/14.
//  Copyright © 2018年 datayes. All rights reserved.
//

// 智能盯盘通用开关设置cell
#import "DYBorderViewCell.h"

static NSString *const DYStareGeneralSwitchSettingCellID = @"DYStareGeneralSwitchSettingCellIdentifier";

@interface DYStareGeneralSwitchSettingCell : DYBorderViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;//左侧图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;       //title
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;     //content
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;    //开关按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstraint;

@property (nonatomic, copy) IntegerBlock switchBlock;

// cell赋值，左侧无图片
- (void)configCellWithTitle:(NSString *)title
                    content:(NSString *)content
                 switchIsOn:(BOOL)isOn
                switchBlock:(IntegerBlock)block;

// cell赋值，左侧含有图片
- (void)configCellWithImage:(NSString *)imageName
                      title:(NSString *)title
                    content:(NSString *)content
                 switchIsOn:(BOOL)isOn
                switchBlock:(IntegerBlock)block;

@end
