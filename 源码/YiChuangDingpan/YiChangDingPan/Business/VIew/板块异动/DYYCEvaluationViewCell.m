//
//  DYYCEvaluationViewCell.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/8.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCEvaluationViewCell.h"
#import "DYCalculateAttrilabelHeight.h"
#import "NSString+UILableAdjustment.h"
#import "YCButton.h"

@interface DYYCEvaluationViewCell()<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *upLineView;
@property (strong, nonatomic) UIImageView *circleIcon;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *downLineView;
@property (strong, nonatomic) UILabel *evaluationLabel;
@property (strong, nonatomic) UILabel *headerLabel;
@property (nonatomic,strong) TYAttributedLabel *attrbuteLabel;
@property (nonatomic,strong) TYAttributedLabel *normalLabel;
@property (nonatomic,strong) YCButton *expandButton;
@property (nonatomic, copy) DataBlock clickBlock;
@property (nonatomic, assign) NSInteger cellType;

@end

@implementation DYYCEvaluationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadContent];
    }
    return self;
}

- (void)loadContent {
    _circleIcon =[[UIImageView alloc]init];
    [_circleIcon setImage:DY_ImgLoader(@"yc_circle", @"YiChuangLibrary")];
    [self.contentView addSubview:_circleIcon];
    [_circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    
    _upLineView =[[UIImageView alloc]init];
    _upLineView.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    [self.contentView addSubview:_upLineView];
    [_upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.equalTo(_circleIcon.mas_top).offset(0);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(_circleIcon);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = DYAppearanceColorFromHex(0xA5A5A5, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_circleIcon);
        make.top.equalTo(_circleIcon.mas_bottom).offset(5);
    }];
    
    _downLineView=[[UIImageView alloc]init];
    _downLineView.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    [self.contentView addSubview:_downLineView];
    [_downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.top.equalTo(_timeLabel.mas_bottom).offset(0);
        make.centerX.equalTo(_upLineView);
    }];
    
//    _evaluationLabel = [UILabel new];
//    _evaluationLabel.font = [UIFont systemFontOfSize:14];
//    _evaluationLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
//    [self.contentView addSubview:_evaluationLabel];
//    [_evaluationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(55);
//    }];
    
    _headerLabel = [UILabel new];
    _headerLabel.numberOfLines = 0;
    _headerLabel.font = [UIFont systemFontOfSize:14];
    _headerLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
    [self.contentView addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(55);
        make.right.mas_equalTo(-10);
    }];
    
    _attrbuteLabel = [[TYAttributedLabel alloc] init];
    _attrbuteLabel.font = [UIFont systemFontOfSize:14];
    _attrbuteLabel.alpha = 0;
    _attrbuteLabel.delegate = self;
    _attrbuteLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
    _attrbuteLabel.numberOfLines = 0;
    [self.contentView addSubview:_attrbuteLabel];
    [_attrbuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(55);
        make.top.equalTo(_headerLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
    }];
    
    _normalLabel = [[TYAttributedLabel alloc] init];
    _normalLabel.font = [UIFont systemFontOfSize:14];
    _normalLabel.delegate = self;
    _normalLabel.textColor = DYAppearanceColorFromHex(0x676767, 1);
    _normalLabel.numberOfLines = 3;
    _attrbuteLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    _normalLabel.alpha = 1;
    [self.contentView addSubview:_normalLabel];
    [_normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(55);
        make.top.equalTo(_headerLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
    }];
    
    self.expandButton.alpha = 0;
    [self.contentView addSubview:self.expandButton];
    
}


- (void)configCellWithDict:(NSDictionary *)dict
                clickBlock:(DataBlock)clickBlock {
    NSNumber *up = dict[@"up"];
    NSNumber *down = dict[@"down"];
    _upLineView.hidden = up.boolValue;
    _downLineView.hidden = !down.boolValue;
    _timeLabel.text = dict[@"time"];
    _headerLabel.text = dict[@"header"];
    NSString *detail = dict[@"detail"];
    NSNumber *type = dict[@"showType"];
    NSNumber *isTip = dict[@"isTip"];
    _cellType = type.integerValue;
    
    if (!isTip.boolValue) {
        _expandButton.alpha = 1;
    }
    else {
        _expandButton.alpha = 0;
    }
    
    if (detail.length == 0) {
        _attrbuteLabel.alpha = 0;
        _normalLabel.alpha = 0;
        
    }
    else {
        if (_cellType == 1) {
            _expandButton.selected = YES;
            _normalLabel.alpha = 0;
            _attrbuteLabel.alpha = 1;
            
            _attrbuteLabel.text = detail;
            
            CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance]rowHeightWithDetailStr:detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
            
            [_attrbuteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(detailHeight);
            }];
            
            [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_attrbuteLabel.mas_bottom);
                make.right.equalTo(self.contentView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
        else {
            _expandButton.selected = NO;
            _attrbuteLabel.alpha = 0;
            _normalLabel.alpha = 1;
            
            _normalLabel.text = detail;
            
            CGFloat normalHeight = [[DYCalculateAttrilabelHeight sharedInstance]rowHeightWithDetailStr:detail width:DYScreenWidth - 55 - 10 font:14 lineNum:3];
            
            [_normalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(normalHeight);
            }];
            [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_normalLabel.mas_bottom);
                make.right.equalTo(self.contentView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
    }
    
    self.clickBlock = clickBlock;
}

+ (CGFloat)getCellHeightWhihData:(NSString *)detail {
    CGFloat height = 0;
    CGFloat topHeight = [@"早评" getStringHeightInLabSize:CGSizeMake(MAXFLOAT, MAXFLOAT) AndFont:[UIFont systemFontOfSize:14]];
    height = topHeight + 12;
    if (detail.length != 0) {
        CGFloat detailHeight = [[DYCalculateAttrilabelHeight sharedInstance] rowHeightWithDetailStr:detail width:DYScreenWidth - 55 - 10 font:14 lineNum:0];
        height += detailHeight;
    }
    height += 5;
    height = height>44?height:44;
    return height;
}

- (void)handleAttrText:(NSString *)textStr isOptional:(BOOL)optional {
    
    TYLinkTextStorage * textStorage = [[TYLinkTextStorage alloc]init];
    textStorage.range = [_attrbuteLabel.text rangeOfString:textStr];
    
    textStorage.textColor = optional ? DYAppearanceColor(@"R3", 1.0) : DYAppearanceColorFromHex(0x226DD2, 1);
    textStorage.font = [UIFont systemFontOfSize:14];
    textStorage.underLineStyle = kCTUnderlineStyleNone;
    [_attrbuteLabel addTextStorage:textStorage];
    _attrbuteLabel.lineBreakMode = kCTLineBreakByClipping;
    _attrbuteLabel.lineBreakMode = kCTLineBreakByCharWrapping;
    
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    
//    !self.clickBlock ?: self.clickBlock(nil);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter

- (YCButton *)expandButton {
    if (!_expandButton) {
        _expandButton = [YCButton yc_shareButton];
        _expandButton.yc_imageAligmentLeft = NO;
        _expandButton.status = YCAlignmentStatusRight;
        _expandButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_expandButton setTitleColor:DYAppearanceColorFromHex(0xCEA76E, 1) forState:UIControlStateNormal];
        [_expandButton setTitle:@"展开" forState:UIControlStateNormal];
        [_expandButton setTitle:@"收起" forState:UIControlStateSelected];
        [_expandButton setImage:DY_ImgLoader(@"dy_downArrow", @"YiChuangLibrary") forState:UIControlStateNormal];
        [_expandButton setImage:DY_ImgLoader(@"dy_upArrow", @"YiChuangLibrary") forState:UIControlStateSelected];
        [_expandButton addTarget:self action:@selector(expandButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandButton;
}


- (void)expandButtonAction {
    !self.clickBlock ?: self.clickBlock(nil);
}

@end
