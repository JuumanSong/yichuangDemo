//
//  DYSelectButtonView.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYSelectButtonView.h"

@interface DYSelectButtonView()


@end
@implementation DYSelectButtonView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self loadUI];
    }
    
    return self;
}
-(void)loadUI{
    
    _selectButton =[ML_Button ml_shareButton];
    _selectButton.status =MLAlignmentStatusCenter_ImgLeft;
    [_selectButton setTitleColor:DYAppearanceColorFromHex(0x676767,1) forState:UIControlStateNormal];
    [_selectButton setTitleColor:DYAppearanceColorFromHex(0xCEA76E,1) forState:UIControlStateSelected];
    [_selectButton setBackgroundColor:DYAppearanceColorFromHex(0xF4F5F9 , 1)];
    [_selectButton setImage:DY_ImgLoader(@"YC_check_hoop", @"YiChuangLibrary") forState:UIControlStateSelected];
    [_selectButton setImage:nil forState:UIControlStateNormal];
    _selectButton.titleLabel.font =[UIFont systemFontOfSize:14];
    _selectButton.layer.borderColor=DYAppearanceColorFromHex(0xCEA76E,1).CGColor;
    _selectButton.layer.cornerRadius = 4;
    _selectButton.clipsToBounds =YES;
    [self addSubview:_selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
}

-(void)setButtonTitle:(NSString *)title{
    [_selectButton setTitle:title forState:UIControlStateNormal];
    
}
@end
