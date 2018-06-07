//
//  DYSegmentView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/4.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYSegmentView.h"
#import "NSString+UILableAdjustment.h"

#define MaxWidth 160
#define Margin 7
#define MarginTop 2
#define BottomLineWidth 12

@interface DYSegmentView()<UIScrollViewDelegate>

//UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *underLine;
//样式
@property (nonatomic, strong) UIFont *nomalFont;
@property (nonatomic, strong) UIColor *nomalColor;
@property (nonatomic, strong) UIFont *selFont;
@property (nonatomic, strong) UIColor *selColor;

//按钮数组
@property (nonatomic, strong) NSMutableArray *labelsArray;
//按钮宽度
@property (nonatomic, strong)NSMutableArray *labelsWidthArray;
//文字的数组
@property (nonatomic, strong) NSArray *titlesArray;

//初始的类型
@property (nonatomic, assign) SegmentType originalType;
//选中的index
@property (nonatomic, assign) NSInteger index;
//规定自身的宽度
@property (nonatomic, assign) CGFloat contentWidth;
//是否显示蓝条
@property (nonatomic, assign) BOOL showBlueVFlag;

@end

@implementation DYSegmentView

-(NSMutableArray *)labelsArray{
    if (_labelsArray == nil) {
        _labelsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelsArray;
}
-(NSMutableArray *)labelsWidthArray{
    if (_labelsWidthArray == nil) {
        _labelsWidthArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelsWidthArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.originalType = SegmentTypeFullScreen;
        [self initSubView];
    }
    return self;
}


- (void)initSubView {
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate= self;
    [self addSubview:self.scrollView];
    
    self.underLine = [[UIView alloc]init];
    self.underLine.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    [self addSubview:self.underLine];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.layer.cornerRadius = 1;
    self.bottomView.backgroundColor = DYAppearanceColor(@"R3", 1);
    [self.scrollView addSubview:self.bottomView];
    
    self.index = 0;
    self.contentWidth = 230;
    //样式
    self.nomalFont = DYAppearanceFont(@"T5");
    self.selFont = DYAppearanceBoldFont(@"T5");
    self.nomalColor = DYAppearanceColor(@"H8", 1);
    self.selColor = DYAppearanceColor(@"R3", 1);
    self.showBlueVFlag = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    CGFloat scrollHeight = CGRectGetHeight(rect) - 2*MarginTop;
    self.scrollView.frame = CGRectMake(0, MarginTop, rect.size.width, scrollHeight);
    //labes
    CGFloat totalWidth = Margin;
    CGFloat firstX = 0;
    CGFloat underLineW = 0;
    NSInteger i = 0;
    if (rect.size.height > 0 && self.labelsArray.count >0) {
        for (DYClickLabel *label in self.labelsArray) {
            NSNumber *width = @(0);
            if (self.labelsWidthArray.count >i) {
                width = self.labelsWidthArray[i];
                label.frame = CGRectMake(totalWidth, 0, [width floatValue], scrollHeight-(self.showBlueVFlag?3:0));
                if (i == 0) {
                    firstX = totalWidth;
                    underLineW = [width floatValue];
                }
                totalWidth += [width integerValue];
            }else {
                label.frame = CGRectZero;
            }
            i++;
        }
        if (self.bottomView.frame.size.width <= 0 || self.bottomView.frame.origin.y < 0) {
            DYClickLabel *label = self.labelsArray[self.index];
            self.bottomView.frame = CGRectMake(CGRectGetMidX(label.frame)-BottomLineWidth/2,scrollHeight-3, BottomLineWidth, 2);
        }
        if (totalWidth+Margin <= CGRectGetWidth(self.scrollView.frame)) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), scrollHeight);
        }else {
            self.scrollView.contentSize = CGSizeMake(totalWidth+Margin, scrollHeight);
        }
    }
    [self insertSubview:self.underLine belowSubview:self.scrollView];
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.scrollView);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo((underLineW -20) * 2);
        make.height.equalTo(@1);
    }];
//    self.underLine.frame = CGRectMake(firstX + 10, CGRectGetMaxY(self.bottomView.frame),(underLineW - 15) * 2, 2);
}


- (void)setTitleArray:(NSArray <NSString *>*)titlesArray selectedIndex:(NSInteger)index {
    
    if ([self changedTitles:titlesArray]) {
        self.titlesArray = [titlesArray copy];
        [self.labelsWidthArray removeAllObjects];
        NSInteger i = 0;
        WS(weakSelf)
        for (DYClickLabel *label in self.labelsArray) {
            label.text = @"";
        }
        CGFloat totalWidth = 0;
        for (NSString *title in titlesArray) {
            DYClickLabel *label;
            if (self.labelsArray.count > i) {
                label = self.labelsArray[i];
            }else {
                label = [[DYClickLabel alloc]init];
                label.textAlignment = NSTextAlignmentCenter;
                [self.labelsArray addObject:label];
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
                [weakSelf selectedIndex:label.tag];
                if (weakSelf.delegate) {
                    if ([weakSelf.delegate respondsToSelector:@selector(didSelected:withIndex:atView:)]) {
                        [weakSelf.delegate didSelected:label withIndex:label.tag atView:self];
                    }
                }
            }];
            CGFloat width = [title getStringWidthInLabSize:CGSizeMake(FLT_MAX, 30) AndFont:self.nomalFont]+20;
            totalWidth+=width;
            [self.labelsWidthArray addObject:[NSNumber numberWithFloat:width]];
            [self.scrollView addSubview:label];
            i++;
        }
        if (titlesArray.count >0 && totalWidth+Margin*2 < self.contentWidth && self.originalType == SegmentTypeFullScreen) {
            CGFloat gap = (self.contentWidth - totalWidth-Margin*2)/titlesArray.count;
            NSMutableArray *widthTempArray = [NSMutableArray arrayWithCapacity:0];
            for (NSNumber *number in self.labelsWidthArray) {
                NSNumber *tempNumber = [NSNumber numberWithFloat:([number floatValue]+gap)];
                [widthTempArray addObject:tempNumber];
            }
            [self.labelsWidthArray removeAllObjects];
            [self.labelsWidthArray addObjectsFromArray:widthTempArray];
        }
        
        [self selectedIndex:index];
    }else if (index != self.index) {
        [self selectedIndex:index];
    }
}

- (void)selectedIndex:(NSInteger)index {
    if (self.labelsArray.count > index) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self selectedIndex:index animation:YES];
        });
    }
}

- (void)selectedIndex:(NSInteger)index animation:(BOOL)animation {
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
        CGRect nowLabelRect = nowLabel.frame;
        if (animation) {
            [UIView animateWithDuration:0.2 // 动画时长
                             animations:^{
                                 [self changeFrameWithNowLabelRect:nowLabelRect];
                             }];
        }else {
            [self changeFrameWithNowLabelRect:nowLabelRect];
        }
    }
}


//获取指定按钮
- (DYClickLabel *)getClickLabelAtIndex:(NSInteger)index {
    if (self.labelsArray.count > index) {
        return self.labelsArray[index];
    }
    return nil;
}

//获取指定按钮文字
- (NSString *)getLabelTextAtIndex:(NSInteger)index {
    DYClickLabel *label = [self getClickLabelAtIndex:index];
    if (label) {
        return label.text;
    }
    return nil;
}
//获取当前选中文字
- (NSString *)getSelectedText {
    return [self getLabelTextAtIndex:self.index];
}

- (void)reloadData {
    [self reloadUIStyle];
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentSelectedIndexWithView:)]) {
        self.index = [self.delegate contentSelectedIndexWithView:self];
    }
    NSArray *array = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(conentsInfoArrayWithView:)]) {
        array = [self.delegate conentsInfoArrayWithView:self];
        [self setTitleArray:array selectedIndex:self.index];
    }
}

#pragma mark -private

//设置当前View的宽度,默认是屏幕宽度
- (void)setSelfWidth:(CGFloat)width {
    if (width > 0) {
        self.contentWidth = width;
    }
}

- (void)reloadUIStyle {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLabelColorWithView:)]) {
        self.selColor = [self.delegate selectedLabelColorWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLabelFontWithView:)]) {
        self.selFont = [self.delegate selectedLabelFontWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalLabelColorWithView:)]) {
        self.nomalColor = [self.delegate nomalLabelColorWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalLabelFontWithView:)]) {
        self.nomalFont = [self.delegate nomalLabelFontWithView:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showShortLineViewWithView:)]) {
        self.bottomView.hidden = ![self.delegate showShortLineViewWithView:self];
        self.bottomView.backgroundColor = self.selColor;
        self.showBlueVFlag = [self.delegate showShortLineViewWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(showBottomLineViewWithView:)]) {
//        self.underLine.hidden = ![self.delegate showBottomLineViewWithView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoAdjustFullContentView)]) {
        self.originalType = [self.delegate autoAdjustFullContentView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewWidth)]) {
        self.contentWidth = [self.delegate contentViewWidth];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomLineColorWithView:)]) {
//        self.underLine.backgroundColor = [self.delegate bottomLineColorWithView:self];
    }
}

- (void)changeFrameWithNowLabelRect:(CGRect)labelRect {
    if (labelRect.size.width >0) {
        CGFloat mid = CGRectGetMidX(labelRect);
        CGFloat halfWidth = self.contentWidth/2;
        CGFloat gap = fabs(mid-halfWidth);
        CGFloat contentSizeWidth = self.scrollView.contentSize.width;
        if (labelRect.size.height > 0) {
            self.bottomView.frame=CGRectMake(CGRectGetMidX(labelRect)-BottomLineWidth/2, CGRectGetHeight(self.scrollView.bounds)-3, BottomLineWidth, 2);
        }
        if(mid <= halfWidth || contentSizeWidth<= CGRectGetWidth(self.scrollView.frame)){
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }else if ( contentSizeWidth - (CGRectGetMinX(labelRect)+CGRectGetWidth(labelRect)/2) <= halfWidth){
            self.scrollView.contentOffset = CGPointMake(contentSizeWidth-CGRectGetWidth(self.scrollView.frame), 0);
        }else {
            self.scrollView.contentOffset = CGPointMake(gap, 0);
        }
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

@end
