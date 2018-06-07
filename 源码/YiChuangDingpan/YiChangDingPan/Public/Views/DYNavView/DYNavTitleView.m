//
//  DYNavTitleView.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/22.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYNavTitleView.h"

//左右margin 15,按钮本身有8的margin
#define DYMargin 7
#define DYMarginTop 5
#define DYButtonWidth 40
@interface DYNavTitleView()
@property (nonatomic, strong) DataBlock rightBlock;
@property (nonatomic, strong) DataBlock leftBlock;
@property (nonatomic)BOOL isCustomSubFrame;//是否是自定义frame
@property (nonatomic)BOOL isSelfDefine;//是否是自定义的view

@end

@implementation DYNavTitleView

-(instancetype)init{
    self = [super init];
    if(self){
        self.backgroundColor = DYAppearanceColor(@"W1", 1.0);
        self.isSelfDefine = NO;
        [self defultUI];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    
    CGFloat subViewHeight = DYNavigationBarHeight - 2*DYMarginTop;
    if(!_isSelfDefine || !_isCustomSubFrame) {
        _defultNavView.frame = CGRectMake(0, DYStatusBarHeight, width, DYNavigationBarHeight-1);
        CGFloat navTop = (!_isSelfDefine)?DYMarginTop:(DYStatusBarHeight+DYMarginTop);
        _backBtn.frame = CGRectMake(DYMargin, navTop, DYButtonWidth, subViewHeight);
        _closeBtn.frame = CGRectMake(DYButtonWidth+DYMargin, navTop, 36, subViewHeight);
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_closeBtn.frame), navTop, width - 2 * CGRectGetMaxX(_closeBtn.frame), subViewHeight);
        _rightBtn.frame = CGRectMake(width - DYButtonWidth -DYMargin, navTop, DYButtonWidth, subViewHeight);
    }
    _bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-1, width, 0.5);
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:DY_ImgLoader(@"dy_nav_back_b", @"YiChuangLibrary") forState:UIControlStateNormal];
         _backBtn.titleLabel.font = DYAppearanceFont(@"T5");
//        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.tag = 1;
        [_backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}

-(UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc]init];
        _rightBtn.tag = 3;
        _rightBtn.titleLabel.font = DYAppearanceFont(@"T5");
//        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _rightBtn;
}

- (DYScrollRepeatLable *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[DYScrollRepeatLable alloc]init];
        _titleLabel.textColor = DYAppearanceColor(@"H9", 1);
        _titleLabel.font = DYAppearanceFont(@"T6");
    }
    return _titleLabel;
}

-(void)defultUI{
    self.defultNavView = [[UIView alloc]init];
    [self addSubview:self.defultNavView];

    [self.defultNavView addSubview:self.titleLabel];
 
    [self.defultNavView addSubview:self.backBtn];
    
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeBtn.titleLabel setFont:DYAppearanceFont(@"T2")];
    [self.closeBtn setTitleColor:DYAppearanceColor(@"H9", 1.0) forState:UIControlStateNormal];
    self.closeBtn.tag = 2;
    [self.defultNavView addSubview:self.closeBtn];
    self.closeBtn.hidden = YES;

    [self.defultNavView addSubview:self.rightBtn];
    self.rightBtn.hidden = YES;
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = DYAppearanceColor(@"H2", 1);
    [self addSubview:self.bottomLineView];
    self.bottomLineView.hidden = YES;

}


//自定义整个view
-(void)redefine{
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    self.isSelfDefine = YES;
}

//自定义整个view
-(void)redefineWithSubFrame {
    [self redefine];
    self.isCustomSubFrame = YES;
}

- (void)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            if (self.leftBlock) {
                self.leftBlock(sender);
            }
            break;
        case 2:
            
            break;
        case 3:
            if (self.rightBlock) {
                self.rightBlock(sender);
            }
            break;
            
        default:
            break;
    }
}


- (void)setTitle:(NSString *)title {
    [self.titleLabel reSetText:title?title:@""];
}

- (void)setRightBtnImage:(UIImage *)image
               withClick:(DataBlock)click {
    if (image) {
        [self.rightBtn setImage:image forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    }else {
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
    }
    self.rightBlock = click;

}

- (void)setRightBtnText:(NSString *)text
                  color:(UIColor *)color
              withClick:(DataBlock)click {
    self.rightBtn.hidden = NO;
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:NilToEmptyString(text) forState:UIControlStateNormal];
    if (color) {
        [self.rightBtn setTitleColor:color forState:UIControlStateNormal];
    }
    self.rightBlock = click;
}

- (void)setBackBtnImage:(UIImage *)image
              withClick:(DataBlock)click {
    if (image) {
        [self.backBtn setImage:image forState:UIControlStateNormal];
    }
    self.leftBlock = click;

}

- (void)setNavWhiteStyle {
    self.backgroundColor = [UIColor whiteColor];
    [self.titleLabel setTextColor:DYAppearanceColor(@"H9", 1)];
    [self.titleLabel setFont:DYAppearanceFont(@"T6")];
    [self.backBtn setImage:DY_ImgLoader(@"dy_nav_back_b", @"YiChuangLibrary") forState:UIControlStateNormal];
}

- (void)setNavBlackStyle {
    self.backgroundColor = DYAppearanceColor(@"H18", 1);
    [self.titleLabel setTextColor:DYAppearanceColor(@"W1", 1)];
    [_backBtn setImage:DY_ImgLoader(@"dy_nav_back_w", @"YiChuangLibrary") forState:UIControlStateNormal];
    self.bottomLineView.backgroundColor = DYAppearanceColor(@"H15", 1);
}
@end
