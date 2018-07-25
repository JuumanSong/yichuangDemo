//
//  DYYCInterface.m
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCInterface.h"
#import "DYAdvancedSetService.h"
#import "SEDatabase.h"
#import "DYStockPropertyService.h"
#import "DYStareOptionalMonitorSetService.h"

#import "DYStockCardViewController.h"
#import "DYWebSocketService.h"

#import "DYYCStockBarIndexView.h"
#import "DYYC_PlateMoveEnterView.h"
#import "DYYCStockHelper.h"

#import "DYPriceRulesPageViewController.h"


static DYYCInterface* instance = nil;

@interface DYYCInterface()
@property (nonatomic, strong) DataBlock plateBlock;
@property (nonatomic, strong) DataBlock stockBlock;
@end

@implementation DYYCInterface

//单例
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DYYCInterface new];
    });
    return instance;
}

-(void)appStart{
    [[SEDatabase sharedDatabase] setDbName:@"dy_dingpan.db"];
    
    //获取获取个股对应行业分类列表
    [DYStockPropertyService getNewsestStocksProperty];
    //获取个人配置
    [self requestGeneralRulesDataInfo];
    //获取盯盘列表--特别关注
     [self requestStareWizardDataInfo];
}

//用户登录成功
- (void)userHasLogin{
    
}

//app进入前台调用
- (void)applicationWillEnterForeground{
    //如果之前退到后台时断开过长链接
    if([DYWebSocketService shareInstance].connectType == disConnectByGoBack){
        [DYWebSocketService shareInstance].connectType = disConnectByServer;
        [[DYWebSocketService shareInstance] connect];
    }
}

//app退到后台调用
- (void)applicationWillEnterBackground{
    //如果长链接连着
    if([DYWebSocketService shareInstance].isConnected){
        [[DYWebSocketService shareInstance] disConnect];
        [DYWebSocketService shareInstance].connectType = disConnectByGoBack;
    }
}

//返回监控落地页
- (UIViewController *)dyStareStockVC:(NSInteger)tag{
    DYStockCardViewController * vc =[[DYStockCardViewController alloc]init];
    if (tag ==1) {
        vc.showIndex = 0;
    }else if(tag ==2){
        vc.showIndex = 1;
    }
    return vc;
}

//返回时时更新股票监控条view
- (UIView *)dyStocksStareBarViewWithPushBlock:(void(^)(id data))block {
    DYYCStockBarIndexView *ssbV = [[DYYCStockBarIndexView alloc] init];
    self.stockBlock = block;
    [ssbV addTarget:self action:@selector(stockBarClick) forControlEvents:UIControlEventTouchUpInside];
    return ssbV;
}

- (void)stockBarClick {
    if (self.stockBlock) {
        self.stockBlock(nil);
    }
}

//个股监控bar开始时时更新 - open：开启or关闭
- (void)stocksStareOpen:(BOOL)open target:(id)target{
    if(open){
        if([target isKindOfClass:[DYYCStockBarIndexView class]]){
            [(DYYCStockBarIndexView *)target requestSettingDataList];
        }
        
        //将view 加到长链接监控中
        [[DYWebSocketService shareInstance] addDelegateTarget:target forType:WSSupportTypes_GPDP];
        //如果长链接连着
        if([DYWebSocketService shareInstance].isConnected){
            //sendmsg
            NSArray *arr = @[@{@"t":@1,@"s":@1}];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[DYWebSocketService shareInstance] sendMsg:str];
        }
        else{
            [[DYWebSocketService shareInstance] connect];
        }
    }
    else{
        [[DYWebSocketService shareInstance] removeDelegateTarget:target forType:WSSupportTypes_GPDP];
        //如果长链接连着
        if([DYWebSocketService shareInstance].isConnected){
            [[DYWebSocketService shareInstance] disConnect];
        }
    }
}

//返回时时更新板块监控条view
- (UIView *)dyThemeStareBarViewWithPushBlock:(DataBlock)block {
    self.plateBlock = block;
    UIControl *control = [[DYYC_PlateMoveEnterView alloc]init];
    [control addTarget:self action:@selector(themStareClick) forControlEvents:UIControlEventTouchUpInside];
    return control;
}

- (void)themStareClick {
    if (self.plateBlock) {
        self.plateBlock(nil);
    }
}

//板块监控bar开始时时更新 - open：开启or关闭
- (void)themeStareOpen:(BOOL)open target:(id)target{
    if ([target isKindOfClass:[DYYC_PlateMoveEnterView class]]) {
        DYYC_PlateMoveEnterView * view = target;
        [view themeStareOpen:open];
    }
}

-(void)requestStareWizardDataInfo{
    [DYStareOptionalMonitorSetService getStareWizardStockListWithSuccess:^(id data) {
        
    } fail:^(id data) {
        
    }];
}
-(void)requestGeneralRulesDataInfo{
    [[DYAdvancedSetService shareInstance]getGeneralRulesWithSuccess:^(id data) {
        
    } fail:^(id data) {
        
    }];
}

-(UIViewController *)getRulesViewControllerWithTicker:(NSString *)ticker{
    DYPriceRulesPageViewController *vc = [[DYPriceRulesPageViewController alloc] init];
    if(ticker){
        DYStockPropertyItem *item = [DYStockPropertyService getPropertyItemByTicker:@"600105"];
        if(item && item.secId){
            vc.secId = item.secId;
        }
    }
    return vc;
}


//返回信号类型
+ (NSString *)getMsgBySct:(NSString *)sct bt:(NSString *)bt otherMsg:(NSString *)msg{
    if (sct.integerValue == 12) { // 盘后多日信号类型
        return msg;
    }
    else if (sct.integerValue == 5) {// 重要公告
        return @"重要公告";
    }
    else if (sct.integerValue == 6) { //相似K线
        return @"相似K线";
    }
    else {
        NSString *key = [sct stringByAppendingString:bt];
        return [[DYYCStockHelper shareInstance] getMoveMsgWithCode:key];
    }
    return nil;
}

@end
