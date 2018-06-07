//
//  DYMessagePopView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMessagePopView.h"
#import "DYPopBoxHeader.h"
#import "DYMessgePopViewCell.h"
#import "DYItem.h"
#import "DYAdvancedSetService.h"
#import "UIResponder+Router.h"
#import "DYProgressHUD.h"
#import "DYYC_SiftStock.h"

@interface DYMessagePopView()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isTrigger;
@property(nonatomic,strong)DYPersonSettingModel * settingModel;

@end

@implementation DYMessagePopView

- (id)initWithItem:(NSArray *)itemArr type:(DYItemMarkTypeViewDisplayType)type {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"selectSetingNote" object:nil];
        self.backgroundColor = [UIColor whiteColor];
        self.itemArr = itemArr;
        [self _findSelectedItem];
        _settingModel = [[DYAdvancedSetService shareInstance].personSettingModel mutableCopy];
    }
    return self;
}

- (void)configUI {
    _isTrigger = NO;
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"DYMessgePopViewCell" bundle:DY_BundleLoader(@"YiChuangLibrary")] forCellReuseIdentifier:DYMessgePopViewCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
}

- (void)popupViewFromSourceFrame:(CGRect)frame superView:(UIView *)superView completion:(void (^ __nullable)(void))completion {
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    
    [superView addSubview:self];
    
//    [self addBorderLineWithFillColor:[UIColor darkGrayColor]];
    //add ShadowView
    self.shadowView.frame = CGRectMake(0, top, DYScreenWidth, DYScreenHeight - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    self.shadowView.alpha = ShadowAlpha;
    self.frame = CGRectMake(0, top, DYScreenWidth, 480 * DYScreenHeight / 736.0);
    [self configUI];
    completion();
    
}



#pragma mark - UITableViewDataSource,delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WS(weakSelf);
    DYMessgePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DYMessgePopViewCellId forIndexPath:indexPath];
    DYAdvancedModel * model =_settingModel.modelArray[indexPath.row];
    BOOL isSelected =NO;
    if ([model.bt rangeOfString:@"1"].location !=NSNotFound) {
        isSelected = YES;
    }else{
        isSelected = NO;
    }
    DYItem *item = self.itemArr[indexPath.row];
    [cell configLeftImage:item.leftImg
                    title:item.title
                   detail:item.detail
               isSelected:isSelected withSwitchBlock:^(BOOL isSelect) {
                  NSString * str = _settingModel.modelArray[indexPath.row].bt;
                   if (isSelect) {
                     str = [str stringByReplacingOccurrencesOfString:@"0" withString:@"1"];
                   }else{
                       
                      str =  [str stringByReplacingOccurrencesOfString:@"1" withString:@"0"];
                   }
                   _settingModel.modelArray[indexPath.row].bt =str;
               }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DYItem *item = self.itemArr[indexPath.row];
    return item.height;
}

#pragma mark - Logic

- (void)caheSelectItem:(DYItem *)item {
    BOOL isExit = NO;
    for (NSString *sub in self.selectedArray) {
        if ([sub isEqualToString:item.title]) {
            isExit = YES;
        }
    }
    if (item.isSelected) {
        
        if (!isExit) {
            [self.selectedArray addObject:item.title];
        }
        
    }
    else if (!item.isSelected) {
        if (isExit) {
            [self.selectedArray removeObject:item.title];
        }
    }
}

- (void)_findSelectedItem {
    for (NSInteger i = 0; i < self.itemArr.count; i++) {
        DYItem *item = self.itemArr[i];
        if (item.isSelected == YES) {
            [self.selectedArray addObject:item.title];
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
    
    [self.tableView.layer addSublayer:shapeLayer];
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - Action

- (void)refreshUI {
    _settingModel = [DYAdvancedSetService shareInstance].personSettingModel;
    [self.tableView reloadData];
}

- (void)leftButtonAction {
    _isTrigger = NO;
    //获取内存个人设置数据
    _settingModel = [DYAdvancedSetService getDefaultGeneralRulesInfo];
    if (self.itemArr && self.itemArr.count > 0) {
        for (DYItem *item in self.itemArr) {
            item.isSelected = NO;
        }
        [self.tableView reloadData];
    }
}

- (void)rightButtonAction {
    _isTrigger = YES;
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItem:)]) {
        [self.delegate popupView:self didSelectedItem:self.selectedArray];
    }
    [self dismiss];
    //设置成功，更新内存设置
    [DYAdvancedSetService shareInstance].personSettingModel =_settingModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectSetingNote" object:nil];
    WS(weakSelf);
    [[DYAdvancedSetService shareInstance]setGeneralRuleWithDataModel:_settingModel Success:^(id data) {
        if (data) {
            
            [[DYYC_SiftStock shareInstance] clearCache];
//            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//            [DYProgressHUD showTextHUDAddTo:window withDetails:@"设置成功"];
            
        }
    } fail:^(id data) {
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        [DYProgressHUD showTextHUDAddTo:window withDetails:@"设置失败"];
    }];
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}

- (void)dismiss{
    if (!_isTrigger) {
        [self leftButtonAction];
    }
    [super dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    self.frame = CGRectMake(0, top, DYScreenWidth, 0);
    self.shadowView.alpha = 0.0;
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    
}

@end
