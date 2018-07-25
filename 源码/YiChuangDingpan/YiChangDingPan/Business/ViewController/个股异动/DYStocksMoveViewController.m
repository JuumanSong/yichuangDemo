//
//  DYStocksMoveViewController.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/4.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStocksMoveViewController.h"
#import "DYAdvancedSetViewController.h"
#import "DYPopHeaderView.h"
#import "DYItem.h"
#import "DYStocksMoveViewCell.h"
#import "DYStocksMoveHeaderView.h"
#import "DYYCStocksMoveService.h"
#import "DYYCNewMsgsModel.h"
#import "UITableView+fresh.h"
#import "UIResponder+Router.h"
#import "DYWebSocketService.h"
#import "DYYC_SiftStock.h"
#import "DYYCTipViewCell.h"
#import "DYNewGuidePopView.h"
#import "DYStockCardViewController.h"

@interface DYStocksMoveViewController ()<DYPopHeaderViewDataSource,DYPopHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,DYWebSocketTargetDelegate,DYYCInterfaceDelegate>


@property (nonatomic, strong) NSMutableArray *dataArr;

//一直在改变的数据源
@property (nonatomic, strong) NSMutableArray *mListArr;

//刷新tableview所需要的数据源，每次刷新的时候从mListArr mutableCopy一份用作刷新，保证点击cell时间跳转对应的ticker
@property (nonatomic, strong) NSMutableArray *mListArrCopy;
@property (nonatomic, strong) DYPopHeaderView *comBoBoxView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSTimer * myTimer;
@property (nonatomic) BOOL isfirstTimeLoad;
@property (nonatomic,strong) DYStocksMoveHeaderView *stocksMoveHeaderView;

@end

@implementation DYStocksMoveViewController {
    NSString *_searchStockId;
}

/**
 页面消失时移除长链接
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DYWebSocketService shareInstance] disConnect];
    [_myTimer invalidate];
    _myTimer = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![DYWebSocketService shareInstance].isConnected){

        [[DYWebSocketService shareInstance] connect];
    }
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshTableView) userInfo:nil repeats:YES];
    }
//    if (_searchStockId) return;
    [self requestSettingDataList];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WS(weakSelf);
    
    NSString *data = loadFromCacheWithType(@"UserCache/YIDONG/FirstShow", JMDataTypeEnumString);
    if(!data){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(weakSelf.showYin){
                [weakSelf showGuidePopView:0];
                saveToCacheWithType(@"UserCache/YIDONG/FirstShow", @"1", JMDataTypeEnumString);
            }
            else{
                weakSelf.showYin = YES;
            }
        });
    }
}

-(void)showGuidePopView:(NSInteger)index{
    if(index == 0){
        NSArray *arr = self.comBoBoxView.dropDownBoxArray;
        if(arr.count>=4){
            DYDropDownBox *box1 = arr[2];
            DYNewGuidePopView *popView = [[DYNewGuidePopView alloc]initWithSender:box1 withDirection:1];
            [popView setContentText:@"自定义纳入监控的股票范围、行业板块，信号类型，个性化偏好设置～"];
            WS(weakSelf);
            [popView completeBlock:^(id data) {
                [weakSelf showGuidePopView:1];
            }];
            [popView showView];
        }
    }
    else if(index == 1){
        NSArray *arr = self.comBoBoxView.dropDownBoxArray;
        if(arr.count>=4){
            DYDropDownBox *box1 = arr[3];
            DYNewGuidePopView *popView = [[DYNewGuidePopView alloc]initWithSender:box1 withDirection:1];
            [popView setContentText:@"添加特别关注股票，一有异动即可进行APP消息推送；订阅更多信号类型，个性化推送～"];
            WS(weakSelf);
            [popView completeBlock:^(id data) {
                [weakSelf showGuidePopView:2];
            }];
            [popView showView];
        }
    }
    else if(index == 2){
        DYNewGuidePopView *popView = [[DYNewGuidePopView alloc]initWithSender:self.stocksMoveHeaderView.tmp withDirection:1];
        [popView setContentText:@"异动值跟具体信号相关，可能是涨跌幅，成交量等～"];
        [popView showView];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];

    _isfirstTimeLoad = YES;
    
    self.stocksMoveHeaderView = [[DY_BundleLoader(@"YiChuangLibrary") loadNibNamed:@"DYStocksMoveHeaderView" owner:nil options:nil]lastObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSettingDataList) name:@"selectSetingNote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Push_DYStareMonitorStockEditViewController) name:@"Push_DYStareMonitorStockEditViewController" object:nil];
    //建立长链接
    DYWebSocketService *service = [DYWebSocketService shareInstance];
    [service addDelegateTarget:self forType:WSSupportTypes_GPDP];
}

-(void)Push_DYStareMonitorStockEditViewController{
    
    DYAdvancedSetViewController * vc =[[DYAdvancedSetViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)initSubViews {
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 65;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DYStocksMoveViewCell" bundle:DY_BundleLoader(@"YiChuangLibrary")] forCellReuseIdentifier:DYStocksMoveViewCellId];
    [self.mainView addSubview:self.tableView];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0);
    WS(weakSelf)
    [self.tableView addFootFreshWithBlock:^{
        [weakSelf requestFooterSettingDataList];
    }];

    [self.tableView addHeadFreshWithBlock:^{
        
        [ weakSelf requestSettingDataList];
    }];
}

- (void)initViewData {
    _mListArr = [NSMutableArray array];
    self.comBoBoxView = [[DYPopHeaderView alloc] initWithFrame:CGRectMake(0, 0, DYScreenWidth, 40)];
    self.comBoBoxView.dataSource = self;
    self.comBoBoxView.delegate = self;
    self.comBoBoxView.baseView = self.mainView;
    [self.mainView addSubview:self.comBoBoxView];
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf requestSettingDataList];
    });

    [[DYYCStocksMoveService shareInstance] loadSettingMessageListBlock:^(NSArray *data) {

        [weakSelf.dataArr addObjectsFromArray:data];

        [weakSelf.comBoBoxView reload];
    }];
}


/**
 上拉加载更多
 */
- (void)requestFooterSettingDataList {
    WS(weakSelf);
    
    [[DYYCStocksMoveService shareInstance] loadNewMsgsDataOfStockId:_searchStockId isUp:NO success:^(id data,BOOL isMore) {
        
        if (data&&[data isKindOfClass:[NSArray class]]) {
            weakSelf.mListArr = [DYYCStocksMoveService shareInstance].cache;
        }
        if (isMore) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
            //没有更多数据
            [weakSelf.tableView noMoreData];
        }
        [weakSelf.tableView reloadData];
    } fail:^(id data) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

/**
 获取最新数据，请求回掉后开始推送长链接数据
 */
- (void)requestSettingDataList {
    WS(weakSelf);
    [self.tableView hasMoreData];
    
   //先不接受长链接消息，然后请求短链接
    
    [[DYYCStocksMoveService shareInstance] loadNewMsgsDataOfStockId:_searchStockId isUp:YES success:^(id data,BOOL isMore) {
        if([data isKindOfClass:[NSArray class]]){
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.mListArr = data;
            weakSelf.mListArrCopy = weakSelf.mListArr.mutableCopy;
            weakSelf.isfirstTimeLoad = NO;
            [weakSelf.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            });
        }

        
        if([DYWebSocketService shareInstance].isConnected){
            [weakSelf sendStartMessage];
        }
        else{
            [[DYWebSocketService shareInstance] connect];
        }
    } fail:^(id data) {
        weakSelf.isfirstTimeLoad = NO;
        [weakSelf.tableView.mj_header endRefreshing];
        if([DYWebSocketService shareInstance].isConnected){
            [weakSelf sendStartMessage];
        }
        else{
            [[DYWebSocketService shareInstance] connect];
        }
    }];
}

/**
 重绘
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.mainView.frame;
    CGFloat safeHeight = iPhoneX ? UIView.additionaliPhoneXBottomSafeHeight : 0;
    self.tableView.frame = CGRectMake(0, 40, rect.size.width, rect.size.height - 40 - safeHeight);

}

#pragma mark - response events

- (void)searchStockDidSelectTradeCode:(NSString *)code {
    
    if (!code.length) return;
    _searchStockId = code;
}

- (void)executeCancelFiltrateEvent {
    _searchStockId = nil;
    WS(weakSelf);

    [[DYYCStocksMoveService shareInstance] loadNewMsgsDataOfStockId:nil isUp:YES success:^(id data,BOOL isMore) {
        [weakSelf.tableView.mj_footer endRefreshing];
//        [weakSelf.mListArr removeAllObjects];
//        [weakSelf.mListArr addObjectsFromArray:data];
        weakSelf.mListArr = data;
        weakSelf.mListArrCopy=weakSelf.mListArr;
        [weakSelf.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        });
        
    } fail:^(id data) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)executeRouterEventName:(NSString *)name {
    
    [[DYYCStocksMoveService shareInstance].cache removeAllObjects];
    [self requestSettingDataList];
}
#pragma mark - DYPopHeaderViewDataSource

- (NSUInteger)numberOfColumnsIncomBoBoxView:(DYPopHeaderView *)comBoBoxView {
    return self.dataArr.count;
}

- (DYItem *)comBoBoxView:(DYPopHeaderView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.dataArr[column];
}
#pragma mark - DYPopHeaderViewDataSource

- (void)pushToSetViewController {
    DYAdvancedSetViewController *setVc = [[DYAdvancedSetViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - UITableViewDataSource,delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.stocksMoveHeaderView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return !_searchStockId ? self.mListArr.count : self.stockArr.count;
    
    return self.mListArrCopy.count == 0 ? 1 : self.mListArrCopy.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mListArrCopy.count == 0) {
        DYYCTipViewCell *cell = [DYYCTipViewCell getReusableCellClass:@"DYYCTipViewCell" byIdentifier:DYYCTipViewCellId forTableView:tableView];
        if(_isfirstTimeLoad == YES){
            [self showRoboStateTo:cell state:DYRoboViewTypeInicatorLoad];
        }
        else{
            [self showRoboStateTo:cell state:DYRoboViewTypeNoData];
        }
        return cell;
    }
    DYStocksMoveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DYStocksMoveViewCellId forIndexPath:indexPath];
    DYYCNewMsgsModel *model = self.mListArrCopy[indexPath.row];

    [cell configCellWithDict:@{
                               @"time": model.dataModel.time ?: @"-:-",
                               @"stockName": model.dataModel.sn ?: @"--",
                               @"code": model.dataModel.t ?: @"--",
                               @"msg": model.dataModel.moveMsg ?: @"--",
                               @"color": model.dataModel.f ?: @"",
                               @"value": model.dataModel.value ?: @"--",
                               }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.mListArrCopy.count == 0) return;
    DYYCNewMsgsModel *model = self.mListArrCopy[indexPath.row];
    if ([DYYCInterface shareInstance].delegate&&[[DYYCInterface shareInstance].delegate respondsToSelector:@selector(pushToStockDetailVCWithTicker:)]) {
        
        [[DYYCInterface shareInstance].delegate pushToStockDetailVCWithTicker:model.dataModel.t];

    }
}
#pragma mark - Getter

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[DYWebSocketService shareInstance] removeDelegateTarget:self forType:WSSupportTypes_GPDP];
}
#pragma mark - DYWebSocketTargetDelegate
- (void)sendStartMessage{
    NSArray *arr = @[@{@"t":@1,@"s":@1}];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[DYWebSocketService shareInstance] sendMsg:str];
}
- (void)webSocketDidConnect{
    [self sendStartMessage];
}

/**
 接受长链接消息，并对消息进行过滤

 @param message 长链接信息
 */
- (void)webSocketDidReceiveMessage:(id)message{
    NSLog(@"个股异动消息：%@",message);
    WS(weakSelf);
    DYYCNewMsgsModel * msgModel =[[DYYCNewMsgsModel alloc]init];
    DYYCNewMsgsDataModel *model =[DYYCNewMsgsDataModel yy_modelWithJSON:message];
    msgModel.dataModel = model;
    
    if (_searchStockId) {
        if ([model.t isEqualToString:_searchStockId]) {
            [weakSelf.mListArr insertObject:msgModel atIndex:0];
        }
    }
    else{
        BOOL flag = [[DYYC_SiftStock shareInstance] siftStockWithTicker:model.t sct:model.sct bt:model.bt];
        if (flag){
            [weakSelf.mListArr insertObject:msgModel atIndex:0];
        }
    }
}
#pragma mark--每两秒刷新一次tableview
-(void)refreshTableView{
    self.mListArrCopy = self.mListArr.mutableCopy;
    [self.tableView reloadData];
}

@end
