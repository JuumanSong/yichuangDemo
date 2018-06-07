//
//  DYRoboViewHUD.m
//  RobotResearchReport
//
//  Created by 周志忠 on 2017/9/27.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYRoboViewHUD.h"
#import "Masonry.h"

@interface DYRoboViewHUD ()
@property (nonatomic, strong) DataBlock btnBlock;

@end

@implementation DYRoboViewHUD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type {
    [self showRoboStateTo:view state:type backColor:nil withBlock:nil];
}

+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)color {
    [self showRoboStateTo:view state:type backColor:color withBlock:nil];
}

+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              backColor:(UIColor *)color
              withBlock:(DataBlock)block {
    [self showRoboStateTo:view content:nil state:type backColor:color withBlock:block];
}

+ (void)showRoboStateTo:(UIView *)view
                  state:(DYRoboViewType)type
              withBlock:(DataBlock)block {
    [self showRoboStateTo:view content:nil state:type backColor:nil withBlock:block];
}

+ (void)showRoboStateTo:(UIView *)view
                content:(NSString *)content
                  state:(DYRoboViewType)type
              backColor:(UIColor *)backColor
              withBlock:(DataBlock)block {
    if (view) {
        [DYRoboViewHUD removeHUDForView:view];
        if (type != DYRoboViewTypeNormal) {
            DYRoboViewHUD *viewHUD = [[DYRoboViewHUD alloc]init];
            viewHUD.backgroundColor = backColor ? backColor : [UIColor whiteColor];
            [view addSubview:viewHUD];
            [viewHUD mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(view);
                make.size.mas_equalTo(view);
            }];
            BOOL isBlack = backColor ? YES : NO;
            
            switch (type) {
                case DYRoboViewTypeNoData:
                    [viewHUD addNoDataViewWithContent:content isBlack:isBlack];
                    break;
                case DYRoboViewTypeNoNetWork:
                    [viewHUD addNoNetWorkViewWithContent:content withBtnTitle:nil isBlack:isBlack WithBlock:nil];
                    break;
                case DYRoboViewTypeNoNetWorkCanFresh:
                    [viewHUD addNoNetWorkViewWithContent:content withBtnTitle:@"刷新" isBlack:isBlack WithBlock:block];
                    break;

                case DYRoboViewTypeIsLoading:
                    [viewHUD addIsLoadView];
                    break;
                case DYRoboViewTypeIsLoadingText:
                    [viewHUD addIsLoadTextView];
                    break;
                case DYRoboViewTypeGoSubscribe:
                    [viewHUD addSubscribeViewWithBtnTitle:@"去订阅" WithBlock:block];
                    break;
                case DYRoboViewTypeSubscribeGoLogin:
                    [viewHUD addSubscribeViewWithBtnTitle:@"去登录" WithBlock:block];
                    break;
                case DYRoboViewTypeAddView:
                    [viewHUD addViewWithContent:content withblock:block];
                    break;
                case DYRoboViewTypeInicatorLoad: {
                    UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    loadView.color = DYAppearanceColor(@"H5", 1);
                    [loadView startAnimating];
                    [viewHUD addSubview:loadView];
                    [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
                        [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.center.mas_equalTo(view);
                        }];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

+ (void)removeHUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            DYRoboViewHUD *hud = (DYRoboViewHUD *)subview;
            [hud removeFromSuperview];
        }
    }
}

- (void)addNoDataViewWithContent:(NSString *)content isBlack:(BOOL)isBlack {
    if (content.length <= 0) {
        content = @"暂无相关内容";
    }
    
    NSString *imgName = isBlack ? @"dy_img_nodata_b" : @"dy_img_nodata_w";
    
    [self addCustomWithImage:DY_ImgLoader(imgName, @"YiChuangLibrary")
                 withContent:content
                withBtnTitle:nil
                     isBlack:isBlack
                withBtnBlock:nil];
}

- (void)addNoNetWorkViewWithContent:(NSString *)content
                       withBtnTitle:(NSString *)btnTitle
                            isBlack:(BOOL)isBlack
                          WithBlock:(DataBlock)block{
    if (content.length <= 0) {
        content = @"亲~您的网络不给力喔！";
    }
    NSString *imgName = isBlack ? @"dy_img_nonet_b" : @"dy_img_nonet_w";
    [self addCustomWithImage:DY_ImgLoader(imgName, @"YiChuangLibrary")
                 withContent:content
                withBtnTitle:btnTitle
                     isBlack:isBlack
                withBtnBlock:block];
}

- (void)addIsLoadTextView {
    [self addCustomWithImage:nil
                 withContent:@"数据加载中..."
                withBtnTitle:nil
                     isBlack:NO
                withBtnBlock:nil];
}

- (void)addSubscribeViewWithBtnTitle:(NSString *)string
                           WithBlock:(DataBlock)block {
    [self addCustomWithImage:DY_ImgLoader(@"dy_img_subscribe", @"YiChuangLibrary")
                 withContent:@"更多精彩  尽在订阅"
                withBtnTitle:string
                     isBlack:NO
                withBtnBlock:block];
}

- (void)addViewWithContent:(NSString *)content
                 withblock:(DataBlock)block {
    if (content.length <= 0) {
        content = @"添加自选股";
    }
    [self addCustomWithImage:DY_ImgLoader(@"dy_img_addstock", @"YiChuangLibrary")
                 withContent:content
                withBtnTitle:nil
                     isBlack:YES
                withBtnBlock:block];
}

- (void)addCustomWithImage:(UIImage *)image
               withContent:(NSString *)content
              withBtnTitle:(NSString *)btnTitle
                   isBlack:(BOOL)isBlack
              withBtnBlock:(DataBlock)block {
    
    UILabel *label;
    if (image) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:imageView];
        int offset = -40;
        if (btnTitle) {
            offset = -80;
        }
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(offset);
        }];
        
        if (btnTitle == nil && block) {
            self.btnBlock = block;
            UIControl *control= [[UIControl alloc]init];
            [control addTarget:self action:@selector(clickRefreshDataBtn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(imageView);
                make.centerX.equalTo(self);
                make.centerY.equalTo(self.mas_centerY).offset(offset);
            }];
        }
        
        label = [[UILabel alloc]init];
        [self addSubview:label];
        label.text = content?content:@"";
        BOOL isStock = ([content rangeOfString:@"自选股"].location != NSNotFound) ? YES : NO;
        if (isStock) {
            label.textColor = DYAppearanceColor(@"B14", 1.0);
        }else {
            label.textColor = isBlack ? DYAppearanceColor(@"H19", 1.0) : DYAppearanceColor(@"H5", 1.0);
        }
        label.font = isStock ? DYAppearanceFont(@"T5") : DYAppearanceFont(@"T3");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        CGFloat laeblOffset = isStock ? 20 : 40;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(laeblOffset);
            make.centerX.equalTo(imageView);
        }];
    }else {
        label = [[UILabel alloc]init];
        [self addSubview:label];
        label.text = content?content:@"";
        label.textColor = isBlack ? DYAppearanceColor(@"H19", 1.0) : DYAppearanceColor(@"H5", 1.0);
        label.font = DYAppearanceFont(@"T3");
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(150);
        }];
    }
    if (btnTitle) {
        self.btnBlock = block;
        
        UIButton *refreshBtn = [[UIButton alloc]init];
        [self addSubview:refreshBtn];
        refreshBtn.backgroundColor = DYAppearanceColor(@"W1", 1.0);
        [refreshBtn setTitle:btnTitle forState:UIControlStateNormal];
        [refreshBtn setTitleColor:DYAppearanceColor(@"B1", 1.0) forState:UIControlStateNormal];
        refreshBtn.titleLabel.font = DYAppearanceFont(@"T3");
        refreshBtn.layer.borderWidth = 1.0;
        refreshBtn.layer.borderColor = DYAppearanceColor(@"B1", 1.0).CGColor;
        refreshBtn.layer.cornerRadius = 2;
        refreshBtn.layer.masksToBounds = YES;
        [refreshBtn addTarget:self action:@selector(clickRefreshDataBtn) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(25);
            make.centerX.equalTo(label.mas_centerX);
            make.width.equalTo(@105);
            make.height.equalTo(@31);
        }];
    }
}

- (void)clickRefreshDataBtn {
    if (self.btnBlock) {
        self.btnBlock(nil);
    }
}


- (void)addIsLoadView {
    UIImageView *roboGifImg = [[UIImageView alloc]init];
    [self addSubview:roboGifImg];
    
    NSMutableArray *roboImages = [[NSMutableArray alloc] init];
    // 循环添加图片
    for (int i = 1; i <= 7; i++) {
        NSString *tmpstr = [NSString stringWithFormat:@"loadingd%d", i];
        UIImage *image = DY_ImgLoader(tmpstr, @"YiChuangLibrary");
        [roboImages addObject:image];
    }
    roboGifImg.animationImages = roboImages;
    roboGifImg.animationDuration = 0.7; // //执行一次完整动画所需的时长
    roboGifImg.animationRepeatCount = MAXFLOAT;   // 无限循环
    [roboGifImg startAnimating];
    
    [roboGifImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-50);
        make.width.equalTo(@221);
        make.height.equalTo(@54);
    }];
}

@end


