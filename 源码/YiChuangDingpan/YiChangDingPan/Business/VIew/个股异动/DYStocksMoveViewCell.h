//
//  DYStocksMoveViewCell.h
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const DYStocksMoveViewCellId = @"DYStocksMoveViewCellIdentifier";
@interface DYStocksMoveViewCell : UITableViewCell

- (void)configCellWithDict:(NSDictionary *)dict;

@end
