//
//  DYStareWizardHoldStockPageController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardHoldStockPageController.h"
#import "DYTitleClickScrollView.h"
#import "DYStareWizardSearchSelfStockController.h"
#import "DYStareWizardSearchHoldPositionController.h"

@interface DYStareWizardHoldStockPageController ()<DYTitleClickScrollViewDelegate>
@property (nonatomic, strong) DYTitleClickScrollView *titleView;
@property (nonatomic, strong) DYStareWizardSearchSelfStockController *stockVC;
@property (nonatomic, strong) DYStareWizardSearchHoldPositionController *holdVC;

@property (nonatomic, strong) UIView *coverHView;

@end

@implementation DYStareWizardHoldStockPageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSubViews {
    [self setDyNavTitleViewHide:YES];
    self.titleView = [[DYTitleClickScrollView alloc]init];
    self.titleView.delegate = self;
    [self.titleView reloadData];
    [self.mainView addSubview:self.titleView];
    
    
    self.stockVC = [[DYStareWizardSearchSelfStockController alloc]init];
    self.stockVC.delegate = self.delegate;

    self.holdVC = [[DYStareWizardSearchHoldPositionController alloc]init];

    [self.viewControllers addObjectsFromArray:@[_stockVC,_holdVC]];
    [super initSubViews];
    [self setScrollEnable:NO];
    [self initCoverLabel];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect rect = self.mainView.bounds;
    _titleView.frame = CGRectMake(0, 0, rect.size.width, 35);
    _coverHView.frame = CGRectMake(0, 0, rect.size.width, 34);
    CGFloat pageY = 35;
    self.pageViewController.view.frame = CGRectMake(0, pageY, DYSelfViewWidth, rect.size.height - pageY);
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

// 临时覆盖层，为了只显示"自选股"tab
// 后期若需要显示"自选股 & 持仓股"，可以直接删掉，无任何影响
- (void)initCoverLabel {
    self.coverHView = [[UIView alloc]init];
    self.coverHView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    UIView *yView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, 4, 10)];
    yView.backgroundColor = DYAppearanceColorFromHex(YC_Y1, 1);
    [self.coverHView addSubview:yView];
    UILabel *coverLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 34)];
    coverLabel.textAlignment = NSTextAlignmentLeft;
    coverLabel.text = @"自选股";
    coverLabel.textColor = DYAppearanceColor(@"H9", 1.0);
    coverLabel.font = DYAppearanceFont(@"T4");
    coverLabel.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    [self.coverHView addSubview:coverLabel];
    [self.mainView addSubview:self.coverHView];
}

#pragma mark - override
- (void)changeStatusOfRelatedToolsWithIndex:(NSInteger)index {
    self.selectedIndex = index;
     [self.titleView selectedIndex:index];
}



#pragma mark - delegate
//选中的字体
- (UIFont *)selectedLabelFontWithView:(UIView *)view {
    return DYAppearanceBoldFont(@"T4");
}
//选中的颜色
- (UIColor *)selectedLabelColorWithView:(UIView *)view {
    return DYAppearanceColor(@"B14", 1);
}
//未选中的颜色
- (UIColor *)nomalLabelColorWithView:(UIView *)view {
    return DYAppearanceColor(@"H8", 1);
}

//未选中的字体
- (UIFont *)nomalLabelFontWithView:(UIView *)view {
    return DYAppearanceFont(@"T4");
}

//数据
- (NSArray *)conentsInfoArrayWithView:(UIView *)view {
    return @[@"自选股",@"持仓股"];
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

- (void)reloadTable {
    if (self.stockVC.myTableView) {
        [self.stockVC.myTableView reloadData];
    }
    if (self.holdVC.myTableView) {
        [self.holdVC.myTableView reloadData];
    }
}

@end
