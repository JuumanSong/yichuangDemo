//
//  DYStareMonitorStockEditViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by yun.shu on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareMonitorStockEditViewController.h"
#import "DYStareMonitorStockEditCell.h"
#import "DYStareMonitorStockEditHeaderView.h"
#import "DYStareMonitorStockEditBottomView.h"
#import "DYStareWizardSearchViewController.h"

#import "DYStareOptionalMonitorSetService.h"
#import "DYProgressHUD.h"
#import "DYAlertUtil.h"
#import "YCButton.h"
#import "DYTools+DeviceInfo.h"


@interface DYStareMonitorStockEditViewController ()<UITableViewDelegate, UITableViewDataSource,DYStareWizardSearchDelegate, DYStareMonitorStockEditBottomViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) DYStareMonitorStockEditBottomView *toolView;//底部工具栏
@property (nonatomic, strong) UIView *noDataView; // 无数据时展示的view

@property (nonatomic, strong) NSMutableArray *selectArray; // 记录选中的数组
@property (nonatomic, assign) BOOL editFlag;    // 是否编辑flag
@property (nonatomic, assign) BOOL isSelectAll; // 是否全选
@property (nonatomic, strong) YCButton *messagePushButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray* stockArray;


@end

@implementation DYStareMonitorStockEditViewController

#pragma mark - View's Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockArray = [DYStareOptionalMonitorSetService shareInstance].stockArray;
}

- (void)initViewData {
    [super initViewData];
}

- (void)initSubViews {
    [super initSubViews];
    self.dyNavTitleView.bottomLineView.hidden = NO;
    [self setNavTitleText:@"监控股票"];
    [self changeRightButtonWithEdit:NO];
    
    //table
    self.myTableView = [[UITableView alloc]init];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //ios11自动内边距
    if (@available(iOS 11.0, *)) {
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.mainView addSubview:self.myTableView];
    
    [self.mainView addSubview:self.messagePushButton];
    [self.mainView bringSubviewToFront:self.messagePushButton];
    
    [self.messagePushButton addSubview:self.lineView];
    
    // 消息推送开关查询
    [DYStareOptionalMonitorSetService getMsgStatusWithSuccess:^(id data) {
        NSString *flag = data[@"data"];
        if (flag.integerValue == 1) {
            self.messagePushButton.selected = YES;
        }
    } fail:^(id data) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showViewState];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.mainView.bounds.size;
    CGFloat toolH = 44;
    CGFloat safeHeight = iPhoneX ? UIView.additionaliPhoneXBottomSafeHeight : 0;
    if (self.editFlag) {
        self.myTableView.frame = CGRectMake(0, 0, size.width, size.height - toolH);
        self.toolView.hidden = NO;
    }else {
        self.toolView.hidden = YES;
        self.myTableView.frame = CGRectMake(0, 0, size.width, size.height - 50);
        self.noDataView.frame = CGRectMake(0, 93, size.width, size.height - 93);
    }
    
    self.toolView.frame = CGRectMake(0, size.height - toolH - safeHeight, size.width, toolH);
//    self.messagePushButton.frame = CGRectMake(0, CGRectGetMaxY(self.myTableView.frame), DYScreenWidth, 50);
    
    [self.messagePushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView);
        make.bottom.mas_equalTo(-safeHeight);
        make.height.equalTo(@50);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.messagePushButton);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UI Methods
- (void)showViewState {
    if (self.stockArray.count > 0) {
        self.noDataView.hidden = YES;
        self.myTableView.scrollEnabled = YES;
        [self showRoboStateTo:self.mainView state:DYRoboViewTypeNormal];
        
    }else {
        [self changeRightButtonWithEdit:NO];
        self.noDataView.hidden = NO;
        self.myTableView.scrollEnabled = NO;
        [self showRoboStateTo:self.noDataView state:DYRoboViewTypeNoData];
    }
}

// 改变右上角按钮状态
- (void)changeRightButtonWithEdit:(BOOL)isEdit {
    self.editFlag = isEdit;
    if (self.isChildVC) {
        if (!isEdit) {
            self.isSelectAll = NO;
            self.messagePushButton.hidden = NO;
            self.lineView.hidden = NO;
            [self.selectArray removeAllObjects];
            [self reloadToolView];
            [self.myTableView reloadData];
        }else {
            self.messagePushButton.hidden = YES;
            self.lineView.hidden = YES;
            if (self.stockArray.count > 0) {
                [self.myTableView reloadData];
            }else {
                [self showToast:@"去添加股票~"];
            }
        }
    }else {
        WS(weakSelf);
        if (isEdit) {
            weakSelf.messagePushButton.hidden = NO;
            self.lineView.hidden = NO;
            [self.dyNavTitleView setRightBtnText:@"完成"
                                           color:DYAppearanceColor(@"W1", 1.0)
                                       withClick:^(id data) {
                                           
                                           [weakSelf changeRightButtonWithEdit:NO];
                                           weakSelf.isSelectAll = NO;
                                           [weakSelf.selectArray removeAllObjects];
                                           
                                           [weakSelf reloadToolView];
                                           [weakSelf.myTableView reloadData];
                                       }];
            
        }else {
            weakSelf.messagePushButton.hidden = YES;
            self.lineView.hidden = YES;
            [self.dyNavTitleView setRightBtnText:@"编辑" color:DYAppearanceColor(@"W1", 1.0)
                                       withClick:^(id data) {
                                           
                                           if (self.stockArray.count > 0) {
                                               [weakSelf changeRightButtonWithEdit:YES];
                                               [weakSelf.myTableView reloadData];
                                           }else {
                                               [weakSelf showToast:@"去添加股票~"];
                                           }
                                       }];
        }
    }
  
}

// 刷新底部栏UI
- (void)reloadToolView {
    [self.toolView reloadUIIsSelectAll:self.isSelectAll
                           deleteCount:self.selectArray.count];
}

#pragma mark - Request Data
// 添加股票
- (void)addStockList:(NSArray *)array {
    WS(weakSelf);
    [DYStareOptionalMonitorSetService addStareWizardStockListWithArray:array success:^(id data) {
        
        [weakSelf.myTableView reloadData];
        
    } fail:^(id data) {
        [weakSelf showToast:@"添加失败"];
    }];
}

// 删除股票
- (void)deleteStockList:(NSArray *)array {
    WS(weakSelf);
    [DYStareOptionalMonitorSetService deleteStareWizardStockListWithArray:array success:^(id data) {
        
        [weakSelf showViewState];
        [weakSelf.myTableView reloadData];
        if (weakSelf.Block) {
            weakSelf.Block();
        }
        
    } fail:^(id data) {
        [weakSelf showToast:@"删除失败"];
    }];
    
}

#pragma mark - UITableViewDatasource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stockArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DYStareMonitorStockEditCell rowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [DYStareMonitorStockEditHeaderView getHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DYStareMonitorStockEditHeaderView *header = (DYStareMonitorStockEditHeaderView *)[DYNibInitService getNibViewByName:@"DYStareMonitorStockEditHeaderView" bundleName:@"YiChuangLibrary"];
    
    NSString *countStr = [NSString stringWithFormat:@"%lu只", (unsigned long)self.stockArray.count];
    WS(weakSelf);
    [header configStockCount:countStr clickBlock:^(id data) {
        DYStareWizardSearchViewController *vc = [[DYStareWizardSearchViewController alloc]init];
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.stockArray.count > 0) {
        DYStareMonitorStockEditCell *cell = [DYNibInitService getDequeueReusableCell:tableView bundleName:@"YiChuangLibrary" byNibName:@"DYStareMonitorStockEditCell" reuseIdentifier:DYStareMonitorStockEditCellID];
        
        DYStareWizardStockInfoModel *model = self.stockArray[indexPath.row];
        
        BOOL isSelect = NO;
        if ([self.selectArray containsObject:model]) {
            isSelect = YES;
        }
        
        [cell configCellName:model.stockName
                        code:model.tickerId
                      source:model.source
                      isEdit:self.editFlag
                    isSelect:isSelect];
        cell.borderOption = kDYBorderOptionBottom;
        return cell;
    }else {
        return [[UITableViewCell alloc]init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editFlag) {
        [self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - Cell Click
// cell点击事件
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.stockArray.count - 1) {
        return;
    }
    
    DYStareWizardStockInfoModel *model = self.stockArray[indexPath.row];
    
    if ([self.selectArray containsObject:model]) {
        self.isSelectAll = NO;
        [self.selectArray removeObject:model];
    }else {
        [self.selectArray addObject:model];
    }
    
    if (self.selectArray.count == self.stockArray.count) {
        self.isSelectAll = YES;
    }
    
    [self reloadToolView];
    [self.myTableView reloadData];
    
//    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark- Message Push Action

- (void)messagePushAction:(YCButton *)button {
    button.selected = !button.selected;
    [DYStareOptionalMonitorSetService setMsgStatusWithParam:@{
                                                              @"s": button.selected ? @"1" : @"0"
                                                              }
                                                    Success:^(id data) {
                                                        
                                                    } fail:^(id data) {
                                                        
                                                    }];
}

#pragma mark - DYStareMonitorStockEditBottomViewDelegate
- (void)stareMonitorEditToolViewClickWithTag:(NSInteger)tag {
    if (1000 == tag) { // 全选
        [self selectAllButtonClick];
        
    }else { // 删除
        [self deleteStockButtonClick];
    }
}

// 全选
- (void)selectAllButtonClick {
    self.isSelectAll = !self.isSelectAll;
    
    if (self.isSelectAll) {
        self.selectArray = [self.stockArray mutableCopy];
        
    }else {
        [self.selectArray removeAllObjects];
    }
    [self.myTableView reloadData];
    [self reloadToolView];
}

// 删除
- (void)deleteStockButtonClick {
    WS(weakSelf);
    NSString *msg = @"是否确定删除监控股票？";
    if(IOS_VERSION_LATER(8)) {
        [DYAlertUtil dyAlertView:nil message:msg leftTitle:@"取消" rightTitle:@"删除" superVC:self completBlcok:^(NSInteger i) {
            if (1 == i) {
                [weakSelf deleteStockList:weakSelf.selectArray];
                weakSelf.isSelectAll = NO;
                [weakSelf.selectArray removeAllObjects];
                [weakSelf reloadToolView];
                
            }
        }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex ==1) {
        [self deleteStockList:self.selectArray];
        self.isSelectAll = NO;
        [self.selectArray removeAllObjects];
        [self reloadToolView];
    }
}

#pragma mark - DYStareWizardSearchDelegate

//是否选中及model
- (void)stockPropertyItemSelected:(BOOL)selected withModel:(DYStockPropertyItem *)item fromStatus:(NSInteger)status {
    DYStareWizardStockInfoModel *model = [[DYStareWizardStockInfoModel alloc]init];
    model.stockName = item.secName;
    model.tickerId = item.tradeCode;
    model.assetType = item.secType;
    model.status = status;
    model.exchangeCD = item.tradeMarket;
    
    NSMutableArray *stockList = [[NSMutableArray alloc]init];
    [stockList addObject:model];
    
    if (selected) { // 添加
        [DYProgressHUD showBingGoIndicatorInView:self.navigationController.view
                                         message:@"添加成功"];
        [self addStockList:stockList];
        
        if (self.stockArray.count >20) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DYProgressHUD showBingGoIndicatorInView:self.navigationController.view
                                                 message:@"特别关注个股最好不超过20只哦，压力满满"];
            });
        }
    }else {
        [DYProgressHUD showErrorIndicatorInView:self.navigationController.view
                                        message:@"取消添加"];
        [self deleteStockList:stockList];
    }
}

//是否显示添加按钮
- (BOOL)showAddedFlag {
    return YES;
}

//判断是否添加
- (BOOL)judgeStockItemIsAdded:(DYStockPropertyItem *)item {
    for (int i = 0; i < self.stockArray.count; i++) {
        DYStareWizardStockInfoModel *model = self.stockArray[i];
        if ([item.tradeCode isEqualToString:model.tickerId]) {
            return YES;
        }
    }
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - getter
- (NSMutableArray *)selectArray {
    if (_selectArray == nil) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}

// 底部工具栏
- (DYStareMonitorStockEditBottomView *)toolView {
    if (_toolView == nil) {
        _toolView = [[DYStareMonitorStockEditBottomView alloc]init];
        _toolView.delegate = self;
        [self.mainView addSubview:_toolView];
    }
    return _toolView;
}

- (UIView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc]init];
        _noDataView.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:_noDataView];
    }
    return _noDataView;
}

- (YCButton *)messagePushButton {
    if (!_messagePushButton) {
        _messagePushButton = [YCButton yc_shareButton];
        _messagePushButton.backgroundColor = [UIColor whiteColor];
        _messagePushButton.yc_imageAligmentLeft = YES;
        _messagePushButton.status = YCAlignmentStatusCenter;
        _messagePushButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_messagePushButton setTitleColor:DYAppearanceColorFromHex(0xCEA76E, 1) forState:UIControlStateNormal];
        [_messagePushButton setTitle:@"开启消息通知" forState:UIControlStateNormal];
        [_messagePushButton setImage:DY_ImgLoader(@"YC_check_border", @"YiChuangLibrary") forState:UIControlStateNormal];
        [_messagePushButton setImage:DY_ImgLoader(@"YC_checked_border", @"YiChuangLibrary") forState:UIControlStateSelected];
        [_messagePushButton addTarget:self action:@selector(messagePushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messagePushButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = DYAppearanceColor(@"H2", 1.0);
        
    }
    return _lineView;
}

@end
