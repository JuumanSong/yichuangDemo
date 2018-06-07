//
//  DYBasePopupView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBasePopupView.h"
#import "DYMessagePopView.h"
#import "DYNomalPopView.h"
#import "DYItem.h"

@implementation DYBasePopupView

- (id)initWithItem:(NSArray *)itemArr type:(DYItemMarkTypeViewDisplayType)type {
    self = [self init];
//    if (self) {
//        [self loadUI];
//    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.backgroundColor = DYAppearanceColor(@"R3", 1.0);
    self.shadowView = [[UIView alloc] init];
    self.shadowView.backgroundColor = DYAppearanceColor(@"H18", 1.0);
    self.selectedArray = [NSMutableArray array];
    self.temporaryArray = [NSMutableArray array];
    
    _leftButton = [self custumButtonWithText:@"重置" textColor:DYAppearanceColorFromHex(0x404040, 1) backgroundCol:[UIColor whiteColor] TouchSel:@selector(leftButtonAction)];
    
    _rightButton = [self custumButtonWithText:@"确定" textColor:[UIColor whiteColor] backgroundCol:DYAppearanceColorFromHex(0xCEA76E, 1) TouchSel:@selector(rightButtonAction)];
}

- (UIButton *)custumButtonWithText:(NSString *)text textColor:(UIColor *)col backgroundCol:(UIColor *)bCol TouchSel:(SEL)sel {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = bCol;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:col forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return btn;
}

+ (DYBasePopupView *)getSubPopupView:(DYItem *)item {
    DYBasePopupView *view;
    switch (item.displayType) {
        case DYItemMarkTypeViewDisplayTypeindustry:
        {
            view =  [[DYNomalPopView alloc] initWithItem:item.childrenNodes type:DYItemMarkTypeViewDisplayTypeindustry];
        }
            break;
        case DYItemMarkTypeViewDisplayTypeNormal:
            view =  [[DYNomalPopView alloc] initWithItem:item.childrenNodes type:DYItemMarkTypeViewDisplayTypeNormal];
            break;
        case DYItemMarkTypeViewDisplayTypeMessage:
            view =  [[DYMessagePopView alloc] initWithItem:item.childrenNodes type:DYItemMarkTypeViewDisplayTypeMessage];
            break;
        default:
            view = [DYBasePopupView new];
            break;
    }
    return view;
}

- (void)leftButtonAction {
    
}

- (void)rightButtonAction {
    
}

- (void)dismiss {
    if (self.superview) {
        [self.shadowView removeFromSuperview];
    }
}

- (void)dismissWithOutAnimation {
    if (self.superview) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)popupViewFromSourceFrame:(CGRect)frame superView:(UIView *)superView completion:(void (^ __nullable)(void))completion {
    //写这些方法是为了消除警告；
}

@end
