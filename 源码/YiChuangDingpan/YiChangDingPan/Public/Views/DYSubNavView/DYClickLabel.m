//
//  DYClickLabel.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/12/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYClickLabel.h"
@interface DYClickLabel ()
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) DataBlock block;

@end
@implementation DYClickLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.control = [[UIControl alloc]initWithFrame:frame];
        [self.control addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.control];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.control.frame = self.bounds;
}

- (void)clickLabelBlock:(DataBlock)block {
    self.block = block;
}

- (void)bgClick {
    if (self.block) {
        self.block(self);
    }
}

@end
