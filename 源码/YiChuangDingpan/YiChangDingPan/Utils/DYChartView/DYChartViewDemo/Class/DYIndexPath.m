//
//  DYIndexPath.m
//  DYChartViewDemo
//
//  Created by 鄢彭超 on 2017/3/14.
//  Copyright © 2017年 鄢彭超. All rights reserved.
//

#import "DYIndexPath.h"

@implementation DYIndexPath

+ (instancetype)indexPathForRow:(long long)row inSection:(long long)section
{
    DYIndexPath* indexPath = [[DYIndexPath alloc] init];
    indexPath.section = section;
    indexPath.row = row;
    
    return indexPath;
}

@end
