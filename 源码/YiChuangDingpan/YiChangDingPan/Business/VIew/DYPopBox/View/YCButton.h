//
//  YCButton.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/20.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    // 正常
    YCAlignmentStatusNormal,
    // 图标和文本位置变化
    YCAlignmentStatusLeft,// 左对齐
    YCAlignmentStatusCenter,// 居中对齐
    YCAlignmentStatusRight,// 右对齐
    YCAlignmentStatusTop,// 图标在上，文本在下(居中)
    YCAlignmentStatusBottom, // 图标在下，文本在上(居中)
}YCAlignmentStatus;

@interface YCButton : UIButton

@property (nonatomic,assign) YCAlignmentStatus status;

+ (instancetype)yc_shareButton;

@property (nonatomic, assign) BOOL yc_imageAligmentLeft; // 设置图片居前  注: 默认文字在前 图片在后

@end
