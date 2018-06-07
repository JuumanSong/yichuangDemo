//
//  DYSZ_SettingBaseViewCell.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/23.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYBorderViewCell.h"

@interface DYSZ_SettingBaseViewCell : DYBorderViewCell
@property(nonatomic,assign)BOOL switch_flag;
@property(nonatomic,copy)DataBlock dataBlock;
- (void)configCellWithBt:(NSString*)bt sct:(NSString*)sct withDataBlock:(DataBlock)dataBlock;

@end
