//
//  DYXAxisView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/12/5.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYXAxisView.h"
#import "DYIndexPath.h"

@implementation DYXAxisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = NO;
        self.textTransform = 0.002;
        [self setShowMoreMajorText:NO];
        //        self.majorScaleColor = UIColorFromRGBValue(0x666666);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resetLabelPosition];
}

- (void)reloadData
{
    if (self.isHidden) {
        return;
    }
    
    [self resetData];
    
    if (self.textTransform == 0) {
        [self setNeedsDisplay];
        return;
    }
    
    if (self.dataSource == nil) {
        return;
    }

    NSInteger count = [self.dataSource numberOfScaleSections:self];
    if (self.showMoreMajorText) {
        count += 1;
    }
    
    if (count <= 0) {
        [self drawWhenOnlyOneMajorText];
    }
    
    if (count > 0 && count < MAX_SCALE_COUNT) {
        CGFloat xOffset = 0;
        NSString* preSectionString = nil;
        NSInteger positionOffset = 0;       // 用于保存位置
        BOOL positionOffsetAdded = NO;      // 位置偏移是否已经添加上
        for (NSInteger section = 0 ; section < count ; section ++) {
            NSString* sectionString = [self.dataSource scaleStringForAxisView:self atSection:section withOffset:positionOffset];
            
            if (section == 0) {
                xOffset = self.offset;
            }
            else
            {
                CGFloat distance = [self.dataSource distanceForAxisView:self atSection:section - 1];
                xOffset += distance*self.zoomValue;
                
                if ([preSectionString isEqualToString:sectionString]) {
                    continue;
                }
            }
            
            // 如果需要调整，则调整
            if (positionOffset > 0 && !positionOffsetAdded) {
                CGFloat distance = [self.dataSource distanceForAxisView:self forOffset:positionOffset];
                xOffset += distance*self.zoomValue;
                positionOffsetAdded = YES;
            }
            
            CGFloat tempOffset = [self.dataSource positionOfScaleStringForAxisView:self atSection:section withOffset:positionOffset];
            if (tempOffset > -MAXFLOAT/2) {
                xOffset = tempOffset + self.offset;
            }
            preSectionString = [sectionString copy];
            
            if ([sectionString length] > 0 && self.drawContentFlag & eDrawMajorScaleText) {
                UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:section];
                NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
                CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                CGFloat start = xOffset - rect.size.width/2;
                
                // 如果设置了自动计算文字位置，并且没有缩放，并且当前文字会画出去
                if (self.autoCalcMajorTextPosition && self.offset >= 0 && start < 0) {
                    positionOffsetAdded = NO;
                    positionOffset ++;
                    section --;
                    continue;
                }
                
//                if (start < - rect.size.width/2 + self.offset) {
//                    continue;
//                }
                
                if (![self isZoomed] && start + rect.size.width > self.bounds.size.width) {
                    continue;
                }
                
                UILabel* sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(start, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height)];
                
                [sectionLabel setFont:sectionFont];
                [sectionLabel setText:sectionString];
                [sectionLabel setTextAlignment:self.textAlignment];
                [sectionLabel setBackgroundColor:[UIColor clearColor]];
                [sectionLabel setTextColor:[self.dataSource colorForAxisView:self atSection:section]];
                [sectionLabel setTag:section + 1];  // 防止tag为0，所以从1开始，因为不设置tag，tag就是0
                [sectionLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
                [self addSubview:sectionLabel];
                UIView *bottomView = [self.dataSource bottomViewForAxisView:self atSection:section];
                if (bottomView) {
                    CGRect rect1 = sectionLabel.frame;
                    rect1.origin.x = rect1.origin.x-2;
                    rect1.origin.y = rect1.origin.y+rect1.size.height;
                    bottomView.frame = rect1;
                    [self addSubview:bottomView];
                }
            }
            
            if (section < count && self.drawContentFlag & eDrawMinorScaleText) {
                NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                CGFloat subXOffset = xOffset;
                
                for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                    subXOffset += [self.dataSource distanceForAxisView:self atIndexPath:indexPath];
                    
                    NSString* subSectionString = [self.dataSource scaleStringForAxisView:self atIndexPath:indexPath];
                    if ([subSectionString length] > 0) {
                        UIFont* subFont = [self.dataSource fontForAxisView:self atIndexPath:indexPath];
                        NSDictionary *attributes = @{NSFontAttributeName:subFont};
                        CGRect rect = [subSectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                        CGFloat x = (xOffset - rect.size.width/2)>=0?(xOffset - rect.size.width/2):0;
                        
                        UILabel* subLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height)];
                        
                        [subLabel setFont:subFont];
                        [subLabel setText:subSectionString];
                        [subLabel setTextAlignment:self.textAlignment];
                        [subLabel setBackgroundColor:[UIColor clearColor]];
                        [subLabel setTextColor:[self.dataSource colorForAxisView:self atIndexPath:indexPath]];
                        [subLabel setTag:(section + 1)*MAX_SCALE_COUNT + (subSection + 1)]; // 最小10..01
                        [subLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
                        [self addSubview:subLabel];
                    }
                }
            }
        }
        
        [self setNeedsDisplay];
    }
}

- (void)resetData
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)resetLabelPosition
{
    if (self.isHidden) {
        return;
    }
    
    if (self.textTransform == 0) {
        [self setNeedsDisplay];
        return ;
    }
    
    if (self.dataSource == nil) {
        return;
    }
    
    NSInteger count = [self.dataSource numberOfScaleSections:self];
    if (self.showMoreMajorText) {
        count += 1;
    }
    
    if (count <= 0) {
        [self drawWhenOnlyOneMajorText];
    }
    
    if (count > 0 && count < MAX_SCALE_COUNT) {
        CGFloat xOffset = 0;
        NSString* preSectionString = nil;
        NSInteger positionOffset = 0;       // 用于保存位置
        BOOL positionOffsetAdded = NO;      // 位置偏移是否已经添加上
        for (NSInteger section = 0 ; section < count ; section ++) {
            NSString* sectionString = [self.dataSource scaleStringForAxisView:self atSection:section withOffset:positionOffset];
            
            if (section == 0) {
                xOffset = self.offset;
            }
            else
            {
                CGFloat distance = [self.dataSource distanceForAxisView:self atSection:section - 1];
                xOffset += distance*self.zoomValue;
                
                if ([preSectionString isEqualToString:sectionString]) {
                    continue;
                }
            }
            
            // 如果需要调整，则调整
            if (positionOffset > 0 && !positionOffsetAdded) {
                CGFloat distance = [self.dataSource distanceForAxisView:self forOffset:positionOffset];
                xOffset += distance*self.zoomValue;
                positionOffsetAdded = YES;
            }
            
            CGFloat tempOffset = [self.dataSource positionOfScaleStringForAxisView:self atSection:section withOffset:positionOffset];
            if (tempOffset > -MAXFLOAT/2) {
                xOffset = tempOffset + self.offset;
            }
            preSectionString = [sectionString copy];
            
            if ([sectionString length] > 0 && self.drawContentFlag & eDrawMajorScaleText) {
                UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:section];
                NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
                CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                
                UILabel* sectionLabel = (UILabel*)[self viewWithTag:section + 1];
                CGFloat start = xOffset - rect.size.width/2;
                
                // 如果设置了自动计算文字位置，并且还未计算位置，并且没有缩放，并且当前文字会画出去
                if (self.autoCalcMajorTextPosition && self.offset >= 0 && start < 0) {
                    positionOffsetAdded = NO;
                    positionOffset ++;
                    section --;
                    continue;
                }
                
//                if (start < - rect.size.width/2 + self.offset) {
//                    continue;
//                }
                
                if (![self isZoomed] && start + rect.size.width > self.bounds.size.width) {
                    continue;
                }
                [sectionLabel setFrame:CGRectMake(start, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height)];
                
                [sectionLabel setFont:sectionFont];
                [sectionLabel setText:sectionString];
                [sectionLabel setTextAlignment:self.textAlignment];
                [sectionLabel setBackgroundColor:[UIColor clearColor]];
                [sectionLabel setTextColor:[self.dataSource colorForAxisView:self atSection:section]];
                [sectionLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
            }
            
            if (section < count && self.drawContentFlag & eDrawMinorScaleText) {
                NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                CGFloat subXOffset = xOffset;
                
                for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                    subXOffset += [self.dataSource distanceForAxisView:self atIndexPath:indexPath]*self.zoomValue;
                    
                    NSString* subSectionString = [self.dataSource scaleStringForAxisView:self atIndexPath:indexPath];
                    if ([subSectionString length] > 0) {
                        UIFont* subFont = [self.dataSource fontForAxisView:self atIndexPath:indexPath];
                        NSDictionary *attributes = @{NSFontAttributeName:subFont};
                        CGRect rect = [subSectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                        
                        UILabel* subLabel = (UILabel*)[self viewWithTag:(section + 1)*MAX_SCALE_COUNT + (subSection + 1)];
                        CGFloat x = (xOffset - rect.size.width/2)>=0?(xOffset - rect.size.width/2):0;
                        [subLabel setFrame:CGRectMake(x, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height)];
                        
                        [subLabel setFont:subFont];
                        [subLabel setText:subSectionString];
                        [subLabel setTextAlignment:self.textAlignment];
                        [subLabel setBackgroundColor:[UIColor clearColor]];
                        [subLabel setTextColor:[self.dataSource colorForAxisView:self atIndexPath:indexPath]];
                        [subLabel setTransform:CGAffineTransformMakeRotation(self.textTransform)];
                    }
                }
            }
        }
        
        [self setNeedsDisplay];
    }
}

- (void)drawAllTextLabels
{
    if (self.isHidden) {
        return;
    }
    
    if (self.textTransform != 0) {
        return;
    }
    
    if (self.dataSource == nil) {
        return;
    }
    
    NSInteger count = [self.dataSource numberOfScaleSections:self];
    if (self.showMoreMajorText) {
        count += 1;
    }
    
    if (count <= 0) {
        [self drawWhenOnlyOneMajorText];
    }
    
    if (count > 0 && count < MAX_SCALE_COUNT) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat xOffset = 0;
        NSString* preSectionString = nil;
        NSInteger positionOffset = 0;       // 用于保存位置
        BOOL positionOffsetAdded = NO;      // 位置偏移是否已经添加上
        for (NSInteger section = 0 ; section < count ; section ++) {
            NSString* sectionString = [self.dataSource scaleStringForAxisView:self atSection:section withOffset:positionOffset];
            
            if (section == 0) {
                xOffset = self.offset;
            }
            else
            {
                CGFloat distance = [self.dataSource distanceForAxisView:self atSection:section - 1];
                xOffset += distance*self.zoomValue;
                
                if ([preSectionString isEqualToString:sectionString]) {
                    continue;
                }
            }
            
            // 如果需要调整，则调整
            if (positionOffset > 0 && !positionOffsetAdded) {
                CGFloat distance = [self.dataSource distanceForAxisView:self forOffset:positionOffset];
                xOffset += distance*self.zoomValue;
                positionOffsetAdded = YES;
            }
            
            CGFloat tempOffset = [self.dataSource positionOfScaleStringForAxisView:self atSection:section withOffset:positionOffset];
            if (tempOffset > -MAXFLOAT/2) {
                xOffset = tempOffset + self.offset;
            }
            preSectionString = [sectionString copy];
            
            if ([sectionString length] > 0 && self.drawContentFlag & eDrawMajorScaleText) {
                UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:section];
                NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
                CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                CGContextSetFillColorWithColor(context, [[self.dataSource colorForAxisView:self atSection:section] CGColor]);
                CGFloat start = xOffset - rect.size.width/2;
                
                // 如果设置了自动计算文字位置，并且还未计算位置，并且没有缩放，并且当前文字会画出去
                if (self.autoCalcMajorTextPosition && self.offset >= 0 && start < 0) {
                    positionOffsetAdded = NO;
                    positionOffset ++;
                    section --;
                    continue;
                }
                
//                if (start < - rect.size.width/2 + self.offset) {
//                    continue;
//                }
//
                if (![self isZoomed] && start + rect.size.width > self.bounds.size.width) {
                    continue;
                }
                
                [sectionString drawInRect:CGRectMake(start, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height) withAttributes:@{NSFontAttributeName:sectionFont, NSForegroundColorAttributeName:[self.dataSource colorForAxisView:self atSection:section]}];
            }
            
            if (section < count && self.drawContentFlag & eDrawMinorScaleText) {
                NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                CGFloat subXOffset = xOffset;
                
                for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                    subXOffset += [self.dataSource distanceForAxisView:self atIndexPath:indexPath]*self.zoomValue;
                    
                    NSString* subSectionString = [self.dataSource scaleStringForAxisView:self atIndexPath:indexPath];
                    if ([subSectionString length] > 0) {
                        UIFont* subFont = [self.dataSource fontForAxisView:self atIndexPath:indexPath];
                        NSDictionary *attributes = @{NSFontAttributeName:subFont};
                        CGRect rect = [subSectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                        CGContextSetFillColorWithColor(context, [[self.dataSource colorForAxisView:self atIndexPath:indexPath] CGColor]);
                        [subSectionString drawInRect:CGRectMake(subXOffset - rect.size.width/2, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height) withAttributes:@{NSFontAttributeName:subFont, NSForegroundColorAttributeName:[self.dataSource colorForAxisView:self atIndexPath:indexPath]}];
                    }
                }
            }
        }
        
        CGContextStrokePath(context);
    }
}

- (void)drawWhenOnlyOneMajorText
{
    NSString* sectionString = [self.dataSource scaleStringForAxisView:self atSection:0 withOffset:0];
    if ([sectionString length] > 0) {
        UIFont* sectionFont = [self.dataSource fontForAxisView:self atSection:0];
        NSDictionary *attributes = @{NSFontAttributeName:sectionFont};
        CGRect rect = [sectionString boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        [sectionString drawInRect:CGRectMake(0, self.majorScaleLength + self.axisWidth + self.textEdgeOffset, rect.size.width, rect.size.height) withAttributes:@{NSFontAttributeName:sectionFont, NSForegroundColorAttributeName:[self.dataSource colorForAxisView:self atSection:0]}];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.isHidden) {
        return;
    }
    
    // Drawing code
    CGRect bounds = self.bounds;
    
    // 大小刻度
    NSInteger count = [self.dataSource numberOfScaleSections:self];
    if (self.showMoreMajorText) {
        count += 1;
    }
    
    if (count <= 0) {
        [self drawWhenOnlyOneMajorText];
    }
    
    if (count > 0 && count < MAX_SCALE_COUNT) {
        CGFloat xOffset = 0;
        for (int section = 0 ; section < count ; section ++) {
            if (section == 0) {
                xOffset = self.offset;
            }
            else
            {
                CGFloat distance = [self.dataSource distanceForAxisView:self atSection:section - 1];
                xOffset += distance*self.zoomValue;
            }
            
            if (self.drawContentFlag & eDrawMajorScale) {
                [self drawLineFromPoint:CGPointMake(xOffset, self.majorScaleLength + self.axisWidth) toPoint:CGPointMake(xOffset, self.axisWidth/2) withColor:self.majorScaleColor andLineWidth:self.majorScaleWidth];
            }
            
            if (section < count && self.drawContentFlag & eDrawMinorScale) {
                NSInteger subCount = [self.dataSource numberOfScaleForAxisView:self atSection:section];
                CGFloat subYOffset = xOffset;
                
                for (int subSection = 0 ; subSection < subCount ; subSection ++) {
                    DYIndexPath* indexPath = [DYIndexPath indexPathForRow:subSection inSection:section];
                    subYOffset += [self.dataSource distanceForAxisView:self atIndexPath:indexPath]*self.zoomValue;
                    
                    [self drawLineFromPoint:CGPointMake(subYOffset, self.minorScaleLength + self.axisWidth) toPoint:CGPointMake(subYOffset, self.axisWidth/2) withColor:self.minorScaleColor andLineWidth:self.minorScaleWidth];
                }
            }
        }
    }
    
    // X轴
    if (self.drawContentFlag & eDrawAxis) {
        [self drawLineFromPoint:CGPointMake(0, self.axisWidth/2) toPoint:CGPointMake(bounds.size.width, self.axisWidth/2) withColor:self.axisColor andLineWidth:self.axisWidth];
    }
    
    [self drawAllTextLabels];
}

@end
