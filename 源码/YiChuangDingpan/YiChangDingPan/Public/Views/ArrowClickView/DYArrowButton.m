//
//  DYArrowButton.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/26.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYArrowButton.h"
#import "Masonry.h"

@interface DYArrowButton()

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) DataBlock clickBlock;


@end

@implementation DYArrowButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    [self addTarget:self action:@selector(touchDownClick:) forControlEvents:UIControlEventTouchDown];
    
    self.label = [[UILabel alloc]init];
    self.color = DYAppearanceColor(@"H9", 1);
    self.selectedColor = DYAppearanceColor(@"B1", 1);
    self.label.font = DYAppearanceFont(@"T3");
    self.label.textColor = self.color;
    self.label.text = @"";
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.imageView = [[UIImageView alloc]init];
    self.image = DY_ImgLoader(@"dy_img_arrow_down_gray", @"YiChuangLibrary");
    
    self.selectedImage = DY_ImgLoader(@"dy_img_arrow_up_blue", @"YiChuangLibrary");
    self.imageView.image = self.image;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(9, 6));
        make.centerY.equalTo(self);
    }];
}

- (void)resetTextFrame {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
        make.right.mas_lessThanOrEqualTo(self).offset(-10);
    }];
//    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.label.mas_right).offset(2);
//        make.centerY.equalTo(self);
//    }];
}

- (void)touchDownClick:(DYArrowButton *)sender {
    self.selected = !self.selected;
    
    if (self.selected) {
        if (self.selectedColor) {
            self.label.textColor = self.selectedColor;
        }
        if (self.selectedImage) {
            self.imageView.image = self.selectedImage;
        }
    }else {
        self.label.textColor = self.color;
        self.imageView.image = self.image;
    }
    
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}

- (void)setLabelFont:(UIFont *)font
               color:(UIColor *)color
       selectedColor:(UIColor*)selectColor {
    
    if (font != nil) {
         self.label.font = font;
    }
    if (color != nil) {
        self.color = color;
        self.label.textColor = color;
    }
    if (selectColor!=nil) {
        self.selectedColor = selectColor;
    }
}

- (void)setImageViewImage:(UIImage *)image
            selectedImage:(UIImage *)selectedImage {
    if (image) {
        self.imageView.image = image;
        self.image = image;
    }
    
    if (selectedImage) {
        self.selectedImage = selectedImage;
    }
}

- (void)setBtnSelected:(BOOL)selected {
    self.selected = selected;
    if (self.selected) {
        if (self.selectedColor) {
            self.label.textColor = self.selectedColor;
        }
        if (self.selectedImage) {
            self.imageView.image = self.selectedImage;
        }
    }else {
        self.label.textColor = self.color;
        self.imageView.image = self.image;
    }
}

- (void)arrowButtonClick:(DataBlock)block {
    self.clickBlock = block;
}

@end
