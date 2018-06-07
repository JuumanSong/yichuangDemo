//
//  DYAppRootService.h
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/2/1.
//  Copyright © 2018年 datayes. All rights reserved.
//  APP基本方法&常量

#import <Foundation/Foundation.h>
#import "DYUserDefaultUtil.h"
//数据库搜索tag
typedef NS_ENUM(NSUInteger, DBDataSearchTag) {
    SearchWhatever = 0,             // 管他搜啥呢
    SearchAllStocksProperty,        // 获取所有股票列表
    SearchStockPropertyInfo,        // 根据关键字搜索股票列表
    FetchStockPropertyInfo,         // 指定Code列表获取股票列表
};

//通用block
typedef void(^DataBlock)(id data);
typedef void(^IntegerBlock)(NSInteger i);
typedef void(^ClickBlock)(NSInteger i,id data);
typedef void(^EventCallBackWithNoParams)(void);

//通用宏
#define NilToEmptyString(s)     ((s && [s isKindOfClass:[NSString class]] && [s length]>0) ? (s) : @"")  // nil to ""
#define NilToLineString(s)     ((s && [s isKindOfClass:[NSString class]] && [s length]>0) ? (s) : @"--")  // nil to "--"
#define WS(weakSelf)            __weak __typeof(&*self)weakSelf = self;
#define WeakObj(weakObj,obj)    __weak __typeof(&*obj)weakObj = obj;

#define DYIsKindOfDictionaryClass(obj)      (obj && [obj isKindOfClass:[NSDictionary class]])
#define DYIsKindOfArrayClass(obj)           (obj && [obj isKindOfClass:[NSArray class]])
#define DYIsKindOfNullClass(obj)            (obj && [obj isKindOfClass:[NSNull class]])
#define NilToEmptyDictionary(obj)           ((obj && [obj isKindOfClass:[NSDictionary class]])?(obj) : nil)  // nil to {}
#define NilToEmptyArray(obj)                ((obj && [obj isKindOfClass:[NSArray class]])?(obj) : nil)       // nil to []
#define NullToNil(obj)                      ((obj && [obj isKindOfClass:[NSNull class]])?nil : (obj))        // null to nil
#define DYJsonGet(o,k,d)                    ([DYAppRootService DYJsonGetObject:o keys:k defult:d])


//通用常量
//app相关
#define AppInfoDic              [DYAppRootService sharedInstance].infoDictionary
#define AppInfoByKey(key)       [[DYAppRootService sharedInstance].infoDictionary objectForKey:key]

@interface DYAppRootService : NSObject{
    
}
/*
 app基本信息:
 appBundleIdentifier
 appVersion
 appBuildNumber
 appProductId
 appChannelId
 appPromotionId
 app_id
 app_secret
 */
@property (nonatomic,strong,readonly)NSMutableDictionary *infoDictionary;

// 单例
+(instancetype)sharedInstance;

// 给app基本信息附新值
-(void)addObject:(NSData *)object forKey:(NSString *)key;

+(id)DYJsonGetObject:(id)obj keys:(NSString *)keys defult:(id)defult;

@end
