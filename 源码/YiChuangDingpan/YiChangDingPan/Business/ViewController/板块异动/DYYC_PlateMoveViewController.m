//
//  DYYC_PlateMoveViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/9.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_PlateMoveViewController.h"
#import "DYYC_PlateMoveViewCell.h"
#import "DYTimeTransformUtil.h"
#import "DYYC_SubHeaderView.h"
#import "DYYC_PlateMoveService.h"
#import "DYYC_AreaShakeModel.h"
#import "DYDYMarketForecastChartController.h"
#import "DYStockMarketService.h"
#import "DYYC_PlateTypeViewCell.h"
#import "NSString+NumberFormat.h"
#import "DYYCEvaluationViewCell.h"

@interface DYYC_PlateMoveViewController ()

@property (nonatomic,strong)NSMutableArray<DYYC_AreaShakeModel*>*modelArray;
@property (nonatomic,strong)DYDYMarketForecastChartController*timeVC;
@property (nonatomic,strong)UIView * chartView;

@property (nonatomic,strong)DYMarketForecastChartModel * chartModel;
@property (nonatomic,strong)DYTimeSharePointModel * pointModel;
@property (strong, nonatomic) NSTimer *myTimer;//定时器
@property (nonatomic,strong) DYYC_PlateMoveService *service;

@end

@implementation DYYC_PlateMoveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开启定时器
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    }
//    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //关闭定时器
    [_myTimer invalidate];
    _myTimer = nil;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

-(void)dealloc {

}

-(void)refreshData{
    //每5秒刷新异动信息
    [self requestNewDataInfo];
    //每5秒刷新分时图
    [self requestHeadDataInfo];
}

- (void)initViewData {
    [super initViewData];
    self.headRefresh=NO;
    self.footRefresh=NO;
    _modelArray =[[NSMutableArray alloc]init];
    _chartModel =[[DYMarketForecastChartModel alloc]init];
    [self requestHeadDataInfo];
    [self requestNewDataInfo];
    
}

-(void)initSubViews {
    [super initSubViews];
    self.service = [[DYYC_PlateMoveService alloc] init];
    [self initTimeShareView];
    self.mainView.backgroundColor = DYAppearanceColor(@"H1", 1);
    self.myTableView.backgroundColor = DYAppearanceColorFromHex(0xF4F5F9, 1);
    [self.myTableView registerClass:[DYYC_PlateMoveViewCell class] forCellReuseIdentifier:DYYC_PlateMoveViewCellId];
    [self.myTableView registerClass:[DYYC_PlateTypeViewCell class] forCellReuseIdentifier:DYYC_PlateTypeViewCellId];
    [self.myTableView registerClass:[DYYCEvaluationViewCell class] forCellReuseIdentifier:DYYCEvaluationViewCellId];
}

-(void)initTimeShareView {
    self.timeVC = [[DYDYMarketForecastChartController alloc]init];
    [self addChildViewController:self.timeVC];
    _chartView =[[UIView alloc]init];
    _chartView.backgroundColor = DYAppearanceColor(@"W1", 1);
    [self.mainView addSubview:_chartView];
    [_chartView addSubview:self.timeVC.view];
    WS(weakSelf)
    [self.timeVC tipClickBlock:^(id data) {
        DYMarketForecastPointModel *tipModel = data;
        for (NSInteger i = 0; i <weakSelf.modelArray.count; i++) {
            DYYC_AreaShakeModel *model = weakSelf.modelArray[i];
            if(model.data.ts == tipModel.timestamp && [NilToEmptyString(model.data.a) isEqualToString:tipModel.content]) {
                [weakSelf.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame =self.myTableView.frame;
    frame.origin.y  = 200;
    CGFloat safeHeight = DYISVirtualHome ? UIView.additionaliPhoneXBottomSafeHeight : 0;
    frame.size.height -=200 + safeHeight;
    self.myTableView.frame =frame;
    _chartView.frame = CGRectMake(0, 0, DYSelfViewWidth, 190);
    _timeVC.view.frame = CGRectMake(5, 8, DYSelfViewWidth-10, 182);
}

/**
 请求分时图数据
 */
-(void)requestHeadDataInfo{
    WS(weakSelf);
    [DYYC_PlateMoveService getIdxMktPriceGraphWithSecId:nil success:^(id data) {
        
        if ([data isKindOfClass:[NSDictionary class]]&&[data[@"priceNodeList"]isKindOfClass:[NSArray class]]) {
            
            NSArray * array = data[@"priceNodeList"];
            NSMutableArray * pointArray =[[NSMutableArray alloc]init];
            for (id obj in array) {
                weakSelf.pointModel =[[DYTimeSharePointModel alloc]init];
                weakSelf.pointModel.barTime =[DYTimeTransformUtil translateToHHMMWithTime:[[obj objectForKey:@"t"]longLongValue]/1000];
                weakSelf.pointModel.closePrice = [[obj objectForKey:@"p"]floatValue];
                [pointArray addObject:_pointModel];
            }
            DYTimeShareModel * timeShareModel =[[DYTimeShareModel alloc]init];
            timeShareModel.pointsArray = pointArray;
            
            NSDictionary *preModel =data[@"rtBean"];
            
            timeShareModel.lowPrice = [DYJsonGet(preModel, @"low", @0.0) floatValue];
            timeShareModel.highPrice = [DYJsonGet(preModel, @"high", @0.0) floatValue];
            timeShareModel.prevClosePrice = [DYJsonGet(preModel, @"prev", @0.0) floatValue];
            
//            if(NilToEmptyDictionary(preModel)) {
//                if(preModel[@"low"]) {
//                    timeShareModel.lowPrice = [preModel[@"low"] floatValue];
//                }
//                if(preModel[@"high"]) {
//                    timeShareModel.highPrice= [preModel[@"high"] floatValue];
//                }
//                if(preModel[@"high"]) {
//                    timeShareModel.prevClosePrice= [preModel[@"prev"] floatValue];
//                }
//            }
            
            weakSelf.chartModel.timeShareModel = timeShareModel;
            [weakSelf.timeVC setChartData:_chartModel];
        }
        
    } fail:^(id data) {
        
    }];
}
/**
 
 由于dict中的data不是字典类型的，不能直接使用yymoel去深层次转换
 */
-(void)requestNewDataInfo{
    WS(weakSelf);
    [DYYC_PlateMoveService getNewAreaMsgsWithLastId:0 success:^(id data) {
        if ([data isKindOfClass:[NSArray class]]) {
            [weakSelf.modelArray removeAllObjects];
            [weakSelf.modelArray addObjectsFromArray:data];
            NSMutableArray * tipArray = [[NSMutableArray alloc]init];
            NSMutableArray * tipDateArray = [[NSMutableArray alloc]init];
            for (DYYC_AreaShakeModel *sModel in weakSelf.modelArray) {
                for (NSString *code in weakSelf.service.expandDict) {
                    if ([code isEqualToString:sModel.lastId]) {
                        sModel.data.showType = DYYCPlateMoveShowTypeExpand;
                        break;
                    }
                }
                if (![tipDateArray containsObject:[NSString stringWithFormat:@"%ld",sModel.data.ts/60000]]) {
                    if (sModel.subCardType && ([sModel.subCardType isEqualToString:@"19"] ||[sModel.subCardType isEqualToString:@"20"] || [sModel.subCardType isEqualToString:@"21"])) {
                        continue;
                    }
                    DYMarketForecastPointModel *tipModel =[[DYMarketForecastPointModel alloc]init];
                    tipModel.barTime =[DYTimeTransformUtil translateToHHMMWithTime:sModel.data.ts/1000];
                    tipModel.timestamp = sModel.data.ts;
                    tipModel.content = NilToEmptyString(sModel.data.a);
                    [tipArray addObject:tipModel];
                }
            }
            weakSelf.chartModel.tipModelArr = tipArray;
            if (weakSelf.chartModel.timeShareModel.pointsArray.count >0) {
                [weakSelf.timeVC setChartData:_chartModel];
            }
            
            [weakSelf.myTableView reloadData];
        }
    } fail:^(id data) {
        
        
    }];
}

#pragma mark--tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.modelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DYYC_AreaShakeModel *model = (DYYC_AreaShakeModel *)_modelArray[indexPath.row];
//    if (model.data.type == DYYCPlateMoveTypeTheme) {
//        return [DYYC_PlateTypeViewCell getCellHeightWhihData:model.data.detail];
//    }
//    else if (model.data.type == DYYCPlateMoveTypeDefult) {
//        return [DYYC_PlateMoveViewCell getCellHeightWhihData:model.data.detail];
//    }
//    return  [DYYCEvaluationViewCell getCellHeightWhihData:model.data.detail];
    return _modelArray[indexPath.row].data.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[DY_BundleLoader(@"YiChuangLibrary") loadNibNamed:@"DYYC_SubHeaderView" owner:nil options:nil]lastObject];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WS(weakSelf);
    BOOL showUp = (0 == indexPath.row ? YES : NO);
    
    BOOL showDown = (indexPath.row == self.modelArray.count-1  ? NO : YES);
    DYYC_AreaShakeModel *model = _modelArray[indexPath.row];
    
    if (model.data.type == DYYCPlateMoveTypeTheme) {
        NSString *typeStr = model.subCardType.integerValue == 7 ? @"板块拉升" : @"板块跳水";
        DYYC_PlateTypeViewCell *cell = [DYYC_PlateTypeViewCell getReusableCellClass:@"DYYC_PlateTypeViewCell" byIdentifier:DYYC_PlateTypeViewCellId forTableView:tableView];
        NSString *realCp = [[NSString convertToNumber:model.data.cp * 100 withUnit:NO] stringByAppendingString:@"%"];
        [cell configCellWithDict:@{
                                   @"up": @(showUp),
                                   @"down": @(showDown),
                                   @"time": model.data.dateStr ?: @"-:-",
                                   @"theme": model.data.a,
                                   @"f": model.data.f,
                                   @"cp": realCp,
                                   @"type":typeStr,
                                   @"detail": model.data.detail,
                                   @"showType": @(model.data.showType),
                                   @"isTip": @(model.data.isTip)
                                   }
                      clickBlock:^(id data) {
                          if (model.data.showType == DYYCPlateMoveShowTypeDefult) {
                              model.data.showType = DYYCPlateMoveShowTypeExpand;
                              [self.service.expandDict setValue:model.lastId forKey:model.lastId ?: @""];
                          }
                          else {
                              [weakSelf.service.expandDict removeObjectForKey:model.lastId ?: @""];
                              model.data.showType = DYYCPlateMoveShowTypeDefult;
                          }
                          
                          [weakSelf.myTableView reloadData];
                      }];
        return cell;
    }
    else if (model.data.type == DYYCPlateMoveTypeDefult){
        
        DYYC_PlateMoveViewCell *cell =[DYYC_PlateMoveViewCell getReusableCellClass:@"DYYC_PlateMoveViewCell" byIdentifier:DYYC_PlateMoveViewCellId forTableView:tableView];
        
        [cell configCellShowUp:showUp
                      showDown:showDown
                          time:_modelArray[indexPath.row].data.dateStr
                        detail:_modelArray[indexPath.row].data.detail
                  highlightArr:_modelArray[indexPath.row].data.highlightArr
                   optionalArr:_modelArray[indexPath.row].data.optionalArr
                    clickBlock:^(id data) {
                        
                        if ([DYYCInterface shareInstance].delegate&&[[DYYCInterface shareInstance].delegate respondsToSelector:@selector(pushToStockDetailVCWithTicker:)]) {
                            
                            [[DYYCInterface shareInstance].delegate pushToStockDetailVCWithTicker:data];
                        }
                    }];
        
        return cell;
    }
    else {
        NSString *typeStr;
        switch (model.subCardType.integerValue) {
            case 19:
            {
                typeStr = @"早评";
            }
                break;
            case 20:
            {
                typeStr = @"午评";
            }
                break;
            default:
                typeStr = @"收评";
                break;
        }

        DYYCEvaluationViewCell *cell = [DYYCEvaluationViewCell getReusableCellClass:@"DYYCEvaluationViewCell" byIdentifier:DYYCEvaluationViewCellId forTableView:tableView];
        [cell configCellWithDict:@{
                                   @"up": @(showUp),
                                   @"down": @(showDown),
                                   @"time": model.data.dateStr ?: @"-:-",
                                   @"type": typeStr,
                                   @"header": model.data.a ?: @"",
                                   @"detail": model.data.detail ?: @"",
                                   @"showType": @(model.data.showType),
                                   @"isTip": @(model.data.isTip)
                                   }
                      clickBlock:^(id data) {
                          if (model.data.showType == DYYCPlateMoveShowTypeDefult) {
                              model.data.showType = DYYCPlateMoveShowTypeExpand;
                              [self.service.expandDict setValue:model.lastId forKey:model.lastId ?: @""];
                          }
                          else {
                              [weakSelf.service.expandDict removeObjectForKey:model.lastId ?: @""];
                              model.data.showType = DYYCPlateMoveShowTypeDefult;
                          }
                          
                          [weakSelf.myTableView reloadData];
                      }];

        return cell;

    }
    
}

@end

