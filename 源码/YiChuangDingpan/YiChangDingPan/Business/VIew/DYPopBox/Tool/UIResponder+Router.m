//
//  UIResponder+Router.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/4/27.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)executeRouterEventName:(NSString *)name {
    
    [self.nextResponder executeRouterEventName:name];
    
}

@end
