//
//  DYPageRootViewController.m
//  IntelligenceResearchReport
//
//  Created by yun.shu on 2017/10/9.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYPageRootViewController.h"

@interface DYPageRootViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation DYPageRootViewController


- (NSMutableArray *)viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc]init];
    }
    return _viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initSubViews {
    [super initSubViews];
    
    // 设置转换页面风格／设置滚动方向／设置页面间距
    NSDictionary *dict = @{UIPageViewControllerOptionInterPageSpacingKey: @(20)};
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:self.hasSpacing ? dict : nil];
    _pageViewController.view.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    if (_viewControllers.count > 0) {
        NSArray *viewControllers = [NSArray arrayWithObject:[_viewControllers objectAtIndex:0]];
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    
    // 添加子控制器和子控制器视图
    [self addChildViewController:_pageViewController];
    [self.mainView addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    // 设置手势识别
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pageViewController.view.frame = self.mainView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setScrollEnable:(BOOL)enable{
    for(UIView* view in self.pageViewController.view.subviews){
        if([view isKindOfClass:UIScrollView.class]){
            [(UIScrollView *)view setScrollEnabled:enable];
        }
    }
}

#pragma mark - PageViewController DataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index -= 1;
    return [self.viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if ((index == self.viewControllers.count-1) || (index == NSNotFound)) {
        return nil;
    }
    index++;
    return [self.viewControllers objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(finished){
        UIViewController *curViewController = pageViewController.viewControllers[0];
        UIViewController *preViewController = previousViewControllers[0];
        NSInteger index = -1;
        if(curViewController != preViewController){
            for (int i = 0; i < self.viewControllers.count; i++) {
                UIViewController *vc = self.viewControllers[i];
                if (curViewController == vc) {
                    index = i;
                    break;
                }
            }
            if(index >= 0){
                [self changeStatusOfRelatedToolsWithIndex:index];
            }
        }
    }
}

// 根据index改变相关组件的状态
- (void)changeStatusOfRelatedToolsWithIndex:(NSInteger)index {
    
}

@end
