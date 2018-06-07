//
//  DYClickSegementView.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/31.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYClickSegementView.h"

@interface DYClickSegementView ()
//按钮数组
@property (nonatomic, strong) NSMutableArray *labelsArray;
//左边边框数组
@property (nonatomic, strong) NSMutableArray *leftBorderArray;
//文字的数组
@property (nonatomic, strong) NSArray *titlesArray;
//选中的index
@property (nonatomic, assign) NSInteger index;

//样式
@property (nonatomic, strong) UIFont *nomalFont;
@property (nonatomic, strong) UIColor *nomalColor;
@property (nonatomic, strong) UIFont *selFont;
@property (nonatomic, strong) UIColor *selColor;
@property (nonatomic, strong) UIColor *borderColor;

@end


@implementation DYClickSegementView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = DYAppearanceColor(@"W1", 1);
        self.index = 0;
        //样式
        self.nomalFont = DYAppearanceFont(@"T2");
        self.selFont = DYAppearanceBoldFont(@"T2");
        self.nomalColor = DYAppearanceColor(@"H8", 1);
        self.selColor = DYAppearanceColor(@"B1", 1);
        self.borderColor=DYAppearanceColor(@"H2", 1);
        self.leftBorderArray = [NSMutableArray arrayWithCapacity:0];
        self.labelsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    //labes
    if (rect.size.width > 0 && self.titlesArray.count >0) {
        NSInteger i = 0;
        CGFloat labelW = CGRectGetWidth(rect)/self.titlesArray.count;
        for (DYClickLabel *label in self.labelsArray) {
            label.frame = CGRectMake(labelW *i, 0, labelW, CGRectGetHeight(rect));
            if (self.leftBorderArray.count >i) {
                CALayer *layer = self.leftBorderArray[i];
                layer.frame = CGRectMake(0, 0, 0.5, CGRectGetHeight(rect));
            }
            i++;
        }
    }
}

- (void)reloadUIStyle {
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementSelectedColorWithView:)]) {
        self.selColor = [self.delegate segementSelectedColorWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementSelectedFontWithView:)]) {
        self.selFont = [self.delegate segementSelectedFontWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementNomalColorWithView:)]) {
        self.nomalColor = [self.delegate segementNomalColorWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementNomalFontWithView:)]) {
        self.nomalFont = [self.delegate segementNomalFontWithView:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementBorderViewColorWithView:)]) {
        self.borderColor = [self.delegate segementBorderViewColorWithView:self];
    }
    self.layer.borderColor= self.borderColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius =3;
}

- (void)reloadData {
    [self reloadUIStyle];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementInfoArrayWithView:)]) {
        NSArray *array = [self.delegate segementInfoArrayWithView:self];
        NSUInteger index =0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(segementSelectedIndexWithView:)]) {
            index = [self.delegate segementSelectedIndexWithView:self];
        }
        [self setTitleArray:array selectedIndex:index];
    }
}


- (BOOL)changedTitles:(NSArray *)titlesArray {
    if (titlesArray.count != self.titlesArray.count) {
        return YES;
    }else {
        for (NSInteger i=0; i < titlesArray.count; i++) {
            NSString *title1 = titlesArray[i];
            NSString *title2 = self.titlesArray[i];
            if (![title1 isEqualToString:title2]) {
                return YES;
            }
        }
        return NO;
    }
}

- (void)setTitleArray:(NSArray <NSString *>*)titlesArray selectedIndex:(NSInteger)index {
    
    if ([self changedTitles:titlesArray]) {
        self.titlesArray = [titlesArray copy];
        WS(weakSelf)
        if (self.labelsArray.count > self.titlesArray.count) {
            self.labelsArray = [[self.labelsArray subarrayWithRange:NSMakeRange(0, self.titlesArray.count)] mutableCopy];
        }
        for (DYClickLabel *label in self.labelsArray) {
            label.text = @"";
        }
        NSInteger i = 0;
        for (NSString *title in titlesArray) {
            DYClickLabel *label;
            if (self.labelsArray.count > i) {
                label = self.labelsArray[i];
            }else {
                label = [[DYClickLabel alloc]init];
                label.textAlignment = NSTextAlignmentCenter;
                [self.labelsArray addObject:label];
                [self addSubview:label];
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = self.borderColor.CGColor;
                [label.layer addSublayer:layer];
                [self.leftBorderArray addObject:layer];
            }
            if (index ==i) {
                label.textColor = self.selColor;
                label.font = self.selFont;
            }else {
                label.textColor = self.nomalColor;
                label.font = self.nomalFont;
            }
            label.text = title;
            label.tag = i;
            
            [label clickLabelBlock:^(id data) {
                DYClickLabel *temp =data;
                [weakSelf selectedIndex:temp.tag];
                if (weakSelf.delegate) {
                    if ([weakSelf.delegate respondsToSelector:@selector(segementWithView:withIndex:)]) {
                        [weakSelf.delegate segementWithView:weakSelf withIndex:temp.tag];
                    }
                }
            }];
            i++;
        }
        [self selectedIndex:index];
    }else if (index != self.index) {
        [self selectedIndex:index];
    }
}


- (void)selectedIndex:(NSInteger)index {
    if (self.labelsArray.count > index) {
        if (self.index >=0 && self.index < self.labelsArray.count) {
            DYClickLabel *label = self.labelsArray[self.index];
            label.textColor = self.nomalColor;
            label.font = self.nomalFont;
        }
        DYClickLabel *nowLabel = self.labelsArray[index];
        nowLabel.textColor = self.selColor;
        nowLabel.font = self.selFont;
        self.index = index;
    }
}

@end
