//
//  DYIndexPath.h
//  DYChartViewDemo
//
//  Created by 鄢彭超 on 2017/3/14.
//  Copyright © 2017年 鄢彭超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYIndexPath : NSObject

@property (nonatomic)long long section;
@property (nonatomic)long long row;

+ (instancetype)indexPathForRow:(long long)row inSection:(long long)section;

@end
