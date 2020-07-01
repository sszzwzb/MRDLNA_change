//
//  HomeworkTabBarController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingletonUserInfo.h"
#import "BaseViewController.h"
@interface HomeworkTabBarController : UITabBarController
{
    UIView *_tabView;
    
    UIButton *_lastButton;
    GlobalSingletonUserInfo* g_userInfo;
    NSString *usertype;
}

@end
