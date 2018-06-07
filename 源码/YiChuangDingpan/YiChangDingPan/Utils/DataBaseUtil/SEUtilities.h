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
//  Utilities.h
//  SimpleEncapsulate
//
//  Created by yhtian on 13-5-4.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LOG(format, ...)        NSLog(format, ##__VA_ARGS__)
#define TIP(format, ...)        NSLog(format", file:%s, line:%d, function:%s.", ##__VA_ARGS__, __FILE__, __LINE__, __PRETTY_FUNCTION__)
#define TRACE(format, ...)      NSLog(@"--- %s "format"---", __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define LOG(format, ...)
#define TIP(format, ...)
#define TRACE(format, ...)
#endif

@interface SEUtilities : NSObject

/**
 @method    +deviceIdentifier
 @abstract  Return an uniform UUID identifier each time.
 @return    UUID.
 @discussion If system is lower than 6.0, it returns an UUID and store to NSUserDefaults,
            else it returns |identifierForVendor.UUIDString|.
 */
+ (NSString *)deviceIdentifier;

/**
 *	@brief	在某目录的路径
 *
 *	@param 	name 	路径带文件名
 *	@param 	directory 	目录名
 *
 *	@return	返回目录的路径
 */
+ (NSString *)filePathWithName:(NSString *)name inDirectory:(NSSearchPathDirectory)directory;

+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName;

+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName
                              toDirectory:(NSSearchPathDirectory)directory;
/**
 @method +duplicateBundleFileWithName:toDirectory:overwrite:
 @param fileName name with suffix, such as "xxxx.xxx".
        |directory|, default directory is NSDocumentDirectory.
        |overwrite|, default is NO, not overwrite if exists.
 @return return |filePath| in directory, if copy succeed or
         file already exists, otherwise return nil.
 @discussion Copy file from mainbundle to current directory.
 */
+ (NSString *)duplicateBundleFileWithName:(NSString *)fileName
                              toDirectory:(NSSearchPathDirectory)directory
                                overwrite:(BOOL)overwrite;

/**
 @method    +systemVersionUpper50
 @abstract  Check if iOS is upper than 5.0.
 @return    YES if system is upper than 5.0.
 */
+ (BOOL)systemVersionUpper50;

/**
 @method    +configureWithSourceName:
 @abstract  Read a configure file and return an array or dictionary.
 @param     sourceName name of configure file, plist.
 @return    NSArray or NSDictionary.
 @discussion Return value NSArray or NSDictionary, determined by the plist file.
            If file is an array, return NSArray, if file is an dictionary, return
            NSDictionary, otherwise return directly without format.
 */
+ (id)configureWithSourceName:(NSString *)sourceName;

/**
 @method    +archiveObject:toFile:
 @abstract  Archive an object to file.
 @param     object the object we need to archive.
 @param     filePath the file we archive to.
 @discussion When archiving an object to file, we set the root key "root".
 */
+ (void)archiveObject:(id)object toFile:(NSString *)filePath;

/**
 @method    +unarchiveObjectFromFile:
 @abstract  Unarchive an object from file.
 @param     filePath the file we archive from.
 @return    The object we unarchived.
 @discussion When unarchiving an object to file, the first key is "root".
 */
+ (id)unarchiveObjectFromFile:(NSString *)filePath;

/**
 @method    +propertiesNameOfObject:
 @abstract  Get properties name of object.
 @param     object the object we get from.
 @return    The array of properties name.
 */
+ (NSArray *)propertiesNameOfObject:(id)object;


/**
 *	@brief	标记一个文件不上传iCloud
 *
 *	@param 	aFilePath 	文件路径
 *
 *	@return	操作结果，YES为成功，NO为失败
 */
+ (BOOL)addSkipBackupAttributeToFileAtPath:(NSString *)aFilePath;

@end
