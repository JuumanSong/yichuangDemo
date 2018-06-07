//
//  DYTableViewController.h
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/10/11.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYViewController.h"
#import "UITableView+fresh.h"

/**
 基本的带tableView的VC
 */
@interface DYTableViewController : DYViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;//UI
@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, assign) NSInteger totalCount; //总个数
//需要在initViewData方法中修改
@property (nonatomic, assign) NSInteger pageNow; //当前页数 （默认1）
@property (nonatomic, assign) NSInteger pageCount; //请求个数 （默认20）
@property (nonatomic, assign) BOOL headRefresh; //default YES
@property (nonatomic, assign) BOOL footRefresh; //default YES
@property (nonatomic, assign) BOOL estimateHeight;//是否为自动估计高度 //default NO
@property (nonatomic, assign) BOOL headBlack; //default NO

//重置pageNow
- (void)resetPageNow:(NSInteger)pageNow;
//pageNow加减
- (void)pageNowPlus:(BOOL)plus;

//重写的方法，可选
//初始化设置tableView其他属性
- (void)setTableViewProperty;
//初始化设置tableView类型
- (UITableViewStyle)tableViewStyle;

//请求数据
- (void)requestDataInfo;

@end
