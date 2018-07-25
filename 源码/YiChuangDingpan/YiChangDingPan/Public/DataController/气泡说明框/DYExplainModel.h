//
//  DYExplainModel.h
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2018/1/10.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYExplainSubModel.h"

////气泡说明Model
@interface DYExplainModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic, strong) NSArray <DYExplainSubModel*>*itemsArray;
@end

