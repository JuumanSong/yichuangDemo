//
//  DYStocksMoveViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 梁德清 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYStocksMoveViewCell.h"
#import "NSString+NumberFormat.h"

@interface DYStocksMoveViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveNumLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


@end

@implementation DYStocksMoveViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bottomLine.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = DYAppearanceColorFromHex(0xA5A5A5, 1);
    
    self.stockNameLabel.font = [UIFont systemFontOfSize:14];
    self.stockNameLabel.textColor = DYAppearanceColorFromHex(0x404040, 1);
    
    self.stockCodeLabel.font = [UIFont systemFontOfSize:14];
    self.stockCodeLabel.textColor = DYAppearanceColorFromHex(0xA5A5A5, 1);
    
    self.moveDesLabel.font = [UIFont systemFontOfSize:14];
    self.moveDesLabel.textColor = DYAppearanceColorFromHex(0xE6190D, 1);
    self.moveDesLabel.adjustsFontSizeToFitWidth = YES;
    
    self.moveNumLabel.font = [UIFont systemFontOfSize :14];
    self.moveNumLabel.textColor = DYAppearanceColorFromHex(0xE6190D, 1);
    self.moveNumLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)configCellWithDict:(NSDictionary *)dict {
    self.timeLabel.text = dict[@"time"];
    self.stockNameLabel.text = dict[@"stockName"];
    self.stockCodeLabel.text = dict[@"code"];
    self.moveDesLabel.text = dict[@"msg"];
    NSString *value = (NSString *)dict[@"value"];
    self.moveNumLabel.text = value;
    
    // 根据label行数调整是否左对齐
//    CGFloat labelHeight = [self.moveNumLabel sizeThatFits:CGSizeMake(self.moveNumLabel.frame.size.width, MAXFLOAT)].height;
//
//    NSInteger count = (labelHeight) / self.moveNumLabel.font.lineHeight;
//    if (count == 2) {
//        self.moveNumLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    else {
//        self.moveNumLabel.textAlignment = NSTextAlignmentRight;
//    }
    NSString *color = dict[@"color"];
    if (!color.length) return;
    switch (color.integerValue) {
        case 1:
            {
                self.moveDesLabel.textColor = DYAppearanceColorFromHex(0xE6190D, 1);
                self.moveNumLabel.textColor = DYAppearanceColorFromHex(0xE6190D, 1);
            }
            break;
        case -1:
        {
            self.moveDesLabel.textColor = DYAppearanceColorFromHex(0x0FB81D, 1);
            self.moveNumLabel.textColor = DYAppearanceColorFromHex(0x0FB81D, 1);
        }
            break;
        default:
        {
            self.moveDesLabel.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
            self.moveNumLabel.textColor = DYAppearanceColorFromHex(0xCEA76E, 1);
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
