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
//  NSMutableArray+AvoidCrash.m
//  Demo
//
//  Created by datayes on 16/1/22.
//

#import "NSMutableArray+AvoidCrash.h"
#import "objc/runtime.h"

@implementation NSMutableArray (AvoidCrash)

+(void)load
{
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(dy_MultobjctAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
    
//    fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(addObject:));
//    toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(dy_MulArrayAddObject:));
//    method_exchangeImplementations(fromMethod, toMethod);
    
    if (@available(iOS 11.0, *)) {
        fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:));
        toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(dy_mulArrayObjectAtIndexedSubscript:));
        method_exchangeImplementations(fromMethod, toMethod);
    }
}


- (id)dy_MultobjctAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        @try {
            return [self dy_MultobjctAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s 可变数组获取越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally { }
    }else {
        return [self dy_MultobjctAtIndex:index];
    }
}


- (void)dy_MulArrayAddObject:(id)anObject
{
    if (anObject == nil || [anObject isKindOfClass:[NSNull class]]) {
        @try {
            [self dy_MulArrayAddObject:anObject];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s 可变数组添加数据为nil,Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally { }
    }else {
        [self dy_MulArrayAddObject:anObject];
    }
}

- (id)dy_mulArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (self.count <= idx) {
        @try {
            return [self dy_mulArrayObjectAtIndexedSubscript:idx];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s 可变数组获取越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally { }
    }else {
        return [self dy_mulArrayObjectAtIndexedSubscript:idx];
    }
}

@end



@implementation NSArray (DYArray)

+ (void)load
{
    //    //获取对象
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(dy_objctAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    //iOS11字面量获取对象
    fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:));
    toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(dy_objectAtIndexedSubscript:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    // 只有一个object的数组
    fromMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
    toMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(dy_singleObjctAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    fromMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:));
    toMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(dy_singleObjectAtIndexedSubscript:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    // 空数组
    fromMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
    toMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(dy_0objctAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    fromMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndexedSubscript:));
    toMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(dy_0objectAtIndexedSubscript:));
    method_exchangeImplementations(fromMethod, toMethod);
}


- (id)dy_objectAtIndexedSubscript:(NSUInteger)idx {
    if (self.count > idx) {
        return [self dy_objectAtIndexedSubscript:idx];
    }else {
        NSLog(@"字面量-------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}

- (id)dy_objctAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self dy_objctAtIndex:index];
    }else {
        NSLog(@"---------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}

- (id)dy_singleObjectAtIndexedSubscript:(NSUInteger)idx {
    if (self.count > idx) {
        return [self dy_singleObjectAtIndexedSubscript:idx];
    }else {
        NSLog(@"字面量-------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}

- (id)dy_singleObjctAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self dy_singleObjctAtIndex:index];
    }else {
        NSLog(@"---------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}

- (id)dy_0objectAtIndexedSubscript:(NSUInteger)idx {
    if (self.count > idx) {
        return [self dy_0objectAtIndexedSubscript:idx];
    }else {
        NSLog(@"字面量-------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}

- (id)dy_0objctAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self dy_0objctAtIndex:index];
    }else {
        NSLog(@"---------- %s 数组越界Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        return nil;
    }
}
@end

