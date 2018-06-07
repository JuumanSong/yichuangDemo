//
//  DYAdvancedModel.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//高级设置---消息类型

#import "DYPersonSettingModel.h"

@implementation DYAdvancedModel
-(id)mutableCopyWithZone:(NSZone *)zone{
    DYAdvancedModel *model = [[self class] allocWithZone:zone];
    
    model.sct =self.sct;
    model.ct =self.ct;
    model.bt= self.bt;
    model.s=self.s;
    return model;
}
-(id)copyWithZone:(NSZone *)zone{
    DYAdvancedModel *model = [[self class] allocWithZone:zone];
    
    model.sct =self.sct;
    model.ct =self.ct;
    model.bt= self.bt;
    model.s=self.s;
    return model;
}
-(NSString *)bt{
    if (!_bt) {
        
       _bt= [self returnDefaultWithSct:self.sct];
    }
    return _bt;
}

-(NSString*)returnDefaultWithSct:(NSString*)sct{
    NSDictionary * dict =@{@"1":@"011",@"4":@"011",@"3":@"011",@"11":@"01111111",@"16":@"01111111",@"6":@"0111",@"12":@"0111111111111111111",@"5":@"011111111"};
    return [dict objectForKey:sct];
}
@end
@implementation DYPersonSettingModel


-(id)mutableCopyWithZone:(NSZone *)zone{
    DYPersonSettingModel *model = [[self class] allocWithZone:zone];
    model.industryArray = [[NSMutableArray alloc] initWithArray:self.industryArray copyItems:YES];
    model.category =self.category;
    model.modelArray =[[NSMutableArray alloc]initWithArray:self.modelArray.copy copyItems:YES];
    
    return model;
}
-(id)copyWithZone:(NSZone *)zone{
    DYPersonSettingModel *model = [[self class] allocWithZone:zone];
    model.industryArray = [[NSMutableArray alloc] initWithArray:self.industryArray copyItems:YES];
    model.category =self.category;
    model.modelArray =[[NSMutableArray alloc]initWithArray:self.modelArray.copy copyItems:YES];
    
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"modelArray" : [DYAdvancedModel class]};
}
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"category":@"c",
             @"industryArray":@"i",
             @"modelArray":@"g"
             };
}
@end
