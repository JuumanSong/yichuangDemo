//
//  EncryptStringUtil.m
//  RobotResearchReport
//
//  Created by 宋骁俊 on 2017/9/29.
//  Copyright © 2017年 datayes. All rights reserved.
//

#import "EncryptStringUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "DYGTMBase64.h"


@implementation EncryptStringUtil

const Byte iv[] = {1,2,3,4,5,6,7,8};

//base64
+(NSString *)base64:(NSData *)data{
    NSString* base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

//base64
+(NSString *)base64WithStr:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

//Des加密
+(NSString *) encryptUseDES:(NSString *)string key:(NSString *)key
{
    
    NSString *ciphertext = nil;
    NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [DYGTMBase64 stringByEncodingData:data];
    }
    return ciphertext;
}



//Des解密
+(NSString *)decryptUseDES:(NSString *)string key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [DYGTMBase64 decodeString:string];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess)
    {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

//md5加密
+ (NSString *)md5:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] &&
        str.length > 0) {
        const char *cStr = [str cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        
        return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0],result[1],result[2],result[3],
                result[4],result[5],result[6],result[7],
                result[8],result[9],result[10],result[11],
                result[12],result[13],result[14],result[15]];
    }
    return @"";
}


+ (NSString *)verifyChineseUrlStr:(NSString *)chineseStr{
    NSString *urlStrCopy = [chineseStr mutableCopy];
    BOOL hasChinese = NO;
    for(int i=0; i< [urlStrCopy length];i++){
        int a = [urlStrCopy characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            hasChinese = YES;
        }
    }
    if(hasChinese){
        urlStrCopy = [urlStrCopy stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    }
    return urlStrCopy;
}

+ (NSString *)sha256:(NSString *)str {
    return [str sha256];
}
@end
