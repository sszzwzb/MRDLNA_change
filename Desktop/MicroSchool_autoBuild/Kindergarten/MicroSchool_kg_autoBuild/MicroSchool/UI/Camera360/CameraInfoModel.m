//
//  CameraInfoModel.m
//  MicroSchool
//
//  Created by CheungStephen on 22/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "CameraInfoModel.h"

/*
 360开发者账号提供的信息
 App_ID             CFKVKVKVKVKVKVKV
 Server_Key         495750cd4477a6c99acfe74252edb0bc
 App_Key            cc116f732c27dad71187abdd3504f4cd
 */

NSString *const appId = @"CFKVKVKVKVKVKVKV";
NSString *const appKey = @"cc116f732c27dad71187abdd3504f4cd";

@implementation CameraInfoModel


- (id)init {
    if(self = [super init]) {
        _appId = appId;
        _appSdkKey = appKey;
    }
    
    return self;
}

@end
