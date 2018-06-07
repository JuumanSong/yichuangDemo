//
//  DYTableViewController.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/10/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYTableViewController.h"

@interface DYTableViewController ()
@end

@implementation DYTableViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        _pageNow = 1;
        _pageCount = 20;
        _totalCount = INT_MAX;
        _headRefresh = YES;
        _footRefresh = YES;
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initViewData {
    [super initViewData];
    
}

- (void)initSubViews {
    [super initSubViews];
    
    _myTableView = [[UITableView alloc]initWithFrame:self.mainView.bounds style:[self tableViewStyle]];
    _myTableView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.estimateHeight) {
        _myTableView.estimatedRowHeight = 44;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
    }else {
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
    }
    //ios11自动内边距
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self setTableViewProperty];
    [self.mainView addSubview: _myTableView];
    
    WS(weakSelf);
    if (self.headRefresh) {
        [self.myTableView addHeadIcon:self.headBlack FreshWithBlock:^{
            weakSelf.pageNow = 1;
            [weakSelf requestDataInfo];
        }];
    }
    if (self.footRefresh) {
        [self.myTableView addFootFreshWithBlock:^{
            if (weakSelf.totalCount > 0
                && (weakSelf.totalCount != weakSelf.dataArray.count)) {
                [weakSelf requestDataInfo];
                
            }else {
                [weakSelf.myTableView noMoreData];
            }
        }];
    }
}

//重置pageNow
- (void)resetPageNow:(NSInteger)pageNow {
    self.pageNow = pageNow;
}

//pageNow加减
- (void)pageNowPlus:(BOOL)plus {
    if (plus) {
        self.pageNow++;
    }else {
        self.pageNow--;
    }
}

//初始化设置tableView其他属性
- (void)setTableViewProperty {
}

//初始化设置tableView类型
- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _myTableView.frame = self.mainView.bounds;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - RequestData
//请求数据
- (void)requestDataInfo {
    
}

#pragma mark - UITableViewDatasource / UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end

