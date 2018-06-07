//
//  YCButton.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "YCButton.h"

/**
 *  图标在上，文本在下按钮的图文间隔比例（0-1），默认0.8
 */
#define yc_buttonTopRadio 0.8
/**
 *  图标在下，文本在上按钮的图文间隔比例（0-1），默认0.5
 */
#define yc_buttonBottomRadio 0.5

#define yc_padding 4
#define yc_btnRadio 0.6

//    获得按钮的大小
#define yc_btnWidth self.bounds.size.width
#define yc_btnHeight self.bounds.size.height
//    获得按钮中UILabel文本的大小
#define yc_labelWidth self.titleLabel.bounds.size.width
#define yc_labelHeight self.titleLabel.bounds.size.height
//    获得按钮中image图标的大小
#define yc_imageWidth self.imageView.bounds.size.width
#define yc_imageHeight self.imageView.bounds.size.height

@implementation YCButton

+ (instancetype)yc_shareButton {
    return [[self alloc] init];
}

- (void)setStatus:(YCAlignmentStatus)status {
    _status = status;
}

- (void)setYc_imageAligmentLeft:(BOOL)yc_imageAligmentLeft {
    _yc_imageAligmentLeft = yc_imageAligmentLeft;
}

#pragma mark - 左对齐
- (void)alignmentLeft{
    
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    if (_yc_imageAligmentLeft) {
        
        imageFrame.origin.x = yc_padding;
        titleFrame.origin.x = CGRectGetWidth(imageFrame) + yc_padding + yc_padding;
    }
    else {
        titleFrame.origin.x = yc_padding;
        imageFrame.origin.x = CGRectGetWidth(titleFrame) + yc_padding + yc_padding;
    }
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = titleFrame;
}


#pragma mark - 右对齐
- (void)alignmentRight{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    if (_yc_imageAligmentLeft) {
        titleFrame.origin.x = self.bounds.size.width - frame.size.width - yc_padding;
        imageFrame.origin.x = titleFrame.origin.x - yc_imageWidth - yc_padding;
    }
    else {
        imageFrame.origin.x = self.bounds.size.width - yc_imageWidth - yc_padding;
        titleFrame.origin.x = imageFrame.origin.x - frame.size.width - yc_padding;
    }
    
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}

#pragma mark - 居中对齐
- (void)alignmentCenter{
    //    设置文本的坐标
    CGFloat labelX = (yc_btnWidth - yc_labelWidth -yc_imageWidth - yc_padding) * 0.5;
    CGFloat labelY = (yc_btnHeight - yc_labelHeight) * 0.5;
    
    //    设置label的frame
    self.titleLabel.frame = CGRectMake(labelX, labelY, yc_labelWidth, yc_labelHeight);
    
    //    设置图片的坐标
    CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame) + yc_padding;
    if (_yc_imageAligmentLeft) {
        imageX = labelX - yc_padding - yc_imageWidth;
    }
     
    CGFloat imageY = (yc_btnHeight - yc_imageHeight) * 0.5;
    //    设置图片的frame
    self.imageView.frame = CGRectMake(imageX, imageY, yc_imageWidth, yc_imageHeight);
}

#pragma mark - 图标在上，文本在下(居中)
- (void)alignmentTop{
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGFloat imageX = (yc_btnWidth - yc_imageWidth) * 0.5;
    self.imageView.frame = CGRectMake(imageX, yc_btnHeight * 0.5 - yc_imageHeight * yc_buttonTopRadio, yc_imageWidth, yc_imageHeight);
    self.titleLabel.frame = CGRectMake((self.center.x - frame.size.width) * 0.5, yc_btnHeight * 0.5 + yc_labelHeight * yc_buttonTopRadio, yc_labelWidth, yc_labelHeight);
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}

#pragma mark - 图标在下，文本在上(居中)
- (void)alignmentBottom{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGFloat imageX = (yc_btnWidth - yc_imageWidth) * 0.5;
    self.titleLabel.frame = CGRectMake((self.center.x - frame.size.width) * 0.5, yc_btnHeight * 0.5 - yc_labelHeight * (1 + yc_buttonBottomRadio), yc_labelWidth, yc_labelHeight);
    self.imageView.frame = CGRectMake(imageX, yc_btnHeight * 0.5 , yc_imageWidth, yc_imageHeight);
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    // 判断
    //    if (_status == FLAlignmentStatusNormal) {
    //
    //    }
    if (_status == YCAlignmentStatusLeft){
        [self alignmentLeft];
    }
    else if (_status == YCAlignmentStatusCenter){
        [self alignmentCenter];
    }
    else if (_status == YCAlignmentStatusRight){
        [self alignmentRight];
    }
    else if (_status == YCAlignmentStatusTop){
        [self alignmentTop];
    }
    else if (_status == YCAlignmentStatusBottom){
        [self alignmentBottom];
    }
}

@end
