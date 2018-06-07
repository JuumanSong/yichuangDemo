//
//  DYPriceRulesHeadView.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/16.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYSegmentControlView.h"

@interface DYPriceRulesHeadView : UIView<DYSegmentControlViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UILabel *stockKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chufaKeyLabel;

@property (weak, nonatomic) IBOutlet UIView *stockInfoView;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockTickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLastPriceKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLastPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLastPriceRiseLabel;
@property (weak, nonatomic) IBOutlet DYSegmentControlView *segmentView;

- (void)segementBlock:(IntegerBlock)block;

- (void)chooseBlock:(DataBlock)block;

@end
