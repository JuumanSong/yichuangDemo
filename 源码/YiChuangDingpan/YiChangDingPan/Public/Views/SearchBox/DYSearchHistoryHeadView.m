//
//  DYSearchHistoryHeadView.m
//  IntelligenceResearchReport
//
//  Created by 周志忠 on 2017/11/6.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "DYSearchHistoryHeadView.h"

@interface  DYSearchHistoryHeadView()
@property (nonatomic, strong) DataBlock okBlock;
@end

@implementation DYSearchHistoryHeadView


- (IBAction)btnClick:(id)sender {
    if (self.okBlock) {
        self.okBlock(nil);
    }
}

- (void)headClickWithBlock:(DataBlock)block {
    self.okBlock = block;
}
@end
