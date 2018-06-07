//
//  DYYC_PlateMoveEnterView.m
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/5/7.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYC_PlateMoveEnterView.h"
#import "DYStockMarketService.h"
#import "DYYC_PlateMoveService.h"
#import "DYYC_AreaShakeModel.h"
#import "DYTimeTransformUtil.h"
#import "DYResourceLoader.h"

@interface DYYC_PlateMoveEnterView()


@property (strong, nonatomic) NSTimer *myTimer;//定时器
@property (nonatomic, assign) BOOL firstRequest;

@end

@implementation DYYC_PlateMoveEnterView

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
        _nameLabel.font = DYAppearanceFont(@"T1");
        _nameLabel.text = @"板块异动";
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = DYAppearanceColor(@"R3", 1);
        _timeLabel.font = font;
        _timeLabel.text = @"--";
        [self addSubview:_timeLabel];
        
        _content1Label = [[UILabel alloc]init];
        _content1Label.textColor = DYAppearanceColor(@"R3", 1);
        _content1Label.font = font;
        _content1Label.text = @"--";
        _content1Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content1Label];
        
        _content2Label = [[UILabel alloc]init];
        _content2Label.textColor = DYAppearanceColor(@"R3", 1);
        _content2Label.font = font;
        _content2Label.text = @"--";
        _content2Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_content2Label];
     
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        //开启定时器
        [_myTimer setFireDate:[NSDate distantFuture]];
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat h = size.height;
    CGFloat w = size.width;
    _imgView.frame = CGRectMake(10, (h-26)/2, 27, 26);
    _rightImgView.frame = CGRectMake(w - 27, (h-12)/2, 12, 12);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+5, 0, 55, h);
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+8, 0,45, h);

    CGFloat contentW = (w - CGRectGetMaxX(_timeLabel.frame) - 35)/2;
    _content1Label.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+3, 0, contentW, h);
    _content2Label.frame = CGRectMake(CGRectGetMaxX(_content1Label.frame)+3, 0, contentW, h);
}


-(void)refreshData {
    
    if (!self.firstRequest || [DYStockMarketService checkIsMarketTime]) {
        //每5秒刷新异动信息
        WS(weakSelf);
        [DYYC_PlateMoveService getNewAreaMsgsWithLastId:1 success:^(id data) {
            if ([data isKindOfClass:[NSArray class]]) {
                NSArray *array = data;
                if (array.count >0) {
                    DYYC_AreaShakeModel *sModel = array.firstObject;
                    if (sModel && sModel.data) {
                        weakSelf.timeLabel.text = [DYTimeTransformUtil translateToHHMMWithTime:sModel.data.ts/1000];
                        weakSelf.content1Label.text = sModel.data.a;
                        weakSelf.content2Label.text = [self getSubCardStrByType:[sModel.subCardType integerValue]];
                    }
                }
            }
            weakSelf.firstRequest = YES;
        } fail:^(id data) {
        }];
    }
}


- (NSString *)getSubCardStrByType:(NSInteger)type {
    switch (type) {
        case 7:
            return @"板块拉升";
            break;
        case 13:
            return @"板块跳水";
            break;
        case 17:
            return @"板块走强";
            break;
        case 18:
            return @"板块走弱";
            break;
        case 19:
            return @"早评";
            break;
        case 20:
            return @"午评";
            break;
        case 21:
            return @"收评";
            break;
        default:
            break;
    }
    return @"--";
}

- (void)dealloc {
    [self.myTimer invalidate];
    self.myTimer = nil;
}

- (void)themeStareOpen:(BOOL)open {
    if (_myTimer) {
        if (open) {
            [_myTimer setFireDate:[NSDate distantPast]];
        }else {
            [_myTimer setFireDate:[NSDate distantFuture]];
        }
    }
}

@end
