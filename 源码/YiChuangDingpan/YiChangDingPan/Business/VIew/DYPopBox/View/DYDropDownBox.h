//
//  DYDropDownBox.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYDropDownBoxDelegate;
@interface DYDropDownBox : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<DYDropDownBoxDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title;
- (void)updateTitleState:(BOOL)isSelected;
- (void)updateSelectState:(BOOL)isSelect;
- (void)updateTitleContent:(NSString *)title;
- (void)addBorderLineWithFillColor:(UIColor *)fillColor isSelect:(BOOL)isSelect;
- (void)reSetHeaderTitle;
@end

@protocol DYDropDownBoxDelegate <NSObject>
/*点击了dropDownBox**/
- (void)didTapDropDownBox:(DYDropDownBox *)dropDownBox atIndex:(NSUInteger)index;
@end
