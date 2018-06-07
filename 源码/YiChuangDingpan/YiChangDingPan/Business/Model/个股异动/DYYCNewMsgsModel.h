//
//  DYYCNewMsgsModel.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYCNewMsgsDataModel : NSObject
//时间
@property (nonatomic,copy) NSString *ts;
//个股Ticker
@property (nonatomic,copy) NSString *t;
//个股名称
@property (nonatomic,copy) NSString *sn;
//二级类型
@property (nonatomic,copy) NSString *sct;
//三级分类枚举值
@property (nonatomic,copy) NSString *bt;
//红绿标志, 1:标红, 0:中性, -1:标绿
@property (nonatomic,copy) NSString *f;
//异动指
@property (nonatomic,copy) NSString *v;

@property (nonatomic,copy) NSString *value;
//盘后多日信号专属字段
@property (nonatomic,copy) NSString *nt;
@property (nonatomic,copy) NSString *n;
@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *moveMsg;

// 数字超过1万，显示单位"xx万"；超过1亿，显示单位"xx亿"
+ (NSString *)convertToNumber:(float)number withUnit:(BOOL)unit;

@end
@interface DYYCNewMsgsModel : NSObject<YYModel>
@property (nonatomic,copy) NSString *l;
@property (nonatomic,copy) NSString *stockId;
@property (nonatomic,copy) NSString *cardType;
@property (nonatomic,copy) NSString *subCardType;
@property (nonatomic,copy) NSString *baseType;
@property (nonatomic,copy) NSString *ts;
@property (nonatomic,copy) NSString *data;

@property (nonatomic,strong) DYYCNewMsgsDataModel*dataModel;


@end

