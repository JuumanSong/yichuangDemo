//
//  DYYC_SubHeaderView.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_SubHeaderView.h"

@interface DYYC_SubHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation DYYC_SubHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.image = DY_ImgLoader(@"yc_area", @"YiChuangLibrary");
    self.imgView.layer.cornerRadius = 15;
    self.imgView.layer.masksToBounds = YES;
    
    self.headerLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
    self.headerLabel.font = [UIFont boldSystemFontOfSize:16];
    
    self.detailLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:12];
}

@end
