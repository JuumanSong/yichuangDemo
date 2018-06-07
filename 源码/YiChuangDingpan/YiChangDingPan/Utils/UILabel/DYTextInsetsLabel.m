//
//  DYTextInsetsLabel.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYTextInsetsLabel.h"

@implementation DYTextInsetsLabel


- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
