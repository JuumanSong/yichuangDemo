//
//  DYSZ_MessageTypeHeadView.h
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DYSZ_MessageTypeHeadViewDelegate<NSObject>
-(void)clickSwitchisOn:(BOOL)isOn section:(NSInteger)section;
-(void)clickSettingBtn;
@end
@interface DYSZ_MessageTypeHeadView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<DYSZ_MessageTypeHeadViewDelegate>messageTypeHeadViewDelegate;
@property(nonatomic,assign)NSInteger section;
- (void)setHeaderText:(NSString *)text;
- (void)setSwitchIsOnWithBt:(NSString*)bt;
@end
