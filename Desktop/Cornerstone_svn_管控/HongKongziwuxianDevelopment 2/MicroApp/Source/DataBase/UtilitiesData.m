//
//  UtilitiesData.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "UtilitiesData.h"

#import "AES128Encrypt.h"

#import <CommonCrypto/CommonDigest.h>

@implementation UtilitiesData

//加密
+ (NSString *)AES128EncryptWithContent:(NSString *)str
{
    NSString *string = [AES128Encrypt AES128Encrypt:str skey:@"" sIv:@""];
    return [Utilities replaceNull:string];
}

//解密
+ (NSString *)AES128DecryptWithContent:(NSString *)str
{
    NSString *string = [AES128Encrypt AES128Decrypt:str skey:@"" sIv:@""];
    return [Utilities replaceNull:string];
}


+ (NSString *)md5:(NSString *)str;
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    
    NSString *md5 = [[md5Str substringWithRange:NSMakeRange(8,16)] uppercaseString];
    
    return md5;
}

+ (NSString *)md5With32:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    
    return md5Str;
}




+ (void)setLoginUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:[Utilities replaceNull:userName] forKey:@"LoginUserName"];
}

+ (NSString *)getLoginUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserName"];
    return [Utilities replaceNull:userName];
}

@end
