//
//  AES128Encrypt.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128Encrypt : NSObject

//   加密   CBC    AES128     key 和 Iv 必须是16位的，和后台商量，因为用的是 PKCS7Padding
+ (NSString*) AES128Encrypt:(NSString *)plainText skey:(NSString *)skey sIv:(NSString *)sIv;

+ (NSString*) AES128Decrypt:(NSString *)encryptText skey:(NSString *)skey sIv:(NSString *)sIv;

@end
