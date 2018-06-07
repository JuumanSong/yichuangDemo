//
//  DYWebSocketService.h
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/4/19.
//  Copyright © 2018年 datayes. All rights reserved.
//  长连接服务

#import <Foundation/Foundation.h>
#import "DYWebSocketTargetDelegate.h"

//所有长连接服务类型
typedef enum{
    WSSupportTypes_GPDP = 1,  //股票盯盘
    WSSupportTypes_BKYD = 2,  //板块异动
} WSSupportTypes;

//断开长链接类型
typedef enum{
    disConnectByUser = 1000,   //用户主动断开
    disConnectByServer,        //服务端断开
    disConnectByGoBack,        //退到后台断开
} DDisConnectType;



@interface DYWebSocketService : NSObject

//是否是连接状态
@property (nonatomic)BOOL isConnected;
//当前所支持的类型
@property (nonatomic,strong)NSMutableArray *supportTypes;
//baseUrl
@property (nonatomic,strong)NSString *khost;
//断开类型
@property (nonatomic)DDisConnectType connectType;

//单例
+ (instancetype)shareInstance;

- (void)addDelegateTarget:(id)target forType:(WSSupportTypes)type;

- (void)removeDelegateTarget:(id)target forType:(WSSupportTypes)type;


//创建连接
- (void)connect;

//断开连接
- (void)disConnect;

//心跳
- (void)ping;

//发消息
- (void)sendMsg:(NSString *)msg;
@end



//注册接收事件的对象
@interface DYWebSocketReceiveItem : NSObject
//目标对象
@property (nonatomic,weak)id target;
//类型
@property (nonatomic)WSSupportTypes type;

@end
