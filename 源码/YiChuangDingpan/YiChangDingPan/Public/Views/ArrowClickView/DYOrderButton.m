//
//  DYOrderButton.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYOrderButton.h"
#import "Masonry.h"

@interface DYOrderButton ()
@property (nonatomic, strong) ClickBlock block;

@end

@implementation DYOrderButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    [self addTarget:self action:@selector(touchDownClick) forControlEvents:UIControlEventTouchDown];
    
    self.label = [[UILabel alloc]init];
    self.label.font = DYAppearanceFont(@"T2");
    self.label.textColor = DYAppearanceColor(@"H9", 1);
    self.label.text = @"--";
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-3);
        make.centerY.equalTo(self);
    }];
    
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(3);
        make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.equalTo(self);
    }];
    self.orderState = OrderStateNormal;
}

- (void)setLabelFont:(UIFont *)font color:(UIColor *)color {
    if (font != nil) {
        self.label.font = font;
    }
    if (color != nil) {
        self.label.textColor = color;
    }
}

- (void)setOrderState:(DYOrderState)state {
    _orderState = state;
    switch (state) {
        case OrderStateUp:{
            self.imageView.image = DY_ImgLoader(@"dy_img_btntop", @"YiChuangLibrary");
        }
            break;
        case OrderStateDown:{
            self.imageView.image = DY_ImgLoader(@"dy_img_btnbelow", @"YiChuangLibrary");
        }
            break;
        default:{
            self.imageView.image = DY_ImgLoader(@"dy_img_btnbelowgray", @"YiChuangLibrary");
        }
            break;
    }
}


- (void)touchDownClick {
    self.orderState = (DYOrderState)((self.orderState+1)%3);
    if (self.block) {
        self.block(self.orderState,self);
    }
}


/**
 点击事件
 @param block
 */
- (void)arrowButtonClick:(ClickBlock)block {
    self.block = block;
}


@end
