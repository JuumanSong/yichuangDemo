//
//  DYAlertUtil.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/5.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYAlertUtil : NSObject

// 默认从中间弹框,操作按钮文字为蓝色
+ (void)dyAlertView:(NSString*)title
            message:(NSString*)message
          leftTitle:(NSString*)leftTitle
         rightTitle:(NSString*)rightTitle
            superVC:(UIViewController*)superVC
       completBlcok:(IntegerBlock)block;

/**
 系统弹框

 @param isRed action文字为红色还是蓝色
 @param style 从中间弹出 or 从底部弹出
 */
+ (void)dyAlertView:(NSString *)title
            message:(NSString *)message
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rightTitle
              isRed:(BOOL)isRed
            superVC:(UIViewController *)superVC
         alertStyle:(UIAlertControllerStyle)style
       completBlcok:(IntegerBlock)block;
@end
