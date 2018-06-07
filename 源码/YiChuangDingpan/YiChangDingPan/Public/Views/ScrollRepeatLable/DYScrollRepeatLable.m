//
//  ScrollRepeatLable.m
//  IntelligenceResearchReport
//
//  Created by datayes on 2016/10/17.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYScrollRepeatLable.h"

@interface DYScrollRepeatLable()
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic, assign) CGSize sizeToFit;

@end

@implementation DYScrollRepeatLable

- (UILabel *)lab1
{
    if (!_lab1) {
        self.lab1 = [[UILabel alloc]init];
        [self addSubview:_lab1];
    }
    return _lab1;
}

- (UILabel *)lab2
{
    if (!_lab2) {
        self.lab2 = [[UILabel alloc]init];
        [self addSubview:_lab2];
    }
    return _lab2;
}

- (void)dealloc
{
    [self endScroll];
}

//用代码初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor clearColor];
        self.speed = 40;
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text{
    self = [self initWithFrame:frame];
    [self setText:text Font:DYAppearanceFont(@"T6") Color:DYAppearanceColor(@"W1",1.0) AndBacketgroundColor:[UIColor clearColor]];
    return self;
}


-(void)endScroll{
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(_sizeToFit.width <= self.frame.size.width || CGRectGetWidth(self.frame) ==0){//不滚动
        _lab1.frame = self.bounds;
        _lab2.frame = CGRectZero;
        _lab2.hidden = YES;
    }else{
        _lab1.frame = CGRectMake(0, 0, _sizeToFit.width, _sizeToFit.height);
        _lab2.frame = CGRectMake(_sizeToFit.width + 50, 0, _sizeToFit.width, _sizeToFit.height);
        _lab2.hidden = NO;
        [self scrollLab];
        
        float time=(_sizeToFit.width + 50)/self.speed;
        [_scrollTimer invalidate];
        _scrollTimer = nil;
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:time + 1
                                                        target:self selector:@selector(scrollLab) userInfo:nil repeats:YES];
    }
}

-(void)reSetText:(NSString *)text{
    [self endScroll];
    self.text = text;
    CGSize sizeToFit = [self sizeForContentString:text AndFont:self.font];
    self.sizeToFit = sizeToFit;
    
    self.lab1.text = text;
    self.lab1.font = self.font;
    self.lab1.textColor = self.textColor;
    self.lab1.backgroundColor = self.backgroundColor;
    self.lab1.textAlignment = NSTextAlignmentCenter;
    
    self.lab2.text = text;
    self.lab2.font = self.font;
    self.lab2.textColor = self.textColor;
    self.lab2.backgroundColor = self.backgroundColor;
    self.lab2.textAlignment = NSTextAlignmentCenter;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setText:(NSString *)text Font:(UIFont *)font Color:(UIColor *)color AndBacketgroundColor:(UIColor *)bgColor{
    self.text = text;
    self.font = font;
    self.textColor = color;
    self.backgroundColor = bgColor;
    [self reSetText:text];
}


-(void)scrollLab{
    
    CGSize sizeToFit = [self sizeForContentString:self.text AndFont:self.font];
    if (sizeToFit.width > self.frame.size.width) {
        float time = (sizeToFit.width + 50)/self.speed;
        
        [UIView animateWithDuration:time delay:0 options:0 animations:^{
            self.lab1.frame=CGRectMake(- sizeToFit.width - 50, 0, sizeToFit.width, sizeToFit.height);
            self.lab2.frame=CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
        } completion:^(BOOL finished) {
            self.lab1.frame = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
            self.lab2.frame = CGRectMake(sizeToFit.width + 50, 0, sizeToFit.width, sizeToFit.height);
        }];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        self.lab1.textColor = textColor;
        self.lab2.textColor = textColor;
        _textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font {
    if (font) {
        self.lab1.font = font;
        self.lab2.font = font;
        _font = font;
    }
}

//获取string宽高
- (CGSize)sizeForContentString:(NSString *)string AndFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName : style};
    
    CGRect rect = [string boundingRectWithSize:maxSize
                                       options:opts
                                    attributes:attributes
                                       context:nil];
    return rect.size;
}


@end
