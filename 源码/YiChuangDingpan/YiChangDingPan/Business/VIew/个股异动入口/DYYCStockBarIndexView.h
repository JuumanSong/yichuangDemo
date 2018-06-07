//
//  DYYCStockBarIndexView.h
//  YiChangDingPan
//
//  Created by 宋骁俊 on 2018/5/7.
//  Copyright © 2018年 datayes. All rights reserved.
//  一创个股异动轮播入口

#import <UIKit/UIKit.h>

@interface DYYCStockBarIndexView : UIControl
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *content1Label;//个股名称
@property (nonatomic, strong) UILabel *content2Label;//异动信号
@property (nonatomic, strong) UILabel *content3Label;//异动值
/**
 首先调用一次短链接
 */
- (void)requestSettingDataList;


@end
