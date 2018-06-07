//
//  DYYAxisView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYYAxisView.h"
#import "DYIndexPath.h"
#import "DYAppearance.h"

@implementation DYYAxisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTextEdgeOffset:2];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setAxisPosition:eAxisPositionLeft];
        [self setMajorScaleLength:2];
        [self setAxisWidth:1];
//        [self setShowMoreMajorText:YES];
    }
    return self;
}

- (void)reloadData
{
    if (self.isHidden) {
        return;
    }
    
    [self resetData];
    
    if (self.dataSource == nil) {
        return;
    }
    
    if (self.justShowMinAndMaxValue) {
        [self addMinOrMaxValueLabel:YES];
        [self addMinOrMaxValueLabel:NO];
    } else {
        NSInteger count = [self.dataSource numberOfScaleSections:self];
        if (self.showMoreMajorText) {
            count += 1;
        }
        if (count > 0 && count < MAX_SCALE_COUNT) {
            CGFloat yOffset = 0;
            for (int section = 0 ; section < count ; section ++) {
                NSString* sectionString = [self.dataSource scaleStringForAxisView:self atSection:section withOffset:0];
                
                if (section == 0) {
                    yOffset = self.bounds.size.height - self.offset;
                }
                else
                {
                    CGFloat distance = self.bounds.size.height/count;//[self.dataSource distanceForAxisView:self atSection:section - 1];
                    yOffset -= distance;//*self.zoomValue;
                }
                
                if (isnan(yOffset)) {
                    yOffset = 0;
                }
                
                // 文字能使用区域的宽度
                int width = self.bounds.size.width;
                int textWidth = self.bounds.size.width - self.textEdgeOffset - self.axisWidth - self.majorScaleLength;
                if ([sectionString length] > 0 && self.drawContentFlag & eDrawMajorScaleText) {
                    UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:section];
                    
                    NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
                    CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                    if (rect.size.width > textWidth) {
                        rect.size.width = textWidth;
                    }
                    // 左边Y轴
                    CGFloat startX = 0;
                    if (self.axisPosition == eAxisPositionLeft) {
                        if (self.textAlignment == NSTextAlignmentLeft) {
                            startX = width - textWidth;
                        }
                        else {
                            startX = width - rect.size.width;
                        }
                    }
                    else {
                        if (self.textAlignment == NSTextAlignmentLeft) {
                            startX = 0;
                        }
                        else {
                            startX = textWidth - rect.size.width;
                        }
                    }
                    CGRect labelRect = CGRectMake(startX, yOffset - rect.size.height/2, rect.size.width, rect.size.height);
                    
                    UILabel* sectionLabel = [[UILabel alloc] initWithFrame:labelRect];
                    sectionLabel.adjustsFontSizeToFitWidth = YES;
                    sectionLabel .minimumScaleFactor = 0.5f;
                    [sectionLabel setFont:sectionFont];
                    [sectionLabel setText:sectionString];
                    [sectionLabel setTextAlignment:self.textAlignment];
                    if (self.textBackgroundColor != nil) {
                        [sectionLabel setBackgroundColor:self.textBackgroundColor];
                    }
                    else {
                        [sectionLabel setBackgroundColor:[UIColor clearColor]];
                    }
                    [sectionLabel setTextColor:[self.dataSource colorForAxisView:self atSection:section]];
                    [sectionLabel setTag:section + 1];  // 防止tag为0，所以从1开始，因为不设置tag，tag就是0
                    [sectionLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
                    [self addSubview:sectionLabel];
                }
                
                if (section < count && self.drawContentFlag & eDrawMinorScaleText) {
                    NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                    CGFloat subYOffset = yOffset;
                    
                    for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                        DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                        subYOffset -= [self.dataSource distanceForAxisView:self atIndexPath:indexPath];
                        
                        NSString* subSectionString = [self.dataSource scaleStringForAxisView:self atIndexPath:indexPath];
                        if ([subSectionString length] > 0) {
                            UIFont* subFont = [self.dataSource fontForAxisView:self atIndexPath:indexPath];
                            NSDictionary *attributes = @{NSFontAttributeName:subFont};
                            CGRect rect = [subSectionString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                            
                            CGFloat startX = 0;
                            if (self.axisPosition == eAxisPositionLeft) {
                                if (self.textAlignment == NSTextAlignmentLeft) {
                                    startX = width - textWidth;
                                }
                                else {
                                    startX = width - rect.size.width;
                                }
                            }
                            else {
                                if (self.textAlignment == NSTextAlignmentLeft) {
                                    startX = 0;
                                }
                                else {
                                    startX = textWidth - rect.size.width;
                                }
                            }
                            CGRect labelRect = CGRectMake(startX, subYOffset - rect.size.height/2, rect.size.width, rect.size.height);
                            UILabel* subLabel = [[UILabel alloc] initWithFrame:labelRect];
                            
                            subLabel.adjustsFontSizeToFitWidth = YES;
                            subLabel .minimumScaleFactor = 0.5f;
                            [subLabel setFont:subFont];
                            [subLabel setText:subSectionString];
                            [subLabel setTextAlignment:self.textAlignment];
                            if (self.textBackgroundColor != nil) {
                                [subLabel setBackgroundColor:self.textBackgroundColor];
                            }
                            else {
                                [subLabel setBackgroundColor:[UIColor clearColor]];
                            }
                            [subLabel setTextColor:[self.dataSource colorForAxisView:self atIndexPath:indexPath]];
                            [subLabel setTag:(section + 1)*MAX_SCALE_COUNT + (subSection + 1)]; // 最小10..01
                            [subLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
                            [self addSubview:subLabel];
                        }
                    }
                }
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (void)addMinOrMaxValueLabel:(BOOL)isMinValue
{
    NSString* sectionString = nil;
    if (isMinValue) {
        if (self.axisPosition == eAxisPositionLeft) {
            sectionString = [NSString stringWithFormat:@"%.02f", [self.dataSource minValueForAxisView:self]];
        } else {
            sectionString = [NSString stringWithFormat:@"%.02f%%", [self.dataSource minValueForAxisView:self]];
        }
    }
    else {
        if (self.axisPosition == eAxisPositionLeft) {
            sectionString = [NSString stringWithFormat:@"%.02f", [self.dataSource maxValueForAxisView:self]];
        } else {
            sectionString = [NSString stringWithFormat:@"%.02f%%", [self.dataSource maxValueForAxisView:self]];
        }
    }
    
    // 文字能使用区域的宽度
    int width = self.bounds.size.width;
    if ([sectionString length] > 0 && self.drawContentFlag & eDrawMajorScaleText) {
        UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:0];
        
        NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
        CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        // 左边Y轴
        CGFloat startX = 0;
        if (self.axisPosition == eAxisPositionLeft) {
            startX = width + 3;
        }
        else {
            startX = - rect.size.width - 3 + width;
        }
        CGFloat yOffset = self.bounds.size.height - self.offset - rect.size.height - 3;
        if (!isMinValue) {
            yOffset = self.offset + 3;
        }
        CGRect labelRect = CGRectMake(startX, yOffset, rect.size.width, rect.size.height);
        
        UILabel* sectionLabel = [[UILabel alloc] initWithFrame:labelRect];
        sectionLabel.adjustsFontSizeToFitWidth = YES;
        sectionLabel .minimumScaleFactor = 0.5f;
        [sectionLabel setFont:sectionFont];
        [sectionLabel setText:sectionString];
        [sectionLabel setTextAlignment:self.textAlignment];
        if (self.textBackgroundColor != nil) {
            [sectionLabel setBackgroundColor:self.textBackgroundColor];
        }
        else {
            [sectionLabel setBackgroundColor:DYAppearanceColor(@"W1", 0.75)];
        }
        [sectionLabel setTextColor:[self.dataSource colorForAxisView:self atSection:0]];
        [sectionLabel setTag:1 + isMinValue];  // 防止tag为0，所以从1开始，因为不设置tag，tag就是0
        [sectionLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
        [self addSubview:sectionLabel];
    }
}

- (void)resetData
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.isHidden) {
        return;
    }
    
    [super drawRect:rect];
    CGRect bounds = self.bounds;
    
    // 大小刻度
    NSInteger count = [self.dataSource numberOfScaleSections:self];
    if (self.showMoreMajorText) {
        count += 1;
    }
    if (count > 0 && count < MAX_SCALE_COUNT) {
        CGFloat yOffset = 0;
        for (int section = 0 ; section < count; section ++) {
            if (section == 0) {
                yOffset = self.bounds.size.height - self.offset;
            }
            else
            {
                CGFloat distance = bounds.size.height/count;//[self.dataSource distanceForAxisView:self atSection:section - 1];
                yOffset -= distance;//*self.zoomValue;
            }
            
            if (isnan(yOffset)) {
                yOffset = 0;
            }
            
            // 画大刻度
            // 左边Y轴
            if (self.axisPosition == eAxisPositionLeft) {
                if (self.drawContentFlag & eDrawMajorScale) {
                    [self drawLineFromPoint:CGPointMake(self.axisWidth/2, yOffset)
                                    toPoint:CGPointMake(self.axisWidth/2 + self.majorScaleLength, yOffset)
                                  withColor:self.majorScaleColor andLineWidth:self.majorScaleWidth];
                }
            }
            else {
                if (self.drawContentFlag & eDrawMajorScale) {
                    [self drawLineFromPoint:CGPointMake(bounds.size.width - self.axisWidth/2 - self.majorScaleLength, yOffset)
                                    toPoint:CGPointMake(bounds.size.width - self.axisWidth/2, yOffset)
                                  withColor:self.majorScaleColor andLineWidth:self.majorScaleWidth];
                }
            }
            
            // 画小刻度
            // 左边Y轴
            if (section < count && self.drawContentFlag & eDrawMinorScale) {
                NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                CGFloat subYOffset = yOffset;
                
                for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                    subYOffset -= [self.dataSource distanceForAxisView:self atIndexPath:indexPath];
                    
                    if (self.axisPosition == eAxisPositionLeft) {
                        [self drawLineFromPoint:CGPointMake(self.axisWidth/2, subYOffset)
                                        toPoint:CGPointMake(self.axisWidth/2 + self.minorScaleLength, subYOffset)
                                      withColor:self.minorScaleColor andLineWidth:self.minorScaleWidth];
                    }
                    else {
                        [self drawLineFromPoint:CGPointMake(bounds.size.width - self.axisWidth/2 - self.minorScaleLength, subYOffset)
                                        toPoint:CGPointMake(bounds.size.width - self.axisWidth/2, subYOffset)
                                      withColor:self.minorScaleColor andLineWidth:self.minorScaleWidth];
                    }
                }
            }
        }
    }
    
    // Y轴
    if (self.drawContentFlag & eDrawAxis) {
        // 左边Y轴
        if (self.axisPosition == eAxisPositionLeft) {
            [self drawLineFromPoint:CGPointMake(0, 0)
                            toPoint:CGPointMake(0, bounds.size.height)
                          withColor:self.axisColor andLineWidth:self.axisWidth];
        }
        else {
            [self drawLineFromPoint:CGPointMake(bounds.size.width - self.axisWidth, 0)
                            toPoint:CGPointMake(bounds.size.width - self.axisWidth, bounds.size.height)
                          withColor:self.axisColor andLineWidth:self.axisWidth];
        }
    }
}

@end
