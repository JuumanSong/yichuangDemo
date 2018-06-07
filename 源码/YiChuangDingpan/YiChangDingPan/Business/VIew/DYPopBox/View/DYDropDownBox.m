//
//  DYDropDownBox.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYDropDownBox.h"
#import "DYPopBoxHeader.h"
#import "YCButton.h"

@interface DYDropDownBox()

@property (nonatomic, strong) YCButton *boxLabel;
@property (nonatomic, strong) NSString *orginTitle;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation DYDropDownBox {
    CAShapeLayer *shapeLayer; // 边框
}

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.orginTitle = title;
        self.title = title;
        
        self.isSelected = NO;
        // 调整边框
        [self configViewCorners:UIRectCornerTopLeft | UIRectCornerTopRight currentView:self];
        
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = DYAppearanceColorFromHex(0x3B3A3F, 1);
        
        self.boxLabel = [YCButton yc_shareButton];
        
        [self.boxLabel setTitle:self.title forState:UIControlStateNormal];
        
        self.boxLabel.status = YCAlignmentStatusCenter;
        UIFont *font = (iPhone4_4s || iPhone5_5s) ? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:14];
        self.boxLabel.titleLabel.font =  font;
        
        self.boxLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.boxLabel addTarget:self action:@selector(respondToTapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.boxLabel];
        
        [self.boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.with.insets(UIEdgeInsetsMake(1, 1, 0, 1));
            make.bottom.equalTo(self).offset(-8);
        }];
        
        if (![title isEqualToString:@"高级设置"]) {
            self.boxLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
            self.boxLabel.backgroundColor = DYAppearanceColorFromHex(0x3B3A3F, 1);
            self.boxLabel.layer.cornerRadius = 4.0f;
            self.boxLabel.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
            self.boxLabel.layer.borderWidth = 0.5f;
            self.boxLabel.layer.masksToBounds = YES;
            [self.boxLabel setImage:DY_ImgLoader(@"YC_arrow_down", @"YiChuangLibrary") forState:UIControlStateNormal];
        }
        else {
            self.boxLabel.titleLabel.adjustsFontSizeToFitWidth = NO;
            self.boxLabel.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
    
}

- (void)reSetHeaderTitle {
    
    [self.boxLabel setTitle:self.orginTitle forState:UIControlStateNormal];
}

- (void)addBorderLineWithFillColor:(UIColor *)fillColor isSelect:(BOOL)isSelect {
    if ([self.orginTitle isEqualToString:@"高级设置"]) return;
    [shapeLayer removeFromSuperlayer];
    if (!isSelect) {
        
        self.layer.borderWidth = 1.0f;
    }
    else {
        self.layer.borderWidth = 0.0f;
        shapeLayer = [CAShapeLayer layer];
        
        [shapeLayer setFillColor:[fillColor CGColor]];
        [shapeLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        // Setup the path
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGFloat height = isSelect ? self.height + 5 : self.height;
        
        [path moveToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointZero];
        
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(self.width, 0)];
        
        [path moveToPoint:CGPointMake(self.width, 0)];
        [path addLineToPoint:CGPointMake(self.width, height)];
        
        [shapeLayer setPath:path.CGPath];
        
        [self.layer addSublayer:shapeLayer];
    }
    
}

- (void)configViewCorners:(UIRectCorner)corners currentView:(UIView *)view {
    CGRect rect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)updateTitleState:(BOOL)isSelected {
    if ([self.orginTitle isEqualToString:@"高级设置"]) return;
    if (isSelected) {
        
        self.backgroundColor = DYAppearanceColorFromHex(0xFFFFFF, 1);
        self.boxLabel.backgroundColor = DYAppearanceColorFromHex(0xFFFFFF, 1);
//        self.boxLabel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.boxLabel setTitleColor:DYAppearanceColorFromHex(0xCEA76E, 1) forState:UIControlStateNormal];
        [self.boxLabel setTitleColor:DYAppearanceColorFromHex(0xCEA76E, 1) forState:UIControlStateNormal];
        [self.boxLabel setImage:DY_ImgLoader(@"YC_arrow_up", @"YiChuangLibrary") forState:UIControlStateNormal];
        
    } else {
        
        self.backgroundColor = [UIColor clearColor];
        self.boxLabel.backgroundColor = DYAppearanceColorFromHex(0x3B3A3F, 1);
//        self.boxLabel.titleLabel.font =  [UIFont boldSystemFontOfSize:14];

        [self.boxLabel setTitleColor:DYAppearanceColor(@"W1", 1.0) forState:UIControlStateNormal];
        [self.boxLabel setImage:DY_ImgLoader(@"YC_arrow_down", @"YiChuangLibrary") forState:UIControlStateNormal];

    }
}

- (void)updateSelectState:(BOOL)isSelect {
    
//    self.boxLabel.backgroundColor = isSelect ? [[UIColor whiteColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}

- (void)updateTitleContent:(NSString *)title {
//    self.orginTitle = title;
    [self.boxLabel setTitle:title forState:UIControlStateNormal];
}

- (void)respondToTapAction {
    
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}

@end
