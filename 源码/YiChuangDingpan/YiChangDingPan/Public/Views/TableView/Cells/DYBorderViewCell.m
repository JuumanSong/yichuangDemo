/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYBorderViewCell.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/22.
//

#import "DYBorderViewCell.h"
#import "Masonry.h"

const UIEdgeInsets kDefaultBorderInset = {0, 15, 0, 15};

@interface DYBorderBackgroundView : UIView

@property(nonatomic) DYBorderOption borderOption;
@property(nonatomic) UIEdgeInsets separatorInset;
@property(nonatomic,strong) UIColor *lineColor;
@end


@implementation DYBorderBackgroundView
- (UIColor *)lineColor
{
    if (!_lineColor) {
        _lineColor = DYAppearanceColor(@"H2", 1);
    }
    return _lineColor;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.borderOption) {
        CGContextBeginPath(context);
        CGFloat lineWidth = 0.5;
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetShouldAntialias(context, NO);
        UIColor *color = self.lineColor;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        if (self.borderOption & kDYBorderOptionTop) {
            CGContextMoveToPoint(context, self.separatorInset.left, self.separatorInset.top + lineWidth);
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - self.separatorInset.right, self.separatorInset.top +lineWidth);
        }
        else if (self.borderOption  & kDYBorderOptionTopTopNoInset){
            CGContextMoveToPoint(context, 0, self.separatorInset.top + lineWidth);
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), self.separatorInset.top +lineWidth);
        }
        
        if (self.borderOption & kDYBorderOptionBottom) {
            CGContextMoveToPoint(context, self.separatorInset.left, CGRectGetMaxY(rect) - self.separatorInset.bottom);
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - self.separatorInset.right, CGRectGetMaxY(rect) - self.separatorInset.bottom);
        }
        else if (self.borderOption  & kDYBorderOptionBottomNoInset){
            CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - self.separatorInset.bottom);
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - self.separatorInset.bottom);
        }
        if (self.borderOption & kDYBorderOptionLeft) {
            CGContextMoveToPoint(context,
                                 0,
                                 self.separatorInset.top + lineWidth);
            CGContextAddLineToPoint(context,
                                    0,
                                    CGRectGetMaxY(rect) - self.separatorInset.bottom);
        }
        if (self.borderOption & kDYBorderOptionRight) {
            CGContextMoveToPoint(context,
                                 CGRectGetMaxX(rect)-lineWidth,
                                 self.separatorInset.top + lineWidth);
            CGContextAddLineToPoint(context,
                                    CGRectGetMaxX(rect)-lineWidth,
                                    CGRectGetMaxY(rect) - self.separatorInset.bottom);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
}


@end
@implementation DYBorderViewCell

- (void)initInternal
{
    DYBorderBackgroundView *backgroundView =[[DYBorderBackgroundView alloc]initWithFrame:self.frame];
    backgroundView.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    self.backgroundView = backgroundView;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.borderInset = kDefaultBorderInset;// 设置cell的点击颜色
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = DYAppearanceColor(@"H14", 1.0);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initInternal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self initInternal];
    }
    return self;
}

- (void)setBorderOption:(DYBorderOption)borderOption
{
    if ([self.backgroundView isKindOfClass:[DYBorderBackgroundView class]]) {
        ((DYBorderBackgroundView *)self.backgroundView).borderOption = borderOption;
        [self.backgroundView setNeedsDisplay];
    }
    
}

-(void)setBorderInset:(UIEdgeInsets)borderInset
{
    if ([self.backgroundView isKindOfClass:[DYBorderBackgroundView class]]) {
        ((DYBorderBackgroundView *)self.backgroundView).separatorInset = borderInset;
        [self.backgroundView setNeedsDisplay];
    }
}
- (DYBorderOption)borderOption
{
    return ((DYBorderBackgroundView *)self.backgroundView).borderOption;
}

- (void)setLineColor:(UIColor *)lineColor
{
    if ([self.backgroundView isKindOfClass:[DYBorderBackgroundView class]]) {
        ((DYBorderBackgroundView *)self.backgroundView).lineColor = lineColor;
        [self.backgroundView setNeedsDisplay];
    }
}
- (UIColor *)lineColor
{
    return ((DYBorderBackgroundView *)self.backgroundView).lineColor;
}
- (UIEdgeInsets)borderInset
{
    return ((DYBorderBackgroundView *)self.backgroundView).separatorInset;
}


//overrde for rowHeight
+ (CGFloat)rowHeight
{
    return 44;
}


- (void)configCellWithItem:(id)item
{
    
}

+ (NSString *)cellIndentifier
{
    
    return nil;
}
+ (id)getReusableCellClass:(NSString *)className
              byIdentifier:(NSString *)identifier
              forTableView:(UITableView *)tableView {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class class = NSClassFromString(className);
        cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
