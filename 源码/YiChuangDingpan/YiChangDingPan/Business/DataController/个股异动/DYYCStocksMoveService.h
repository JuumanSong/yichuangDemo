//
//  DYYCStocksMoveService.h
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYItem.h"

@class DYItem,DYPersonSettingModel;
@interface DYYCStocksMoveService : NSObject

@property (nonatomic,strong) NSMutableArray *cache;

+ (instancetype)shareInstance;


//
- (void)loadNewMsgsDataOfStockId:(NSString *)stockId
                            isUp:(BOOL)up
                         success:(void(^)(id data,BOOL isMore))success
                            fail:(void(^)(id data))fail;


// 加载筛选列表
- (void)loadSettingMessageListBlock:(void(^)(NSArray *arr))Block;

// 根据类型返回相应的单项/多项数组
- (id)getLocalSaveSettingDataType:(DYItemMarkTypeViewDisplayType)type;

// 根据类型设置筛选项
- (DYPersonSettingModel *)setSelectSettingDataWithType:(DYItemMarkTypeViewDisplayType)type data:(id)data;
@end
