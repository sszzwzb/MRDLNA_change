//
//  MicroSchoolAppDelegate.h
//  MicroSchool
//
//  Created by jojo on 13-10-29.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

#import "MicroSchoolLoginViewController.h"
#import "MicroSchoolViewController.h"
#import "GuideViewController.h"
#import "MicroSchoolMainMenuViewController.h"
#import "ScoreDetailViewController.h"

#import "NetworkUtility.h"
#import "SDWebImageDownloader.h"
#import "Utilities.h"
#import "CXAlertView.h"
#import "MMDrawerController.h"

#import "BaiduMobStat.h"
#import <UserNotifications/UserNotifications.h>

@interface MicroSchoolAppDelegate : UIResponder <UIApplicationDelegate, HttpReqCallbackDelegate,UNUserNotificationCenterDelegate>
{
    //闪屏view
    UIView *splashView;
    
    //图片的UIView
    UIImageView *imgView;
    
    NetworkUtility *network;
    
    //GlobalSingletonUserInfo* g_userInfo;
    
    NSTimer *getMsgTimer;// add by kate 2014.05.04
    NSInteger getMsgTimeInterval;// add by kate 2014.05.04
    
    NSString *updateUrl;
    CXAlertView *checkUpdateAlert;
    
    UINavigationController *navigation;
    
    MyTabBarController *tabBarController;// add by kate 2014.12.26
    
    NSInteger count;//add 2015.06.01
    NSInteger singleCount;//add by kate 2015.07.03
    NSTimer *getGroupMsgTimer;// add by kate 2015.06.01
    NSInteger interval;
    
    NSMutableArray *chatArray;//add by kate 2015.08.13
    
}

-(void)removeDefaultsInfo;
@property (nonatomic, retain) MyTabBarController *tabBarController;// add by kate 2014.12.26

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MicroSchoolViewController *viewController;

@property (retain, nonatomic) SplashViewController *splash_viewController;

@property (strong, nonatomic) GuideViewController *guideViewController;
@property (nonatomic, retain) NSString *appId;
@property (nonatomic, retain) NSString *channelId;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *token;

@property (nonatomic, assign) BOOL isRebindBaidu;
@property (nonatomic, assign) BOOL isRemoteNotification;

@property (nonatomic, retain) NSDictionary *launchOptionsDic;

-(void)doLogOut:(NSString*)msg;
-(void)checkAllRedPoints;
-(void)unbindBaiduPush;
- (void)bindBaiduPush;

- (void)doHandleInactiveNotification:(NSDictionary *)userInfo;

@end
