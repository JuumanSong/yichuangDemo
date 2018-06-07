//
//  DYNormalDataAdapter.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYNormalDataAdapter.h"

@implementation DYNormalDataAdapter

- (BOOL)calcMinMaxValueWithStartIndex:(NSUInteger)startIndex andEndIndex:(NSUInteger)endIndex
{
    if ([super calcMinMaxValueWithStartIndex:startIndex andEndIndex:endIndex]) {
        if (!self.notFixDataWith125Rule) {
            DYFixDataBy125RuleResult* result = [DYNormalDataAdapter fixDataBy125RuleWithMinValue:self.minY
                                                                                     andMaxValue:self.maxY
                                                                            andDefaultYPartCount:self.yPartCount
                                                                             andFixPartCountFlag:YES
                                                                              andIsYZeroInMiddle:self.yZeroInMiddle
                                                                                 andCanvasHeight:self.canvasHeight];
            self.minY = result.minValue;
            self.maxY = result.maxValue;
            self.yZeroPosition = result.yZeroPosition;
            [self setJustYPartCount:result.yPartCount];
        }
        
        return YES;
    }
    
    return NO;
}

- (DataAdapterType)adapterType
{
    return normalDataAdapter;
}

@end
