//
//  DYPriceRulesSetTableViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/17.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYPriceRulesSetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *daojiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel1;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel2;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel3;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindHeight;
@property (weak, nonatomic) IBOutlet UIView *remindView;

- (void)editBlock:(DataBlock)block;

@end
