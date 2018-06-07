//
//  DYSZ_PriceShakeViewCell.m
//  IntelligentInvestmentAdviser
//
//  Created by 黄义如 on 2018/4/11.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYSZ_PriceShakeViewCell.h"
#import "DYSelectButtonView.h"
#define DataCount 4
@implementation DYSZ_PriceShakeViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadUI];
    }
    
    return self;
}
-(void)loadUI{
    self.contentView.backgroundColor=DYAppearanceColor(@"W1", 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * arr =@[@"快速拉升",@"火箭发射",@"快速下跌",@"直线暴跌"];
    for (int i=0; i<DataCount; i++) {
        
        DYSelectButtonView * buttonView =[[DYSelectButtonView alloc]initWithFrame:CGRectMake(15+(i%2)*140, (i/2)*55, 130, 36)];
        buttonView.selectButton.tag = 10000+i;
        [buttonView.selectButton setTitle:arr[i] forState:UIControlStateNormal];
        [buttonView.selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:buttonView];
    }
    UIImageView * bottomLine =[[UIImageView alloc]init];
    bottomLine.backgroundColor = DYAppearanceColorFromHex(0xE5E5E5, 1);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)selectButton:(UIButton*)button{
     button.selected = !button.selected;
    NSMutableString *str = [[NSMutableString alloc]initWithCapacity:DataCount+1];
    [str appendFormat:@"%d",0];
    for (int i=0; i<DataCount; i++) {
        UIButton * button =[self.contentView viewWithTag:10000+i];
        if (button.isSelected) {
            [button.layer setBorderWidth:1.0];
            [button setBackgroundColor:DYAppearanceColorFromHex(0xFFFFFF , 1)];
            [str appendFormat:@"%d",1];
        }else{
            
            [button.layer setBorderWidth:0.0];
            [button setBackgroundColor:DYAppearanceColorFromHex(0xF4F5F9 , 1)];
            [str appendFormat:@"%d",0];
        }
    }
    if (self.dataBlock) {
        
        self.dataBlock(str);
    }
    
}

-(void)configCellWithBt:(NSString *)bt sct:(NSString *)sct withDataBlock:(DataBlock)dataBlock{
    
    //解析bt
    if (!bt) {
        return;
    }
    bt =[bt substringFromIndex:1];
    const char * chars =[bt cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<strlen(chars); i++) {
        UIButton * button =[self.contentView viewWithTag:10000+i];
        if (chars[i]=='0') {
            button.selected =NO;
            [button setBackgroundColor:DYAppearanceColorFromHex(0xF4F5F9 , 1)];
            [button.layer setBorderWidth:0.0];
        }else{
            button.selected=YES;
            [button setBackgroundColor:DYAppearanceColorFromHex(0xFFFFFF , 1)];
            [button.layer setBorderWidth:1.0];
        }
    }
    self.dataBlock = dataBlock;
}
@end
