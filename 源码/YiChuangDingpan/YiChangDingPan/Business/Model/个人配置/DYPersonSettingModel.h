//
//  DYAdvancedModel.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYAdvancedModel : NSObject<NSMutableCopying,NSCopying>
@property(nonatomic,copy)NSString * sct; // 二级分类
@property(nonatomic,copy)NSString * ct;  // 一级分类
@property(nonatomic,copy)NSString * bt;  // 011具体设置项
@property(nonatomic,copy)NSString * s;   //  状态, 0: 未启用, 1: 启用

@end

@interface DYPersonSettingModel : NSObject<YYModel,NSMutableCopying,NSCopying>
@property(nonatomic,strong)NSMutableArray *industryArray;//行业类型
@property(nonatomic,assign)NSInteger category;//股票类型
@property(nonatomic,assign)NSInteger s;//#0-非首次访问, 1-首次访问
@property(nonatomic,strong)NSMutableArray<DYAdvancedModel*>*modelArray;//消息类型
@end

