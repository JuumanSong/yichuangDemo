//
//  DYSearchTextFieldView.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/20.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYSearchTextFieldView : UIView
@property (nonatomic, strong) UITextField *textField;

- (void)setPlaceHolder:(NSString *)p;

- (void)setLeftViewByImage:(UIImage *)image;

- (void)setPlaceHolder:(NSString *)p withColor:(UIColor *)color;

// 根据textField的背景色刷新搜索icon及右侧"叉号"icon，默认textField背景为白色
- (void)reloadTextFieldImageView:(BOOL)isWhite;

//这个方法监控tf文字改变，及return按钮
- (void)textFieldTextChange:(DataBlock)changeBlock
            withReturnBlock:(DataBlock)returnBlock;

- (void)textFieldTextChange:(DataBlock)changeBlock
            withReturnBlock:(DataBlock)returnBlock
          andBeginEditBlock:(EventCallBackWithNoParams)beginEditBlock;

@end
