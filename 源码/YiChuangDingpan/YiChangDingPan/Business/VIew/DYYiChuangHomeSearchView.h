//
//  DYYiChuangHomeSearchView.h
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

//首页筛选view
@interface DYYiChuangHomeSearchView : UIView


- (void)setContentStr:(NSString *)content;

- (void)leftClickBLock:(DataBlock)leftBlock cancelBlock:(DataBlock)cBlock;
@end
