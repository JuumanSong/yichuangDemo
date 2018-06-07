//
//  DYViewController.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/3/30.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYNavTitleView.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Toast.h"

extern NSString * const kAlicloudFeedbackAppKey;
extern NSString * const kAlicloudFeedbackAppSecret;

@class BCFeedbackKit;
/**
 自定义导航栏的VC基类
 */
@interface DYViewController : UIViewController
//是否是第一次加载页面
@property (nonatomic,assign) BOOL isFirstTimeAppear;
//当前是否可见的
@property (nonatomic)BOOL isVisible;
//导航栏
@property (nonatomic,strong)DYNavTitleView *dyNavTitleView;
//mainView相当于self.view
@property (nonatomic,strong)UIView *mainView;

@property (nonatomic, strong) BCFeedbackKit *feedbackKit;
/**
 隐藏导航栏

 @param hide BooL
 */
-(void)setDyNavTitleViewHide:(BOOL)hide;

/**
 设置导航栏文字

 @param title 文字
 */
- (void)setNavTitleText:(NSString *)title;

- (NSString *)getNavTitleText;

/**
 子类覆写（viewDidLoad会先调该方法，再调initSubViews方法）
 初始化数据
 */
- (void)initViewData;

/**
 子类覆写（viewDidLoad会先调该方法，再调initSubViews方法）
 初始化UI
 */
- (void)initSubViews;



@end
