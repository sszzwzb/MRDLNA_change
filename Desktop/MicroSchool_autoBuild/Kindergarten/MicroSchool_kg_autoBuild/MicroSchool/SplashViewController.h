//
//  SplashViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-23.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MicroSchoolLoginViewController.h"
#import "GuideViewController.h"

#import "NetworkUtility.h"
#import "FRNetPoolUtils.h"
#import "BaseViewController.h"

@interface SplashViewController : BaseViewController<HttpReqCallbackDelegate>
{
    //闪屏view
    UIView *splashView;
    
    //图片的UIView
    UIImageView *imgView;
    
    //NetworkUtility *network;
    
    
}

@end
