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
//  DYStockPropertyItem.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//
#import "NSObject+Representation.h"

REP_COLLECTION_TYPE(DYStockPropertyItem)

@interface DYStockPropertyItem : NSObject<NSCoding>

//证券ID
@property (nonatomic, strong)NSString* secId;
//交易代码
@property (nonatomic, copy)NSString* tradeCode;
//证券名
@property (nonatomic, copy)NSString* secName;
//证券简称拼音
@property (nonatomic, copy)NSString* pinyin;
//证券简称首字母
@property (nonatomic, copy)NSString* pyInital;
//交易市场
@property (nonatomic, copy)NSString* tradeMarket;
//行业一级分类ID
@property (nonatomic, copy)NSString* classifyId;
//行业一级分类名
@property (nonatomic, copy)NSString* classifyName;
//证券类型
@property (nonatomic, copy)NSString* secType;

@end
