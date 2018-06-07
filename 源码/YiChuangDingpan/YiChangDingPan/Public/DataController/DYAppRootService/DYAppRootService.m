//
//  DYAppRootService.m
//  IntelligentInvestmentAdviser
//
//  Created by 宋骁俊 on 2018/2/1.
//  Copyright © 2018年 datayes. All rights reserved.
//

#import "DYAppRootService.h"

static DYAppRootService *instance;

@implementation DYAppRootService

// 单例
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DYAppRootService alloc] init];
    });
    return instance;
}

//init
-(instancetype)init{
    self = [super init];
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AppRootService" ofType:@"plist"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    [dic setObject:[self appVersion] forKey:@"appVersion"];
//    [dic setObject:[self appBuildNumber] forKey:@"appBuildNumber"];
//    [dic setObject:[self appBundleIdentifier] forKey:@"appBundleIdentifier"];
//    _infoDictionary = dic;
    return self;
}

//给app基本信息附新值
-(void)addObject:(NSData *)object forKey:(NSString *)key{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_infoDictionary];
    [dic setObject:object forKey:key];
    _infoDictionary = dic;
}


//appVersion
- (NSString *)appVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}

//appBuildNumber
- (NSString *)appBuildNumber
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* buildNumber =[infoDict objectForKey:@"CFBundleVersion"];
    return buildNumber;
}

//appBundleIdentifier
- (NSString *)appBundleIdentifier
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* bundleIdentifier =[infoDict objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}



+(id)DYJsonGetObject:(id)obj keys:(NSString *)keys defult:(id)defult{
    id result = NullToNil(obj);

    NSArray *tmpKey = [keys componentsSeparatedByString:@","];
    for(int i=0;i<tmpKey.count;i++){
        //字典类型
        if(DYIsKindOfDictionaryClass(result)){
            result = [result objectForKey:tmpKey[i]];
        }
        //数组类型
        else if(DYIsKindOfArrayClass(result)){
            NSArray *tmpArr = result;
            NSString *str = tmpKey[i];
            NSInteger index = [str integerValue];
            //不是数字或者越界
            if((index == 0 && ![@"0" isEqualToString:str]) || tmpArr.count<=index){
                result = nil;
            }
            else{
                result = [tmpArr objectAtIndex:index];
            }
        }
        else{
            result = nil;
        }
        
        if(!NullToNil(result)){
            break;
        }
    }
    result = NullToNil(result);

    
    if(!result && defult){
        result = defult;
    }
    return result;
}


@end
