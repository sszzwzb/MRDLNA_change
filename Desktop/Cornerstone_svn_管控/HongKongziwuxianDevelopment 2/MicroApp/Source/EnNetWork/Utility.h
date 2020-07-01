//
//  Utility.h
//  
//
//  Created by yunlong.li on 15-4-2.
//  Copyright (c) 2015年 yunlong.li. All rights reserved.
//

/**** 公共函数都定义在这里 ****/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

// 检测网络状态(0-未连网 1-已链接)
+ (BOOL)isNetAvilible;

// 判断是否为iOS7版本
+ (BOOL)isIOS7;

// 判断是否为iOS8版本
+ (BOOL)isIOS8;

// 判断是否为iOS9版本
+ (BOOL)isIOS9;

// 判断是否为iOS10版本
+ (BOOL)isIOS10;

// 获取设备的当前版本
+ (float)getCurrentSysVersion;


@end
