//
//  DYBasePopupView.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYItem.h"
NS_ASSUME_NONNULL_BEGIN
@protocol DYBasePopupViewDelegate;
typedef void(^SelectedBlock)(void);
@interface DYBasePopupView : UIView

@property (nonatomic, assign) CGRect sourceFrame;                                       /* tapBar的frame**/
@property (nonatomic, strong) UIView *shadowView;                                       /* 遮罩层**/
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *subTableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;                            /* 记录所选的item**/
@property (nonatomic, strong) NSArray *temporaryArray;                                  /* 暂存最初的状态**/
@property (nonatomic,strong) NSArray *itemArr;
@property (nonatomic, assign) CGFloat orginX;
@property (nonatomic, assign) CGFloat sizeW;

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,copy) SelectedBlock selectBlock;

@property (nonatomic, weak) id<DYBasePopupViewDelegate> delegate;
+ (DYBasePopupView *)getSubPopupView:(DYItem *)item;
- (id)initWithItem:(NSArray *)itemArr type:(DYItemMarkTypeViewDisplayType)type;

- (void)popupViewFromSourceFrame:(CGRect)frame superView:(UIView *)superView completion:(void (^ __nullable)(void))completion;
- (void)dismiss;
- (void)dismissWithOutAnimation;

@end

@protocol DYBasePopupViewDelegate <NSObject>
@optional
- (void)popupView:(DYBasePopupView *)popupView didSelectedItem:(NSArray *)item;
- (void)popupView:(DYBasePopupView *)popupView didSelected:(BOOL)isSelected;
@required
- (void)popupViewWillDismiss:(DYBasePopupView *)popupView;
@end

NS_ASSUME_NONNULL_END
