//
//  DYPriceRulesUserSetViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesUserSetViewController.h"
#import "DYPriceRulesService.h"
#import "DYPriceRulesSetTableViewCell.h"
#import "UIPriceRulesHeadSectionView.h"
#import "NSString+NumberFormat.h"

@interface DYPriceRulesUserSetViewController ()

@property (nonatomic, strong) DataBlock block;

@end

@implementation DYPriceRulesUserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewData {
    [super initViewData];
    self.headRefresh = NO;
    self.footRefresh = NO;
    self.estimateHeight =  YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
    self.myTableView.backgroundColor= DYAppearanceColor(@"H1", 1);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataInfo];
}

- (void)requestDataInfo {
    WS(weakSelf)
    [self showBlackLoading];
    [self.service getStareWizardPriceRulesWithResultBlock:^(id data) {
        [weakSelf hideLoading];
        [weakSelf showRoboStateTo:weakSelf.mainView state:DYRoboViewTypeNormal];
        if (weakSelf.service.rulesArray.count >0) {
            [weakSelf.service getStockMarket:weakSelf.service.rulesArray[0] WithSuccess:^(id data) {
                [weakSelf.myTableView reloadData];
            } fail:^(id data) {
                
            }];
            [weakSelf.service getStockMarket:weakSelf.service.rulesArray[1] WithSuccess:^(id data) {
                [weakSelf.myTableView reloadData];
            } fail:^(id data) {
                
            }];
        }else {
            [weakSelf showRoboStateTo:weakSelf.mainView state:DYRoboViewTypeNoData];
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}


#pragma mark - UITableViewDatasource / UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.service.rulesArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *modelArray = self.service.rulesArray[section];
    if (modelArray.count > 0) {
        UIPriceRulesHeadSectionView *view = (UIPriceRulesHeadSectionView *)[DYNibInitService getNibViewByName:@"UIPriceRulesHeadSectionView" bundleName:@"YiChuangLibrary"];
        view.titleLabel.text = section==0?@"监控中":@"已触发";
        view.titleLabel.backgroundColor = (section ==0)?DYAppearanceColorFromHex(YC_Y1, 1):DYAppearanceColor(@"H4", 1);
        NSArray *modelArray = self.service.rulesArray[section];
        view.titleLabel.hidden = (modelArray.count ==0);
        return view;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *modelArray = self.service.rulesArray[section];
    return modelArray.count > 0 ? 45 : 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *modelArray = self.service.rulesArray[section];
    return modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYPriceRulesSetTableViewCell *cell = [DYNibInitService getDequeueReusableCell:tableView bundleName:@"YiChuangLibrary" byNibName:@"DYPriceRulesSetTableViewCell" reuseIdentifier:@"DYPriceRulesSetTableViewCell"];
    NSArray *modelArray = self.service.rulesArray[indexPath.section];
    DYStareWizardPriceRuleModel *model = modelArray[indexPath.row];
    
    cell.nameLabel.text = NilToEmptyString(model.stockInfo.stockName);
    cell.codeLabel.text = model.stockInfo.tickerId;
    cell.editBtn.hidden = indexPath.section ==1;
    cell.lastPriceLabel.text = [NSString stringWithPriceDigit2:model.stockInfo.lastPrice];
    cell.priceRiseLabel.text = [NSString stringWithPecent:model.stockInfo.changePct];
    if (model.stockInfo.changePct>0) {
        cell.lastPriceLabel.textColor = DYAppearanceColor(@"R3", 1);
        cell.priceRiseLabel.textColor = DYAppearanceColor(@"R3", 1);
    }else if (model.stockInfo.changePct<0) {
        cell.lastPriceLabel.textColor = DYAppearanceColor(@"G3", 1);
        cell.priceRiseLabel.textColor = DYAppearanceColor(@"G3", 1);
    }else {
        cell.lastPriceLabel.textColor = DYAppearanceColor(@"H5", 1);
        cell.priceRiseLabel.textColor = DYAppearanceColor(@"H5", 1);
    }
    CGFloat height = 70;
    NSString *remindStr1,*remindStr2;
    if (model.cp >0 && model.cr >0){
        remindStr1 = [NSString stringWithFormat:@"股价涨幅达到%@",[NSString stringWithPecent:model.cr]];
    }else if (model.cp >0) {
        remindStr1 = [NSString stringWithFormat:@"股价涨到%@元",[NSString stringWithPriceDigit2:model.cp]];
    }
    
    if (model.fp >0 && model.fr>0){
        remindStr2 = [NSString stringWithFormat:@"股价跌幅达到%@",[NSString stringWithPecent:model.fr]];
    }else if (model.fp >0) {
        remindStr2 = [NSString stringWithFormat:@"股价跌到%@元",[NSString stringWithPriceDigit2:model.fp]];
    }
 
    if (remindStr1.length >0 && remindStr2.length >0) {
        cell.remindLabel1.text = remindStr1;
        cell.remindLabel2.text = remindStr2;
    }else if (remindStr2.length >0) {
        cell.remindLabel1.text = remindStr2;
        height-=35;
    }else if (remindStr1.length >0) {
        cell.remindLabel1.text = remindStr1;
        height-=35;
    }
    cell.remindHeight.constant = height;
    
    WS(weakSelf)
    [cell editBlock:^(id data) {
        if (weakSelf.block) {
            weakSelf.block(model);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)editClickBlock:(DataBlock)block {
    self.block = block;
}
@end
