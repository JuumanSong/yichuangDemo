//
//  DYAlertUtil.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/5.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYAlertUtil.h"

@implementation DYAlertUtil


+ (void)dyAlertView:(NSString*)title
            message:(NSString*)message
          leftTitle:(NSString*)leftTitle
         rightTitle:(NSString*)rightTitle
            superVC:(UIViewController*)superVC
       completBlcok:(IntegerBlock)block {
    
    [self dyAlertView:title
              message:message
            leftTitle:leftTitle
           rightTitle:rightTitle
                isRed:NO
              superVC:superVC
           alertStyle:UIAlertControllerStyleAlert
         completBlcok:block];
    
}

+ (void)dyAlertView:(NSString *)title
            message:(NSString *)message
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rightTitle
              isRed:(BOOL)isRed
            superVC:(UIViewController *)superVC
         alertStyle:(UIAlertControllerStyle)style
       completBlcok:(IntegerBlock)block {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message preferredStyle:style];
    if (leftTitle && leftTitle.length > 0) {
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(0);
                return ;
            }
        }];
        [alertVC addAction:leftAction];
    }
    
    if (rightTitle && rightTitle.length > 0) {
        UIAlertActionStyle actionStyle = isRed ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(1);
                return ;
            }
        }];
        [alertVC addAction:rightAction];
    }
    [superVC presentViewController:alertVC animated:YES completion:nil];
}

@end
