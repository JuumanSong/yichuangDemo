//
//  DYYC_PlateMoveViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/9.
//  Copyright © 2018年 datayes. All rights reserved.
//板块异动

#import "DYYC_PlateMoveViewCell.h"
#import "DYCalculateAttrilabelHeight.h"
@interface DYYC_PlateMoveViewCell()<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *upLineView;
@property (strong, nonatomic) UIImageView *circleIcon;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *downLineView;
@property (nonatomic,strong) TYAttributedLabel *attrbuteLabel;
@property (nonatomic, copy) DataBlock clickBlock;
@end

@implementation DYYC_PlateMoveViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadAttrbuteLabel];
    }
    return self;
}

- (void)loadAttrbuteLabel {
    _circleIcon =[[UIImageView alloc]init];
    [_circleIcon setImage:DY_ImgLoader(@"yc_circle", @"YiChuangLibrary")];
    [self.contentView addSubview:_circleIcon];

    _upLineView =[[UIImageView alloc]init];
    _upLineView.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    [self.contentView addSubview:_upLineView];

    _timeLabel =[[UILabel alloc]init];
    _timeLabel.textColor = DYAppearanceColorFromHex(0xA5A5A5, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];

    _downLineView=[[UIImageView alloc]init];
    _downLineView.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    [self.contentView addSubview:_downLineView];

    _attrbuteLabel = [[TYAttributedLabel alloc] init];
    
    _attrbuteLabel.font = [UIFont systemFontOfSize:14];
    _attrbuteLabel.delegate = self;
    _attrbuteLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
    _attrbuteLabel.numberOfLines = 0;
    [self.contentView addSubview:_attrbuteLabel];

    
    
    [_circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    [_upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.equalTo(_circleIcon.mas_top).offset(0);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(_circleIcon);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_circleIcon);
        make.top.equalTo(_circleIcon.mas_bottom).offset(5);
    }];
    [_downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.top.equalTo(_timeLabel.mas_bottom).offset(0);
        make.centerX.equalTo(_upLineView);
    }];
    [_attrbuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(55);
        make.right.mas_equalTo(-10);
//        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-1);
    }];
    
}

- (void)configCellShowUp:(BOOL)isShowUp
                showDown:(BOOL)isShowDown
                    time:(NSString *)time
                  detail:(NSString *)detail
            highlightArr:(NSArray *)highlightArr
             optionalArr:(NSArray *)optionalArr
              clickBlock:(DataBlock)clickBlock {

    _upLineView.hidden = isShowUp;
    _downLineView.hidden = !isShowDown;
    _timeLabel.text = time;
    if ([detail isEqualToString:@""]||!detail||[detail isKindOfClass:[NSNull class]]) {
        
        detail =@"暂时无数据显示";
    }
     _attrbuteLabel.text = detail;
//    CGFloat detailHeight =[[DYCalculateAttrilabelHeight sharedInstance]rowHeightWithDetailStr:detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
//
//    [_attrbuteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.height.mas_equalTo(detailHeight);
//    }];
    
    for (NSDictionary *sub in highlightArr) {
        [self handleAttrText:sub[@"stock"] code:sub[@"stockNum"] isOptional:NO];
    }
    
    for (NSDictionary *sub in optionalArr) {
        [self handleAttrText:sub[@"stock"] code:sub[@"stockNum"] isOptional:YES];
    }
    
    self.clickBlock = clickBlock;
}


+(CGFloat)getCellHeightWhihData:(NSString *)detail {

    CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance]rowHeightWithDetailStr:detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
    detailHeight = 10 + detailHeight ;
    
    return detailHeight>44?detailHeight:44;
}

- (void)handleAttrText:(NSString *)textStr code:(NSString *)code isOptional:(BOOL)optional {
    
    TYLinkTextStorage * textStorage = [[TYLinkTextStorage alloc]init];
    textStorage.range = [_attrbuteLabel.text rangeOfString:textStr];
    textStorage.textColor = optional ? DYAppearanceColor(@"R3", 1.0) : DYAppearanceColorFromHex(0x226DD2, 1);
    textStorage.font = [UIFont systemFontOfSize:14];
    textStorage.underLineStyle = kCTUnderlineStyleNone;
    [_attrbuteLabel addTextStorage:textStorage];
    textStorage.linkData =code;
    _attrbuteLabel.lineBreakMode = kCTLineBreakByClipping;
    _attrbuteLabel.lineBreakMode = kCTLineBreakByCharWrapping;
    
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    
  
    for (TYLinkTextStorage * storage in attributedLabel.textContainer.textStorages) {
        
        if (storage.range.length==textStorage.range.length&&storage.range.location==textStorage.range.location) {
            
              !self.clickBlock ?: self.clickBlock(storage.linkData);
            break;
        }
    }
    
}

@end
