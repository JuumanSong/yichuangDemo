//
//  DYNewSearchHistoryHeadView.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYNewSearchHistoryHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *rightImg;
- (void)headClickWithBlock:(DataBlock)block;

@end
