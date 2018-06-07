//
//  DYYC_PlateMoveEnterView.h
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/5/7.
//  Copyright © 2018年 datayes. All rights reserved.
//  板块异动入口View

#import <UIKit/UIKit.h>


/**
 板块异动入口View,frame宽最小320  高度35
 */
@interface DYYC_PlateMoveEnterView : UIControl
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *content1Label;
@property (nonatomic, strong) UILabel *content2Label;

- (void)themeStareOpen:(BOOL)open;

@end
