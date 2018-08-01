//
//  DYMFChartView.m
//  YiChangDingPan
//
//  Created by 周志忠 on 2018/5/2.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYMFChartView.h"

@implementation DYMFChartView

- (UIColor*)lineColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath {
    if (indexPath.row ==0) {
        return DYAppearanceColor(@"B14", 1);
    }
    return DYAppearanceColorFromHex(0x4690EC, 1);
}

- (UIColor*)fillColorInChartView:(DYKLineChartView*)chartView
                     atIndexPath:(DYIndexPath*)indexPath {
    if (indexPath.row == 0) {
        return DYAppearanceColor(@"B14", 0.05);
    }
    return nil;
}

- (EFixedViewItemType)fixedViewItemTypeInChartView:(DYKLineChartView*)chartView
                                           atIndex:(NSUInteger)index {
    return 0;
}
@end
