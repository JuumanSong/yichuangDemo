//
//  DYYC_AreaShakeModel.h
//  YiChangDingPan
//
//  Created by 黄义如 on 2018/4/26.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DYYCPlateMoveShowTypeDefult,
    DYYCPlateMoveShowTypeExpand
}DYYCPlateMoveShowType;

typedef enum {
    DYYCPlateMoveTypeDefult,
    DYYCPlateMoveTypeTheme,
    DYYCPlateMoveTypeComment
}DYYCPlateMoveType;

@interface DYYC_AreaShakeDataModel : NSObject

@property(nonatomic, assign) long ts;
@property(nonatomic,copy)NSString * a;
@property(nonatomic,copy)NSString * f;
@property(nonatomic,assign)double cp;
@property(nonatomic,copy)NSString * abs;
@property(nonatomic,copy)NSString * dateStr;
// 附加的属性
@property (nonatomic,assign) DYYCPlateMoveType type;
@property (nonatomic,assign) DYYCPlateMoveShowType showType;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSArray *optionalArr;
@property(nonatomic,copy)NSArray *highlightArr;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)BOOL isTip;


@end


@interface DYYC_AreaShakeModel : NSObject<YYModel>

@property(nonatomic,copy)NSString * lastId;
@property(nonatomic,copy)NSString * subCardType;
@property(nonatomic,copy)NSString * baseType;
@property(nonatomic, assign) long ts;
@property(nonatomic,strong)DYYC_AreaShakeDataModel*data;

// 附加的属性
@property (nonatomic,assign) NSInteger cellType;

//@property(nonatomic, strong) NSString *abs;
//@property(nonatomic, assign) long ts;
//@property(nonatomic, assign) BOOL dis;
//@property(nonatomic, copy) NSString *sf;
//@property(nonatomic, copy) NSString *ff;
//@property(nonatomic, strong) DYYC_AreaShakeDataModel*data;

@end

