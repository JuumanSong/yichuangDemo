/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  UITableView+fresh.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#import "UITableView+fresh.h"

@implementation UITableView (fresh)

- (void)addHeadFreshWithBlock:(freshBlock)block{
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
}

- (void)addFootFreshWithBlock:(freshBlock)block{
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
}
- (void)noMoreData
{
    self.mj_footer.state = MJRefreshStateNoMoreData;
}

- (void)hasMoreData
{
    self.mj_footer.state = MJRefreshStateIdle;
}

- (void)endHeadFreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mj_header endRefreshing];
    });
}

- (void)endFooterFreshing{
    [self.mj_footer endRefreshing];
}

- (void)endFreshing {
    [self endHeadFreshing];
    [self endFooterFreshing];
}

@end

@implementation UITableView(NoneDataShow)

- (void)reloadWithEmpty:(BOOL)emptyFlag
         withShowString:(NSString*)string
{
    if(emptyFlag) {
         self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        CGRect rect = self.bounds;
        rect.origin.y = WIDTH_EQUAL(320) ?150:170;
        rect.size = CGSizeMake(rect.size.width, 200);
        label.text = string;
        label.numberOfLines = 2;
        label.frame = rect;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        self.tableHeaderView = label;
    } else {
         self.tableHeaderView = nil;
    }
    [self reloadData];
}

@end
@implementation UITableView(CustomGIF)

#pragma mark - head动画刷新
- (void)addHeadYanFreshWithBlock:(freshBlock)block
{
    self.mj_header = [DYCustomFreshHeader loadingYanFreshHeaderWithBolck:^{
        if (block) {
            block();
        }
    }];
}

- (void)addHeadRoboFreshWithBlock:(freshBlock)block
{
    self.mj_header = [DYCustomFreshHeader loadingRoboFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

- (void)addHeadWriteFreshWithBlock:(freshBlock)block
{
    self.mj_header = [DYCustomFreshHeader loadingWriteFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

- (void)addHeadBookFreshWithBlock:(freshBlock)block
{
    self.mj_header = [DYCustomFreshHeader loadingBookFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

- (void)addHeadIcon:(BOOL)blue FreshWithBlock:(freshBlock)block {
    self.mj_header = [DYCustomFreshHeader loadingIcon:blue FreshHeader:^{
        if (block) {
            block();
        }
    }];
}

#pragma mark - foot动画刷新
- (void)addFootYanFreshWithBlock:(freshBlock)block
{
    self.mj_footer = [DYCustomFreshFooter loadingYanFreshHeaderWithBolck:^{
        if (block) {
            block();
        }
    }];
}

- (void)addFootRoboFreshWithBlock:(freshBlock)block
{
    self.mj_footer = [DYCustomFreshFooter loadingRoboFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

- (void)addFootWriteFreshWithBlock:(freshBlock)block
{
    self.mj_footer = [DYCustomFreshFooter loadingWriteFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

- (void)addFootBookFreshWithBlock:(freshBlock)block {
    self.mj_footer = [DYCustomFreshFooter loadingBookFreshHeader:^{
        if (block) {
            block();
        }
    }];
}

@end
