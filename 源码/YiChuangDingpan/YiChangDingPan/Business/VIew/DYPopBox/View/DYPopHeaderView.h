//
//  DYPopHeaderView.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYDropDownBox.h"


@class DYPopHeaderView,DYItem;

@protocol DYPopHeaderViewDataSource <NSObject>
@required;
- (NSUInteger)numberOfColumnsIncomBoBoxView :(DYPopHeaderView *)comBoBoxView;
- (DYItem *)comBoBoxView:(DYPopHeaderView *)comBoBoxView infomationForColumn:(NSUInteger)column;

@end

@protocol DYPopHeaderViewDelegate <NSObject>
@optional
- (void)comBoBoxView:(DYPopHeaderView *)comBoBoxView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index;

- (void)pushToSetViewController;
@end

@interface DYPopHeaderView : UIView

@property (nonatomic, weak) id<DYPopHeaderViewDataSource> dataSource;
@property (nonatomic, weak) id<DYPopHeaderViewDelegate> delegate;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong) NSMutableArray <DYDropDownBox *> *dropDownBoxArray;

- (void)reload;
- (void)dimissPopView;

@end
