//
//  DYMessgePopViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchBlock)(BOOL isSelect);
typedef void(^EventTouchUpBlock)(void);

static NSString *const DYMessgePopViewCellId = @"DYMessgePopViewCellIdentifier";
@interface DYMessgePopViewCell : UITableViewCell

@property (nonatomic,copy) SwitchBlock switchBlock;
@property (nonatomic,copy) EventTouchUpBlock TouchBlock;



- (void)configLeftImage:(NSString *)leftImg
                  title:(NSString *)title
                 detail:(NSString *)detail
             isSelected:(BOOL)isSelect withSwitchBlock:(SwitchBlock)switchBlock;

@end
