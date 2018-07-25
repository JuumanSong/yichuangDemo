//
//  DYMessageTypeViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMessageTypeViewController.h"
#import "DYSZ_MessageTypeHeadView.h"
#import "DYSZ_PriceRuleViewCell.h"
#import "DYSZ_TechSignalViewCell.h"
#import "DYSZ_SimilarKViewCell.h"
#import "DYSZ_MultiDaysViewCell.h"
#import "DYSZ_ImportantAnnViewCell.h"
#import "DYSZ_PriceShakeViewCell.h"
#import "DYSZ_BigDealViewCell.h"
#import "DYSZ_LimitMoveViewCell.h"
#import "DYAdvancedSetService.h"
#import "DYPersonSettingModel.h"
#import "DYPriceRulesPageViewController.h"
#import "DYYC_SiftStock.h"
#import "DYProgressHUD.h"
#import "DYExplainHelper.h"


@interface DYMessageTypeViewController ()<UITableViewDelegate,UITableViewDataSource,DYSZ_MessageTypeHeadViewDelegate>
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)DYSZ_PriceRuleViewCell * priceRuleViewCell;
@property(nonatomic,strong)DYSZ_TechSignalViewCell * techSignalViewCell;
@property(nonatomic,strong)DYSZ_SimilarKViewCell * similarKViewCell;
@property(nonatomic,strong)DYSZ_MultiDaysViewCell * multiDaysViewCell;
@property(nonatomic,strong)DYSZ_ImportantAnnViewCell * importantAnnViewCell;
@property(nonatomic,strong)DYSZ_PriceShakeViewCell * priceShakeViewCell;
@property(nonatomic,strong)DYSZ_BigDealViewCell * bigDealViewCell;
@property(nonatomic,strong)DYSZ_LimitMoveViewCell * limitMoveViewCell;
@property(nonatomic,strong)DYPersonSettingModel * settingModel;
@end

@implementation DYMessageTypeViewController
#pragma mark---init data
-(void)initViewData{
    
    [self requestDataInfo];
}

/**
先将数据copy一份用于UI的刷新，等确定设置后再去改变源数据
 */
-(void)requestDataInfo{
    _settingModel =[[DYAdvancedSetService shareInstance].personSettingModel mutableCopy];
}
#pragma mark --initView
-(void)initSubViews{
    [super initSubViews];
    [self loadTableView];
    [self loadTaleViewCell];
    [self loadBottomView];
}

-(void)loadBottomView{
    
    CGFloat safeHeight = iPhoneX ? UIView.additionaliPhoneXBottomSafeHeight : 0;
    UIButton * leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:DYAppearanceColorFromHex(0x404040, 1) forState:UIControlStateNormal];
    [leftButton setTitle:@"重置" forState:UIControlStateNormal];
    leftButton.titleLabel.font =[UIFont systemFontOfSize:16];
    [leftButton setBackgroundColor:DYAppearanceColor(@"W1", 1)];
    [self.mainView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(DYScreenWidth/2);
    }];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:DYAppearanceColorFromHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    rightButton.titleLabel.font =[UIFont systemFontOfSize:16];
    [rightButton setBackgroundColor:DYAppearanceColorFromHex(0xCEA76E, 1)];
    [self.mainView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(DYScreenWidth/2);

    }];
    
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];

}

/**
 重置设置，获取默认设置数据，刷新UI
 */
-(void)leftButtonClick{
    
    _settingModel =[DYAdvancedSetService getDefaultGeneralRulesInfo];
    
    [self.myTableView reloadData];
}

/**
 提交设置数据,调用API
 */
-(void)rightButtonClick{
    
    [DYAdvancedSetService shareInstance].personSettingModel = self.settingModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectSetingNote" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[DYAdvancedSetService shareInstance]setGeneralRuleWithDataModel:_settingModel Success:^(id data) {
        
        if (data) {
            //调用成功，更新本地设置
//            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//            [DYProgressHUD showTextHUDAddTo:window withDetails:@"设置成功"];
            [[DYYC_SiftStock shareInstance]clearCache];
            
        }
    } fail:^(id data) {
        //失败则不更新
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        [DYProgressHUD showTextHUDAddTo:window withDetails:@"设置失败"];
    }];
}
-(void)loadTableView{;
    
    //table
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    self.dyNavTitleView.hidden=YES;
    [self.myTableView registerClass:[DYSZ_MessageTypeHeadView class] forHeaderFooterViewReuseIdentifier:@"DYSZ_MessageTypeHeadView"];
    //ios11自动内边距
    if (@available(iOS 11.0, *)) {
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.myTableView.estimatedRowHeight=0;
        self.myTableView.estimatedSectionHeaderHeight=0;
        self.myTableView.estimatedSectionFooterHeight=0;
    }

    
    [self.mainView addSubview:self.myTableView];
}
-(void)loadTaleViewCell{
    
    _priceRuleViewCell =[[DYSZ_PriceRuleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _techSignalViewCell =[[DYSZ_TechSignalViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _similarKViewCell =[[DYSZ_SimilarKViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _multiDaysViewCell =[[DYSZ_MultiDaysViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _importantAnnViewCell =[[DYSZ_ImportantAnnViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _priceShakeViewCell =[[DYSZ_PriceShakeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _bigDealViewCell =[[DYSZ_BigDealViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _limitMoveViewCell =[[DYSZ_LimitMoveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat safeHeight = iPhoneX ? UIView.additionaliPhoneXBottomSafeHeight : 0;
    _myTableView.frame = self.mainView.bounds;
    CGRect frame =self.myTableView.frame;
    frame.size.height -= 44 + safeHeight;
    self.myTableView.frame = frame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.myTableView reloadData];
}
#pragma mark--tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 8;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height =0;
    switch (indexPath.section) {
        case 0:
        {
            height=55;
        }
            break;
        case 1:
        {
            height=55*2;
        }
            break;
        case 2:
        {
            height = 55;
        }
            break;
        case 3:
        case 4:
        {
             height= 55*4;
        }
            break;
        case 5:
        {
            height= 55*2;
        }
            break;
        case 6:
        {
            height= 55*9;
        }
            break;
        case 7:
        {
            height= 55*5;
        }
            break;
        default:
        {
            height= 55;
        }
            break;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * arr =@[@"到价提醒",@"价格异动",@"主力大单",@"技术信号",@"涨跌停",@"相似K线",@"盘后监控",@"重要公告"];
    NSArray * arr2 =@[@1,@2,@2,@2,@2,@2,@2,@0];
    DYSZ_MessageTypeHeadView * headerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DYSZ_MessageTypeHeadView"];
    headerView.messageTypeHeadViewDelegate=self;
    [headerView setSection:section withType:[arr2[section] integerValue]];
    [headerView setHeaderText:arr[section]];
    [headerView setSwitchIsOnWithBt:_settingModel.modelArray[section].bt];
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(weakSelf);
   
    DYAdvancedModel * model  =_settingModel.modelArray[indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            [_priceRuleViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
                
             _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

            }];
            return _priceRuleViewCell;
           
        }
            break;
        case 1:
        {
            [_priceShakeViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
               _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

            }];
            return _priceShakeViewCell;
        }
            break;
        case 2:
        {
            [_bigDealViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
               _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

                
            }];
            return _bigDealViewCell;
        }
            break;
        case 3:
        {
            [_techSignalViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
               _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

                
            }];
            return _techSignalViewCell;
        }
            break;
        case 4:
        {
            [_limitMoveViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
               _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

                
            }];
            return _limitMoveViewCell;
        }
            break;
        case 5:
        {
            [_similarKViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
                _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

            }];
            return _similarKViewCell;
        }
            break;
        case 6:
        {
            [_multiDaysViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
                _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

            }];
            return _multiDaysViewCell;
        }
            break;
        case 7:
        {
            [_importantAnnViewCell configCellWithBt:model.bt sct:model.sct withDataBlock:^(id data) {
                _settingModel.modelArray[indexPath.section].bt =data;
                [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }];
            return _importantAnnViewCell;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}
#pragma mark--messageTypeHeadViewDelegate
//目前没有考虑首位0的用途，暂时全部替换
-(void)clickSwitchisOn:(BOOL)isOn section:(NSInteger)section{
    
     NSString * str = _settingModel.modelArray[section].bt;
    if (isOn) {
       
        str =[str stringByReplacingOccurrencesOfString:@"0" withString:@"1"];
    }else{
        str =[str stringByReplacingOccurrencesOfString:@"1" withString:@"0"];
    }
    _settingModel.modelArray[section].bt =str;

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)clickSettingBtn{
    
    DYPriceRulesPageViewController * vc =[[DYPriceRulesPageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickInfoBtnWithSection:(NSInteger)section btn:(UIButton *)btn{
    DYExplainHelper *helper = [[DYExplainHelper alloc]init];
    DYExplainModel *model = [self modelWithSection:section];
    [helper showAtView:btn dirct:NO withModel:model];
}


-(DYExplainModel *)modelWithSection:(NSInteger)section{
    DYExplainModel *model = [[DYExplainModel alloc]init];
    
    NSArray *keys;
    NSArray *values;
    
    switch (section) {
        case 1:{
            model.title = @"价格异动";
             keys = @[@"快速拉升：",@"火箭发射：",@"快速下跌：",@"直线暴跌："];
             values = @[@"个股5分钟涨速达到3%",@"个股5分钟涨速达到5%",@"个股5分钟跌速达到3%",@"个股5分钟跌速达到5%"];
        }
            break;
        case 2:{
            model.title = @"主力大单";
            model.content = @"单笔成交金额达到500万";
        }
            break;
        case 3:{
            model.title = @"技术信号";
            keys = @[@"KDJ金叉：",@"KDJ死叉：",@"MACD金叉：",@"MACD死叉：",@"突破上轨：",@"突破5日均线：",@"Boll开口变大："];
            values = @[@"KDJ指标出现金叉，K线突破D线",@"KDJ指标发生死叉，K线下穿D线",@"MACD指标发生金叉，短期均线DIF突破长期均线DEA",@"MACD指标发生死叉，短期均线DIF下穿长期均线DEA",@"Boll指标盘中突破上轨,上涨信号",@"股价突破5日均线",@"上涨趋势中BOLL线开头变大，上涨信号"];
        }
            break;
        case 4:{
            model.title = @"涨跌停";
            keys = @[@"封板量下降："];
            values = @[@"涨跌停之后，封板量持续下降，比最高封板量下降80%，开板概率较高"];
        }
            break;
        case 5:{
            model.title = @"相似K线";
            model.content = @"对于相似度80%以上的个股，未来20日预期收益率达到15%以上";
        }
            break;
        case 6:{
            model.title = @"盘后监控";
            model.content = @"针对特别关注个股形成一份盘后监控总结，在收盘之后一次推送";
        }
            break;
            
        default:
            break;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i =0; i<keys.count; i++) {
        NSString *keystr = keys[i];
        NSString *valueStr = values[i];
        DYExplainSubModel *subModel = [[DYExplainSubModel alloc] init];
        subModel.keyStr = keystr;
        subModel.valueStr = valueStr;
        [array addObject:subModel];
    }
    model.itemsArray = [array copy];
    
    return model;
}


@end
