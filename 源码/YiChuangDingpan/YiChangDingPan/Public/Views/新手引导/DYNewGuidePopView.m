//
//  DYNewGuidePopView.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/12/29.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYNewGuidePopView.h"

#define ViewMaxWidth     DYScreenWidth*0.7
#define PaddingLeft      15
#define PaddingTop       8
#define TextMinHeight    18
#define TextMaxWidth     DYScreenWidth*0.7-2*PaddingLeft
#define TextFont         DYAppearanceFont(@"T2")

@interface DYNewGuidePopView()<DYPopviewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, assign) TriangleDirection dirct;
@property (nonatomic, strong) DataBlock fBlock;

@end

@implementation DYNewGuidePopView


- (id)initWithSender:(id)sender withDirection:(TriangleDirection)dirct {
    self = [super initWithSender:sender];
    if (self) {
        self.dirct = dirct;
        self.delegate = self;
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = DYAppearanceColor(@"H13", 0.8);
        self.contentView.layer.cornerRadius = 4;
        self.contentView.clipsToBounds = YES;
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.textColor = DYAppearanceColor(@"W1", 1);
        self.contentLabel.font = TextFont;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setContentText:(NSString *)str {
    self.contentStr = NilToEmptyString(str);
    self.contentLabel.text = self.contentStr;
}

//页面结束回调
- (void)completeBlock:(DataBlock)block {
    self.fBlock = block;
}


#pragma delegate

//返回内容view
- (UIView *)contentViewOfDYPopview:(DYPopview *)popview {
    CGFloat textWidth,textHeight;
     textWidth = [self.contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TextFont} context:nil].size.width;
    if (textWidth > TextMaxWidth) {
        textWidth = TextMaxWidth;
          textHeight = [self.contentStr boundingRectWithSize:CGSizeMake(TextMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TextFont} context:nil].size.height;
    }else {
        textHeight = TextMinHeight;
    }
    self.contentView.frame = CGRectMake(0, 0, textWidth+2*PaddingLeft, textHeight+2*PaddingTop);
    self.contentLabel.frame = CGRectMake(PaddingLeft, PaddingTop, textWidth, textHeight);
    return self.contentView;
}

////返回内容view的origin;
//- (CGPoint)originOfContentView {
//    return CGPointMake(23, 122);
//}


/*
 *-------箭头属性---------
 */
//返回箭头方向
-(TriangleDirection)triangleViewDirection {
    return self.dirct;
}

//返回箭头颜色，默认白
-(UIColor *)colorOfTriangleView {
    return DYAppearanceColor(@"H13", 0.8);
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
    return  [UIColor clearColor];
}

//返回动画持续时间，默认0.2s
-(NSTimeInterval)animationDuration {
    return 0;
}

//页面消失后调用
- (void)viewDidClosed {
    if (self.fBlock) {
        self.fBlock(nil);
    }
}

@end
