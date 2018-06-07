//
//  DYSearchView.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/20.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYSearchView.h"
@interface DYSearchView()

@end

@implementation DYSearchView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, DYScreenWidth, DYStatusBarHeight+DYNavigationBarHeight)];
    if (self) {
        self.backgroundColor = DYAppearanceColor(@"W1", 1);
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:DY_ImgLoader(@"dy_nav_back_b", @"YiChuangLibrary") forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        _tfView = [[DYSearchTextFieldView alloc]initWithFrame:CGRectZero];
        [self addSubview:_tfView];
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:DYAppearanceColor(@"B14", 1.0) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = DYAppearanceFont(@"T5");
        [self addSubview:_rightBtn];
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = DYAppearanceColor(@"H2", 1);
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    CGFloat statusBarHight = _statusBarHide?0:DYStatusBarHeight;
    CGFloat rightWidth = _rightBtn.titleLabel.text.length*16+30;
    if (_rightBtn.titleLabel.font == DYAppearanceFont(@"T4")) {
        rightWidth = _rightBtn.titleLabel.text.length*15+25;
    }
    if (self.showLeft) {
        _leftBtn.frame = CGRectMake(0, statusBarHight+6, 35, 35);
        _tfView.frame = CGRectMake(40, statusBarHight+6, rect.size.width - 40-rightWidth, 33);
    }else {
        _leftBtn.frame = CGRectZero;
        _tfView.frame = CGRectMake(15, statusBarHight+6, rect.size.width - 15 - rightWidth, 33);
    }
    _rightBtn.frame = CGRectMake(rect.size.width - rightWidth, statusBarHight+5, rightWidth, 35);
    _bottomLine.frame = CGRectMake(0, rect.size.height-1, CGRectGetWidth(rect), 0.5);
}

- (void)setShowLeft:(BOOL)showLeft {
    _showLeft = showLeft;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setHiddenStatusBar:(BOOL)hide {
    _statusBarHide = hide;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



- (void)setRightBtnText:(NSString *)text
             withEnable:(BOOL)enable {
    
    [_rightBtn setTitle:NilToEmptyString(text) forState:UIControlStateNormal];
    _rightBtn.enabled = enable;
}

- (NSString *)getTextInputStr {
    return self.tfView.textField.text;
}

- (UITextField *)searchTextField {
    return self.tfView.textField;
}

- (void)setTextFieldContent:(NSString *)content {
    if (content!=nil) {
        self.tfView.textField.text = content;
        self.tfView.textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)firstResponder:(BOOL)resign {
    if (resign) {
        if (!self.tfView.textField.isFirstResponder) {
            [[self searchTextField]becomeFirstResponder];
        }
    }else {
        if (self.tfView.textField.isFirstResponder) {
            [[self searchTextField]resignFirstResponder];
        }
    }
}

// 设置textField是否为白色，默认白色
- (void)setTextFieldIsWhite:(BOOL)isWhite {
    [self.tfView reloadTextFieldImageView:isWhite];
}

@end
