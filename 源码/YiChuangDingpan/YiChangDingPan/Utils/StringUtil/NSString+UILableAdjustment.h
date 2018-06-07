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
//  NSString+UILableAdjustment.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/5/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UILableAdjustment)

/**
 *	@brief	子字符串
 *
 *	@param 	width lable的宽度
 *	@param 	font 字符串font
 *	@param 	lines 需要显示的行数
 *	@param 	blank 最后一行末尾留空的长度
 *
 *	@return	子字符串，超出补……
 */
-(NSString *)getSubStringWithLabWidth:(CGFloat)width Font:(UIFont *)font  Lines:(int)lines Keep:(CGFloat)blank;

/**
 *	@brief	字符串在lable里的行数
 *
 *	@param 	size lable的size
 *	@param 	font 字符串font
 *
 *	@return 行数
 */
-(int)getStringlinesInLabSize:(CGSize)size AndFont:(UIFont *)font;

/**
 *	@brief	字符串在lable里的高度
 *
 *	@param 	size lable的size
 *	@param 	font 字符串font
 *
 *	@return 高度
 */
-(float)getStringHeightInLabSize:(CGSize)size AndFont:(UIFont *)font;

-(float)getStringWidthInLabSize:(CGSize)size AndFont:(UIFont *)font;


/**
 设置str前的字体及颜色，默认包含str在内一起设置

 @param label    文字所在的label
 @param str      label中所含的string
 @param boldFont font
 @param color    color
 */
+ (void)setPartOfBoldFontWithTheLabel:(UILabel *)label
                        containString:(NSString *)str
                             boldFont:(UIFont *)boldFont
                                color:(UIColor *)color;

//设置str前的字体及颜色，isChange:YES,包含str；NO:不包含
+ (void)setPartOfBoldFontWithTheLabel:(UILabel *)label
                        containString:(NSString *)str
                             boldFont:(UIFont *)boldFont
                                color:(UIColor *)color
                          isStrChange:(BOOL)isChange;

@end
