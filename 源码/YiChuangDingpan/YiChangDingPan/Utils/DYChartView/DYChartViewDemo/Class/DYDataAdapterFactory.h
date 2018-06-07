//
//  DYDataAdapterFactory.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYDataAdapterBase;

typedef NS_ENUM(NSUInteger, DataAdapterType) {
    // 单根单位线
    
    // 正常使用：多组数据的单位一致，只使用单独一根Y轴（或两根Y轴意思一样）就ok了
    // 这种情况下，会保证所有曲线综合下来的最大振幅，不会对每条线的offset做额外调整；不会对zoom做额外调整
    normalDataAdapter = 0,
    // 多组数据的单位一致，只使用单独一根Y轴（或两根Y轴意思一样）就ok了，但期望曲线起点相同
    // 这种情况下，会保证所有曲线综合下来的最大振幅，会对每条线的offset或zoom做额外调整
    // 其实这种情况下，单位一致没有意义，因为offset不一样
    normalWithSameStartYPoint,
    
    // 混合数据：多组数据的单位不一致
    // 这种情况下，会保证每根曲线的最大振幅，会对每根曲线的zoom做额外调整
    // 只有两组数据的情况下，可以左右各取一侧轴做单位，三组以上数据则不需要有Y轴
    mixedDataWithNoUnitsAdapter,
    
    // 第一组使用左侧(或右侧)Y轴单位，剩下的使用右侧(或左侧)Y轴单位
    // 要求以左侧Y轴为单位的线和右侧Y轴为单位的线都能尽量保持较大的振幅
    twoUnitsAdapter,
    
    // 第一组使用左侧(或右侧)Y轴单位，剩下的使用右侧(或左侧)Y轴单位并保证起点一致，
    // 这种情况下，会保证所有曲线综合下来的最大振幅，会对每条线的offset或zoom做额外调整
    // 其实这种情况下，线多一侧的单位一致没有意义，因为offset不一样
    twoUnitsWithSameStartYPoint,
    
    // 与 twoUnitsAdapter 左-右Y轴对调
    twoUnitsReverseAdapter,
    
    // 这种情况下，会保证每根曲线的最大振幅，会对每根曲线的zoom做额外调整
    // 这种情况与 mixedDataWithNoUnitsAdapter 对比，区别在于
    // 1，2两组数据参照的Y轴都会使用125法则，第三组及后续组的数据只保证最大振幅，没有Y轴
    twoUnitsWith1_2_X,
    
    // 用于画指定中线的图
    fixedCentralLineDataAdapter,
};

@interface DYDataAdapterFactory : NSObject

+ (DYDataAdapterBase*)createDataAdapterByType:(DataAdapterType)type;

@end
