//
//  DYPriceRulesViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYPriceRulesViewController.h"
#import "DYPriceRulesHeadView.h"
#import "DYPriceRulesTableViewCell.h"
#import "DYPriceRulesService.h"
#import "NSString+NumberFormat.h"

#import "DYStareWizardSearchViewController.h"

@interface DYPriceRulesViewController ()<DYStareWizardSearchDelegate>
@property (nonatomic, strong) DYPriceRulesHeadView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *footBtn;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL showPrice;

@end

@implementation DYPriceRulesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewData {
    [super initViewData];
    self.headRefresh = NO;
    self.footRefresh = NO;
    self.estimateHeight =  YES;
    self.showPrice = YES;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.service.stockModel) {
        WS(weakSelf)
        [self.service getStockMarket:@[self.service.stockModel] WithSuccess:^(id data) {
            [weakSelf.myTableView reloadData];
        } fail:^(id data) {
            
        }];
    }
    if(self.service.stockModel && self.service.stockModel.cId.length >0) {
        [self.footBtn setTitle:@"更新提醒" forState:UIControlStateNormal];
    }else {
        [self.footBtn setTitle:@"创建提醒" forState:UIControlStateNormal];
        
        
        
//        if(self.service.stockModel.stockInfo.tickerId){
//            DYStockPropertyItem * item = [DYStockPropertyService getPropertyItemByTicker:self.service.stockModel.stockInfo.tickerId];
//            WS(weakSelf)
//            [self.service getStareWizardPriceRulesWithResultBlock:^(id data) {
//                [weakSelf stockPropertyItemSelected:YES withModel:item fromStatus:2];
//            }];
//        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


- (void)reload {
    if(self.service.stockModel && self.service.stockModel.cId.length >0) {
        [self.footBtn setTitle:@"更新提醒" forState:UIControlStateNormal];
    }else {
        [self.footBtn setTitle:@"创建提醒" forState:UIControlStateNormal];
    }
    
    WS(weakSelf)
    [self.service getStockMarket:@[self.service.stockModel] WithSuccess:^(id data) {
        [weakSelf.myTableView reloadData];
    } fail:^(id data) {
        
    }];
}

- (void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
    self.headView =(DYPriceRulesHeadView *) [DYNibInitService getNibViewByName:@"DYPriceRulesHeadView" bundleName:@"YiChuangLibrary"];
    WS(weakSelf)
    [self.headView segementBlock:^(NSInteger i) {
        weakSelf.showPrice = (i==0);
        [weakSelf.myTableView reloadData];
    }];
    [self.headView chooseBlock:^(id data) {
        [weakSelf pushToSearch];
    }];
    [self.myTableView reloadData];
    
    self.footView = [[UIView alloc]init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 30, DYScreenWidth-30, 44);
//    btn.backgroundColor = DYAppearanceColor(@"B14", 1);
    btn.backgroundColor = DYAppearanceColorFromHex(0xCEA76E, 1);
    [btn setTitle:@"创建提醒" forState:UIControlStateNormal];
    [btn setTitleColor:DYAppearanceColor(@"W1", 1) forState:UIControlStateNormal];
    btn.titleLabel.font = DYAppearanceFont(@"T5");
    btn.layer.cornerRadius =2;
    [btn addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
    self.footBtn = btn;
    [self.footView addSubview:btn];
    [self setFootBtnEnable];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.myTableView.frame = self.mainView.bounds;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setFootBtnEnable {
    if (!self.service.stockModel.stockInfo) {
        [self setFootBtnEnalbeByFlag:NO];
    }else if (self.service.stockModel.cp<=0 && self.service.stockModel.cr<=0 &&
              self.service.stockModel.fr<=0 && self.service.stockModel.fr<=0 ) {
        [self setFootBtnEnalbeByFlag:NO];
    }else {
        [self setFootBtnEnalbeByFlag:YES];
    }
}


- (void)setFootBtnEnalbeByFlag:(BOOL)flag {
    self.footBtn.enabled = flag;
    UIColor *color = flag ? DYAppearanceColor(@"W1", 1.0) : DYAppearanceColor(@"H8", 1.0);
    [self.footBtn setTitleColor:color forState:UIControlStateNormal];
//    self.footBtn.backgroundColor = flag?DYAppearanceColor(@"B14", 1):DYAppearanceColor(@"H1", 1);
    self.footBtn.backgroundColor = flag?DYAppearanceColorFromHex(0xCEA76E, 1):DYAppearanceColor(@"H1", 1);

}

//初始化设置tableView类型
- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (void)pushToSearch {
    DYStareWizardSearchViewController *vc =[[DYStareWizardSearchViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)footClick {
    WS(weakSelf);
    [DYPriceRulesService setStareWizardPriceRuleWithInfo:self.service.stockModel resultBlock:^(id data) {
        [weakSelf.view endEditing:YES];
        NSNumber *num = data;
        if ([num boolValue]) {
            if([weakSelf.parentViewController isKindOfClass:[UIViewController class]]){
                [weakSelf.parentViewController showToast:@"创建成功"];
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(creatRemindDownNeedToPushVC)]) {
                [weakSelf.delegate creatRemindDownNeedToPushVC];
            }
            [self clearAll];
        }else {
            [weakSelf showToast:@"创建失败"];
        }
    }];
}

-(void)clearAll{
    self.service.stockModel = nil;
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDatasource / UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headView.inputNameLabel.hidden = NO;
    self.headView.stockLastPriceLabel.textColor = DYAppearanceColor(@"H8", 1);
    self.headView.stockLastPriceRiseLabel.textColor = DYAppearanceColor(@"H8", 1);
    self.headView.imgHeight.constant = 215;
    if (self.service.stockModel.stockInfo.tickerId) {
        self.headView.stockInfoView.hidden = NO;
        self.headView.inputNameLabel.hidden = YES;
        self.headView.stockTickerLabel.text = NilToEmptyString(self.service.stockModel.stockInfo.tickerId);
        self.headView.stockNameLabel.text = NilToEmptyString(self.service.stockModel.stockInfo.stockName);
        self.headView.stockLastPriceLabel.text = [NSString stringWithPriceDigit2:self.service.stockModel.stockInfo.lastPrice];
        self.headView.stockLastPriceRiseLabel.text = [NSString stringWithPecent:self.service.stockModel.stockInfo.changePct];
        if (self.service.stockModel.stockInfo.changePct>0) {
            self.headView.stockLastPriceLabel.textColor = DYAppearanceColor(@"R3", 1);
            self.headView.stockLastPriceRiseLabel.textColor = DYAppearanceColor(@"R3", 1);
        }else if (self.service.stockModel.stockInfo.changePct<0) {
            self.headView.stockLastPriceLabel.textColor = DYAppearanceColor(@"G3", 1);
            self.headView.stockLastPriceRiseLabel.textColor = DYAppearanceColor(@"G3", 1);
        }else {
            self.headView.stockLastPriceLabel.textColor = DYAppearanceColor(@"H5", 1);
            self.headView.stockLastPriceRiseLabel.textColor = DYAppearanceColor(@"H5", 1);
        }
    }
    return self.headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 370;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYPriceRulesTableViewCell *cell = [DYNibInitService getDequeueReusableCell:tableView bundleName:@"YiChuangLibrary" byNibName:@"DYPriceRulesTableViewCell" reuseIdentifier:@"DYPriceRulesTableViewCell"];
    
    cell.textField.placeholder = self.showPrice?@"请输入价格":@"请输入幅度";
    cell.unitLabel.text = self.showPrice?@"元":@"%";
    
    CGFloat value;
    if (indexPath.row ==0) {
        cell.titleLabel.text = self.showPrice?@"股价涨到":@"股价涨幅";
        if (self.showPrice) {
            if (self.service.stockModel.cp>0 && self.service.stockModel.cr >0) {
                value = 0;
            }else {
                value = self.service.stockModel.cp;
            }
        }else {
            value = self.service.stockModel.cr;
        }
    }else {
        cell.titleLabel.text = self.showPrice?@"股价跌到":@"股价跌幅";
        if (self.showPrice) {
            if (self.service.stockModel.fp>0 && self.service.stockModel.fr >0) {
                value =0;
            }else {
                value = self.service.stockModel.fp;
            }
        }else {
            value = self.service.stockModel.fr;
        }
    }
    
    [cell setSwitchOn:value>0];
    if (value >0) {
        cell.textField.text = self.showPrice?[NSString stringWithPriceDigit2:value]:[NSString stringWithPriceDigit2:value*100];
    }else{
        cell.textField.text = @"";
    }
    WS(weakSelf)
    [cell textFieldBeginEdit:^(id data) {
        if (!weakSelf.service.stockModel.stockInfo) {
            [weakSelf pushToSearch];
            return NO;
        }
        return YES;
    } endEdit:^(id data) {
        NSString *str = data;
        NSDictionary *dict = [weakSelf.service textChangeValue:[str floatValue] withPrice:weakSelf.showPrice withRise:indexPath.row==0];
        NSString *warningStr = dict[@"warning"];
        if (warningStr) {
            [cell setSwitchOn:NO];
            cell.textField.text = @"";
        }
    }  textChange:^(id data) {
        NSString *str = data;
        NSDictionary *dict = [weakSelf.service textChangeValue:[str floatValue] withPrice:weakSelf.showPrice withRise:indexPath.row==0];
        NSString *warningStr = dict[@"warning"];
        if (warningStr) {
            cell.popKeyLabel.text = NilToEmptyString(warningStr);
            cell.popKeyLabel.textColor = DYAppearanceColor(@"R3", 1);
            [weakSelf setFootBtnEnalbeByFlag:NO];
            if ([dict[@"requestInfo"]boolValue]) {//重新获取股价
                [weakSelf requestDataInfo];
            }
            [cell changeBoxString:warningStr imageRed:YES];
        }else {
            NSString *contentStr = dict[@"key"];
            if (contentStr) {
                cell.popKeyLabel.text = NilToEmptyString(contentStr);
                cell.popKeyLabel.textColor = DYAppearanceColor(@"H8", 1);
            }
            [weakSelf.service setValue:str withPrice:weakSelf.showPrice withRise:indexPath.row==0];
            [weakSelf setFootBtnEnalbeByFlag:YES];
            [cell changeBoxString:contentStr imageRed:NO];
        }
    } switchBlock:nil];
    
    return cell;
}

#pragma mark delegate

//是否选中及model
- (void)stockPropertyItemSelected:(BOOL)selected withModel:(DYStockPropertyItem *)item fromStatus:(NSInteger)status {
    if (item) {
        [self.service rePlaceChooseStock:item];
        WS(weakSelf)
        [self.service getStockMarket:@[self.service.stockModel] WithSuccess:^(id data) {
            [weakSelf.myTableView reloadData];
        } fail:^(id data) {
            
        }];
    }
    [self.myTableView reloadData];
}

//是否显示添加按钮
- (BOOL)showAddedFlag {
    return NO;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    CGRect rect = self.myTableView.frame;
    rect.origin.y = -250;
    [UIView animateWithDuration:0.5 animations:^{
        self.myTableView.frame = rect;
    }];
    self.isEditing = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
        CGRect rect = self.myTableView.frame;
        rect.origin = CGPointMake(0, 0);
        self.myTableView.frame = rect;
}


- (void)setEditModel:(DYStareWizardPriceRuleModel *)model {
    if (model) {
        self.service.stockModel = model;
        [self.myTableView reloadData];
    }
}

@end

