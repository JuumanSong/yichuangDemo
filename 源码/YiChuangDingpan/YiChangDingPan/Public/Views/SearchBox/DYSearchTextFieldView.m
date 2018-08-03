//
//  DYSearchTextFieldView.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/20.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYSearchTextFieldView.h"
@interface DYSearchTextFieldView()<UITextFieldDelegate>
@property (nonatomic, strong) DataBlock changeBlock;
@property (nonatomic, strong) DataBlock returnBlock;
@property (nonatomic, strong) EventCallBackWithNoParams beginEditBlock;

@property (nonatomic, copy) NSString *rightImageName;
@property (nonatomic, copy) NSString *searchImageName;

@end

@implementation DYSearchTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.layer.cornerRadius = 4;
//        self.layer.masksToBounds = YES;
        self.backgroundColor = DYAppearanceColor(@"H1", 1);
        
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = DYAppearanceFont(@"T3");
        _textField.textColor = DYAppearanceColor(@"H13", 1.0);
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.tintColor = DYAppearanceColor(@"B1", 1.0);//光标颜色
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textfieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self reloadTextFieldImageView:YES];
        
        [self addSubview:_textField];
    }
    return self;
}

- (void)reloadTextFieldBaseUI {
    
    // 搜索框右侧delete按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 18, 18);
    UIImage *image = DY_ImgLoader(self.rightImageName, @"YiChuangLibrary");
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchDown];
    _textField.rightView = btn;
    
    //搜索图片(放大镜) UIBarButtonSearch
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = DY_ImgLoader(self.searchImageName, @"YiChuangLibrary");
    // 要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 36, 36);
    _textField.leftView = searchIcon;
    _textField.leftViewMode = UITextFieldViewModeAlways;
}

// 刷新搜索icon及右侧"叉号"icon
- (void)reloadTextFieldImageView:(BOOL)isWhite {
    self.rightImageName = isWhite ? @"dy_img_search_close_b" : @"dy_img_search_close_w";
    self.searchImageName = isWhite ? @"dy_nav_l_search_b" : @"dy_nav_l_search_w";
    
    [self reloadTextFieldBaseUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.frame;
    self.textField.frame = CGRectMake(1, 1, rect.size.width-10, rect.size.height-2);
}

#pragma mark -- delegate

- (void)textfieldValueChanged:(UITextField *)textField {
    if (textField.text.length > 0) {
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }else {
        _textField.rightViewMode = UITextFieldViewModeNever;
    }
    
    UITextRange *selectedRange = [textField markedTextRange];
    NSString * newText = [textField textInRange:selectedRange]; //获取高亮部分
    if(newText.length > 0) {
        return;
    }
    
    if (self.changeBlock) {
        self.changeBlock(textField.text);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }else {
        _textField.rightViewMode = UITextFieldViewModeNever;
    }
    if (self.beginEditBlock) {
        self.beginEditBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.returnBlock) {
        self.returnBlock(textField);
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)clearButtonClick {
    [self.textField setText:@""];
    self.textField.rightViewMode = UITextFieldViewModeNever;
    [self.textField becomeFirstResponder];
    if (self.changeBlock) {
        self.changeBlock(@"");
    }
}

- (void)setPlaceHolder:(NSString *)p {
    [self setPlaceHolder:NilToEmptyString(p) withColor:DYAppearanceColor(@"H4", 1)];
}

- (void)setPlaceHolder:(NSString *)p withColor:(UIColor *)color {
    self.textField.placeholder = NilToEmptyString(p);
    [_textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setLeftViewByImage:(UIImage *)image {
    if (image) {
        //搜索图片(放大镜) UIBarButtonSearch
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = image;
        // 要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.frame = CGRectMake(0, 0, 36, 36);
        _textField.leftView = searchIcon;
    }
}

- (void)textFieldTextChange:(DataBlock)changeBlock
            withReturnBlock:(DataBlock)returnBlock {
    self.changeBlock = changeBlock;
    self.returnBlock = returnBlock;
}

- (void)textFieldTextChange:(DataBlock)changeBlock
            withReturnBlock:(DataBlock)returnBlock
          andBeginEditBlock:(EventCallBackWithNoParams)beginEditBlock
{
    self.changeBlock = changeBlock;
    self.returnBlock = returnBlock;
    self.beginEditBlock = beginEditBlock;
}

@end
