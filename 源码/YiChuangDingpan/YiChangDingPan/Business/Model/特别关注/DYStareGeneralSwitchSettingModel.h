//
//  DYStareGeneralSwitchSettingModel.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/3/15.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
// 智能盯盘通用开关设置Model
@interface DYStareGeneralSwitchSettingModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *contentTitle;
@property (nonatomic, copy) NSString *leftImg;
@property (nonatomic,assign) BOOL switchFlag;

@property (nonatomic, assign) int cardType;     //卡片一级分类
@property (nonatomic, assign) int subCardType;  //卡片二级分类
@end
