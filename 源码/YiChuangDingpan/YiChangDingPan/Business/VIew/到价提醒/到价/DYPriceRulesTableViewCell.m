//
//  DYPriceRulesTableViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesTableViewCell.h"

@interface DYPriceRulesTableViewCell()<UITextFieldDelegate>
@property (nonatomic, strong) ReturnBlock beginBlock;
@property (nonatomic, strong) DataBlock endBlock;
@property (nonatomic, strong) DataBlock changeBlock;
@property (nonatomic, strong) DataBlock switchBlock;
@end

@implementation DYPriceRulesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.borderOption = kDYBorderOptionBottom;

    self.titleLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.titleLabel.font = DYAppearanceFont(@"T5");
    // 缩放switch的size
    self.switchView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.switchView.onTintColor = DYAppearanceColorFromHex(0xCEA76E, 1);
    
    self.boxLabel.textColor = DYAppearanceColor(@"W1", 1.0);
    self.boxLabel.layer.cornerRadius = 2;
    self.boxLabel.layer.masksToBounds = YES;
    self.boxLabel.layer.borderWidth = 0.5;
    
    self.popKeyLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.popKeyLabel.font = DYAppearanceFont(@"T1");
    self.unitLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.unitLabel.font = DYAppearanceFont(@"T5");
    
    self.textField.textColor = DYAppearanceColor(@"H9", 1);
    self.textField.font = DYAppearanceFont(@"T5");
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    [_textField setValue:DYAppearanceColor(@"H3", 1) forKeyPath:@"_placeholderLabel.textColor"];
    _textField.tintColor = DYAppearanceColor(@"B1", 1.0);//光标颜色
    [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.popView.hidden = YES;
    self.unitLabel.hidden = YES;
    
    [self.switchView addTarget:self
                        action:@selector(switchClick:)
              forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setSwitchOn:(BOOL)onFlag {
    self.switchView.on = onFlag;
    self.unitLabel.hidden = !onFlag;
    self.popView.hidden = YES;
}

- (void) textFieldBeginEdit:(ReturnBlock)beginBlock
                    endEdit:(DataBlock)endBlock
                 textChange:(DataBlock)textBlock
                switchBlock:(DataBlock)switchBlock {
    self.beginBlock = beginBlock;
    self.endBlock = endBlock;
    self.changeBlock = textBlock;
    self.switchBlock = switchBlock;
}


- (void)switchClick:(UISwitch *)view {
    if (!view.on) {
        self.popView.hidden = YES;
        self.textField.text = @"";
        self.unitLabel.hidden = YES;
        [self.textField resignFirstResponder];
    }else {
        self.unitLabel.hidden = NO;
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (IBAction)textValueChanged:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@"."]) {
        sender.text = @"0.";
    }
    if (sender.text.length > 1 && !([sender.text rangeOfString:@"."].location != NSNotFound)) {
        sender.text = [self getTheCorrectNum:sender.text];
    }
    self.popView.hidden = (sender.text.length ==0);
    if (self.changeBlock) {
        self.changeBlock(sender.text);
    }
}

// 如果开头数字是0，则去掉0，保留0之后的数据
- (NSString*)getTheCorrectNum:(NSString*)tempString {
    if ([tempString hasPrefix:@"0"]){
        tempString = [tempString substringFromIndex:1];
    }
    return tempString;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self setSwitchOn:YES];
    if (self.beginBlock) {
      return  self.beginBlock(nil);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textField.text.length >0) {
        [self setSwitchOn:YES];
    }else {
        [self setSwitchOn:NO];
    }
    self.popView.hidden = YES;
    if (self.endBlock) {
        if ([textField.text isEqualToString:@"."]) {
            self.endBlock(nil);
        }else {
            self.endBlock(textField.text);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 输入框内已经有“.”了，再次输入“.”返回NO
    if ([string isEqualToString:@"."] && [textField.text rangeOfString:@"."].location != NSNotFound) {
        return NO;
    }
    NSArray *tempArr = [textField.text componentsSeparatedByString:@"."];
    if (string.length >0&& tempArr.count>1) {
        NSString *decimal = tempArr.lastObject;
        if (decimal.length>=2) {
            return NO;
        }
    }
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    // 除了NUMBERS已定义了的数字外，其他输入都返回NO
    if(!basicTest) {
        return NO;
    }
    return YES;
}

// 改变气泡的image
- (void)changeBoxString:(NSString *)content imageRed:(BOOL)isRed {
    self.boxLabel.text = content;
    if (isRed) {
        self.boxLabel.layer.borderColor = DYAppearanceColor(@"R3", 1.0).CGColor;
        self.boxImageV.image = DY_ImgLoader(@"stare_zf_gg", @"YiChuangLibrary");
    }else {
        self.boxLabel.layer.borderColor = DYAppearanceColor(@"H2", 1.0).CGColor;
        self.boxImageV.image = DY_ImgLoader(@"stare_zf_bg", @"YiChuangLibrary");
    }
}

@end
