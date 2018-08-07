//
//  DYYCStockBarIndexView.m
//  YiChangDingPan
//
//  Created by 宋骁俊 on 2018/5/7.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCStockBarIndexView.h"
#import "DYWebSocketService.h"
#import "DYTimeTransformUtil.h"
#import "DYYCNewMsgsModel.h"
#import "DYYCStocksMoveService.h"
#import "DYYC_SiftStock.h"
#import "DYYCInterface.h"

@interface DYYCStockBarIndexView()<DYWebSocketTargetDelegate>

@end

@implementation DYYCStockBarIndexView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = frame;
    if (rect.size.width < 320) {
        rect.size.width = 320;
    }
    if (rect.size.height <35) {
        rect.size.height =35;
    }
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = DYAppearanceColor(@"W1", 1);
        
        _nameLabelBack = [[UIView alloc] init];
        _nameLabelBack.backgroundColor = DYAppearanceColorFromHex(0x67B1F8, 1);
        [self addSubview:_nameLabelBack];
        
        _rightImgView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"stare_price_next", @"YiChuangLibrary")];
        [self addSubview:_rightImgView];
        
        UIFont *font = DYAppearanceFont(@"T1");
        if (WIDTH_EQUAL(320)) {
            font = DYAppearanceFont(@"T0");
        }
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = DYAppearanceColor(@"W1", 1);
        _nameLabel.font = DYAppearanceBoldFont(@"T1");
        _nameLabel.text = @"个股异动";
        [self addSubview:_nameLabel];
        _nameLabel.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = DYAppearanceColor(@"H9", 1);
        _timeLabel.font = font;
        _timeLabel.text = @"--";
        [self addSubview:_timeLabel];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        _content1Label = [[UILabel alloc]init];
        _content1Label.textColor = DYAppearanceColor(@"H9", 1);
        _content1Label.font = font;
        _content1Label.text = @"--";
        _content1Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content1Label];
        _content1Label.backgroundColor = [UIColor clearColor];
        
        _tickerNameBtn = [[UIButton alloc] init];
        [_tickerNameBtn addTarget:self action:@selector(tickerNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _tickerNameBtn.backgroundColor =  [UIColor clearColor];
        [self addSubview:_tickerNameBtn];
        
        _content2Label = [[UILabel alloc]init];
        _content2Label.textColor = DYAppearanceColor(@"H9", 1);
        _content2Label.font = font;
        _content2Label.text = @"--";
        _content2Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content2Label];
        _content2Label.backgroundColor = [UIColor clearColor];
        
        _content3Label = [[UILabel alloc]init];
        _content3Label.textColor = DYAppearanceColor(@"H9", 1);
        _content3Label.font = font;
        _content3Label.text = @"--";
        _content3Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content3Label];
        _content3Label.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat h = size.height;
    CGFloat w = size.width;
    
    
    _rightImgView.frame = CGRectMake(w - 25, (h-12)/2, 12, 12);
    
    _nameLabelBack.frame =  CGRectMake(0, 5, 65, h-10);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_nameLabelBack.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake((h-10)/2, (h-10)/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _nameLabelBack.bounds;
    maskLayer.path = maskPath.CGPath;
    _nameLabelBack.layer.mask = maskLayer;
    
    
    _nameLabel.frame = CGRectMake(5, 0, 55, h);
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+15, 0,45, h);

    CGFloat contentW = (w - CGRectGetMaxX(_timeLabel.frame)-23)/3;
    _content1Label.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame), 0, contentW, h);
    _tickerNameBtn.frame = _content1Label.frame;
    _content2Label.frame = CGRectMake(CGRectGetMaxX(_content1Label.frame), 0, contentW, h);
    _content3Label.frame = CGRectMake(CGRectGetMaxX(_content2Label.frame), 0, contentW, h);
}



- (void)sendStartMessage{
    NSArray *arr = @[@{@"t":@1,@"s":@1}];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[DYWebSocketService shareInstance] sendMsg:str];
}
//当webSocket被连接上时调用
- (void)webSocketDidConnect {
    [self sendStartMessage];
}

//当收到消息时调用
- (void)webSocketDidReceiveMessage:(id)message{
    NSDictionary *dic = message;
    if (NilToEmptyDictionary(dic)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DYYCNewMsgsDataModel *model =[DYYCNewMsgsDataModel yy_modelWithJSON:message];
            BOOL flag = [[DYYC_SiftStock shareInstance] siftStockWithTicker:model.t sct:model.sct bt:model.bt];
            if (flag){
                [self setViewWithModel:model];
            }
        });
    }
}

/**
 首先调用一次短链接
 */
- (void)requestSettingDataList {
    WS(weakSelf);
    [[DYYCStocksMoveService shareInstance] loadNewMsgsDataOfStockId:nil isUp:YES success:^(id data,BOOL isMore) {
        if ([data isKindOfClass:[NSArray class]] && [(NSArray *)data count]>0) {
            DYYCNewMsgsModel * model =[(NSArray*)data firstObject];
            [weakSelf setViewWithModel:model.dataModel];
        }
        else{
            weakSelf.nameLabel.text = @"个股异动";
            weakSelf.timeLabel.text = @"--";
            weakSelf.content1Label.text = @"--";
            weakSelf.content2Label.text = @"--";
            weakSelf.content3Label.text = @"--";
            weakSelf.timeLabel.textColor = DYAppearanceColor(@"H9", 1);
            weakSelf.content1Label.textColor = DYAppearanceColor(@"H9", 1);
            weakSelf.content2Label.textColor = DYAppearanceColor(@"H9", 1);
            weakSelf.content3Label.textColor = DYAppearanceColor(@"H9", 1);
            weakSelf.ticker = nil;
        }
        
    } fail:^(id data) {

        
    }];
}


-(void)setViewWithModel:(DYYCNewMsgsDataModel *)dataModel{
    self.timeLabel.text = [DYTimeTransformUtil translateToHHMMWithTime:[dataModel.ts doubleValue]/1000];
    self.content1Label.text = dataModel.sn;
    self.content2Label.text = dataModel.moveMsg;
    self.content3Label.text = dataModel.value;
    
    if(dataModel.t && dataModel.t.length>0){
        self.ticker = dataModel.t;
    }
    else{
        self.ticker = nil;
    }
    
    NSString *f = dataModel.f;
    if([@"1" isEqualToString: f]){
        self.timeLabel.textColor = DYAppearanceColor(@"R3", 1);
        self.content1Label.textColor = DYAppearanceColor(@"R3", 1);
        self.content2Label.textColor = DYAppearanceColor(@"R3", 1);
        self.content3Label.textColor = DYAppearanceColor(@"R3", 1);
    }
    else if([@"-1" isEqualToString: f]){
        self.timeLabel.textColor = DYAppearanceColor(@"G1", 1);
        self.content1Label.textColor = DYAppearanceColor(@"G1", 1);
        self.content2Label.textColor = DYAppearanceColor(@"G1", 1);
        self.content3Label.textColor = DYAppearanceColor(@"G1", 1);
    }
    else{
        self.timeLabel.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
        self.content1Label.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
        self.content2Label.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
        self.content3Label.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
    }
}


-(void)tickerNameBtnClick{
    if(self.ticker){
        if ([DYYCInterface shareInstance].delegate&&[[DYYCInterface shareInstance].delegate respondsToSelector:@selector(pushToStockDetailVCWithTicker:)]) {
            [[DYYCInterface shareInstance].delegate pushToStockDetailVCWithTicker:self.ticker];
        }
    }
}

@end
