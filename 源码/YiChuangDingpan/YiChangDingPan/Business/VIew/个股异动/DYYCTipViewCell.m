//
//  DYYCTipViewCell.m
//  YiChangDingPan
//
//  Created by 梁德清 on 2018/5/3.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYYCTipViewCell.h"

@implementation DYYCTipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
