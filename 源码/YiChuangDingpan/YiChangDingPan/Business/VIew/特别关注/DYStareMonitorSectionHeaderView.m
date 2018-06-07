//
//  DYStareMonitorSectionHeaderView.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorSectionHeaderView.h"
#import "Masonry.h"

@implementation DYStareMonitorSectionHeaderView

#pragma makr - Init
+ (id)getDequeueReusableStareMonitorHeaderViewforTableView:(UITableView *)tableView {
    DYStareMonitorSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DYStareMonitorSectionHeaderView"];
    if(headerView == nil){
        headerView = [[DYStareMonitorSectionHeaderView alloc]initWithReuseIdentifier:@"DYStareMonitorSectionHeaderView"];
        [headerView loadSubView];
    }
    return headerView;
}

- (void)loadSubView {
    self.contentView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    self.titleLabel.font = DYAppearanceFont(@"T3");
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25);
    }];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"dy_img_tittle_left", @"YiChuangLibrary")];
    [self addSubview:leftImg];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"dy_img_tittle_right", @"YiChuangLibrary")];
    [self addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
    }];
}

// 赋值
- (void)setTitleLabelText:(NSString *)text {
    self.titleLabel.text = text;
}

// height
+ (CGFloat)getHeaderHeight {
    return 44;
}

@end
