//
//  DYSelectButtonView.h
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ML_Button.h"
@interface DYSelectButtonView : UIView
@property(nonatomic,strong)ML_Button * selectButton;
-(void)setButtonTitle:(NSString *)title;
@end
