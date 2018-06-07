//
//  DYPageRootViewController.h
//  IntelligenceResearchReport
//
//  Created by yun.shu on 2017/10/9.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYViewController.h"

@interface DYPageRootViewController : DYViewController

@property (nonatomic, strong) UIPageViewController *pageViewController; //pageView
@property (nonatomic, strong) NSMutableArray *viewControllers;  // subControllers
@property (nonatomic, assign) BOOL hasSpacing; //是否设置页面间距
@property (nonatomic, assign) NSInteger selectedIndex;


// 根据index改变相关组件的状态
- (void)changeStatusOfRelatedToolsWithIndex:(NSInteger)index;

// 设置手势可划
- (void)setScrollEnable:(BOOL)enable;

@end
