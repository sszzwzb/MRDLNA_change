//
//  UtilitiesData.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilitiesData : NSObject

/**
 *  用户登录信息
 */
+ (void)setLoginUserName:(NSString *)userName;
+ (NSString *)getLoginUserName;



//加密
+ (NSString *)AES128EncryptWithContent:(NSString *)str;

//解密
+ (NSString *)AES128DecryptWithContent:(NSString *)str;


// 对字符串进行md5加密  16 位
+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5With32:(NSString *)str;

@end
