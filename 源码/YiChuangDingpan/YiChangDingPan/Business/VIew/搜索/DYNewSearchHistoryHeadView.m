//
//  DYNewSearchHistoryHeadView.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/12.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYNewSearchHistoryHeadView.h"

@interface DYNewSearchHistoryHeadView()
@property (nonatomic, strong) DataBlock okBlock;
@end

@implementation DYNewSearchHistoryHeadView

- (IBAction)btnClick:(id)sender {
    if (self.okBlock) {
        self.okBlock(nil);
    }
}

- (void)headClickWithBlock:(DataBlock)block {
    self.okBlock = block;
}
@end
