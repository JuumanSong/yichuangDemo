//
//  DYPopViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^EditEventTouchUpBlock)(void);

@class DYItem;
static NSString *const DYPopViewCellId = @"DYPopViewCellIdentifier";
@interface DYPopViewCell : UICollectionViewCell

@property (nonatomic,strong)  DYItem *item;
//@property (nonatomic,assign) EditEventTouchUpBlock EditBlock;

- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect;

@end
