//
//  DYWebSocketTargetDelegate.h
//  YiChangDingPan
//
//  Created by 宋骁俊 on 2018/4/24.
//  Copyright © 2018年 datayes. All rights reserved.
//

#pragma mark - DYWebSocketTargetDelegate

@protocol DYWebSocketTargetDelegate <NSObject>

@optional

//当webSocket被连接上时调用
- (void)webSocketDidConnect;

//当连接失败时调用
//- (void)webSocketDidFailWithError:(NSError *)error;

//当收到消息时调用
- (void)webSocketDidReceiveMessage:(id)message;

@end
