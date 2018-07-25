//
//  DYExplainHelper.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYExplainHelper.h"

#import "DYPopview.h"

#define Padding       15
#define ViewMaxWidth  DYScreenWidth - 10
#define LabelMaxWidth ViewMaxWidth-2*Padding
#define TextFont      DYAppearanceFont(@"T3")

@interface DYExplainHelper()<DYPopviewDelegate>

@property (nonatomic, assign) TriangleDirection dirct;
@property (nonatomic, strong) DYExplainModel *model;

@end

@implementation DYExplainHelper

//在view显示
- (void)showAtView:(UIView *)view dirct:(NSInteger)upFlag withModel:(DYExplainModel*)model {
    self.model = model;
    DYPopview *popView = [[DYPopview alloc]initWithSender:view];
    popView.delegate = self;
    self.dirct = (TriangleDirection)upFlag;
    [popView showView];
}

//返回str的高度
- (CGFloat)getHeightByStr:(NSString *)str{
    CGFloat strHeight = [str boundingRectWithSize:CGSizeMake(LabelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TextFont} context:nil].size.height;
    return strHeight;
}

//返回str的行数
- (NSInteger)getRowsByStrHeight:(CGFloat )strHeight {
    CGFloat aHeight = [@"A" boundingRectWithSize:CGSizeMake(LabelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TextFont} context:nil].size.height;
    return (NSInteger)(strHeight/aHeight);
}

- (NSMutableAttributedString *)getSubContentByKey:(NSString *)keyStr byValue:(NSString *)valueStr {
    keyStr = NilToEmptyString(keyStr);
    valueStr = NilToEmptyString(valueStr);
    NSString *str = [NSString stringWithFormat:@"%@%@",keyStr,valueStr];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字体
    [attributedString addAttribute:NSFontAttributeName value:DYAppearanceBoldFont(@"T3") range:NSMakeRange(0, keyStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:DYAppearanceColor(@"H8", 1) range:NSMakeRange(0, str.length)];
    [attributedString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(keyStr.length, valueStr.length)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    return attributedString;
}

#pragma delegate

//返回内容view
- (UIView *)contentViewOfDYPopview:(DYPopview *)popview {
    CGFloat  contentHeight =0;
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = DYAppearanceColor(@"W1", 1);
    contentView.layer.cornerRadius = 4;
    
    if (self.model.title.length >0) {
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Padding, Padding, LabelMaxWidth, 20)];
        titleLab.textColor = DYAppearanceColor(@"H9", 1);
        titleLab.font = DYAppearanceBoldFont(@"T5");
        titleLab.text = NilToEmptyString(self.model.title);
        [contentView addSubview:titleLab];
        contentHeight = CGRectGetMaxY(titleLab.frame)+3;
    }
    
    if (self.model.content.length >0) {
        CGFloat conentH = [self getHeightByStr:self.model.content] + 10;
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(Padding, contentHeight, LabelMaxWidth, conentH)];
        contentLab.textColor = DYAppearanceColor(@"H8", 1);
        contentLab.font = DYAppearanceFont(@"T3");
        contentLab.numberOfLines = [self getRowsByStrHeight:conentH];
        [contentView addSubview:contentLab];
        contentLab.text = self.model.content;
        contentHeight = (CGRectGetMaxY(contentLab.frame)+3);
    }
    
    for (DYExplainSubModel *subModel in self.model.itemsArray) {
        CGFloat subHeight = [self getHeightByStr:[NSString stringWithFormat:@"%@%@",NilToEmptyString(subModel.keyStr),NilToEmptyString(subModel.valueStr)]] + 3;
        NSInteger row = [self getRowsByStrHeight:subHeight];
        subHeight += row*5;
        UILabel *subLab = [[UILabel alloc]initWithFrame:CGRectMake(Padding, contentHeight, LabelMaxWidth, subHeight)];
        subLab.textColor = DYAppearanceColor(@"H8", 1);
        subLab.font = DYAppearanceBoldFont(@"T3");
        subLab.text = NilToEmptyString(self.model.title);
        subLab.numberOfLines = row;
        [contentView addSubview:subLab];
        NSMutableAttributedString *str = [self getSubContentByKey:subModel.keyStr byValue:subModel.valueStr];
        [subLab setAttributedText:str];
        contentHeight = (CGRectGetMaxY(subLab.frame));
    }
    
    contentView.frame = CGRectMake(0, 0, ViewMaxWidth, contentHeight+Padding);
    
    return contentView;
}

/*
 *-------箭头属性---------
 */
//返回箭头方向
-(TriangleDirection)triangleViewDirection {
    return self.dirct;
}

//返回箭头颜色，默认白
-(UIColor *)colorOfTriangleView {
    return DYAppearanceColor(@"W1", 1);
}

//返回箭头的大小，默认CGSizeMake(10,10)
-(CGSize)sizeOfTriangleView {
    return CGSizeMake(10,7);
}

/*
 *-------背景属性---------
 */
//是否显示内容区外的背景
-(BOOL)showBackground {
    return YES;
}

//返回内容区外的背景颜色
-(UIColor *)colorOfBackground {
    return  DYAppearanceColor(@"H13", 0.6);
}

//返回动画持续时间，默认0.2s
-(NSTimeInterval)animationDuration {
    return 0.2;
}

@end

