//
//  DYStareMonitorStockEditBottomView.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorStockEditBottomView.h"
#import "Masonry.h"

@implementation DYStareMonitorStockEditBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DYAppearanceColor(@"W1", 1.0);
        [self loadBaseUI];
    }
    return self;
}

- (void)loadBaseUI {
    // 顶部分割线
    self.topLineView = [[UIView alloc]init];
    self.topLineView.backgroundColor = DYAppearanceColor(@"H2", 1.0);
    [self addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    // 选择器图片
    self.checkImageView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"dy_img_checkbox_h", @"YiChuangLibrary")];
    [self addSubview:self.checkImageView];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    // 左侧label
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.textColor = DYAppearanceColorFromHex(YC_Y1, 1);
    self.leftLabel.font = DYAppearanceFont(@"T5");
    self.leftLabel.text = @"全选";
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImageView.mas_right).offset(15);
        make.centerY.equalTo(self.checkImageView);
    }];
    
    // 左侧按钮
    self.leftButton = [[UIButton alloc]init];
    [self.leftButton addTarget:self
                        action:@selector(didClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = 1000;
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.leftLabel.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    // 右侧label
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.rightLabel.font = DYAppearanceFont(@"T5");
    self.rightLabel.text = @"删除";
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    // 右侧按钮
    self.rightButton = [[UIButton alloc]init];
    [self.rightButton addTarget:self
                         action:@selector(didClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 1001;
    self.rightButton.enabled = NO;
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.rightLabel.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

// 刷新UI
- (void)reloadUIIsSelectAll:(BOOL)isAll
                deleteCount:(NSInteger)count {
    if (isAll) {
        self.checkImageView.image = DY_ImgLoader(@"dy_img_checkboxsel", @"YiChuangLibrary");
    }else {
        self.checkImageView.image = DY_ImgLoader(@"dy_img_checkbox_h", @"YiChuangLibrary");
    }
    
    if (count > 0) {
        self.leftLabel.textColor = DYAppearanceColorFromHex(YC_Y1, 1);
        self.rightLabel.textColor = DYAppearanceColorFromHex(YC_Y1, 1);
        self.rightLabel.text = [NSString stringWithFormat:@"删除(%ld)", (long)count];
        self.rightButton.enabled = YES;
    }else {
        self.leftLabel.textColor = DYAppearanceColor(@"H5", 1.0);
        self.rightLabel.textColor = DYAppearanceColor(@"H5", 1.0);
        self.rightLabel.text = @"删除";
        self.rightButton.enabled = NO;
    }
}

// 点击事件
- (void)didClickButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stareMonitorEditToolViewClickWithTag:)]) {
        [self.delegate stareMonitorEditToolViewClickWithTag:button.tag];
    }
}

// 返回高度
+ (CGFloat)getBottomHeight {
    return 44;
}

@end
