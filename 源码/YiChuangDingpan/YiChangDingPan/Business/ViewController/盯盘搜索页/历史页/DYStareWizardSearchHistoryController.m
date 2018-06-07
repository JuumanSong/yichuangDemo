//
//  DYStareWizardSearchHistoryController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardSearchHistoryController.h"
#import "DYStareWizardSearchService.h"
#import "DYStareWizardSeachStockCell.h"
#import "DYSearchHistoryHeadView.h"
#import "DYAlertUtil.h"

@interface DYStareWizardSearchHistoryController ()<UIAlertViewDelegate>
@property (nonatomic, assign) BOOL showAddFlag;
@property (nonatomic, strong) DataBlock block;
@property (nonatomic, strong) DataBlock endBlock;
@end

@implementation DYStareWizardSearchHistoryController

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
    self.dataArray = [[DYStareWizardSearchService getHistoryData] mutableCopy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAddedFlag)]) {
        self.showAddFlag = [self.delegate showAddedFlag];
    }
}

-(void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.endBlock) {
        self.endBlock(nil);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect rect = self.mainView.frame;
    self.myTableView.frame = CGRectMake(0, 0,CGRectGetWidth(rect), CGRectGetHeight(rect)-290);
}

- (void)clearHistory {
    if (self.block) {
        self.block(@(YES));
    }
    NSString *msg = @"是否清除历史记录？";
    if(IOS_VERSION_LATER(8)) {
        WS(weakSelf)
        [DYAlertUtil dyAlertView:@"提示" message:msg leftTitle:@"取消" rightTitle:@"确认" superVC:self completBlcok:^(NSInteger i) {
            if (1 == i) {
                [DYStareWizardSearchService deleteAllHistory];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.myTableView reloadData];
                [weakSelf.view removeFromSuperview];
                [weakSelf removeFromParentViewController];
            }else {
                if (self.block) {
                    self.block(@(NO));
                }
            }
        }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [DYStareWizardSearchService deleteAllHistory];
        [self.dataArray removeAllObjects];
        [self.myTableView reloadData];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }else {
        if (self.block) {
            self.block(@(NO));
        }
    }
}


#pragma mark - UITableViewDatasource / UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DYSearchHistoryHeadView *headView = [[DY_BundleLoader(@"YiChuangLibrary") loadNibNamed:@"DYSearchHistoryHeadView" owner:nil options:nil] lastObject];
    
    WS(weakSelf);
    [headView headClickWithBlock:^(id data) {
        [weakSelf clearHistory];
    }];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYStareWizardSeachStockCell *cell = [DYNibInitService getDequeueReusableCell:tableView bundleName:@"YiChuangLibrary" byNibName:@"DYStareWizardSeachStockCell" reuseIdentifier:@"DYStareWizardSeachStockCell"];
    DYStockPropertyItem *item = self.dataArray[indexPath.row];
    cell.titleLabel.text = item.secName;
    cell.contentLabel.text = item.tradeCode;
    WS(weakSelf);
    
    __block BOOL isAdded = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(judgeStockItemIsAdded:)]) {
        isAdded = [self.delegate judgeStockItemIsAdded:item];
        [cell addBtnIsAdded:isAdded];
    }
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
    }else {
        [cell deleteBtnClickBlock:^(id data) {
            [DYStareWizardSearchService deleteModel:item];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.myTableView reloadData];
            if (weakSelf.dataArray.count ==0) {
                [weakSelf.view removeFromSuperview];
                [weakSelf removeFromParentViewController];
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)isShowingToastBlock:(DataBlock)block endEditBlock:(DataBlock)endBlock {
    self.block = block;
    self.endBlock = endBlock;
}


@end

