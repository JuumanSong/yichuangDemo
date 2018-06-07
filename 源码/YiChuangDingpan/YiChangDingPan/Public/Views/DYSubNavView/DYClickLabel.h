//
//  DYClickLabel.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/12/13.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 可以点击的Label
 */
@interface DYClickLabel : UILabel

/**
 点击事件回调

 @param block 传当前label对象
 */
- (void)clickLabelBlock:(DataBlock)block;
@end
