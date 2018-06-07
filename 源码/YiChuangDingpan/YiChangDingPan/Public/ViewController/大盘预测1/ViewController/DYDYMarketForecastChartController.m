//
//  DYDYMarketForecastChartController.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/4/27.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYDYMarketForecastChartController.h"
#import "DYMFChartView.h"
#import "DYMarketForecastChartAdapter.h"
#import "DYMFXAxisFootView.h"

@interface DYDYMarketForecastChartController ()
@property (nonatomic, strong) DYMFChartView *chartView;
@property (nonatomic, strong) DYMarketForecastChartAdapter *adapter;
@property (nonatomic, strong) DYMFXAxisFootView *footView;
@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftBottomLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBottomLabel;
@end

@implementation DYDYMarketForecastChartController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSubViews {
    [super initSubViews];
    [self setDyNavTitleViewHide:YES];
    self.chartView = [[DYMFChartView alloc]init];
    self.adapter = [[DYMarketForecastChartAdapter alloc]initWithChartView:self.chartView];
    [self.mainView addSubview:self.chartView];
    
    _footView = [[DY_BundleLoader(@"YiChuangLibrary") loadNibNamed:@"DYMFXAxisFootView" owner:nil options:nil]lastObject];
    [self.mainView addSubview:_footView];
    
    [self initLabel];
}


- (void)initLabel {
    self.leftTopLabel = [[UILabel alloc]init];
    self.leftTopLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTopLabel.font = DYAppearanceFont(@"T15");
    self.leftTopLabel.textColor = DYAppearanceColor(@"R3", 1);
    self.leftTopLabel.text = @"--";
    [self.chartView addSubview:self.leftTopLabel];
    
    self.leftBottomLabel = [[UILabel alloc]init];
    self.leftBottomLabel.textAlignment = NSTextAlignmentLeft;
    self.leftBottomLabel.font = DYAppearanceFont(@"T15");
    self.leftBottomLabel.textColor = DYAppearanceColor(@"G3", 1);
    self.leftBottomLabel.text = @"--";
    [self.chartView addSubview:self.leftBottomLabel];
    
    self.rightTopLabel = [[UILabel alloc]init];
    self.rightTopLabel.textAlignment = NSTextAlignmentRight;
    self.rightTopLabel.font = DYAppearanceFont(@"T15");
    self.rightTopLabel.textColor = DYAppearanceColor(@"R3", 1);
    self.rightTopLabel.text = @"--";
    [self.view addSubview:self.rightTopLabel];
    
    self.rightBottomLabel = [[UILabel alloc]init];
    self.rightBottomLabel.textAlignment = NSTextAlignmentRight;
    self.rightBottomLabel.font = DYAppearanceFont(@"T15");
    self.rightBottomLabel.textColor = DYAppearanceColor(@"G3", 1);
    self.rightBottomLabel.text = @"--";
    [self.view addSubview:self.rightBottomLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chartView.frame = CGRectMake(0, 0, DYSelfViewWidth, CGRectGetHeight(self.view.frame)-14);
    _footView.frame = CGRectMake(0, CGRectGetMaxY(self.chartView.frame), DYSelfViewWidth, 14);
    _leftTopLabel.frame = CGRectMake(13, 5, 45, 12);
    _leftBottomLabel.frame = CGRectMake(13, CGRectGetMaxY(self.chartView.frame)-15, 45, 12);
    _rightTopLabel.frame = CGRectMake(CGRectGetWidth(self.chartView.frame)-57, 5, 45, 12);
    _rightBottomLabel.frame = CGRectMake(CGRectGetWidth(self.chartView.frame)-57, CGRectGetMaxY(self.chartView.frame)-15, 45, 12);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

- (void)setChartData:(DYMarketForecastChartModel*)fenshiModel {
    if (fenshiModel) {
        CGFloat maxGap =0;
        if (fenshiModel.timeShareModel.highPrice >0 && fenshiModel.timeShareModel.lowPrice >0) {
            maxGap = MAX(fabs(fenshiModel.timeShareModel.highPrice - fenshiModel.timeShareModel.prevClosePrice), fabs(fenshiModel.timeShareModel.lowPrice - fenshiModel.timeShareModel.prevClosePrice));
        }
        CGFloat preClose = fenshiModel.timeShareModel.prevClosePrice;
        if (maxGap >0 && preClose>0) {
            self.leftTopLabel.text = [NSString stringWithPriceDigit2:preClose +maxGap];
            self.leftBottomLabel.text = [NSString stringWithPriceDigit2:preClose - maxGap];
            self.rightTopLabel.text = [NSString stringWithPecent:(maxGap)/preClose];
            self.rightBottomLabel.text = [NSString stringWithPecent:(-maxGap)/preClose];
        }
    }
    [self.adapter setAdapterWithData:fenshiModel];
}


- (void)tipClickBlock:(DataBlock)block {
    if (block) {
        [self.adapter tipClickBlock:block];
    }
}
@end
