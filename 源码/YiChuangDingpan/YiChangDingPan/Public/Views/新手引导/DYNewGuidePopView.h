//
//  DYNewGuidePopView.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/12/29.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYPopview.h"

@interface DYNewGuidePopView : DYPopview

- (id)initWithSender:(id)sender withDirection:(TriangleDirection)dirct;
//设置文字
- (void)setContentText:(NSString *)str;
//页面结束回调
- (void)completeBlock:(DataBlock)block;

@end
