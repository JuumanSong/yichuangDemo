//
//  DYStareWizardSearchViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardSearchViewController.h"
#import "DYSearchView.h"
#import "DYStareWizardSearchService.h"
#import "NSString+StringFormat.h"
#import "DYStareWizardSeachStockCell.h"

#import "DYStareWizardSearchHistoryController.h"
#import "DYStareWizardHoldStockPageController.h"

@interface DYStareWizardSearchViewController ()
@property (nonatomic, strong) DYSearchView *searchView;
@property (nonatomic, strong) DYStareWizardHoldStockPageController *holdPageVC;
@property (nonatomic, strong) DYStareWizardSearchHistoryController *historyVC;
@property (nonatomic, assign) BOOL showAddFlag;
@property (nonatomic, assign) BOOL isShowingAlert;

@end

@implementation DYStareWizardSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchView.tfView) {
        [self.searchView.tfView.textField becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initViewData {
    [super initViewData];
    self.headRefresh = NO;
    self.footRefresh = NO;
    self.estimateHeight = YES;
    self.historyVC = [[DYStareWizardSearchHistoryController alloc]init];
    self.historyVC.delegate = self.delegate;
    WS(weakSelf)
    [self.historyVC isShowingToastBlock:^(id data) {
        NSNumber *number = data;
        weakSelf.isShowingAlert = [number boolValue];
    } endEditBlock:^(id data) {
        [weakSelf.searchView firstResponder:NO];
        [weakSelf.mainView sendSubviewToBack:weakSelf.historyVC.view];
        [weakSelf bringToFrontHold];
    }];
    self.holdPageVC = [[DYStareWizardHoldStockPageController alloc]init];
    self.holdPageVC.delegate = self.delegate;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAddedFlag)]) {
        self.showAddFlag = [self.delegate showAddedFlag];
    }
}

-(void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
    if ( [DYStareWizardSearchService getHistoryData].count >0) {
        [self addChildViewController:self.historyVC];
        [self.mainView addSubview:self.historyVC.view];
        [self.mainView sendSubviewToBack:self.historyVC.view];
    }
    if ( [DYStareWizardSearchService getAllStockMarket].count >0) {
        [self addChildViewController:self.holdPageVC];
        [self.mainView addSubview:self.holdPageVC.view];
    }
   
    [self initNavView];
}


- (void)initNavView {
    self.searchView = [[DYSearchView alloc]init];
    self.searchView.backgroundColor = DYAppearanceColor(@"H18", 1);
    [self.searchView.rightBtn setTitleColor:DYAppearanceColor(@"W1", 1) forState:UIControlStateNormal];
    [self.searchView.tfView reloadTextFieldImageView:YES];
    //搜索相关
    WS(weakSelf)
    [self.searchView.tfView setPlaceHolder:@"请输入股票代码/名称/首字母"];
    [self.searchView.tfView textFieldTextChange:^(id data) {
        NSString *text = (NSString *)data;
        [weakSelf fetchSeachInfo:text];
    } withReturnBlock:^(id data) {
    } andBeginEditBlock:^{
        [weakSelf bringToFrontHistory];
    }];
    [self.searchView.tfView.textField addTarget:self action:@selector(textFieldEndEditClick) forControlEvents:UIControlEventEditingDidEnd];
    [self.searchView.rightBtn addTarget:self
                                 action:@selector(navRightBtnClick)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    CGFloat navH = DYISVirtualHome ? (DYStatusBarHeight + 44) : 64;
    self.searchView.frame = CGRectMake(0, 0, rect.size.width, navH);
    self.mainView.frame = CGRectMake(0, navH, rect.size.width, rect.size.height-navH);
    self.myTableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - navH);
}


- (void)bringToFrontHold {
    [self.mainView bringSubviewToFront:self.holdPageVC.view];
    if (self.holdPageVC) {
        [self.holdPageVC reloadTable];
    }
}

- (void)bringToFrontHistory {
    if ([self.searchView getTextInputStr].length ==0) {
        [self.mainView bringSubviewToFront:self.historyVC.view];
        if (self.historyVC) {
            [self.historyVC.myTableView reloadData];
        }
    }
}

#pragma mark - Actions
- (void)navRightBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldEndEditClick {
    
    if (!self.isShowingAlert &&[self.searchView getTextInputStr].length==0) {
        [self bringToFrontHold];
    }
}

- (void)fetchSeachInfo:(NSString *)searchStr {
    if (searchStr.length==0) {
        [self.dataArray removeAllObjects];
        [self.myTableView reloadData];
        [self.mainView bringSubviewToFront:self.historyVC?self.historyVC.view:self.myTableView];
        if (self.historyVC) {
            [self.historyVC.myTableView reloadData];
        }
    }else {
        [self.mainView bringSubviewToFront:self.myTableView];
        WS(weakSelf);
        [DYStockPropertyService findSortedStocksByKeyword:searchStr WithPriority:0 WithArray:nil withResultBlock:^(id data) {
            if (weakSelf.searchView.tfView.textField.text.length >0) {
                [weakSelf showRoboStateTo:weakSelf.mainView state:DYRoboViewTypeNormal];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.dataArray addObjectsFromArray:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.dataArray.count <= 0) {
                        [weakSelf showRoboStateTo:weakSelf.mainView
                                            state:DYRoboViewTypeNoData];
                    }
                    [weakSelf.myTableView reloadData];
                });
            }
        }];
    }
}



#pragma mark - DYScrollPageViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchView.tfView.textField.isFirstResponder) {
        [self.searchView.tfView.textField resignFirstResponder];
    }
}


- (void)closeTextFieldButtonClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}


#pragma mark - UITableViewDatasource / UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYStareWizardSeachStockCell *cell = [DYNibInitService getDequeueReusableCell:tableView bundleName:@"YiChuangLibrary" byNibName:@"DYStareWizardSeachStockCell" reuseIdentifier:@"DYStareWizardSeachStockCell"];
    DYStockPropertyItem *item = self.dataArray[indexPath.row];
    cell.titleLabel.text = item.secName;
    cell.contentLabel.text = item.tradeCode;
    
    __block BOOL isAdded = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(judgeStockItemIsAdded:)]) {
        isAdded = [self.delegate judgeStockItemIsAdded:item];
        [cell addBtnIsAdded:isAdded];
    }
    WS(weakSelf);
    if (self.showAddFlag) {
        __weak __typeof(&*cell)weakCell = cell;
        [cell addBtnClickBlock:^(id data) {
            [DYStareWizardSearchService saveHistoryModel:item];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(stockPropertyItemSelected:withModel:fromStatus:)]) {
                [weakSelf.delegate stockPropertyItemSelected:!isAdded withModel:item fromStatus:2];
                [weakCell addBtnIsAdded:!isAdded];
                isAdded = !isAdded;
            }
        }];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <self.dataArray.count) {
        DYStockPropertyItem *item = self.dataArray[indexPath.row];
        if (!self.showAddFlag) {
            [DYStareWizardSearchService saveHistoryModel:item];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stockPropertyItemSelected:withModel:fromStatus:)]) {
                 [self.delegate stockPropertyItemSelected:YES withModel:item fromStatus:2];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
