//
//  DYTextInsetsLabel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//  设置内边距的Label

#import <UIKit/UIKit.h>

@interface DYTextInsetsLabel : UILabel

// 控制字体与控件边界的间隙
@property (nonatomic, assign) UIEdgeInsets textInsets;
@end
