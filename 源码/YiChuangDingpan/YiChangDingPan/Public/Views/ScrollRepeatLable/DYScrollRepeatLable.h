//
//  ScrollRepeatLable.h
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/10/17.
//  Copyright © 2016年 datayes. All rights reserved.
//  可滚动的lab

#import <UIKit/UIKit.h>

@interface DYScrollRepeatLable : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) float speed;//每秒移动速度

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text;

- (void)endScroll;

-(void)scrollLab;

-(void)reSetText:(NSString *)text;

- (void)setText:(NSString *)text Font:(UIFont *)font Color:(UIColor *)color AndBacketgroundColor:(UIColor *)bgColor;

- (void)setTextColor:(UIColor *)textColor;
@end
