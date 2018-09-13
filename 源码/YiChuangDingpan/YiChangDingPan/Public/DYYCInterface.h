//
//  DYYCInterface.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DYYCHasLogin        ([[DYYCInterface shareInstance].delegate userId] != nil)

#define YCBaseUrlDic        ([[DYYCInterface shareInstance].delegate getBaseUrl])
#define YCWebSocketBase     YCBaseUrlDic[@"webSocketBase"]
#define YCBaseUrl           YCBaseUrlDic[@"ycBase"]

@protocol DYYCInterfaceDelegate <NSObject>

@required

//返回设备id
- (NSString *)deviceId;

//返回应用id
- (NSString *)appKey;

//返回设备类型
- (NSString *)appType;

//返回用户token
- (NSString *)token;

//返回用户id
- (NSString *)userId;



//返回用户(设备)自选股信息(沪深A股:[600001,000001])
- (NSArray *)userStockArr;

/*
 获取baseUrl
 返回格式：{webSocketBase:@"",ycBase:@""}
 webSocketBase 为长链接baseUrl
 ycBase 为http链接baseUrl
 */
- (NSDictionary *)getBaseUrl;

@optional

//沪深A股详情页跳转:(ticker:600001)
- (void)pushToStockDetailVCWithTicker:(NSString *)ticker;

@end


@interface DYYCInterface : NSObject{
    
}
@property (nonatomic,weak) id<DYYCInterfaceDelegate> delegate;

//单例
+ (instancetype)shareInstance;

//app启动调用
- (void)appStart;

//用户登录成功后调用
- (void)userChanged;

//app进入前台调用
- (void)applicationWillEnterForeground;

//app退到后台调用
- (void)applicationWillEnterBackground;

//返回监控落地页1:个股异动 2.板块异动
- (UIViewController *)dyStareStockVC:(NSInteger)tag;

//返回时时更新股票监控条view
- (UIView *)dyStocksStareBarViewWithPushBlock:(void(^)(id data))block;

//个股监控bar开始时时更新 - open：开启or关闭
- (void)stocksStareOpen:(BOOL)open target:(id)target;

//返回时时更新板块监控条view
- (UIView *)dyThemeStareBarViewWithPushBlock:(void(^)(id data))block;

//板块监控bar开始时时更新 - open：开启or关闭
- (void)themeStareOpen:(BOOL)open target:(id)target;

//获取到价提醒VC，参数：ticker：@"600105",不指定传nil
-(UIViewController *)getRulesViewControllerWithTicker:(NSString *)ticker;

//返回信号类型,盘后多日需要传nt字段
+ (NSString *)getMsgBySct:(NSString *)sct bt:(NSString *)bt otherMsg:(NSString *)msg;

@end
