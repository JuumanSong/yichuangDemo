//
//  DYXibInitService.h
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 nib加载初始化
 */
@interface DYNibInitService : NSObject

//根据BundleName获取nib重用的cell
+ (id)getDequeueReusableCell:(UITableView *)tableView bundleName:(NSString *)bundleName byNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier;

//获取nib重用的cell
+ (id)getDequeueReusableCell:(UITableView *)tableView byNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier;

//根据BundleName获取nib加载的View
+ (UIView *)getNibViewByName:(NSString *)nibName
                  bundleName:(NSString *)bundleName;

//获取nib加载的View
+ (UIView *)getNibViewByName:(NSString *)nibName;

@end
