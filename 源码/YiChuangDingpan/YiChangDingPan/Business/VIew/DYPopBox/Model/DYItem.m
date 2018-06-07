//
//  DYItem.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYItem.h"
#import "NSString+UILableAdjustment.h"

@implementation DYItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}

+ (instancetype)itemWithItemType:(DYItemMarkTypeViewDisplayType)type
                       titleName:(NSString *)title
                      industryId:(NSString *)ID {
    DYItem *item = [[[self class] alloc] init];
    
    item.displayType = type;
    item.title = title;
    item.industryId = ID;
    return item;
}

+ (instancetype)itemWithItemType:(DYItemMarkType)type
                       titleName:(NSString *)title
                         leftImg:(NSString *)leftImg
                          detail:(NSString *)detail {
    
    DYItem *item = [[[self class] alloc] init];
    item.markType = type;
    item.title = title;
    item.leftImg = leftImg;
    item.detail = detail;
    return item;
}

#pragma mark - getter
// 消息类型cell动态高度
- (CGFloat)height {
    CGFloat resultH = 0;
    // top
    CGFloat top = 18;
    // 标题
    CGFloat headerH = [_title getStringHeightInLabSize:CGSizeMake(220, MAXFLOAT) AndFont:DYAppearanceFont(@"T7")];
    
    // 详情
    CGFloat detailH = [_detail getStringHeightInLabSize:CGSizeMake(DYScreenWidth - 40 - 53, MAXFLOAT) AndFont:DYAppearanceFont(@"T3")];
    
    resultH = top + headerH + 12 + detailH + 15;
    return resultH;
}

@end
