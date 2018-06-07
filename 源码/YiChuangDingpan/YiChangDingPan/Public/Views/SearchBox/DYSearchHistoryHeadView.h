//
//  DYSearchHistoryHeadView.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/6.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYSearchHistoryHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *rightImg;
- (void)headClickWithBlock:(DataBlock)block;

@end
