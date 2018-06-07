//
//  DYMFTipPopView.h
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/5/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMFTipPopView : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UILabel  *titleLabel;


- (void)setArrowLeftMargin:(CGFloat)leftM arrowUp:(BOOL)up;

@end
