//
//  DYNomalPopView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYNomalPopView.h"
#import "DYPopViewCell.h"
#import "DYItem.h"
#import "DYPopBoxHeader.h"
#import "DYYCStocksMoveService.h"
#import "DYAdvancedSetService.h"
#import "DYPersonSettingModel.h"
#import "UIResponder+Router.h"
#import "DYProgressHUD.h"
#import "DYYC_SiftStock.h"

@interface DYNomalPopView()<
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectView;
@property(nonatomic,strong) DYPersonSettingModel *settingModel;
@property (nonatomic,assign) DYItemMarkTypeViewDisplayType type;

@end

@implementation DYNomalPopView

- (id)initWithItem:(NSArray *)itemArr type:(DYItemMarkTypeViewDisplayType)type {
    self = [super init];
    if (self) {
        self.itemArr = itemArr;
        _type = type;
        _settingModel = [DYAdvancedSetService shareInstance].personSettingModel;
        // 获取筛选数据
        [self _findSelectedItemWithType:type];
    
    }
    return self;
}

- (void)configUI {
    
    [self addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    [self addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置每个按钮的大小
    flowLayout.itemSize=CGSizeMake((DYScreenWidth - 75)/2, 38);
    //设置行列间距
//    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 5;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = DYAppearanceColorFromHex(0xFFFFFF, 1);
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
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    [superView addSubview:self];
    
    //add ShadowView
    self.shadowView.frame = CGRectMake(0, top, DYScreenWidth, DYScreenHeight - top);
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    self.shadowView.alpha = ShadowAlpha;
    self.frame = CGRectMake(0, top, DYScreenWidth, 294);
    [self configUI];
    completion();

}

#pragma mark - Logic

- (void)_findSelectedItemWithType:(DYItemMarkTypeViewDisplayType)type {
    
    [self.selectedArray removeAllObjects];
    
    id data = [[DYYCStocksMoveService shareInstance] getLocalSaveSettingDataType:type];
    
    
    if (type == DYItemMarkTypeViewDisplayTypeNormal) {
        NSString *selectName = (NSString *)data;
        for (DYItem *item in self.itemArr) {
            if (selectName && [selectName isEqualToString:item.title]) {
                item.isSelected = YES;
                [self.selectedArray addObject:selectName];
                break;
            }else if (!selectName && [item.title isEqualToString:@"全A股"]) {
                item.isSelected = YES;
                break;
            }
            
        }
        
    }
    else {
        if (!data) return;
        NSArray *industryArr = (NSArray *)data;
        for (NSString *ID in industryArr) {
            for (DYItem *item in self.itemArr) {
                if ([ID isEqualToString:item.industryId]) {
                    [self.selectedArray addObject:item.title];
                    item.isSelected = YES;
                }
            }
        }
    }

}

- (void)addBorderLineWithFillColor:(UIColor *)fillColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setFillColor:[fillColor CGColor]];
    [shapeLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // Setup the path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //画上实线
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(self.orginX, 0)];
    
    [path moveToPoint:CGPointMake(self.orginX + self.sizeW, 0)];
    [path addLineToPoint:CGPointMake(self.width, 0)];
    
    
    [shapeLayer setPath:path.CGPath];
    
    [self.collectView.layer addSublayer:shapeLayer];
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - Action
// 重置
- (void)leftButtonAction {

    // 清空选中
    if (self.itemArr.count > 0) {
        for (DYItem *sub in self.itemArr) {
            sub.isSelected = NO;
        }
    }
    [self.selectedArray removeAllObjects];
//    [self _findSelectedItemWithType:_type];
    if (_type == DYItemMarkTypeViewDisplayTypeNormal) {
        for (DYItem *item in self.itemArr) {
            if ([@"全A股" isEqualToString:item.title]) {
                item.isSelected = YES;
                [self.selectedArray addObject:@"全A股"];
                break;
            }
            
        }
    }
    else {
            [self.selectedArray removeAllObjects];
        }
    [self.collectView reloadData];

}
// 确定
- (void)rightButtonAction {
    DYPersonSettingModel *model = [DYPersonSettingModel new];
    if (_type == DYItemMarkTypeViewDisplayTypeNormal) {
        NSString *name = @"全A股";
        for (DYItem *sub in self.itemArr) {
            if (sub.isSelected) {
                name = sub.title;
                break;
            }
        }
         model = [[DYYCStocksMoveService shareInstance] setSelectSettingDataWithType:_type data:name];
    }
    else {
        NSMutableArray *arr = @[].mutableCopy;
        for (DYItem *sub in self.itemArr) {
            if (sub.isSelected) {
                [arr addObject:sub.industryId];
            }
        }
        model = [[DYYCStocksMoveService shareInstance] setSelectSettingDataWithType:_type data:arr];
    }
    
    [self.selectedArray removeAllObjects];
    for (DYItem *item in self.itemArr) {
        if (item.isSelected) {
            [self.selectedArray addObject:item.title];
        }
    }

    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItem:)]) {
        [self.delegate popupView:self didSelectedItem:self.selectedArray];
    }
    [self dismiss];

    // 调取设置个人配置接口
    [DYAdvancedSetService shareInstance].personSettingModel = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectSetingNote" object:nil];
    [[DYAdvancedSetService shareInstance] setGeneralRuleWithDataModel:model Success:^(id data) {
        
//        [self executeRouterEventName:nil];
        [[DYYC_SiftStock shareInstance] clearCache];

        
        
    } fail:^(id data) {
//        [DYProgressHUD hideHUDToView:window];
//        [DYProgressHUD showTextHUDAddTo:window withDetails:@"设置失败"];

    }];
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}

- (void)dismiss{
    [super dismiss];
    
    // 清空选中
    if (self.itemArr.count > 0) {
        for (DYItem *sub in self.itemArr) {
            sub.isSelected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    self.frame = CGRectMake(0, top, DYScreenWidth, 0);
    self.shadowView.alpha = 0.0;

    [self removeFromSuperview];

}

#pragma mark - UICollectionViewDataSource,delegate

//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DYPopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DYPopViewCellId forIndexPath:indexPath];
    
    DYItem *item = self.itemArr[indexPath.item];
    [cell configCellWithTitle:item.title isSelect:item.isSelected];
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (!self.itemArr || self.itemArr.count == 0) return;
    DYItem *item = self.itemArr[indexPath.item];
    
    if (item.displayType == DYItemMarkTypeViewDisplayTypeindustry) { // 行业板块
        item.isSelected = !item.isSelected;
        
    }
    else { //全A股
        
        for (DYItem *sub in self.itemArr) {
            sub.isSelected = NO;
        }
        item.isSelected = !item.isSelected;
    }
    
    [self.collectView reloadData];
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 30, 15, 30);
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}
@end
