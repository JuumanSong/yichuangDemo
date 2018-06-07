//
//  DYPriceRulesTableViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

typedef BOOL(^ReturnBlock)(id data) ;

@interface DYPriceRulesTableViewCell : DYBorderViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UILabel *popKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boxImageV;
@property (weak, nonatomic) IBOutlet UILabel *boxLabel;

- (void)setSwitchOn:(BOOL)onFlag;

- (void) textFieldBeginEdit:(ReturnBlock)beginBlock
                    endEdit:(DataBlock)endBlock
                 textChange:(DataBlock)textBlock
                switchBlock:(DataBlock)switchBlock;

// 改变气泡的image
- (void)changeBoxString:(NSString *)content imageRed:(BOOL)isRed;
@end
