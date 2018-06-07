//
//  DYPriceRulesPageViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesPageViewController.h"
#import "DYTitleClickScrollView.h"
#import "DYPriceRulesViewController.h"
#import "DYPriceRulesUserSetViewController.h"
#import "DYPriceRulesService.h"
@interface DYPriceRulesPageViewController ()<DYTitleClickScrollViewDelegate, DYPriceRulesViewControllerDelegate>

@property (nonatomic, strong) DYTitleClickScrollView *titleView;
@property (nonatomic, strong) DYPriceRulesViewController *priceVC;
@property (nonatomic, strong) DYPriceRulesUserSetViewController *setVC;
@property (nonatomic, strong) DYPriceRulesService *service;

@end

@implementation DYPriceRulesPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSubViews {
    [self.dyNavTitleView redefine];
    self.dyNavTitleView.backgroundColor = DYAppearanceColor(@"H18", 1);
    [self.dyNavTitleView setNavBlackStyle];
    self.service = [[DYPriceRulesService alloc]init];
    [self.service getStareWizardPriceRulesWithResultBlock:^(id data) {
        
    }];
    if (self.secId) {
        [self.service rePlaceChooseStockCode:self.secId];
    }

    [self.dyNavTitleView addSubview:self.dyNavTitleView.backBtn];
    [self.dyNavTitleView addSubview:self.dyNavTitleView.bottomLineView];
    self.dyNavTitleView.bottomLineView.hidden = NO;

    
    self.titleView = [[DYTitleClickScrollView alloc]init];
    self.titleView.delegate = self;
    [self.titleView reloadData];
    [self.dyNavTitleView addSubview:self.titleView];

    self.priceVC = [[DYPriceRulesViewController alloc]init];
    self.priceVC.delegate = self;
    self.priceVC.service = self.service;
    WS(weakSelf)
    self.setVC = [[DYPriceRulesUserSetViewController alloc]init];
    self.setVC.service = self.service;
    [self.setVC editClickBlock:^(id data) {
        [weakSelf.priceVC setEditModel:data];
        [weakSelf changeStatusOfRelatedToolsWithIndex:0];
        [weakSelf setPageViewcontrollers:@[weakSelf.viewControllers[0]]];
    }];
    
    [self.viewControllers addObjectsFromArray:@[_priceVC,_setVC]];
    [super initSubViews];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (DYScreenWidth-120 >200) {
        self.titleView.frame = CGRectMake((DYScreenWidth-200)/2, DYStatusBarHeight+4, 200, 35);
    }else {
        self.titleView.frame = CGRectMake(55, DYStatusBarHeight+4, 200, 35);
    }
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
    self.selectedIndex = index;
    [self.titleView selectedIndex:index];
}

#pragma mark - DYPriceRulesViewControllerDelegate
- (void)creatRemindDownNeedToPushVC {
    [self didSelected:nil withIndex:1 atView:self.titleView];
    [self.titleView selectedIndex:1];
}

#pragma mark - delegate
//选中的字体
- (UIFont *)selectedLabelFontWithView:(UIView *)view {
    return DYAppearanceBoldFont(@"T5");
}
//选中的颜色
- (UIColor *)selectedLabelColorWithView:(UIView *)view {
    return DYAppearanceColorFromHex(YC_Y1, 1);
}
//未选中的颜色
- (UIColor *)nomalLabelColorWithView:(UIView *)view {
    return DYAppearanceColor(@"W1", 0.7);
}

//未选中的字体
- (UIFont *)nomalLabelFontWithView:(UIView *)view {
    return DYAppearanceFont(@"T5");
}

//数据
- (NSArray *)conentsInfoArrayWithView:(UIView *)view {
    return @[@"到价提醒",@"我的设置"];
}


//是否显示label下的线
- (BOOL)showShortLineViewWithView:(UIView *)view {
    return NO;
}

//是否显示底部分割线
- (BOOL)showBottomLineViewWithView:(UIView *)view {
    return NO;
}

//内容的宽度;默认：屏幕宽度
- (CGFloat)contentViewWidth {
    return 200;
}


//选中的index
- (NSUInteger)contentSelectedIndexWithView:(UIView *)view {
    return self.selectedIndex;
}
//点击
- (void)didSelected:(DYClickLabel*)label withIndex:(NSInteger)index atView:(UIView *)view {
    [self setPageViewcontrollers:@[self.viewControllers[index]]];
    self.selectedIndex = index;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
