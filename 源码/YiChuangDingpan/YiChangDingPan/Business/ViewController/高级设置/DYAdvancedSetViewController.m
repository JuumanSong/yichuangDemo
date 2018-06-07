//
//  DYAdvancedSetViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYAdvancedSetViewController.h"
#import "DYArrowButton.h"
#import "DYTitleClickScrollView.h"
#import "DYMessageTypeViewController.h"
#import "DYStareMonitorStockEditViewController.h"
#import "DYStareOptionalMonitorSetService.h"

@interface DYAdvancedSetViewController ()<DYTitleClickScrollViewDelegate>

@property (nonatomic, strong) DYArrowButton *titleButton;
@property (nonatomic, strong) DYTitleClickScrollView *titleView;
@property (nonatomic,strong) DYStareMonitorStockEditViewController *focusVc;
@property (nonatomic,strong) DYMessageTypeViewController *mTypeVc;
@property (nonatomic, assign) NSInteger showIndex;

@end

@implementation DYAdvancedSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showIndex == 1) {
        if ([DYStareOptionalMonitorSetService shareInstance].stockArray.count == 0) {
            self.dyNavTitleView.rightBtn.hidden = YES;
        }
        else {
            self.dyNavTitleView.rightBtn.hidden = NO;
        }
    }
    else {
        self.dyNavTitleView.rightBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dyNavTitleView.backgroundColor = DYAppearanceColor(@"H18", 1);
    // Do any additional setup after loading the view.
}

- (void)initViewData {
    [super initViewData];
    WS(weakSelf)
    self.pageViewController.view.backgroundColor = DYAppearanceColor(@"W1", 1);
    self.mainView.backgroundColor = DYAppearanceColor(@"H18", 1);
    self.titleView = [[DYTitleClickScrollView alloc]init];
    self.titleView.delegate = self;
    [self.titleView reloadData];
    self.titleView.backgroundColor=DYAppearanceColor(@"H18", 1.0);
    [self.mainView addSubview:self.titleView];
    self.focusVc = [[DYStareMonitorStockEditViewController alloc] init];
    self.focusVc.Block = ^{
        if ([DYStareOptionalMonitorSetService shareInstance].stockArray.count == 0) {
            weakSelf.dyNavTitleView.rightBtn.selected = NO;
            [weakSelf.dyNavTitleView.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [weakSelf.focusVc changeRightButtonWithEdit:NO];
            weakSelf.dyNavTitleView.rightBtn.hidden = YES;
        }
        else {
            weakSelf.dyNavTitleView.rightBtn.hidden = NO;
        }
    };
    self.focusVc.isChildVC = YES;
    self.mTypeVc = [[DYMessageTypeViewController alloc] init];
    
    [self.viewControllers addObjectsFromArray:@[_mTypeVc,_focusVc]];
    [super initSubViews];
}

- (void)initSubViews {
    [self configNavView];
}

- (void)configNavView {
    [self setNavTitleText:@"高级设置"];
    [self.dyNavTitleView setNavBlackStyle];
    WS(weakSelf)
    [self.dyNavTitleView setRightBtnText:@"编辑" color:[UIColor whiteColor] withClick:^(id data) {
        weakSelf.dyNavTitleView.rightBtn.selected=!weakSelf.dyNavTitleView.rightBtn.selected;
        
        if (weakSelf.dyNavTitleView.rightBtn.selected) {
            [weakSelf.dyNavTitleView.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [weakSelf.dyNavTitleView.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
        [weakSelf.focusVc changeRightButtonWithEdit:weakSelf.dyNavTitleView.rightBtn.selected];
    }];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect rect = self.mainView.bounds;
    _titleView.frame = CGRectMake(0, 0, rect.size.width, 35);
    _titleButton.frame = CGRectMake(37, DYStatusBarHeight+2, rect.size.width -73, 40);
    CGFloat pageY = 35;
    self.pageViewController.view.frame = CGRectMake(0, pageY, DYSelfViewWidth, rect.size.height - pageY);
}

-(void)didSelectedNavItemWithIndex:(NSInteger)index {
    [self setPageViewcontrollers:@[self.viewControllers[index]]];
    self.showIndex = index;
}

- (void)setPageViewcontrollers:(NSArray *)controllers {
    if(controllers && controllers.count > 0){
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.pageViewController setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        });
    }
}

#pragma mark - override
- (void)changeStatusOfRelatedToolsWithIndex:(NSInteger)index {
    self.showIndex = index;
    [self.titleView selectedIndex:index];
    if (index==0) {
        
        self.dyNavTitleView.rightBtn.hidden=YES;
    }else{
        if ([DYStareOptionalMonitorSetService shareInstance].stockArray.count == 0) {
            self.dyNavTitleView.rightBtn.hidden = YES;
        }
        else {
            self.dyNavTitleView.rightBtn.hidden = NO;
        }
//        self.dyNavTitleView.rightBtn.hidden=NO;
    }
}

#pragma mark - delegate
//选中的字体
- (UIFont *)selectedLabelFontWithView:(UIView *)view {
    return DYAppearanceBoldFont(@"T4");
}
//选中的颜色
- (UIColor *)selectedLabelColorWithView:(UIView *)view {
//    return DYAppearanceColor(@"R3", 1);
    return DYAppearanceColorFromHex(0xCEA76E, 1.0);
}
//未选中的颜色
- (UIColor *)nomalLabelColorWithView:(UIView *)view {
    return DYAppearanceColor(@"W1", 0.7);
}

//未选中的字体
- (UIFont *)nomalLabelFontWithView:(UIView *)view {
    return DYAppearanceFont(@"T4");
}
//
- (UIColor *)bottomLineColorWithView:(UIView *)view {
    
     return DYAppearanceColorFromHex(0xCEA76E, 1.0);
}

//是否显示底部分割线
- (BOOL)showBottomLineViewWithView:(UIView *)view {
    return NO;
}

//数据
- (NSArray *)conentsInfoArrayWithView:(UIView *)view {
    return @[@"消息类型",@"特别关注"];
}
//选中的index
- (NSUInteger)contentSelectedIndexWithView:(UIView *)view {
    return self.showIndex;
}
//点击
- (void)didSelected:(DYClickLabel*)label withIndex:(NSInteger)index atView:(UIView *)view {
    [self didSelectedNavItemWithIndex:index];
    
    if (index==0) {
        
        self.dyNavTitleView.rightBtn.hidden=YES;
    }else{
        if ([DYStareOptionalMonitorSetService shareInstance].stockArray.count == 0) {
            self.dyNavTitleView.rightBtn.hidden = YES;
        }
        else {
            self.dyNavTitleView.rightBtn.hidden = NO;
        }
//        self.dyNavTitleView.rightBtn.hidden=NO;
    }
}
-(EScrollType)autoAdjustFullContentView{
    
    return eScrollTypeFullScreen;
}
-(CGFloat)contentViewWidth{
    
    return DYScreenWidth;
}
@end
