//
//  DYWebSocketService.m
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/4/19.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYWebSocketService.h"
#import "SRWebSocket.h"

#define dy_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//心跳时间
#define heartInterval 180

static DYWebSocketService* webSocketService = nil;

@interface DYWebSocketService()<SRWebSocketDelegate>
{
    SRWebSocket * webSocket;
    NSTimer * heartBeat;
    NSTimeInterval reConnecTime;
}
@end

@implementation DYWebSocketService

//单例
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webSocketService = [DYWebSocketService new];
        webSocketService.khost = YCWebSocketBase;
        webSocketService.isConnected = NO;
        [webSocketService connect];
        webSocketService.supportTypes = [[NSMutableArray alloc] init];
        webSocketService.connectType = disConnectByServer;
    });
    return webSocketService;
}

//   建立连接
-(void)connect
{
    [self initSocket];
}

//   断开连接
-(void)disConnect
{
    if (webSocket) {
        self.connectType = disConnectByUser;
        [webSocket close];
        self.isConnected = NO;
        webSocket = nil;
    }
}

//  重连机制
-(void)reConnect{
    [self disConnect];
    [self connect];
}


//初始化Socket
-(void)initSocket
{
    if (webSocket) {
        return;
    }

    NSString *deviceId = [[DYYCInterface shareInstance].delegate deviceId];
    deviceId = deviceId?deviceId:@"";
    NSString *token = [[DYYCInterface shareInstance].delegate token];
    token = token?token:@"";
    NSString *userId = [[DYYCInterface shareInstance].delegate userId];
    userId = userId?userId:@"";
    
    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ws?user=%@&token=%@&opUser=%@", self.khost,deviceId,token,userId]]];

//    测试用
//    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@"ws://10.20.251.139:3001"]];
    
    webSocket.delegate = self;
    //  设置代理线程queue
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount=1;
    [webSocket setDelegateOperationQueue:queue];
    
    //  连接
    [webSocket open];
}

// 初始化心跳
-(void)initHearBeat
{
    dy_async_safe(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        heartBeat = [NSTimer timerWithTimeInterval:heartInterval target:self selector:@selector(ping) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSDefaultRunLoopMode];
    })
}

// ping
-(void)ping{
//    NSLog(@"ping");
//    [webSocket sendPing:nil];
}


// 取消心跳
-(void)destoryHeartBeat
{
    dy_async_safe(^{
        if (heartBeat) {
            [heartBeat invalidate];
            heartBeat = nil;
        }
    })
}

// 添加支持类型,设置类型的回调对象
- (void)addDelegateTarget:(id)target forType:(WSSupportTypes)type{
    BOOL hasTarget = NO;
    for (DYWebSocketReceiveItem *tmp in self.supportTypes) {
        if(tmp.target && tmp.target == target){
            hasTarget = YES;
            break;
        }
    }
    //不存在当前target
    if(!hasTarget){
        DYWebSocketReceiveItem *item = [[DYWebSocketReceiveItem alloc] init];
        item.target = target;
        item.type = type;
        [self.supportTypes addObject:item];
    }
}

- (void)removeDelegateTarget:(id)target forType:(WSSupportTypes)type{
    
    if(self.supportTypes.count>0){
        for (NSInteger i = self.supportTypes.count - 1 ; i>=0; i--) {
            DYWebSocketReceiveItem *item = self.supportTypes[i];
            if(!item.target || item.target == target){
                [self.supportTypes removeObject:item];
            }
        }
    }

}


//发消息
- (void)sendMsg:(NSString *)msg{
    dy_async_safe(^{
        if(self.isConnected){
            [webSocket send:msg];
        }
    })
}


#pragma mark - SRWebScokerDelegate
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
//    NSLog(@"服务器返回的信息:%@",message);
    NSData *JSONData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if(responseJSON){
        for (DYWebSocketReceiveItem *item in self.supportTypes) {
            if(item.target && [item.target respondsToSelector:@selector(webSocketDidReceiveMessage:)]){
                //获取消息类型
                NSNumber *type = DYJsonGet(responseJSON, @"t", @(-1));
                if([type isKindOfClass:[NSNumber class]] && [type integerValue] == item.type){
                    [item.target webSocketDidReceiveMessage:DYJsonGet(responseJSON, @"d", nil)];
                }
            }
        }
    }
}

-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"WS_连接成功");
    self.isConnected = YES;
    self.connectType = disConnectByServer;
    for (DYWebSocketReceiveItem *item in self.supportTypes) {
        if(item.target && [item.target respondsToSelector:@selector(webSocketDidConnect)]){
            [item.target webSocketDidConnect];
        }
    }
    // 连接成功 开始发送心跳
    [self initHearBeat];
}

//  open失败时调用
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"WS_连接失败");
    self.isConnected = NO;
    //  失败了去重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reConnect];
    });
}

//  网络连接中断被调用
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WS_被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    self.isConnected = NO;
    //断开连接时销毁心跳
    [self destoryHeartBeat];
    
    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    if (self.connectType == disConnectByServer) {
        [self reConnect];
    }
}

//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"WS_收到pong回调");
}

@end




@implementation DYWebSocketReceiveItem

@end
