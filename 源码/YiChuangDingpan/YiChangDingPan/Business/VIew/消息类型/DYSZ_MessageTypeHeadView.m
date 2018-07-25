//
//  DYSZ_MessageTypeHeadView.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//消息类型

#import "DYSZ_MessageTypeHeadView.h"
#import "UIButton+Utils.h"

@interface DYSZ_MessageTypeHeadView()
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UISwitch *headerSwitch;
@property (strong, nonatomic) UIButton *settingBtn;
@end
@implementation DYSZ_MessageTypeHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
 
    
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    
    self.contentView.backgroundColor =DYAppearanceColor(@"W1", 1);
    UIImageView * leftImagView =[[UIImageView alloc]init];
    leftImagView.backgroundColor =DYAppearanceColorFromHex(0xCEA76E , 1.0);
    [self.contentView addSubview:leftImagView];

    [leftImagView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(10);
    }];
    
    _headerLabel =[[UILabel alloc]init];
    _headerLabel.text =@"----";
    _headerLabel.textColor=DYAppearanceColorFromHex(0x404040, 1);
    _headerLabel.font =DYAppearanceFont(@"T3");
    [self.contentView addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    _settingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.dy_EnlargeRect = UIEdgeInsetsMake(0, 0, -16, -16);
    _settingBtn.hidden=YES;
    [self.contentView addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headerLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(self.contentView);
    }];
    _headerSwitch =[[UISwitch alloc]init];
    [_headerSwitch setOnTintColor:DYAppearanceColorFromHex(0xCEA76E, 1.0)];
    [_headerSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_headerSwitch];
    [_headerSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
}
-(void)settingButton{
    //跳转到价提醒
    if (self.messageTypeHeadViewDelegate&&[self.messageTypeHeadViewDelegate respondsToSelector:@selector(clickSettingBtn)]) {
        
        [self.messageTypeHeadViewDelegate clickSettingBtn];
    }
}

-(void)infoButtonClicked{
    if (self.messageTypeHeadViewDelegate&&[self.messageTypeHeadViewDelegate respondsToSelector:@selector(clickInfoBtnWithSection:btn:)]) {
        [self.messageTypeHeadViewDelegate clickInfoBtnWithSection:_section btn:_settingBtn];
    }
}

- (void)setHeaderText:(NSString *)text {
    self.headerLabel.text = text.length == 0 ? @"暂无" : text;
}

- (void)setSwitchIsOnWithBt:(NSString *)bt {
    if ([bt rangeOfString:@"1"].location != NSNotFound) {
        
         [self.headerSwitch setOn:YES];
    }else{
        
         [self.headerSwitch setOn:NO];
    }
   
}
-(void)setSection:(NSInteger)section withType:(NSInteger)type{
    
    if (type == 2) {
        _settingBtn.hidden=NO;
        [_settingBtn setImage:DY_ImgLoader(@"forecast_explain", @"YiChuangLibrary") forState:UIControlStateNormal];
        [_settingBtn removeTarget:self action:@selector(settingButton) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn addTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(type == 1){
        _settingBtn.hidden=NO;
        [_settingBtn setImage:DY_ImgLoader(@"YC_set", @"YiChuangLibrary") forState:UIControlStateNormal];
        [_settingBtn removeTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn addTarget:self action:@selector(settingButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        _settingBtn.hidden=YES;
    }
    _section =section;
}
-(void)switchIsOn:(UISwitch*)switchIsOn{
    
    if (self.messageTypeHeadViewDelegate&&[self.messageTypeHeadViewDelegate respondsToSelector:@selector(clickSwitchisOn:section:)]) {
        
        [self.messageTypeHeadViewDelegate clickSwitchisOn:switchIsOn.on section:_section];
    }
}
@end
