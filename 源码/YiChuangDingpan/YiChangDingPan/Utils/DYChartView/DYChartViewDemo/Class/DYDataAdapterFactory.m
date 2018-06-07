//
//  DYDataAdapterFactory.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/11/30.
//  Copyright © 2015年 datayes. All rights reserved.
//

#import "DYDataAdapterFactory.h"
#import "DYNormalDataAdapter.h"
#import "DYNormalWithSameStartYPointDataAdapter.h"
#import "DYMixedDataWithNoUnitsAdapter.h"
#import "DYTwoUnitsDataAdapter.h"
#import "DYTwoUnitsWithSameStartYPointDataAdapter.h"
#import "DYFixedCentralLineDataAdapter.h"
#import "DYTwoUnitsReverseDataAdapter.h"
#import "DYMixedData1_2_XAdapter.h"

@implementation DYDataAdapterFactory

+ (DYDataAdapterBase*)createDataAdapterByType:(DataAdapterType)type
{
    DYDataAdapterBase* dataAdapter = nil;
    switch (type) {
        case normalDataAdapter:
            dataAdapter = [[DYNormalDataAdapter alloc] init];
            break;
        case normalWithSameStartYPoint:
            dataAdapter = [[DYNormalWithSameStartYPointDataAdapter alloc] init];
            break;
        case mixedDataWithNoUnitsAdapter:
            dataAdapter = [[DYMixedDataWithNoUnitsAdapter alloc] init];
            break;
        case twoUnitsAdapter:
            dataAdapter = [[DYTwoUnitsDataAdapter alloc] init];
            break;
        case twoUnitsWithSameStartYPoint:
            dataAdapter = [[DYTwoUnitsWithSameStartYPointDataAdapter alloc] init];
            break;
        case fixedCentralLineDataAdapter:
            dataAdapter = [[DYFixedCentralLineDataAdapter alloc] init];
            break;
        case twoUnitsReverseAdapter:
            dataAdapter = [[DYTwoUnitsReverseDataAdapter alloc] init];
            break;
        case twoUnitsWith1_2_X:
            dataAdapter = [[DYMixedData1_2_XAdapter alloc] init];
            break;
        default:
            break;
    }
    
    return dataAdapter;
}

@end
