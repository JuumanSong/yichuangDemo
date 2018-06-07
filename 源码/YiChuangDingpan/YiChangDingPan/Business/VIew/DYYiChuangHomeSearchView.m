//
//  DYYiChuangHomeSearchView.m
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYiChuangHomeSearchView.h"
#import "DYSearchView.h"

@interface DYYiChuangHomeSearchView ()

@property (nonatomic, strong) DYSearchView *searchView;
@property (nonatomic, strong) UIControl *leftClickView;
@property (nonatomic, strong) DataBlock leftBlock;
@property (nonatomic, strong) DataBlock rightBlock;
@end

@implementation DYYiChuangHomeSearchView

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchView = [[DYSearchView alloc]init];
        _searchView.backgroundColor = DYAppearanceColor(@"H18", 1);
        [_searchView setRightBtnText:@"取消筛选" withEnable:YES];
        _searchView.rightBtn.titleLabel.font = DYAppearanceFont(@"T4");
        [_searchView.rightBtn setTitleColor:DYAppearanceColor(@"W1", 1) forState:UIControlStateNormal];
        [_searchView.tfView reloadTextFieldImageView:YES];
        _searchView.bottomLine.hidden = YES;
        _searchView.tfView.textField.rightView = nil;
        [_searchView.rightBtn addTarget:self
                                     action:@selector(cancelRightClick)
                           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchView];
        
        _leftClickView = [[UIControl alloc]init];
        [_leftClickView addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftClickView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _searchView.frame= self.bounds;
    _leftClickView.frame = _searchView.tfView.frame;
}

- (void)leftClick {
    if (self.leftBlock) {
        self.leftBlock(nil);
    }
}

- (void)cancelRightClick {
    if (self.rightBlock) {
        self.rightBlock(nil);
    }
}

- (void)setContentStr:(NSString *)content {
    [self.searchView setTextFieldContent:NilToEmptyString(content)];
}

- (void)leftClickBLock:(DataBlock)leftBlock cancelBlock:(DataBlock)cBlock {
    self.leftBlock = leftBlock;
    self.rightBlock = cBlock;
}
@end
