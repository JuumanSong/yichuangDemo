/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  NSString+UILableAdjustment.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/5/26.
//

#import "NSString+UILableAdjustment.h"
@implementation NSString (UILableAdjustment)

-(NSString *)getSubStringWithLabWidth:(CGFloat)width Font:(UIFont *)font  Lines:(int)lines Keep:(CGFloat)blank{
    
    CGSize labSize=(CGSize){width,10000};
    
    int strLines=[self getStringlinesInLabSize:labSize AndFont:font];
    
    int length=(int)self.length;
    if (strLines>lines-1) {
        for (int k=1; k<=self.length; k++) {
            NSString* string = [self substringToIndex:k];//保留k个字符串
            if([string getStringlinesInLabSize:labSize AndFont:font]>lines-1){
                length=k-1;
                break;
            }
        }
    }
    else{
        return self;
    }
    
    NSString *completeLineStr = [self substringToIndex:length];//上方完整的str
    NSString *fragmentaryLineStr = [self substringFromIndex:length];//最后行残缺的str
    
    CGSize secLabsize=(CGSize){width-blank,10000};
    if([fragmentaryLineStr getStringlinesInLabSize:secLabsize AndFont:font]<=1){
        return self;
    }
    else{
        for (int k=1; k<=fragmentaryLineStr.length; k++) {
            NSString* string = [fragmentaryLineStr substringToIndex:k];//保留k个字符串
            string=[NSString stringWithFormat:@"%@…",string];
            if([string getStringlinesInLabSize:secLabsize AndFont:font]>1){
                length=k-1;
                break;
            }
        }
        fragmentaryLineStr=[NSString stringWithFormat:@"%@…",[fragmentaryLineStr substringToIndex:length]];
        return [NSString stringWithFormat:@"%@%@",completeLineStr,fragmentaryLineStr];
    }
}


-(int)getStringlinesInLabSize:(CGSize)size AndFont:(UIFont *)font{
    float a=[self getStringHeightInLabSize:size AndFont:font];
    float b=[@"A" getStringHeightInLabSize:size AndFont:font];
    int i=a/b;
    return i;
}

-(float)getStringHeightInLabSize:(CGSize)size AndFont:(UIFont *)font{
    NSStringDrawingContext *context=[[NSStringDrawingContext alloc]init];
    CGRect titleRect =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context];
    float height=titleRect.size.height;
    return height;
}

-(float)getStringWidthInLabSize:(CGSize)size AndFont:(UIFont *)font{
    NSStringDrawingContext *context=[[NSStringDrawingContext alloc]init];
    CGRect titleRect =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context];
    float width=titleRect.size.width;
    return width;
}

// 设置str前的字体及颜色，默认包含str一起设置
+ (void)setPartOfBoldFontWithTheLabel:(UILabel *)label
                        containString:(NSString *)str
                             boldFont:(UIFont *)boldFont
                                color:(UIColor *)color {
    
    [self setPartOfBoldFontWithTheLabel:label containString:str boldFont:boldFont color:color isStrChange:YES];
}

//设置str前的字体及颜色，isChange:YES,包含str；NO:不包含
+ (void)setPartOfBoldFontWithTheLabel:(UILabel *)label
                        containString:(NSString *)str
                             boldFont:(UIFont *)boldFont
                                color:(UIColor *)color
                          isStrChange:(BOOL)isChange
{
    if ([label.text rangeOfString:str].location != NSNotFound) {
        NSRange range = [label.text rangeOfString:str];
        NSString *titleStr;
        if (isChange) {
            titleStr = [label.text substringToIndex:range.location + 1];
        }else {
            titleStr = [label.text substringToIndex:range.location];
        }
        
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc]initWithString:label.text];
        NSRange titleRange = [label.text rangeOfString:titleStr];
        [strM addAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: boldFont} range:titleRange];
        label.attributedText = strM;
    }
}
@end
