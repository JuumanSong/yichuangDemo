//
//  DYSearchView.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/20.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYSearchTextFieldView.h"
//搜索导航栏
@interface DYSearchView : UIView
//左边按钮
@property (nonatomic, strong) UIButton *leftBtn;
//中间输入框
@property (nonatomic, strong) DYSearchTextFieldView *tfView;
//右边按钮
@property (nonatomic, strong) UIButton *rightBtn;
//底部线
@property (nonatomic,strong) UIView *bottomLine;
//是否显示左边按钮
@property (nonatomic, assign) BOOL showLeft;
//是否有导航栏高度，默认有
@property (nonatomic, assign) BOOL statusBarHide;



//设置右边按钮文字及可点击
- (void)setRightBtnText:(NSString *)text
             withEnable:(BOOL)enable;
//获取输入框文字
- (NSString *)getTextInputStr;
//获取输入框
- (UITextField *)searchTextField;
//设置输入框文字
- (void)setTextFieldContent:(NSString *)content;
//输入框是否响应；YES：键盘响应;NO；不响应
- (void)firstResponder:(BOOL)resign;

// 设置textField是否为白色，默认白色
- (void)setTextFieldIsWhite:(BOOL)isWhite;

@end
