//
//  DYStareWizardSearchSelfStockController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStareWizardSearchSelfStockController.h"
#import "DYStareWizardSeachStockCell.h"

#import "DYStareWizardSearchService.h"

@interface DYStareWizardSearchSelfStockController ()
@property (nonatomic, assign) BOOL showAddFlag;

@end

@implementation DYStareWizardSearchSelfStockController

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
    [self.dataArray addObjectsFromArray: [DYStareWizardSearchService getAllStockMarket]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAddedFlag)]) {
        self.showAddFlag = [self.delegate showAddedFlag];
    }
}

-(void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
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
    WS(weakSelf)
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
                [weakSelf.delegate stockPropertyItemSelected:!isAdded withModel:item fromStatus:1];
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
                [self.delegate stockPropertyItemSelected:YES withModel:item fromStatus:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

@end
