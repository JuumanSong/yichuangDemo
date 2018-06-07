//
//  DYPopCollectionView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPopCollectionView.h"
#import "DYPopViewCell.h"

@interface DYPopCollectionView()<
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation DYPopCollectionView

+ (instancetype)configPopView {
    DYPopCollectionView *popView = [[DYPopCollectionView alloc] init];
    return popView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    self.shadowView = [[UIView alloc] init];
    self.shadowView.backgroundColor = DYAppearanceColor(@"H18", 1.0);
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.backgroundColor = [UIColor darkGrayColor];
    [_leftButton setTitle:@"重置" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftButton];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.backgroundColor = [UIColor blueColor];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_rightButton];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = DYAppearanceColor(@"H18", 1);
    self.collectView.showsVerticalScrollIndicator = YES;
    [self.collectView registerNib:[UINib nibWithNibName:@"DYPopViewCell" bundle:DY_BundleLoader(@"YiChuangLibrary")]
       forCellWithReuseIdentifier:DYPopViewCellId];
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    [self addSubview:self.collectView];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
}

- (void)popupViewFromSourceFrame:(CGRect)frame superView:(UIView *)superView completion:(void (^ __nullable)(void))completion {
    
}

#pragma mark - Action

- (void)leftButtonAction {
    
}

- (void)rightButtonAction {
    
}

#pragma mark - UICollectionViewDataSource,delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DYPopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DYPopViewCellId forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
