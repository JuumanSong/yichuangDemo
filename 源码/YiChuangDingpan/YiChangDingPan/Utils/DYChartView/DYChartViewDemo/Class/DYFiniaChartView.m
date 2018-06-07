//
//  DYFiniaChartView.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/4/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYFiniaChartView.h"
#import "DYAppearance.h"


@implementation DYFiniaChartView

- (void)drawRect:(CGRect)rect {
    //    [self setupBasicProperty];
    [self setupFixedSubViews];
    [super drawRect:rect];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setupBasicProperty
{
    [super setupBasicProperty];
    
    self.autoResizeYZoom = YES;
    self.drawXDashedLines = YES;
    self.drawYDashedLines = YES;
    
    self.yTop = 10;
    self.xLeft = 30;
    self.xRight = 15;
}

- (UIColor*)colorForAxisView:(DYAxisView*)axisView atSection:(NSInteger)section
{
    
    return DYAppearanceColor(@"H5", 1.0);
}

- (CGRect)leftYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(self.xLeft,
                      self.yTop,
                      self.yWidth,
                      parentBounds.size.height - self.yTop - self.yBottom);
}

- (CGRect)rightYAxisRect
{
    CGRect parentBounds = self.bounds;
    return CGRectMake(parentBounds.size.width - self.yWidth*2,
                      self.yTop,
                      0,
                      parentBounds.size.height - self.yTop - self.yBottom);
}
@end
