//
//  DYStockCardViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/4.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStockCardViewController.h"
#import "DYTitleClickScrollView.h"
#import "DYStocksMoveViewController.h"
#import "DYYC_PlateMoveViewController.h"
//#import "DYStockSearchInterface.h"
#import "DYYCStocksMoveService.h"
#import "DYStareWizardSearchViewController.h"
#import "DYYiChuangHomeSearchView.h"
#import "DYStockPropertyItem.h"
#import "DYStareOptionalMonitorSetService.h"


@interface DYStockCardViewController ()<DYTitleClickScrollViewDelegate, DYStareWizardSearchDelegate>


@property (nonatomic, strong) DYTitleClickScrollView *titleView;
@property (nonatomic, strong) DYStocksMoveViewController *stocksVC;
@property (nonatomic, strong) DYYC_PlateMoveViewController *plateVC;

@property (nonatomic, strong) DYStockPropertyItem *tickerItem;
@property (nonatomic, strong) DYYiChuangHomeSearchView *searchView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation DYStockCardViewController

#pragma mark- init

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DYAppearanceColor(@"H18", 1.0);
    self.dyNavTitleView.backgroundColor = DYAppearanceColor(@"H18", 1);
    // Do any additional setup after loading the view.
    
    
}

-(void)initViewData {
    [super initViewData];
    [self configNavView];
    
    //首次上次自选股到高级关注
    [DYStareOptionalMonitorSetService firstTimeAddUserStock];
}

- (void)initSubViews {
    
    self.stocksVC = [[DYStocksMoveViewController alloc]init];
    self.plateVC = [[DYYC_PlateMoveViewController alloc]init];
    [self.viewControllers addObjectsFromArray:@[_stocksVC,_plateVC]];
    [super initSubViews];
    self.pageViewController.view.backgroundColor = DYAppearanceColor(@"H18", 1.0);
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];
    
    self.searchView = [[DYYiChuangHomeSearchView alloc]init];
    WS(weakSelf)
    [self.searchView leftClickBLock:^(id data) {
        [weakSelf pushToSearchVCWithInfo];
    } cancelBlock:^(id data) {
        [weakSelf setScrollEnable:YES];
        weakSelf.maskView.hidden = YES;
        weakSelf.tickerItem = nil;
        [weakSelf.searchView setContentStr:nil];
        [weakSelf.view sendSubviewToBack:weakSelf.searchView];
        
        [weakSelf.stocksVC executeCancelFiltrateEvent];
    }];
    [self.view addSubview:self.searchView];
    [self.view sendSubviewToBack:self.searchView];
    if (self.showIndex!=0) {
        [self setPageViewcontrollers:@[self.viewControllers[self.showIndex]]];
        self.dyNavTitleView.rightBtn.hidden = YES;
    }
}

- (void)configNavView {
    [self.dyNavTitleView redefine];
    [self.dyNavTitleView setNavBlackStyle];
    [self.dyNavTitleView addSubview:self.dyNavTitleView.backBtn];
    [self.dyNavTitleView addSubview:self.dyNavTitleView.rightBtn];
    self.dyNavTitleView.backBtn.hidden = NO;
    
    WS(weakSelf)
    [self.dyNavTitleView setRightBtnImage:DY_ImgLoader(@"dy_nav_search_w", @"YiChuangLibrary") withClick:^(id data) {
        [weakSelf pushToSearchVCWithInfo];
    }];
    
    self.titleView = [[DYTitleClickScrollView alloc]init];
    self.titleView.delegate = self;
    [self.titleView reloadData];
    [self.dyNavTitleView addSubview:self.titleView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.titleView.frame = CGRectMake((DYScreenWidth - 230)/2.0, DYStatusBarHeight+4, 230, 35);
    self.searchView.frame = self.dyNavTitleView.frame;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tickerItem) {
        [self.searchView setContentStr:self.tickerItem.tradeCode];
        [self.view bringSubviewToFront:self.searchView];
        self.maskView.hidden = NO;
        self.maskView.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame), DYScreenWidth, 40);
    }
}


- (void)pushToSearchVCWithInfo {
    DYStareWizardSearchViewController *vc = [[DYStareWizardSearchViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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

// 根据index改变相关组件的状态
- (void)changeStatusOfRelatedToolsWithIndex:(NSInteger)index {
    [self didSelectedNavItemWithIndex:index];
    if (index == 0) {
        self.dyNavTitleView.rightBtn.hidden = NO;
    }else {
        self.dyNavTitleView.rightBtn.hidden = YES;
    }

    [self.titleView selectedIndex:index];
    
}

#pragma mark - delegate
//选中的字体
- (UIFont *)selectedLabelFontWithView:(UIView *)view {
    return DYAppearanceBoldFont(@"T5");
}
//选中的颜色
- (UIColor *)selectedLabelColorWithView:(UIView *)view {
    return DYAppearanceColorFromHex(0xCEA76E, 1);
}
//未选中的颜色
- (UIColor *)nomalLabelColorWithView:(UIView *)view {
    return DYAppearanceColor(@"W1", 0.7);
}

//未选中的字体
- (UIFont *)nomalLabelFontWithView:(UIView *)view {
    return DYAppearanceFont(@"T5");
}

//是否显示底部分割线
- (BOOL)showShortLineViewWithView:(UIView *)view {
    return NO;
}

- (BOOL)showBottomLineViewWithView:(UIView *)view {
    return NO;
}

- (CGFloat)contentViewWidth {
    return 230;
}

//数据
- (NSArray *)conentsInfoArrayWithView:(UIView *)view {
    return @[@"个股异动",@"板块异动"];
}
//选中的index
- (NSUInteger)contentSelectedIndexWithView:(UIView *)view {
    return self.showIndex;
}

- (void)didSelected:(DYClickLabel*)label withIndex:(NSInteger)index atView:(UIView *)view {
    [self setPageViewcontrollers:@[self.viewControllers[index]]];
    self.selectedIndex = index;
    if (index == 0) {
        self.dyNavTitleView.rightBtn.hidden = NO;
    }else {
        self.dyNavTitleView.rightBtn.hidden = YES;
    }
}
#pragma mark - DYStareWizardSearchDelegate

//是否选中及model, fromStatus:1, 自选股添加; 2, 手工添加; 3, 持仓股添加
- (void)stockPropertyItemSelected:(BOOL)selected
                        withModel:(DYStockPropertyItem *)item
                       fromStatus:(NSInteger)status {
    // 禁止左右滑动
    [self setScrollEnable:NO];
    if (item) {
        self.tickerItem = item;
        [self.stocksVC searchStockDidSelectTradeCode:item.tradeCode];
        
    }
}
//是否显示添加按钮
- (BOOL)showAddedFlag {
    return NO;
}

#pragma mark - getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _maskView;
}
/** * 功能：禁止横屏 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    
    return UIInterfaceOrientationMaskPortrait;
    
}



@end
