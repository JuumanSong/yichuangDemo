//
//  DYExplainHelper.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYExplainModel.h"
@interface DYExplainHelper : NSObject

//在view显示
- (void)showAtView:(UIView *)view dirct:(NSInteger)upFlag withModel:(DYExplainModel*)model;

@end
