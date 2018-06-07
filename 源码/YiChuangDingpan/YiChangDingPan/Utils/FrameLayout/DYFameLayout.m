//
//  DYFameLayout.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/3/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYFameLayout.h"

@implementation DYFameLayout
void setSizeHeight(UIView* view,CGFloat height)
{
    CGSize size = CGSizeMake([view frame].size.width, height);
    setSize(view,size);
}
void setSize(UIView * view,CGSize size)
{
    CGRect frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height);
    [view setFrame:frame];
}
@end
