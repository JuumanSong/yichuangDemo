//
//  DYClickSegementView.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/31.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYClickLabel.h"

@class DYClickSegementView;
@protocol DYClickSegementViewDelegate<NSObject>
@optional
//选中的颜色;默认:B1
- (UIColor *)segementSelectedColorWithView:(DYClickSegementView*)view;
//选中的字体;默认:T2
- (UIFont *)segementSelectedFontWithView:(DYClickSegementView*)view;
//未选中的颜色;默认:H8
- (UIColor *)segementNomalColorWithView:(DYClickSegementView*)view;
//未选中的字体;默认:T2
- (UIFont *)segementNomalFontWithView:(DYClickSegementView*)view;
//边框颜色
- (UIColor *)segementBorderViewColorWithView:(DYClickSegementView*)view;
//数据
- (NSArray *)segementInfoArrayWithView:(DYClickSegementView*)view;
//选中的index
- (NSUInteger)segementSelectedIndexWithView:(DYClickSegementView*)view;
//点击
- (void)segementWithView:(DYClickSegementView*)view withIndex:(NSInteger)index;

@end


/**
 Segement View
 */
@interface DYClickSegementView : UIView
@property (nonatomic,weak) id<DYClickSegementViewDelegate> delegate;

- (void)reloadData;
@end
