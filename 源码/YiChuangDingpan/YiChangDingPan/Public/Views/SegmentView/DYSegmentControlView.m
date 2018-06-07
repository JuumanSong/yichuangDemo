//
//  DYSegmentControlView.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/2.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYSegmentControlView.h"

@interface DYSegmentControlView ()

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIColor *selectBackColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectTitleColor;
@property (nonatomic, strong) UIFont *segmentFont;
@property (nonatomic, strong) UIColor *layerColor;

@end

@implementation DYSegmentControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.itemsArray = @[@"新闻", @"公告", @"研报"];
        self.segmentFont = DYAppearanceFont(@"T3");
        
        [self configBaseUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemsArray = @[@"新闻", @"公告", @"研报"];
        self.segmentFont = DYAppearanceFont(@"T3");
        [self configBaseUI];
    }
    return self;
}

- (void)configBaseUI {
    if (_segment) {
        [_segment removeFromSuperview];
    }
    _segment = [[UISegmentedControl alloc]initWithItems:self.itemsArray];
    [_segment addTarget:self
                 action:@selector(segmentClickWithIndex:)
       forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segment];
    
    // 设置segment的各种属性值
    _segment.selectedSegmentIndex = self.selectIndex;
    _segment.backgroundColor = self.backColor;
    _segment.tintColor = self.selectBackColor;
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.segmentFont, NSFontAttributeName,
                                        self.selectTitleColor, NSForegroundColorAttributeName, nil];
    [_segment setTitleTextAttributes:selectedAttributes
                            forState:UIControlStateSelected];
    
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.segmentFont, NSFontAttributeName,
                                      self.titleColor, NSForegroundColorAttributeName,
                                      nil];
    [_segment setTitleTextAttributes:normalAttributes
                            forState:UIControlStateNormal];
    
    _segment.layer.borderColor = self.layerColor.CGColor;
}

// 各种代理方法
- (void)reloadSegmentStyle {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControlItems)]) {
        self.itemsArray = [self.delegate segmentControlItems];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelectedIndex)]) {
        self.selectIndex = [self.delegate segmentSelectedIndex];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelectBackColor)]) {
        self.selectBackColor = [self.delegate segmentSelectBackColor];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBackgroundColor)]) {
        self.backColor = [self.delegate segmentBackgroundColor];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentTitleColor)]) {
        self.titleColor = [self.delegate segmentTitleColor];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelectTitleColor)]) {
        self.selectTitleColor = [self.delegate segmentSelectTitleColor];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentTitleFont)]) {
        self.segmentFont = [self.delegate segmentTitleFont];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBorderLayerColor)]) {
        self.layerColor = [self.delegate segmentBorderLayerColor];
    }
    
    [self configBaseUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    _segment.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - Click
- (void)segmentClickWithIndex:(UISegmentedControl *)sender {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(segmentControlClickWithIndex:)]) {
        
        [self.delegate segmentControlClickWithIndex:sender.selectedSegmentIndex];
    }
}

@end
