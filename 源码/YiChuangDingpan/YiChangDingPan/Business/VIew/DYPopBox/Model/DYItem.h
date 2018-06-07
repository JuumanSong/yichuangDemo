//
//  DYItem.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DYItemMarkType) {  //选中的状态
    DYItemMarkTypeeSelected = 0,      //可以选中
    DYItemMarkTypeUnselected = 1,    //不可以选中
};
typedef NS_ENUM(NSUInteger, DYItemMarkTypeViewDisplayType) {  //分辨弹出来的view类型
    DYItemMarkTypeViewDisplayTypeNormal = 0,                //默认
    DYItemMarkTypeViewDisplayTypeindustry = 1,                 // 行业板块
    DYItemMarkTypeViewDisplayTypeMessage = 2            //消息类型
};

@interface DYItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *industryId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray <DYItem *>*childrenNodes;
@property (nonatomic,assign) DYItemMarkType markType;
@property (nonatomic,assign) DYItemMarkTypeViewDisplayType displayType;

@property (nonatomic,assign) CGFloat height;
// 消息类型
@property (nonatomic,copy) NSString *leftImg;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign) BOOL isMsgSelect;

+ (instancetype)itemWithItemType:(DYItemMarkTypeViewDisplayType)type
                       titleName:(NSString *)title
                      industryId:(NSString *)ID;

+ (instancetype)itemWithItemType:(DYItemMarkType)type
                       titleName:(NSString *)title
                         leftImg:(NSString *)leftImg
                          detail:(NSString *)detail;


@end
