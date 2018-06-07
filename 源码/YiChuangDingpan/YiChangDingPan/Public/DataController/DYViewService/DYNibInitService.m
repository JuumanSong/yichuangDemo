//
//  DYXibInitService.m
//  IntelligentInvestmentAdviser
//
//  Created by 周志忠 on 2018/2/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYNibInitService.h"

@implementation DYNibInitService

+ (id)getDequeueReusableCell:(UITableView *)tableView bundleName:(NSString *)bundleName byNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = nil;
    if (tableView != nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    }
    if (cell == nil) {
        NSArray *nibs = [DY_BundleLoader(bundleName) loadNibNamed:nibName owner:nil options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = obj;
                if ([cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
                    return cell;
                }
            }
        }
    }
    return cell?cell:[UITableViewCell new];
}

+ (id)getDequeueReusableCell:(UITableView *)tableView byNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = nil;
    if (tableView != nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    }
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = obj;
                if ([cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
                    return cell;
                }
            }
        }
    }
    return cell?cell:[UITableViewCell new];
}

+ (UIView *)getNibViewByName:(NSString *)nibName
                  bundleName:(NSString *)bundleName {
    if (!nibName) {
        return nil;
    }
    return [[DY_BundleLoader(bundleName) loadNibNamed:nibName owner:nil options:nil]lastObject];
}

+ (UIView *)getNibViewByName:(NSString *)nibName {
    if (!nibName) {
        return nil;
    }
   return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil]lastObject];
}

@end
