//
//  CommonDefine.h
//  MicroApp
//
//  Created by kaiyi on 2018/4/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>


//   是否是通用版  ky 2017.7.6
#define IS_GENERAL_viewSafeAreaInsetsDidChange_SERVER       0


#if IS_GENERAL_viewSafeAreaInsetsDidChange_SERVER

#else

#endif




#define G_APP_VERSION           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]  // @"1.0.0"
#define G_APPID_VERSION         @"1"   //   香港子午线：0    子午线机组宝：1



@interface CommonDefine : NSObject

@end
