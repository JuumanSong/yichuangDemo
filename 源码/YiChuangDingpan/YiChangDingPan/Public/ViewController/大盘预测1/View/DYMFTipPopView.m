//
//  DYMFTipPopView.m
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/5/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMFTipPopView.h"
@interface DYMFTipPopView()
@property (nonatomic, assign) CGFloat leftM;
@property (nonatomic, assign) BOOL arrowUp;

@end
@implementation DYMFTipPopView

- (instancetype)init {
    self = [super init];
    if (self) {
       
        _imageView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"dy_popImg", @"YiChuangLibrary")];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = DYAppearanceColor(@"W1", 1);
        _titleLabel.font = DYAppearanceFont(@"T15");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _arrowImgView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"dy_popImg_arrow", @"YiChuangLibrary")];
        [self addSubview:_arrowImgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize viewSize = self.frame.size;
    
    _imageView.frame = CGRectMake(0, self.arrowUp?4:0, viewSize.width, viewSize.height -4);
    if (self.leftM >0) {
        _arrowImgView.frame = CGRectMake(self.leftM, self.arrowUp?0:(viewSize.height -4), 7, 4);
    }else {
        _arrowImgView.frame = CGRectMake((viewSize.width-7)/2, self.arrowUp?0:(viewSize.height -4), 7, 4);
    }
    _titleLabel.frame = _imageView.frame;
    
}


- (void)setArrowLeftMargin:(CGFloat)leftM arrowUp:(BOOL)up {
    self.leftM = leftM -2;
    self.arrowUp = up;
    if (up) {
        _arrowImgView.image = DY_ImgLoader(@"dy_popImg_up", @"YiChuangLibrary");
    }else {
        _arrowImgView.image = DY_ImgLoader(@"dy_popImg_arrow", @"YiChuangLibrary");
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
