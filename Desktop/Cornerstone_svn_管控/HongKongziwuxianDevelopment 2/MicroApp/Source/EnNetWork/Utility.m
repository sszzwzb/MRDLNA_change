//
//  Utility.m
//  
//
//  Created by yunlong.li on 15-4-2.
//  Copyright (c) 2015年 yunlong.li. All rights reserved.
//

#import "Utility.h"
#import "AFNetworkReachabilityManager.h"

#import "Reachability.h"  //  网络判断的三方


@implementation Utility

// 检测网络状态(0-未连网 1-已链接)
+(BOOL)isNetAvilible{

    Reachability* reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //   @"https://www.taobao.com/"  HOST_IP
    
    return reach.isReachable;
}

// 判断是否为iOS7版本
+ (BOOL)isIOS7 {
//    float currentVersion = [self getCurrentSysVersion];
//    if(currentVersion >=7.0 && currentVersion<8.0){
//        return YES;
//    }else{
//        return NO;
//    }
    
    return (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)?YES:NO;
}

// 判断是否为iOS8版本
+ (BOOL)isIOS8 {
    float currentVersion = [self getCurrentSysVersion];
    if(currentVersion >= 8.0 && currentVersion<9.0){
        return YES;
    }else{
        return NO;
    }
}

// 判断是否为iOS9版本
+ (BOOL)isIOS9 {
    return ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) && (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0))?(YES):(NO);
}

// 判断是否为iOS10版本
+ (BOOL)isIOS10 {
    return (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO);
}


// 获取设备的当前版本
+ (float)getCurrentSysVersion{
    float currentVersion = [[UIDevice currentDevice] systemVersion].floatValue;
    return currentVersion;
}


@end
