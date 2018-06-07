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
        _imgView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"yd_header", @"YiChuangLibrary")];
        [self addSubview:_imgView];
        _rightImgView = [[UIImageView alloc]initWithImage:DY_ImgLoader(@"stare_price_next", @"YiChuangLibrary")];
        [self addSubview:_rightImgView];
        
        UIFont *font = DYAppearanceFont(@"T1");
        if (WIDTH_EQUAL(320)) {
            font = DYAppearanceFont(@"T0");
        }
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = DYAppearanceColor(@"H9", 1);
        _nameLabel.font = DYAppearanceBoldFont(@"T1");
        _nameLabel.text = @"个股异动";
        [self addSubview:_nameLabel];
        _nameLabel.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = DYAppearanceColor(@"R3", 1);
        _timeLabel.font = font;
        _timeLabel.text = @"--";
        [self addSubview:_timeLabel];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        _content1Label = [[UILabel alloc]init];
        _content1Label.textColor = DYAppearanceColor(@"R3", 1);
        _content1Label.font = font;
        _content1Label.text = @"--";
        _content1Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content1Label];
        _content1Label.backgroundColor = [UIColor clearColor];
        
        _content2Label = [[UILabel alloc]init];
        _content2Label.textColor = DYAppearanceColor(@"R3", 1);
        _content2Label.font = font;
        _content2Label.text = @"--";
        _content2Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content2Label];
        _content2Label.backgroundColor = [UIColor clearColor];
        
        _content3Label = [[UILabel alloc]init];
        _content3Label.textColor = DYAppearanceColor(@"R3", 1);
        _content3Label.font = font;
        _content3Label.text = @"--";
        _content3Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content3Label];
        _content3Label.backgroundColor = [UIColor clearColor];
//        //首先调用一次短链接
//        [self requestSettingDataList];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat h = size.height;
    CGFloat w = size.width;
    _imgView.frame = CGRectMake(10, (h-26)/2, 27, 26);
    _rightImgView.frame = CGRectMake(w - 25, (h-12)/2, 12, 12);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+5, 0, 55, h);
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+8, 0,45, h);

    CGFloat contentW = (w - CGRectGetMaxX(_timeLabel.frame)-23)/3;
    _content1Label.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame), 0, contentW, h);
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
            self.timeLabel.text = [DYTimeTransformUtil translateToHHMMWithTime:[model.ts doubleValue]/1000];
            self.content1Label.text = model.sn;
            self.content2Label.text = model.moveMsg;
            self.content3Label.text = model.value;
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
            weakSelf.timeLabel.text = [DYTimeTransformUtil translateToHHMMWithTime:[model.dataModel.ts doubleValue]/1000];
            weakSelf.content1Label.text = model.dataModel.sn;
            weakSelf.content2Label.text = model.dataModel.moveMsg;
            weakSelf.content3Label.text = model.dataModel.value;
        }
        else{
            weakSelf.nameLabel.text = @"个股异动";
            weakSelf.timeLabel.text = @"--";
            weakSelf.content1Label.text = @"--";
            weakSelf.content2Label.text = @"--";
            weakSelf.content3Label.text = @"--";
        }
        
    } fail:^(id data) {

        
    }];
}


@end
