//
//  DYOrderButton.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
//排序状态
typedef NS_ENUM(NSInteger, DYOrderState) {
    OrderStateNormal = 0,
    OrderStateDown = 1, //降序
    OrderStateUp = 2,//升序
};

//排序按钮
@interface DYOrderButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) DYOrderState orderState;

- (void)setLabelFont:(UIFont *)font color:(UIColor *)color;
/**
 点击事件
 @param block block
 */
- (void)arrowButtonClick:(ClickBlock)block;

@end
