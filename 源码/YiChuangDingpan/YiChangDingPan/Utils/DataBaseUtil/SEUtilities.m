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
//  Utilities.m
//  SimpleEncapsulate
//
//  Created by yhtian on 13-5-4.
//

#import "SEUtilities.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <sys/xattr.h>

static NSString *const kUserDefaultUUIDKey = @"uuid";

@implementation SEUtilities

+ (NSString *)deviceIdentifier
{
    NSString *uuid = nil;
    NSString *v = [[UIDevice currentDevice] systemVersion];
    // 6.0 or later
    if ([v compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        return uuid;
    }
    // before 6.0
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uuid = [defaults objectForKey:kUserDefaultUUIDKey];
    if (!uuid) {
        CFUUIDRef uniqueIdRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uniqueIdStringRef = CFUUIDCreateString(kCFAllocatorDefault, uniqueIdRef);
        CFRelease(uniqueIdRef);
        uuid = (__bridge NSString *)(uniqueIdStringRef);
        [defaults setObject:uuid forKey:kUserDefaultUUIDKey];
        [defaults synchronize];
        CFRelease(uniqueIdStringRef);
    }
    return uuid;
}

+ (NSString *)filePathWithName:(NSString *)name inDirectory:(NSSearchPathDirectory)directory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        if ([name length]) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths lastObject], name];
            return filePath;
        } else {
            return [paths lastObject];
        }
    }
//    DDLogInfo(@"Can't find directory!");
    return nil;
}

+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName
{
    return [self duplicateBundleFileWithName:fileName toDirectory:NSDocumentDirectory];
}

+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName
                              toDirectory:(NSSearchPathDirectory)directory
{
    return [self duplicateBundleFileWithName:fileName toDirectory:directory overwrite:NO];
}

+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName
                              toDirectory:(NSSearchPathDirectory)directory
                                overwrite:(BOOL)overwrite
{
    NSString *filePath = [self filePathWithName:fileName inDirectory:directory];
    BOOL copy = overwrite || ![[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (copy) {
        NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
//                DDLogInfo(@"Remove file failed with error: %@", error);
            }
        }
        NSString *name = [fileName stringByDeletingPathExtension];
        NSString *originPath = [[NSBundle mainBundle] pathForResource:name ofType:[fileName pathExtension]];
        BOOL success;
        if (originPath == nil) {
            success = [[NSFileManager defaultManager] createFileAtPath:filePath
                                                              contents:[NSData data]
                                                            attributes:nil];
        } else {
            success = [[NSFileManager defaultManager] copyItemAtPath:originPath
                                                              toPath:filePath
                                                               error:&error];
        }
        if (!success) {
//            DDLogInfo(@"Create or Copy file failed with error: %@", error);
            return nil;
        }
    }
    return filePath;
}

+ (BOOL)systemVersionUpper50
{
    NSString *v = [[UIDevice currentDevice] systemVersion];
    return ([v compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending);
}

+ (id)configureWithSourceName:(NSString *)sourceName
{
    NSString *filePath = [self duplicateBundleFileWithName:sourceName];
    if (filePath) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if ([NSPropertyListSerialization propertyList:data isValidForFormat:NSPropertyListXMLFormat_v1_0]) {
            NSPropertyListFormat format;
            id result = [NSPropertyListSerialization propertyListWithData:data
                                                                  options:NSPropertyListMutableContainers
                                                                   format:&format
                                                                    error:nil];
            return result;
        }
        return data;
    }
    return nil;
}

#define kArchiveObjectRootName  @"root"

+ (void)archiveObject:(id)object toFile:(NSString *)filePath
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:kArchiveObjectRootName];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (id)unarchiveObjectFromFile:(NSString *)filePath
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id obj = [unarchiver decodeObjectForKey:kArchiveObjectRootName];
    [unarchiver finishDecoding];
    return obj;
}

+ (NSArray *)propertiesNameOfObject:(id)object
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int numProps = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &numProps);
    for (int i = 0; i < numProps; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *objName = [NSString stringWithUTF8String:propertyName];
        [array addObject:objName];
    }
    free(properties);
    properties = NULL;
    return array;
}

+ (BOOL)addSkipBackupAttributeToFileAtPath:(NSString *)aFilePath
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:aFilePath]);
    
    NSError *error = nil;
    BOOL success = NO;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 5.1f)
    {
        success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                               forKey:NSURLIsExcludedFromBackupKey
                                                                error:&error];
    }
    else if ([systemVersion isEqualToString:@"5.0.1"])
    {
        const char* filePath = [aFilePath fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    else
    {
//        DDLogInfo(@"Can not add 'do no back up' attribute at systems before 5.0.1");
    }
    
    if(!success)
    {
//        DDLogInfo(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    
    return success;
}

@end
