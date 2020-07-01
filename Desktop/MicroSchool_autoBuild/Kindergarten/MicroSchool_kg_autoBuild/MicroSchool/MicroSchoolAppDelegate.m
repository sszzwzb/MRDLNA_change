//
//  MicroSchoolAppDelegate.m
//  MicroSchool
//
//  Created by jojo on 13-10-29.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MicroSchoolAppDelegate.h"
#import "BPush.h"
//#import "JSONKit.h"
#import "FRNetPoolUtils.h"
#import "MsgDetailsViewController.h"
#import "MsgListViewController.h"
#import "DBDao.h"
#import "CXAlertView.h"
#import "SubUINavigationController.h"
#import "SchoolListForBureauViewController.h"
#import "GroupChatDetailObject.h"
//#import "GroupChatList.h"
//#import "GroupChatListHeadObject.h"
#import "MixChatDetailObject.h"
#import "MixChatListObject.h"
#import "MyClassListViewController.h"
#import "MsgDetailsMixViewController.h"
#import "MomentsEntranceForTeacherController.h"//2016.01.26
#import "AFNetworkReachabilityManager.h"//af里面监听网络状态的类 add by kate 2015.06.26
#import "FileManager.h"//单例模型，用来记录当前的网络状态 add by kate 2015.06.26


@interface MicroSchoolAppDelegate ()<BPushDelegate>

@end

UINavigationController *navigation_Signup;
extern UINavigationController *navigation_NoUserType;
extern GuideViewController *guide_viewCtrl;
@implementation MicroSchoolAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    
    // 绑定baid，失败了再继续绑定
    //[BPush setupChannel:_launchOptionsDic];
    /*//To beck 2015.12.08
     在 1.3 版本中,这条API做了修改,不需要再创建 plist  件, 是改 在参数中直接传 的 式,如下:
     + (void)registerChannel:(NSDictionary *)launchOptions apiKey:(NSString *)apikey pushMode:(BPushMode
     )mode isDebug:(BOOL)isdebug;
     修改完成后,删除掉原有的 plist 配置 件以及 openSource 下的第三 库,使 最新的 BPush.a 静态库以及 BPush.h 头 件,即可完成更新。
     */
    
#if IS_TEST_SERVER
    [BPush registerChannel:_launchOptionsDic apiKey:G_BAIDU_PUSHKEY pushMode:BPushModeDevelopment isDebug:YES];
#else
    [BPush registerChannel:_launchOptionsDic apiKey:G_BAIDU_PUSHKEY pushMode:BPushModeProduction isDebug:NO];
#endif
    [BPush setDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 百度云推送
    //[BPush setupChannel:launchOptions];//1.3版本换成以下方法了
    /*To beck: 2015.12.08
     在 1.3 版本中,这条API做了修改,不需要再创建 plist  件, 是改 在参数中直接传 的 式,如下:
     + (void)registerChannel:(NSDictionary *)launchOptions apiKey:(NSString *)apikey pushMode:(BPushMode
     )mode isDebug:(BOOL)isdebug;
     修改完成后,删除掉原有的 plist 配置 件以及 openSource 下的第三 库,使 最新的 BPush.a 静态库以及 BPush.h 头 件,即可完成更新。
     */
    
#if IS_TEST_SERVER
    [BPush registerChannel:launchOptions apiKey:G_BAIDU_PUSHKEY pushMode:BPushModeDevelopment isDebug:YES];
#else
    [BPush registerChannel:launchOptions apiKey:G_BAIDU_PUSHKEY pushMode:BPushModeProduction isDebug:NO];
#endif
    
    [BPush setDelegate:self];

   BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    

//    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    /*如果有需要，可自行传入adid
     NSString *adId = @"";
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     }
     statTracker.adid = adId;
     */
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // 由于百度统计平台太长的渠道号显示... ，所以截取真正的sid，作为渠道号
    bundleId = [bundleId substringFromIndex:20];

    // 获取真正的版本号，比如2.6.1
    statTracker.shortAppVersion  = versionStr; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取

#if IS_TEST_SERVER
    statTracker.channelId = bundleId;//设置您的app的发布渠道
    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
    [statTracker startWithAppId:@"c8b56c5855"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
#else
    statTracker.channelId = bundleId;//设置您的app的发布渠道
    statTracker.enableDebugOn = NO; //调试的时候打开，会有log打印，发布时候关闭
    [statTracker startWithAppId:@"775e6f4282"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
#endif
    
    

    _launchOptionsDic = launchOptions;
    
    [Utilities getDataReportStr:@"login"];
    
    [self doGetSplash];
    
    chatArray = [[NSMutableArray alloc] init];// add by kate 2015.08.13

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"allLastIdDic"] == nil) {//存储所有红点 2015.11.11 kate
        
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"allLastIdDic"];
    }
    
    if ([userDefaults objectForKey:@"lastDisIdDic"]==nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastDisIdDic"];
    }
    if ([userDefaults objectForKey:@"lastHomeIdDic"] == nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastHomeIdDic"];
    }
    if ([userDefaults objectForKey:@"lastClassDisIdDic"] == nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastClassDisIdDic"];
    }
    if ([userDefaults objectForKey:@"lastSelfNewIdDic"] == nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastSelfNewIdDic"];
    }
    if ([userDefaults objectForKey:@"lastMyNewMsgIdDic"] == nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastMyNewMsgIdDic"];
    }
    if ([userDefaults objectForKey:@"lastSubscribeNumDic"]==nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastSubscribeNumDic"];
    }
    if ([userDefaults objectForKey:@"lastScoreIdDic"]==nil) {
        NSMutableDictionary *lastDIdDic = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:lastDIdDic forKey:@"lastScoreIdDic"];
    }
    
    
    if (![userDefaults objectForKey:@"New_Done"]) {
        [userDefaults setBool:NO forKey:@"New_Done"];
    }if (![userDefaults objectForKey:@"PrivateNew_Done"]) {
        [userDefaults setBool:NO forKey:@"PrivateNew_Done"];
    }if (![userDefaults objectForKey:@"AddFriendNew_Done"]) {
        [userDefaults setBool:NO forKey:@"AddFriendNew_Done"];
    }if (![userDefaults objectForKey:@"lastIDForFeedback"]) {
        [userDefaults setObject:@"" forKey:@"lastIDForFeedback"];
    }
    if (![userDefaults objectForKey:@"ParentNew_Done"]) {
        [userDefaults setBool:NO forKey:@"ParentNew_Done"];
    }
    
    if (![userDefaults objectForKey:@"MsgNew_Done"]) {
        [userDefaults setBool:NO forKey:@"MsgNew_Done"];
    }
    
    
    [userDefaults setBool:YES forKey:@"isShowPopViewForClass"];
    
    [userDefaults setObject:@"" forKey:@"viewName"];//add by kate 2016.03.07
    
    [userDefaults synchronize];
    
   
    
    
    _splash_viewController = [SplashViewController alloc];
    
//    UINavigationController *rootViewNav = [[UINavigationController alloc] initWithRootViewController:_splash_viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [UIColor clearColor];
    // Override point for customization after application launch.
    self.viewController = [[MicroSchoolViewController alloc] init];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.rootViewController = _splash_viewController;
    
    
     //self.window.rootViewController = rootViewNav;//测试代码
//    [NSThread sleepForTimeInterval:2.0];//2015.11.02 启动图片停留暂定2秒 2.9.1新需求
    [self.window makeKeyAndVisible];
    
   /* // 登陆画面 测试代码
    _splash_viewController = [SplashViewController alloc];
    [self.window addSubview:_splash_viewController.view];
    */
    
    
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {//add by kate 2016.10.09
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // 8.0以上需要单独设置推送开关
    {
      [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                           settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
       [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    //[self createLocalNotify];//测试代码
    
    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//iCon角标 要改
//    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    

    // Check if the app was launched in response to the user tapping on a
	// push notification. If so, we add the new message to the data model.
	if (launchOptions != nil) {
		NSDictionary *dictionary =  [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil) {
			NSLog(@"Launched from push notification: %@", dictionary);
            [BPush handleNotification:dictionary];
		}
	}
    
    //-----add by kate 2014.05.04------------------------------------------------
    // 从服务器拉取消息的时间间隔，当前不在聊天画面的话30秒拉取一次，在聊天画面的话10秒拉取一次
    getMsgTimeInterval = TIMER_PUMP_LONG;
    // 启动时间泵
    [self startMsgTimer];
    //----------------------------------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bindBaiduPush)
                                                 name:NOTIFICATION_UI_BIND_BAIDU_PUSH
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unbindBaiduPush)
                                                 name:NOTIFICATION_UI_UNBIND_BAIDU_PUSH
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCheckVersion) name:@"zhixiao_delegate_checkVersion" object:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomFoundConfiguration) name:@"zhixiao_delegate_getFoundName" object:nil];
    
    
    //---add by kate 2015.06.26----------------------------------------------------------------------------
    //---实时监测网络状态
    // 检测网络有一定的延迟，所以如果启动app立即去检测调用[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus 有可能得到的是status == AFNetworkReachabilityStatusUnknown;但是此时明明是有网的,如果启动就去检测 建议延时调用
    [self performSelector:@selector(netWorkStatus:) withObject:nil afterDelay:0.35f];
    //------------------------------------------------------------------------------------------------------


    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if(apsInfo) {
        // 大退之后如果是从推送栏进入的，把结构体记录下来，然后主页面初始化完成之后再进行详细页面的跳转。
        if (!_isRemoteNotification) {
//            [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"recivedApsInfo"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            _isRemoteNotification = NO;
        }
    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     NSLog(@"deviceToken:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    
    _token = [NSString stringWithFormat:@"%@",deviceToken];
    
    NSString *token = _token;
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];

    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"appleToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    //[self bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
}


/*// 测试代码----------------------------------------------------------------------------------------------
-(void)createLocalNotify{
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {//判断系统是否支持本地通知
        //notification.fireDate = [NSDate dateWithTimeIntervalSince1970:16*60*60*24];//本次开启立即执行的周期
        NSDate *now = [NSDate date];
        //从现在开始，10秒以后通知
        notification.fireDate=[now dateByAddingTimeInterval:10];
        notification.repeatInterval=kCFCalendarUnitMinute;//循环通知的周期
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"哇哇哇";//弹出的提示信息
        notification.applicationIconBadgeNumber = 1; //应用程序的右上角小数字
        notification.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
        //notification.alertAction = NSLocalizedString(@"美女呀", nil);  //弹出的提示框按钮
        notification.hasAction = NO;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    UILocalNotification *notification2 =[[UILocalNotification alloc] init];
    if (notification2!=nil) {//判断系统是否支持本地通知
        //notification.fireDate = [NSDate dateWithTimeIntervalSince1970:16*60*60*24];//本次开启立即执行的周期
        NSDate *now = [NSDate date];
        //从现在开始，10秒以后通知
        notification2.fireDate=[now dateByAddingTimeInterval:20];
        notification2.repeatInterval=kCFCalendarUnitMinute;//循环通知的周期
        notification2.timeZone=[NSTimeZone defaultTimeZone];
        notification2.alertBody=@"哇哇哇2";//弹出的提示信息
        //notification2.applicationIconBadgeNumber = 0; //应用程序的右上角小数字
        notification2.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
        //notification.alertAction = NSLocalizedString(@"美女呀", nil);  //弹出的提示框按钮
        notification.hasAction = NO;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
    }
}*/
//------------------------------------------------------------------------------------------

#pragma mark Baidu Delegate
- (void)onMethod:(NSString *)method response:(NSDictionary *)data
{
    NSLog(@"On Baidu method:%@", method);
    NSLog(@"Baidu push response data:%@", [data description]);
    NSDictionary *res = [[NSDictionary alloc] initWithDictionary:data];
    
    /*
     BPushErrorCode_Success = 0,
     BPushErrorCode_MethodTooOften = 22, // 调 过于频繁
     BPushErrorCode_NetworkInvalible = 10002, //  络连接问题 
     BPushErrorCode_InternalError = 30600, // 服务器内部错误 
     BPushErrorCode_MethodNodAllowed = 30601, // 请求 法不允许 
     BPushErrorCode_ParamsNotValid = 30602, // 请求参数错误 
     BPushErrorCode_AuthenFailed = 30603, // 权限验证失败 
     BPushErrorCode_DataNotFound = 30605, // 请求数据不存在 
     BPushErrorCode_RequestExpired = 30606, // 请求时间戳验证超时 BPushErrorCode_BindNotExists = 30608, // 绑定关系不存在
     */
    
     if ([BPushRequestMethodBind isEqualToString:method]) {
        //NSString *baidu_appid = [res valueForKey:BPushRequestAppIdKey];
        //NSString *baidu_userid = [res valueForKey:BPushRequestUserIdKey];
        //NSString *baidu_channelid = [res valueForKey:BPushRequestChannelIdKey];
        //NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSLog(@"BPushErrorCode:%d",returnCode);
        if (returnCode == 0) {
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            self.appId = appid;
            self.channelId = channelid;
            self.userId = userid;
            
            // 和服务器绑定
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:appid forKey:@"Baidu_AppID"];
            [userDefaults setObject:channelid forKey:@"Baidu_ChannelID"];
            [userDefaults setObject:userid forKey:@"Baidu_UserID"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];

            BOOL isBind = [userDefaults boolForKey:@"Bind_Server"];
            if (!isBind) {
                // 获取当前用户的uid
                NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
                NSString *uid = [uI objectForKey:@"uid"];

//                GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//                NSDictionary *user = [g_userInfo getUserDetailInfo];
//                NSString *uid= [user objectForKey:@"uid"];
//                NSString *cid = @"0";
                
                // 获取当前用户的cid
//                NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
//                NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
                
//                if([@"1"  isEqual: usertype])
//                {
//                    cid = [g_userInfo getUserCid];
//                }
//                else
//                {
//                    cid = [userDetailInfo objectForKey:@"cid"];
//                }
                if (uid) {

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        BOOL isSuccess = false;
                        
                        if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
                            // 5303测试学校，用苹果原生推送
//                            NSString *token = _token;
//                            token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//                            token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//                            token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                            
                            NSString *appleToken = [userDefaults objectForKey:@"appleToken"];

                            isSuccess =  [FRNetPoolUtils bindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:[Utilities getDeviceUUID] channelId:appleToken type:@"" token:_token];
                        }else {
                            // 其他所有学校，仍然用百度推送
                            NSString *appleToken = [userDefaults objectForKey:@"appleToken"];

                            isSuccess =  [FRNetPoolUtils bindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:userid channelId:channelid type:@"" token:appleToken];
                        }
                        

                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                            if (isSuccess) {
                                
                                //[userDefaults setBool:YES forKey:@"Bind_Server"];
                                [userDefaults setObject:@"1" forKey:@"MessageSwitch"];
                                
                                DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                                [dr dataReportActiontype:@"bind"];
                            }
                            
                            
                        });
                    
                    
                    
                    });
                    
                    
                }
            }
        }
    } else if ([BPushRequestMethodUnbind isEqualToString:method]) {//
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (_isRebindBaidu) {
            
            GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString *uid= [user objectForKey:@"uid"];
            NSString *cid = @"0";
            
            // 获取当前用户的cid
            NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
            NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
            //
            //            if([@"1"  isEqual: usertype])
            //            {
            //                cid = [g_userInfo getUserCid];
            //            }
            //            else
            //            {
            //                cid = [userDetailInfo objectForKey:@"cid"];
            //            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];
            NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
            
            BOOL isSuccess;
            if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
                // 5303测试学校，用苹果原生推送
                //                NSString *token = _token;
                //                token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
                //                token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
                //                token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                
                NSString *appleToken = [userDefaults objectForKey:@"appleToken"];
                
                isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:cid clientId:[Utilities getDeviceUUID] channelId:appleToken type:usertype];
            }else {
                // 其他所有学校，仍然用百度推送
                isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:cid clientId:userid channelId:channelid type:usertype];
            }
            
            
            if (isSuccess) {
                //[userDefaults setBool:NO forKey:@"Bind_Server"];
                [userDefaults setObject:@"2" forKey:@"MessageSwitch"];
                
                [self doBindBaiduPush];
                
                _isRebindBaidu = NO;
                
            }

//            [self doBindBaiduPush];
//            
//            _isRebindBaidu = NO;
        }else {
            if (returnCode == 0) {
                // 获取当前用户的uid
                GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                NSDictionary *user = [g_userInfo getUserDetailInfo];
                NSString *uid= [user objectForKey:@"uid"];
                NSString *cid = @"0";
                
                // 获取当前用户的cid
                NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
                NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
                //
                //            if([@"1"  isEqual: usertype])
                //            {
                //                cid = [g_userInfo getUserCid];
                //            }
                //            else
                //            {
                //                cid = [userDetailInfo objectForKey:@"cid"];
                //            }
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];
                NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
                
                BOOL isSuccess;
                if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
                    // 5303测试学校，用苹果原生推送
                    //                NSString *token = _token;
                    //                token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
                    //                token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    //                token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                    
                    NSString *appleToken = [userDefaults objectForKey:@"appleToken"];
                    
                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:cid clientId:[Utilities getDeviceUUID] channelId:appleToken type:usertype];
                }else {
                    // 其他所有学校，仍然用百度推送
                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:cid clientId:userid channelId:channelid type:usertype];
                }
                
                
                if (isSuccess) {
                    //[userDefaults setBool:NO forKey:@"Bind_Server"];
                    [userDefaults setObject:@"2" forKey:@"MessageSwitch"];
                    
                    
                }
            }
        }
    }
}

// 本地推送的接收
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收到本地提醒 in app"
//                                                    message:notification.alertBody
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
//    application.applicationIconBadgeNumber += 1;
    
#if 0
    UIViewController* topViewController = self.tabBarController.navigationController.topViewController;
    
    NSLog(@"%@",topViewController);
    if ([topViewController isKindOfClass:[ HomeViewController class]]) {
        
    }
#endif
    
    
#if 0
    UIViewController *vc = self.tabBarController.navigationController.topViewController;
    
    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:@"aaa"];
    
    newsDetailViewCtrl.newsid = @"1234";
//    newsDetailViewCtrl.newsDate = [newsDateList objectAtIndex:indexPath.row];
//    newsDetailViewCtrl.viewNum = [dic objectForKey:@"viewnum"];
//    [vc.navigationController pushViewController:newsDetailViewCtrl animated:YES];
    
//    [vc presentViewController:newsDetailViewCtrl animated:YES completion:nil];
    [self.tabBarController.navigationController pushViewController:newsDetailViewCtrl animated:YES];

#endif

#if 0
    UIViewController *vc = [self getCurrentVC];
    
    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:@"aaa"];
    newsDetailViewCtrl.newsid = @"1234";

    [vc.navigationController pushViewController:newsDetailViewCtrl animated:YES];
#endif
    
    
#if 0
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:@"aaa"];
    newsDetailViewCtrl.newsid = @"1234";
    
    [navigationController pushViewController:newsDetailViewCtrl animated:YES];
#endif
    
    
#if 0
    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:@"aaa"];
    newsDetailViewCtrl.newsid = @"1234";

    // 获取导航控制器
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    // 跳转到对应的控制器
    [pushClassStance pushViewController:newsDetailViewCtrl animated:YES];
#endif
    
//    [self.tabBarController.navigationController popToViewController:newsDetailViewCtrl animated:YES];

    
    
//    [self.window.rootViewController presentViewController:newsDetailViewCtrl animated:YES completion:nil];
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * windowL = [[UIApplication sharedApplication] keyWindow];
    if (windowL.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                windowL = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[windowL subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = windowL.rootViewController;
    
    return result;
}

- (void)doHandleInactiveNotification:(NSDictionary *)userInfo {
#if 0
     private final static String SUBSCRIPTION = "school_subscribe";//校园订阅（已弃用）
     private final static String NEWS = "school_announce";//校园公告
     private final static String CUSTOM_NEWS = "school_news";//自定义公告
     private final static String EVENT = "event";//活动（已弃用）
     private final static String JOIN_CLASS = "joinclass";//加入班级
     private final static String THREAD = "thread";//校园讨论区（已弃用）
     private final static String HOMEWORK = "homework";//作业
     private final static String ANNOUNCEMENT = "announcement";//班级公告
     private final static String FRIEND_NEW = "friend.new";//新的好友
     private final static String CLASS_APPLY_YES = "classapply_yes";//加入班级同意
     private final static String CLASS_REMOVE_MEMBER = "class_remove_member";//被移除班级
     public final static String LOGIN_ON_OTHER_DEVICE = "login_on_other_device";//其他设备登陆 被踢出
     private final static String MESSAGE_CENTER_NEW = "message_center_new";//我的消息 有新内容
     private final static String CLASS_THREAD = "class_forum_post";//班级讨论区
     private final static String CLASS_CIRCLE = "circle_new_thread";//班级动态
     private final static String CLASS_CIRCLE_NEW_MESSAGE = "circle_new_message";//动态消息
     public final static String PROFILE_CHANGED = "teacher_apply_result";//教师资料变更（被审核通过或拒绝）
     private static final String PUSH_IM = "InstanceMessage";//即时聊天
     private static final String PUSH_GROUP_IM = "group_chat_message";//即时聊天 群聊
     private static final String PUSH_FB = "feedback_admin";//FEEDBACK
     private static final String METHOD_SCORE_NEW = "score.new";//新的成绩
     private static final String METHOD_PHYSICAL_NEW = "physical.new";//新的体验评测
     private static final String METHOD_SCHOOL_LEAVE = "school_leave";//请假(学校)
     private static final String METHOD_CLASS_LEAVE = "class_leave";//请假(班级)
#endif

    // 这里处理通过点击推送栏，从后台进入前台之后进行页面的跳转。
    if ([[userInfo objectForKey:@"method"] isEqualToString:@"school_news"] ||
        [[userInfo objectForKey:@"method"] isEqualToString:@"school_announce"]) {
        // 校园公告，自定义公告，推送的跳转
        NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:[userInfo objectForKey:@"title"]];
        newsDetailViewCtrl.newsid = [userInfo objectForKey:@"tid"];
        
        // 新闻类模块的id，用于更新已读与未读db。
        newsDetailViewCtrl.newsMid = [userInfo objectForKey:@"mid"];
        
        [self navigationPush:newsDetailViewCtrl];

        // 通过推送也需要消除红点
        [Utilities updateRedPoint:0 last:[userInfo objectForKey:@"tid"] cid:[userInfo objectForKey:@"cid"] mid:[userInfo objectForKey:@"mid"]];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"announcement"]) {
        // 班级公告
        DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
        disscussDetailViewCtrl.tid = [userInfo objectForKey:@"tid"];
        disscussDetailViewCtrl.cid = [userInfo objectForKey:@"cid"];
        disscussDetailViewCtrl.disTitle = [userInfo objectForKey:@"title"];
        [disscussDetailViewCtrl setFlag:2];
        [self navigationPush:disscussDetailViewCtrl];
        
        [Utilities updateRedPoint:1 last:[userInfo objectForKey:@"tid"] cid:[userInfo objectForKey:@"cid"] mid:[userInfo objectForKey:@"mid"]];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"score.new"]) {
        // 成绩的跳转
        ScoreDetailViewController *scoreDVC = [[ScoreDetailViewController alloc] init];
        scoreDVC.fromName = @"msgCenter";
        scoreDVC.cId = [userInfo objectForKey:@"cid"];
        scoreDVC.examId = [userInfo objectForKey:@"pid"];
        scoreDVC.nunmber = [userInfo objectForKey:@"number"];
        
        [self navigationPush:scoreDVC];
        
        [Utilities updateRedPoint:2 last:[userInfo objectForKey:@"pid"] cid:[userInfo objectForKey:@"cid"] mid:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"mid"]]];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"physical.new"]) {
        // 体测的跳转
        TestReportDetailViewController *testReportDeV = [[TestReportDetailViewController alloc] init];
        testReportDeV.cid = [userInfo objectForKey:@"cid"];
        testReportDeV.pid = [userInfo objectForKey:@"pid"];
        testReportDeV.nunmber = [userInfo objectForKey:@"number"];

        [self navigationPush:testReportDeV];
        
        [Utilities updateRedPoint:2 last:[userInfo objectForKey:@"pid"] cid:[userInfo objectForKey:@"cid"] mid:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"mid"]]];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"class_leave"] ||
             [[userInfo objectForKey:@"method"] isEqualToString:@"school_leave"]) {
        // 请假的跳转
        NSDictionary *user = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        
        NSDictionary *userInfoa = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        NSString *uid= [userInfoa objectForKey:@"uid"];//后续需要修改从单例里面取 kate
        if (nil == uid) {
            uid = @"";
        }
        
        // app_code
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        // 设备型号 eg:iPhone 4S
        NSString *mobile_model = [Utilities getCurrentDeviceModel];
        // 去掉型号里面的空格
        mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // 手机系统版本 eg:8.0.2
        NSString *os_version = [[UIDevice currentDevice] systemVersion];
        
        NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
        if (nil == token) {
            token = @"";
        }
        
        NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
        key = [Utilities md5:key];
        
        NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
        
        NSString *newUrl = [NSString stringWithFormat:@"%@&__api=%@&love=%@&key=%@&uid=%@&sid=%@&cid=%@&grade=%@",[userInfo objectForKey:@"url"], api, love, key, uid, G_SCHOOL_ID, [userInfo objectForKey:@"cid"], usertype];
        
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.requestURL = newUrl;
        fileViewer.titleName = @"";
        fileViewer.isShowSubmenu = @"0";
        fileViewer.isRotate = @"1";
        
        [self navigationPush:fileViewer];
        
        [Utilities updateRedPoint:1 last:[userInfo objectForKey:@"tid"] cid:[userInfo objectForKey:@"cid"] mid:[userInfo objectForKey:@"mid"]];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"InstanceMessage"]) {
        // 单聊的跳转，先拉取最新的聊天内容。
        [self getMsg];

        WWSideslipViewController *vc = (WWSideslipViewController *)self.window.rootViewController;
        if ([vc isKindOfClass:[WWSideslipViewController class]]) {
            UITabBarController *tabVC = (UITabBarController *)[vc getMainControl];
            
            NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
            
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            NSMutableArray *array = pushClassStance.viewControllers;
            
            BOOL isPop = NO;
            for (int i=0; i<[array count]; i++) {
                
                UIViewController *pushClassStance = [array objectAtIndex:i];
                
                if ([pushClassStance isKindOfClass:[MsgDetailsMixViewController class]]) {
                    isPop = YES;
                }
                
            }
            
                if (isPop) {
                    
                    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                    [pushClassStance popToViewController:[pushClassStance.viewControllers objectAtIndex:1] animated:YES];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"MsgListMixView" forKey:@"viewName"];
                    [userDefaults synchronize];
                    
                }else{
                    
                    if(![viewName isEqualToString:@"MsgListMixView"]){
                    
                        PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                        
                        friendViewCtrl.classid = [userInfo objectForKey:@"cid"];
                        friendViewCtrl.titleName = [userInfo objectForKey:@"title"];
                        
                        [self navigationPush:friendViewCtrl];
                    }
                   
                }
            
        }
    
    
        /*if([viewName isEqualToString:@"MsgDetailsMixView"]){
            // 如果本画面是聊天详情页面的话，就只更新聊天详情画面
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
             // 会有不同的人跟你聊天 你当前在a聊天页 如果收到了b给你的聊天推送 得换数据 所以不能单纯的更新当前聊天详情页 所以上边那行注释了
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
            
            if ([tabVC isKindOfClass:[UITabBarController class]]) {
                
                UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                [pushClassStance popViewControllerAnimated:NO];
                
                UserObject *user = [[UserObject alloc]init];
                NSString *fuid = userInfo[@"fuid"];
                
                user.user_id = fuid.longLongValue;
                user.name = [userInfo objectForKey:@"name"];
                user.headimgurl = [userInfo objectForKey:@"avatar"];
                
                [user updateToDB];
                
                // 更改聊天列表的title
                NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and gid = 0", user.name, user.user_id];
                [[DBDao getDaoInstance] executeSql:updateListSql];
               
                MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
                chatDeatilController.gid = 0;
                chatDeatilController.titleName = user.name;
                chatDeatilController.user  = user;
                
                [self navigationPush:chatDeatilController];
                
            }
            
        }else {
            // 不是聊天详情页面，跳转到详情页面
            UserObject *user = [[UserObject alloc]init];
            NSString *fuid = userInfo[@"fuid"];
            
            user.user_id = fuid.longLongValue;
            user.name = [userInfo objectForKey:@"name"];
            user.headimgurl = [userInfo objectForKey:@"avatar"];
            
            [user updateToDB];
            
            // 更改聊天列表的title
            NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and gid = 0", user.name, user.user_id];
            [[DBDao getDaoInstance] executeSql:updateListSql];
            
//            MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
//            chatDeatilController.user = user;
//            chatDeatilController.frontName = @"user";
//            [chatDeatilController getChatDetailData];
            
            MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
            chatDeatilController.gid = 0;
            chatDeatilController.titleName = user.name;
            chatDeatilController.user  = user;
            
            [self navigationPush:chatDeatilController];
        }*/
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"group_chat_message"]) {
        
        [self getMsg];
        
        WWSideslipViewController *vc = (WWSideslipViewController *)self.window.rootViewController;
        if ([vc isKindOfClass:[WWSideslipViewController class]]) {
            UITabBarController *tabVC = (UITabBarController *)[vc getMainControl];
            
            NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
            
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            NSMutableArray *array = pushClassStance.viewControllers;
            
            BOOL isPop = NO;
            for (int i=0; i<[array count]; i++) {
                
                UIViewController *pushClassStance = [array objectAtIndex:i];
                
                if ([pushClassStance isKindOfClass:[MsgDetailsMixViewController class]]) {
                    isPop = YES;
                }
                
            }
            
            
                
                if (isPop) {
                    
                    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                    [pushClassStance popToViewController:[pushClassStance.viewControllers objectAtIndex:1] animated:YES];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"MsgListMixView" forKey:@"viewName"];
                    [userDefaults synchronize];
                    
                }else{
                    
                    if(![viewName isEqualToString:@"MsgListMixView"]){
                    
                    if (1 == [[userInfo objectForKey:@"position"] longLongValue]) {
                        
                        PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                        friendViewCtrl.classid = [userInfo objectForKey:@"cid"];
                        friendViewCtrl.titleName = [userInfo objectForKey:@"title"];
                        [self navigationPush:friendViewCtrl];
                        
                    }
                    }
                    
                }
                
    
            
        }
        
        /*if([viewName isEqualToString:@"MsgDetailsMixView"]){
            // 如果本画面是聊天详情页面的话，就只更新聊天详情画面
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP object:nil];
            // 会有不同的人跟你聊天 你当前在a聊天页 如果收到了b给你的聊天推送 得换数据 所以不能单纯的更新当前聊天详情页 所以上边那行注释了
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;

            if ([tabVC isKindOfClass:[UITabBarController class]]) {
                
                UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                [pushClassStance popViewControllerAnimated:NO];
                
                NSString *cid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]];
                NSString *gid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"gid"]];
                gid = [gid stringByReplacingOccurrencesOfString:@"," withString:@""];
                //                GroupChatDetailViewController *groupDetailV = [[GroupChatDetailViewController alloc]init];
                //                groupDetailV.gid = [gid longLongValue];
                //                groupDetailV.cid = [cid longLongValue];
                //                //[groupDetailV getChatDetailData];
                //                [self navigationPush:groupDetailV];
                
                MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
                chatDeatilController.gid = [gid longLongValue];
                chatDeatilController.cid = [cid longLongValue];
                [self navigationPush:chatDeatilController];
            }
            
        }else {
            
            NSString *cid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]];
            NSString *gid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"gid"]];
            gid = [gid stringByReplacingOccurrencesOfString:@"," withString:@""];
//            GroupChatDetailViewController *groupDetailV = [[GroupChatDetailViewController alloc]init];
//            groupDetailV.gid = [gid longLongValue];
//            groupDetailV.cid = [cid longLongValue];
//            //[groupDetailV getChatDetailData];
            MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
            chatDeatilController.gid = [gid longLongValue];
            chatDeatilController.cid = [cid longLongValue];
            [self navigationPush:chatDeatilController];
        }*/
        
    }else if([[userInfo objectForKey:@"method"] isEqualToString:@"school_spec_act"]){//学校特殊活动
        
        NSDictionary *user = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        NSDictionary *message_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString *uid = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"uid"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:[NSString stringWithFormat:@"%@_%@", [userInfo objectForKey:@"id"],uid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIView *bgView = [[UIApplication sharedApplication].keyWindow viewWithTag:10086];
        [bgView removeFromSuperview];
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        NSString *b = [userInfo objectForKey:@"url"];//url需要拼接
        NSString *newUrl = [Utilities appendUrlParamsV2:b];
        newUrl = [NSString stringWithFormat:@"%@&grade=%@",newUrl,usertype];
        //        fileViewer.requestURL = newUrl;
        //        fileViewer.webType = SWLoadRequest;
        //        fileViewer.titleName = [userInfo objectForKey:@"title"];//导航栏里title
        fileViewer.webType = SWLoadURl;//2015.09.23
        fileViewer.url = [NSURL URLWithString:newUrl];
        fileViewer.isShowSubmenu = @"0";
        fileViewer.closeVoice = 1;
        fileViewer.isFromEvent = YES;
        //fileViewer.hideBar = YES;
        [self navigationPush:fileViewer];
        
    }else {
        // other
    }
}

- (void)navigationPush:(UIViewController *)viewController {
    // 获取导航控制器
    WWSideslipViewController *vc = (WWSideslipViewController *)self.window.rootViewController;
    
    if ([vc isKindOfClass:[WWSideslipViewController class]]) {
        UITabBarController *tabVC = (UITabBarController *)[vc getMainControl];
        
        UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        [pushClassStance pushViewController:viewController animated:YES];
    }


    
#if 0
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    
    if ([tabVC isKindOfClass:[UITabBarController class]]) {
        UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        // 跳转到对应的控制器
        [pushClassStance pushViewController:viewController animated:YES];
    }
#endif
}

//远程推送APP在前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0){

    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        // 程序当前正处于前台
    }else if(application.applicationState == UIApplicationStateInactive) {
        // 程序处于后台
        // 清除所有的通知栏通知内容
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        NSLog(@"11111111111111");
        if (nil != userInfo) {
            [self doHandleInactiveNotification:userInfo];
            
            _isRemoteNotification = YES;
        }
    }
    
    NSLog(@"777777777777");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];// in iOS7 need this
        
    }
    //NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    //if (application.applicationState == UIApplicationStateActive) {
    // 点击推送状态条进这里
    // add your codef
    
    if ([[userInfo objectForKey:@"method"] isEqualToString:@"InstanceMessage"]) {//推送格式
        
        //        // 红点推送
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        // 聊天消息
        [self timerFired];
        //addNewCountForMsg
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"login_on_other_device"]){
        //dologout action
        
        // pushLogout 登出推送 被用户登出or被管理员踢出
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        if (uid) {
            
            GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            
            NSDictionary *userInfom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
            NSString *uid= [userInfom objectForKey:@"uid"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];
            NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
            NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
            NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                BOOL isSuccess;
                if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
                    // 5303测试学校，用苹果原生推送
                    //                    NSString *token = _token;
                    //                    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
                    //                    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    //                    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                    
                    NSString *appleToken = [userDefaults objectForKey:@"appleToken"];
                    
                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:[Utilities getDeviceUUID] channelId:appleToken type:usertype];
                }else {
                    // 其他所有学校，仍然用百度推送
                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:userid channelId:channelid type:usertype];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (isSuccess) {
                        //[userDefaults setBool:NO forKey:@"Bind_Server"];
                    }
                    
                });
                
                
            });
            
            /*
             NSString *baiduUserID = [userDefaults objectForKey:@"Baidu_UserID"];
             NSString *baiduChannelID = [userDefaults objectForKey:@"Baidu_ChannelID"];
             NSString *baiduAppID = [userDefaults objectForKey:@"Baidu_AppID"];
             
             NSString *checkResult = @"login_on_other_device";
             NSString *uuid = [Utilities getUniqueUidWithoutQuit];
             
             NSString *debugStr = [NSString stringWithFormat:@"%@_%@_%@_%@_%@", uuid, checkResult, baiduAppID, baiduChannelID, baiduUserID];
             
             [self doWriteDebugLogPushLogout:debugStr];*/
            
            //[self doLogOut:[userInfo objectForKey:@"description"]];
            [self doLogOut:@"您的账号在其他设备登录，有问题请与管理员联系"];
            
        }
        
    }
    //else if([[userInfo objectForKey:@"method"] isEqualToString:@"knowledgeroot"] || [[userInfo objectForKey:@"method"] isEqualToString:@"news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"event"] || [[userInfo objectForKey:@"method"] isEqualToString:@"thread"]){
    else if([[userInfo objectForKey:@"method"] isEqualToString:@"news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_subscribe"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_announce"]){
        
        //自定义公告类 校园公告 校园导读 校园广播 收到推送重置主页红点 2015.11.11
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        
    }else if([[userInfo objectForKey:@"method"] isEqualToString:@"class_remove_member"]){
        
        // 刷新列表页
        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
        if([viewName isEqualToString:@"MyClassListViewController"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassList" object:nil];
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"classapply_yes"]){//申请加入班级
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
        
        //NSLog(@"userInfo:%@",userInfo);
        
        NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]]];
        
        GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        
        NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[user objectForKey:@"role_id"]];
        
        if([@"0"  isEqual: usertype] || [@"6" isEqual:usertype] ){// 家长 学生
            
            [user setValue:cid forKey:@"role_cid"];
            [g_userInfo setUserDetailInfo:user];
            
            
            ClassDetailViewController *detailV = [[ClassDetailViewController alloc]init];
            detailV.cId = cid;
            detailV.fromName = @"tab";
            detailV.hidesBottomBarWhenPushed = YES;
            
            UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:detailV];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [array replaceObjectAtIndex:1 withObject:customizationNavi];
            [self.tabBarController setViewControllers:array];
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"homework"] || [[userInfo objectForKey:@"method"] isEqualToString:@"announcement"] || [[userInfo objectForKey:@"method"] isEqualToString:@"class_forum_post"] || [[userInfo objectForKey:@"method"] isEqualToString:@"score.new"] || [[userInfo objectForKey:@"method"] isEqualToString:@"physical.new"] || [[userInfo objectForKey:@"method"] isEqualToString:@"class_leave"]){// 班级公告/班级作业/班级讨论区/成长空间/请假
        
        // 刷新班级列表/班级详情 红点
        GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSString *cid = @"0";
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"2" isEqual:usertype] || [@"9" isEqual:usertype])
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            if ([array count] > 0 ) {
                UINavigationController *nav = [array objectAtIndex:1];
                
                if ([[nav.viewControllers objectAtIndex:0] isKindOfClass:[MyClassListViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:nil];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:nil];
                }
            }
            
        }else{
            
            if([cid isEqualToString:@"0"]){
                
            }else{
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetail" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:nil];//2015.11.12
                
            }
            
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"message_center_new"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMsgCenterNew" object:nil];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"circle_new_message"]){// 个人动态消息
        
        // 2.9.2
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"checkSelfMomentsNew" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMomentsNew" object:nil];
        // 刷新动态列表页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
        //2.9.4
        // 刷新主页红点
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"circle_new_thread"]){// 新动态推送
        
        // 刷新班级列表/班级详情红点
        //        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
        //        if([viewName isEqualToString:@"MyClassListViewController"]){
        GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSString *cid = @"0";
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"2" isEqual:usertype] || [@"9" isEqual:usertype])
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:nil];//2015.11.12
            
        }else{
            
            if([cid isEqualToString:@"0"]){
                
            }else{
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetail" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:nil];//2015.11.12
            }
            
        }
        
        //       }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"teacher_apply_result"]){
        // 身份改变推送
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"teacher_apply_result" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"group_chat_message"]){
        
        [self timerFired];
        
    }
    
    // }
    
    // iOS9下百度推送调用了JSONKit崩溃 可选项 先注释掉 等待更新 2015.09.19
    //[BPush handleNotification:userInfo];

    
}

#if 0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"6666666666666");

    if (application.applicationState == UIApplicationStateActive) {
        // 程序当前正处于前台
    }else if(application.applicationState == UIApplicationStateInactive) {
        // 程序处于后台
        // 清除所有的通知栏通知内容
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        NSLog(@"11111111111111");
        if (nil != userInfo) {
            [self doHandleInactiveNotification:userInfo];
        }
    }
    
    NSLog(@"777777777777");

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
    
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];// in iOS7 need this

    }
        //NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    //if (application.applicationState == UIApplicationStateActive) {
    // 点击推送状态条进这里
    // add your codef
    
    if ([[userInfo objectForKey:@"method"] isEqualToString:@"InstanceMessage"]) {//推送格式
        
//        // 红点推送
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        // 聊天消息
        [self timerFired];
        //addNewCountForMsg
         [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"login_on_other_device"]){
        //dologout action
        
        // pushLogout 登出推送 被用户登出or被管理员踢出
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        if (uid) {
            
            GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            
            NSDictionary *userInfom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
            NSString *uid= [userInfom objectForKey:@"uid"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];
            NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
            NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
            NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                BOOL isSuccess;
                if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
                    // 5303测试学校，用苹果原生推送
//                    NSString *token = _token;
//                    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//                    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                    
                    NSString *appleToken = [userDefaults objectForKey:@"appleToken"];

                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:[Utilities getDeviceUUID] channelId:appleToken type:usertype];
                }else {
                    // 其他所有学校，仍然用百度推送
                    isSuccess =  [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:userid channelId:channelid type:usertype];
                }

                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if (isSuccess) {
                         //[userDefaults setBool:NO forKey:@"Bind_Server"];
                    }
                
                });
            
            
            });
            
            /*
            NSString *baiduUserID = [userDefaults objectForKey:@"Baidu_UserID"];
            NSString *baiduChannelID = [userDefaults objectForKey:@"Baidu_ChannelID"];
            NSString *baiduAppID = [userDefaults objectForKey:@"Baidu_AppID"];
            
            NSString *checkResult = @"login_on_other_device";
            NSString *uuid = [Utilities getUniqueUidWithoutQuit];
            
            NSString *debugStr = [NSString stringWithFormat:@"%@_%@_%@_%@_%@", uuid, checkResult, baiduAppID, baiduChannelID, baiduUserID];
            
            [self doWriteDebugLogPushLogout:debugStr];*/

            //[self doLogOut:[userInfo objectForKey:@"description"]];
            [self doLogOut:@"您的账号在其他设备登录，有问题请与管理员联系"];
            
        }
        
    }
    //else if([[userInfo objectForKey:@"method"] isEqualToString:@"knowledgeroot"] || [[userInfo objectForKey:@"method"] isEqualToString:@"news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"event"] || [[userInfo objectForKey:@"method"] isEqualToString:@"thread"]){
    else if([[userInfo objectForKey:@"method"] isEqualToString:@"news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_news"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_subscribe"] || [[userInfo objectForKey:@"method"] isEqualToString:@"school_announce"]){
        
        //自定义公告类 校园公告 校园导读 校园广播 收到推送重置主页红点 2015.11.11
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        
    }else if([[userInfo objectForKey:@"method"] isEqualToString:@"class_remove_member"]){
        
        // 刷新列表页
        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
        if([viewName isEqualToString:@"MyClassListViewController"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassList" object:nil];
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"classapply_yes"]){//申请加入班级
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
        
        //NSLog(@"userInfo:%@",userInfo);
      
        NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]]];
        
        GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;

        NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[user objectForKey:@"role_id"]];
        
        if([@"0"  isEqual: usertype] || [@"6" isEqual:usertype] ){// 家长 学生
            
            [user setValue:cid forKey:@"role_cid"];
            [g_userInfo setUserDetailInfo:user];

            
            ClassDetailViewController *detailV = [[ClassDetailViewController alloc]init];
            detailV.cId = cid;
            detailV.fromName = @"tab";
            detailV.hidesBottomBarWhenPushed = YES;
            
            UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:detailV];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [array replaceObjectAtIndex:1 withObject:customizationNavi];
            [self.tabBarController setViewControllers:array];
            
        }else{
            
              [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"homework"] || [[userInfo objectForKey:@"method"] isEqualToString:@"announcement"] || [[userInfo objectForKey:@"method"] isEqualToString:@"class_forum_post"] || [[userInfo objectForKey:@"method"] isEqualToString:@"score.new"] || [[userInfo objectForKey:@"method"] isEqualToString:@"physical.new"] || [[userInfo objectForKey:@"method"] isEqualToString:@"class_leave"]){// 班级公告/班级作业/班级讨论区/成长空间/请假
        
        // 刷新班级列表/班级详情 红点
        GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSString *cid = @"0";
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"2" isEqual:usertype] || [@"9" isEqual:usertype])
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:nil];//2015.11.12
            
        }else{
            
            if([cid isEqualToString:@"0"]){
                
            }else{
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetail" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:nil];//2015.11.12

            }
            
        }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"message_center_new"]){
       
         [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMsgCenterNew" object:nil];
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"circle_new_message"]){// 个人动态消息
        
        // 2.9.2
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"checkSelfMomentsNew" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMomentsNew" object:nil];
        // 刷新动态列表页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
        //2.9.4
        // 刷新主页红点
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"circle_new_thread"]){// 新动态推送
        
        // 刷新班级列表/班级详情红点
//        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
//        if([viewName isEqualToString:@"MyClassListViewController"]){
        GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSString *cid = @"0";
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"2" isEqual:usertype] || [@"9" isEqual:usertype])
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:nil];//2015.11.12

        }else{
            
            if([cid isEqualToString:@"0"]){
                
            }else{
               //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetail" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:nil];//2015.11.12
            }
            
        }
        
 //       }
        
    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"teacher_apply_result"]){
        // 身份改变推送
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"teacher_apply_result" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];

    }else if ([[userInfo objectForKey:@"method"] isEqualToString:@"group_chat_message"]){
        
         [self timerFired];
        
    }

   // }

    // iOS9下百度推送调用了JSONKit崩溃 可选项 先注释掉 等待更新 2015.09.19
    //[BPush handleNotification:userInfo];
    
}
#endif


- (void)TheAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    splashView.alpha = 0;
    [UIView commitAnimations];
    
    //将闪屏view从父view中移除，以便父view获得点击事件
    [splashView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

-(void)doLogOut:(NSString*)msg{
    
//    [Utilities showAlert:nil message:@"您的帐号在其他设备登录，有问题请与管理员联系" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                   message:@"您的帐号在其他设备登录，有问题请与管理员联系"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
     //self.window.rootViewController = self.splash_viewController;//重置rootview add 2015.10.23
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    __block MicroSchoolAppDelegate *blockSelf = self;

//    if (checkUpdateAlert == nil){
    
        //------update by kate 2014.11.04-----------------------------------------------------
        
//         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
//         message:msg
//         delegate:nil
//         cancelButtonTitle:@"确定"
//         otherButtonTitles:nil,nil];
//         [alertView show];
    
        // @"您的帐号在其他设备登录，有问题请与管理员联系"
        [checkUpdateAlert dismiss];
        checkUpdateAlert = [[CXAlertView alloc]initWithTitle:@"提示" message:msg cancelButtonTitle:nil];
        [checkUpdateAlert addButtonWithTitle:@"确定"
                                        type:CXAlertViewButtonTypeDefault
                                     handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                         // Dismiss alertview
                                         [alertView dismiss];
                                         blockSelf->checkUpdateAlert = nil;
                                     }];
        
        [checkUpdateAlert show];
    
        [self unbindBaiduPush];//解绑 2015.12.08
        
//    }

    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }


//    _login_viewController = [[MicroSchoolLoginViewController alloc]init];
//    [self.window addSubview:_login_viewController.view];
    //[self.tabBarController dismissViewControllerAnimated:YES completion:nil];//update by kate 解决被T再登录崩溃问题
//    [self.tabBarController dismissViewControllerAnimated:YES completion:^{
//       
//        NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
//        
//        if(![fromNameToHome isEqualToString:@"login"]){
//        
//            if ([fromNameToHome isEqualToString:@"setHeadImg"]){
//        
//                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
//            }else if ([fromNameToHome isEqualToString:@"noUserType"]){
//                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
//                 }
//                
//            }
//    
//    }];
//    
//    self.tabBarController = nil;
    
     NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
    if(self.window.rootViewController!=self.splash_viewController){
        self.window.rootViewController = self.splash_viewController;//重置rootview add 2015.10.23
        if(![fromNameToHome isEqualToString:@"login"]){
            if([fromNameToHome isEqualToString:@"splash"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }
            else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                
                [self removeDefaultsInfo];
                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
            }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                [self removeDefaultsInfo];
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
            }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                [self removeDefaultsInfo];
                if (guide_viewCtrl) {//2015.08.27
                    [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                }
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else{
                [self removeDefaultsInfo];
                if (guide_viewCtrl) {//2015.08.27
                    [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }
            
        }else{
            [self removeDefaultsInfo];
        }
        self.tabBarController = nil;
        
    }else{
        
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
            if(![fromNameToHome isEqualToString:@"login"]){
               if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                    
                    [self removeDefaultsInfo];
                    [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                    [self removeDefaultsInfo];
                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                    [self removeDefaultsInfo];
                    if (guide_viewCtrl) {//2015.08.27
                        [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                    }
                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                }else{
                    [self removeDefaultsInfo];
                    if (guide_viewCtrl) {//2015.08.27
                        [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                }
                
            }else{
                [self removeDefaultsInfo];
            }
            
        }];
        self.tabBarController = nil;
    }
  
}

// 清理存在userdefaults中的内容
-(void)removeDefaultsInfo{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
    
    for (int i=0; i<[dynamicArr count]; i++) {
        
        NSDictionary *dic = [dynamicArr objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        //NSLog(@"name:%@",name);
        [defaults removeObjectForKey:name];
    }
    
    
    [defaults removeObjectForKey:G_NSUserDefaults_UserLoginInfo];
    [defaults removeObjectForKey:G_NSUserDefaults_UserUniqueUid];
    [defaults removeObjectForKey:@"lastSubscribeNumDic"];
    [defaults removeObjectForKey:@"lastId_cnews"];
    [defaults removeObjectForKey:@"lastId_news"];
    [defaults removeObjectForKey:@"lastHomeIdDic"];
    [defaults removeObjectForKey:@"lastDisIdDic"];
    [defaults removeObjectForKey:@"lastClassDisIdDic"];
    [defaults removeObjectForKey:@"lastSelfNewIdDic"];
    [defaults removeObjectForKey:@"lastMyNewMsgIdDic"];
    [defaults removeObjectForKey:@"lastId_chat"];
    [defaults setObject:@"1" forKey:@"MessageSwitch"];
    [defaults removeObjectForKey:@"lastId_Education"];
    [defaults removeObjectForKey:@"lastId_CookMenu"];
    [defaults removeObjectForKey:@"lastId_OrientalSound"];
    [defaults removeObjectForKey:@"lastId_StudentHandbook"];
    [defaults setBool:NO forKey:@"DB_DONE"];
    [defaults setObject:nil forKey:@"zhixiao_isNewVersionPopupShow"];
    [defaults removeObjectForKey:@"lastIDForFeedback"];
    [defaults setObject:nil forKey:@"classArray"];// add by kate 2014.12.01
    [defaults setObject:nil forKey:@"MyMsgLastId"];// add by kate 2014.12.03
    [defaults setObject:@"" forKey:@"viewName"];
    [defaults setBool:NO forKey:@"HelpNew_Done"];
    [defaults setObject:nil forKey:@"tabTitles"];
    [defaults setObject:nil forKey:@"isKnowledge"];// add by kate 2015.03.04
    [defaults setObject:nil forKey:@"knowledgeName"];// add by kate 2015.03.31
    [defaults setObject:nil forKey:@"foundModule"];// add by kate 2015.03.31
    [defaults setObject:nil forKey:@"momentEnter"];//add by kate 2015.03.31
    [defaults setObject:nil forKey:@"MyPoints"];//add by kate 2015.08.05
    [defaults setObject:nil forKey:USER_LOGIN_TOKEN];//add by kate 2015.08.05
    [defaults removeObjectForKey:@"lastScoreIdDic"];
    [defaults removeObjectForKey:@"allLastIdDic"];//2015.11.13
    [defaults removeObjectForKey:@"alwaysNewsDic"];//2015.11.13
    [defaults setBool:YES forKey:@"isShowPopViewForClass"];//2016.2.23

    [defaults synchronize];
    
    // 清除发布作业保存之前的标题
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"homeworkTitle"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 清空标记名字的变量，不自动登录
    NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:nil, @"name", nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // add by ht 20140915 用户被踢掉后，清空用户信息，以便下一次直接进入主界面，增加userDefaults变量
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDynamicModule"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*NSString *dbFileStr = [[Utilities getMyInfoDir] stringByAppendingPathComponent:@"WeixiaoChat.db"];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if([fileManager removeItemAtPath:dbFileStr error:nil]){
     //NSLog(@"1");
     }else{
     //NSLog(@"0");
     }*/
    
    // 删除班级头像
    NSString *fullPath = [[Utilities SystemDir] stringByAppendingPathComponent:@"tempImgForClass.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:fullPath error:nil]){
        //NSLog(@"1");
    }else{
        //NSLog(@"0");
    }
    
    [[DBDao getDaoInstance] releaseDB];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"Baidu_UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

// 获取自定义tabTitle
-(void)getCustomTabTitle{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *titleArray = [FRNetPoolUtils getTabTitle];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (titleArray == nil) {
                
                
            }else{
                
                if([titleArray count] > 0){
                    
                    NSMutableArray *titleTabArray = [[NSMutableArray alloc] init];
                    
                    for(int i= 0;i<[titleArray count];i++){
                        
                        NSString *name = [Utilities replaceNull:[[titleArray objectAtIndex:i] objectForKey:@"name"]];
                        [titleTabArray addObject:name];
                    }
                    
                    [[NSUserDefaults standardUserDefaults]setObject:titleTabArray forKey:@"tabTitles"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCustomTabTitle" object:titleArray];
                }
                
            }
            
        });
        
    });
    
}

//// 获取自定义tabTitle
//-(void)getCustomFoundConfiguration{
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSString *name = [FRNetPoolUtils getFoundConfiguration];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (name == nil) {
//                
//            }else{
//                [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"foundModule"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
//        });
//    });
//}

- (void)logOutForOtherDeviceOnLine
{
    // 获取当前用户的uid
//    GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    NSDictionary *user = [g_userInfo getUserDetailInfo];
//    NSString *uid1 = [user objectForKey:@"uid"];
    
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [userDefaults objectForKey:@"Baidu_UserID"];

    BOOL isConnect = [Utilities connectedToNetwork];
    
    if(isConnect) {
        if (uid)
        {
            if (nil != clientId) {
                
//                BOOL isUnbind = [FRNetPoolUtils isUnBind];
//                
//                if (!isUnbind) {
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:@"logOut" forKey:@"fromNameToHome"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    [self doLogOut];
//                }
                
                // update by kate 2015.05.05-------------------------------------------------------------
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    NSDictionary *result = [FRNetPoolUtils isUnBind];
                    //isUnbind

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (result) {
                            if([[result objectForKey:@"result"] integerValue]!=1){

                                /*
                                NSString *baiduUserID = [userDefaults objectForKey:@"Baidu_UserID"];
                                NSString *baiduChannelID = [userDefaults objectForKey:@"Baidu_ChannelID"];
                                NSString *baiduAppID = [userDefaults objectForKey:@"Baidu_AppID"];

                                NSString *checkResult = [result objectForKey:@"result"];
                                NSString *uuid = [Utilities getUniqueUidWithoutQuit];

                                NSString *debugStr = [NSString stringWithFormat:@"%@_%@_%@_%@_%@", uuid, checkResult, baiduAppID, baiduChannelID, baiduUserID];
                                
                                //logout action
                                [self doWriteDebugLogCheckLogout:debugStr];*/

                                [[NSUserDefaults standardUserDefaults] setObject:@"logOut" forKey:@"fromNameToHome"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                [self doLogOut:[result objectForKey:@"message"]];
                            }else{//返回Yes是没有被T
                                
                                GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                                NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
                                NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
                                
                                if ([usertype integerValue] == 2 || [usertype integerValue] == 7 || [usertype integerValue] == 9) {
                                    
                                    [self changeTab3];
                                }
                                
                               
//                                NSDictionary *dic = [result objectForKey:@"message"];
//                                NSString *schoolType = [dic objectForKey:@"type"];
//                                NSString *oldType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"]];
//                                if (![schoolType isEqualToString:oldType]) {
//                                    
//                                    [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:@"schoolType"];
//                                    
//                                    if ([@"bureau" isEqualToString:schoolType]) {
//                                        if([Utilities getUniqueUid]){
//                                            
//                                            [self changeTab2];
//                                        }
//                                    }
//                                }
                            }
                        }
                
//                        if (!isUnbind) {
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"logOut" forKey:@"fromNameToHome"];
//                            [[NSUserDefaults standardUserDefaults]synchronize];
//                            [self doLogOut];
//                        }
                        //-----------------------------------------------------------------------------------

                    });
                });

            }
        }
    }else {
       
    }
}


// 获取学校类型 2015.05.27
-(void)getSchoolType{
    
    /**
     * 获取学校类型
     * @author luke
     * @date 2015.05.27
     * @args
     * ac=School, v=2, op=check, sid=
     */
    
    /*{
     "protocol": "SchoolAction.check",
     "result": true,
     "message": {
     "type": "senior",
     "special": false
     }
     }*/
    
    
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"School",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          G_SCHOOL_ID,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSString *schoolType = [dic objectForKey:@"type"];
            NSString *oldType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"]];
            
            if (![schoolType isEqualToString:oldType]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:@"schoolType"];
            }
            
            /*2015.10.29 教育局改版
             if ([@"bureau" isEqualToString:schoolType]) {
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
                
                if ([array count] >0) {
                    
                    UINavigationController *tempNav = (UINavigationController*)[array objectAtIndex:1];
                    NSArray *tempArray = tempNav.viewControllers;
                    
                    NSLog(@"tempArray:%@",tempArray);
                    
                    if ([[tempArray objectAtIndex:0] isKindOfClass:[SchoolListForBureauViewController class]]) {
                        
                    }else{
                        
                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"addMaskView" object:nil];
                        
                        if([Utilities getUniqueUidWithoutQuit]){
                            
                            [self changeTab2];
                        }
                    }
                }
                
                
            }*/
       
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
    
}

/*
 * 幼儿园版本红点检查接口
 * @author luke
 * @date 2016.03.16
 * @args
 *  v=3 ac=Kindergarten op=checkModules sid= cid= uid= app=
 */

-(void)checkAllRedPoints{
    
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
    
    if (uid) {
        
        NSString *app = [Utilities getAppVersion];

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Kindergarten",@"ac",
                              @"3",@"v",
                              @"checkModules", @"op",
                              app,@"app",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                
                NSDictionary *dic = [respDic objectForKey:@"message"];
                NSLog(@"新红点check接口返回:%@",dic);
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                
                
               NSString *lastForMoment;
                
                if ([defaultsDic count] == 0){
                    
                    if (dic) {
                        
                        NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *schoolLastDicDefault = [[NSMutableDictionary alloc] init];
                        //NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] init];
                        
                        NSArray *classArrayDefault = [dic objectForKey:@"classes"];
                        
                        for (int i=0; i<[classArrayDefault count]; i++) {
                            
                            NSString *mid = [NSString stringWithFormat:@"%@",[[classArrayDefault objectAtIndex:i] objectForKey:@"mid"]];
                            NSString *cid = [NSString stringWithFormat:@"%@",[[classArrayDefault objectAtIndex:i] objectForKey:@"cid"]];
                            NSString *last = [NSString stringWithFormat:@"%@",[[classArrayDefault objectAtIndex:i] objectForKey:@"last"]];
                            
                            NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                            [classLastDicDefault setObject:last forKey:keyStr];
                            
                        }
                        
                        NSArray *schoolDefault = [dic objectForKey:@"school"];
                        
                        for (int i=0; i<[schoolDefault count]; i++) {
                            
                            NSString *mid = [NSString stringWithFormat:@"%@",[[schoolDefault objectAtIndex:i] objectForKey:@"mid"]];
                            NSString *cid = [NSString stringWithFormat:@"%@",[[schoolDefault objectAtIndex:i] objectForKey:@"cid"]];
                            NSString *last = [NSString stringWithFormat:@"%@",[[schoolDefault objectAtIndex:i] objectForKey:@"last"]];
                            
                            NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                            [schoolLastDicDefault setObject:last forKey:keyStr];
                            
                        }
                        
//                        NSArray *spaceDefault = [dic objectForKey:@"spaces"];
//                        
//                        for (int i=0; i<[spaceDefault count]; i++) {
//                            
//                            NSString *mid = [NSString stringWithFormat:@"%@",[[spaceDefault objectAtIndex:i] objectForKey:@"mid"]];
//                            NSString *cid = [NSString stringWithFormat:@"%@",[[spaceDefault objectAtIndex:i] objectForKey:@"cid"]];
//                            NSString *last = [NSString stringWithFormat:@"%@",[[spaceDefault objectAtIndex:i] objectForKey:@"last"]];
//                            
//                            NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
//                            [spaceLastDicDefault setObject:last forKey:keyStr];
//                            
//                        }
                        
                        //NSArray *numberArrayDefault = [dic objectForKey:@"numbers"];
                        //NSArray *foundsArrayDefault = [dic objectForKey:@"founds"];
                        
                        [defaultsDic setObject:schoolLastDicDefault forKey:@"schoolLastDicDefault"];//学校本地字典数据
                        [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//班级本地字典数据
                        //[defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//空间本地字典数据
                        //[defaultsDic setObject:numberArrayDefault forKey:@"numbers"];//订阅号本地数组数据 为了拼接last不为了更新 不用动
                        //[defaultsDic setObject:foundsArrayDefault forKey:@"founds"];//发现本地数组数据 只有一个 先不动
                        [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                        [userDefaults synchronize];
                        
                    }
                    
                }else{
                    
                    if (dic) {
                        
                        [userDefaults setObject:dic forKey:@"alwaysNewsDic"];
                        [userDefaults synchronize];//存贮实时的最新的last
                        
                        // 如果模块增加 更新本地原有数据 增加新模块的数据 如果模块减少 不做处理 因为页面上看不见不影响红点
                        
                        NSArray *schoolArray = [dic objectForKey:@"school"];
                        NSArray *classArray = [dic objectForKey:@"classes"];
                        //NSArray *numberArray = [dic objectForKey:@"numbers"];
                        //NSArray *spacesArray = [dic objectForKey:@"spaces"];
                        //2.9.4
                        //NSArray *foundsArray = [dic objectForKey:@"founds"];
                        
                        //NSLog(@"defaultsDic:%@",defaultsDic);
                        
                        //NSMutableArray *numberArrayDefault = [[NSMutableArray alloc]initWithArray:[defaultsDic objectForKey:@"numbers"]];
                        //2.9.4
                         //NSMutableArray *foundsArrayDefault = [[NSMutableArray alloc]initWithArray:[defaultsDic objectForKey:@"founds"]];
                        
                        NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
                        NSMutableDictionary *schoolLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"schoolLastDicDefault"]];
                        //NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];

                        if ([schoolArray count] > [schoolLastDicDefault count]) {
                            
                            for (int i = 0 ; i<[schoolArray count]; i++) {
                                
                                //if (i > [schoolLastDicDefault count] -1 || [schoolLastDicDefault count] == 0) {
                                    
                                    NSString *mid = [NSString stringWithFormat:@"%@",[[schoolArray objectAtIndex:i] objectForKey:@"mid"]];
                                    NSString *cid = [NSString stringWithFormat:@"%@",[[schoolArray objectAtIndex:i] objectForKey:@"cid"]];
                                    NSString *last = [NSString stringWithFormat:@"%@",[[schoolArray objectAtIndex:i] objectForKey:@"last"]];
                                    
                                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                                
                                if ([schoolLastDicDefault objectForKey:keyStr]) {
                                    
                                }else{
                                    [schoolLastDicDefault setObject:last forKey:keyStr];
                                }
                                    
                                //}
                                
                            }
                            
                            [defaultsDic setObject:schoolLastDicDefault forKey:@"schoolLastDicDefault"];//转化成字典数据
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];
                            
                        }
                        
                        if ([classArray count] > [classLastDicDefault count]) {
                            
                            for (int i = 0 ; i<[classArray count]; i++) {
                                
                                //if (i > [classLastDicDefault count] -1 || [classLastDicDefault count] == 0) {
                                    
                                    NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                                    NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                                    NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
                                    
                                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                                if ([classLastDicDefault objectForKey:keyStr]) {
                                    
                                }else{
                                    [classLastDicDefault setObject:last forKey:keyStr];
                                }
                                    
                                //}
                                
                            }
                            
                            [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];

                        }
                        
                        /*if ([spacesArray count] > [spaceLastDicDefault count]) {
                            
                            for (int i = 0 ; i<[spacesArray count]; i++) {
                                
                                //if (i > [spaceLastDicDefault count] -1 || [spaceLastDicDefault count] == 0) {
                                    
                                    NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
                                    NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
                                    NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
                                    
                                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                                if ([spaceLastDicDefault objectForKey:keyStr]) {
                                    
                                }else{
                                    [spaceLastDicDefault setObject:last forKey:keyStr];
                                }
                                //}
                                
                            }
                            
                            [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];
                            
                        }
                        
                        if ([numberArray count] > [numberArrayDefault count]) {
                            
                            for (int i=0; i<[numberArray count]; i++) {
                                
                                NSDictionary *number = [numberArray objectAtIndex:i];
                                
                                if (i > [numberArrayDefault count]-1) {
                                    [numberArrayDefault addObject:number];
                                }
                                
                            }
                            
                            [defaultsDic setObject:numberArrayDefault forKey:@"numbers"];
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];
                        }
                        
                       
                        if ([foundsArray count] > [foundsArrayDefault count]) {
                            
                            for (int i=0; i<[foundsArray count]; i++) {
                                
                                NSDictionary *founds = [foundsArray objectAtIndex:i];
                                
                                if (i > [foundsArrayDefault count]-1) {
                                    [foundsArrayDefault addObject:founds];
                                }
                                
                            }
                            
                            [defaultsDic setObject:foundsArrayDefault forKey:@"founds"];
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];
                        }*/
                        
                    }
                }
                
               // 更新主画面红点
               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:dic];
                
                // 更新班级Tab红点
                //此时班级列表UI并没有画出 所以只能更新tab上的红点
                GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
                NSLog(@"userDetailInfo:%@",userDetailInfo);
                NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
                NSString *cid = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_cid"]];
                
                if([@"7"  isEqual: usertype] || [@"2" isEqual:usertype] || [@"9" isEqual:usertype])
                {
                    
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
                    if ([array count] > 0 ) {
                        UINavigationController *nav = [array objectAtIndex:1];
                        
                        if ([[nav.viewControllers objectAtIndex:0] isKindOfClass:[MyClassListViewController class]]) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:dic];
                            
                        }else{
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:dic];
                        }
                    }
                   
                }else{
                    
                    if([cid isEqualToString:@"0"]){
                        
                    }else{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassDetailNews" object:dic];
                        
                    }
                    
                }
                
                // 我的消息tab的红点 update 2016.2.22
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"checkMsgCenterNew" object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMsgCenterTabNew" object:nil];//2016.2.22
                
                if (dic) {
                    
                     NSArray *foundsArray = [dic objectForKey:@"classes"];
                    
                    for (int i=0; i<[foundsArray count]; i++) {
                        
                        NSDictionary *founds = [foundsArray objectAtIndex:i];
                        if ([[NSString stringWithFormat:@"%@",[founds objectForKey:@"type"]] isEqualToString:@"19"]) {
                            
                            lastForMoment = [founds objectForKey:@"last"];
                            
                             NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastMyNewMsgIdDic"]];
                             NSString *msgLastId = [Utilities replaceNull:[tempDic objectForKey:[Utilities getUniqueUid]]];
                             
                             if ([msgLastId isEqualToString:@""]) {
                             
                             [tempDic setObject:lastForMoment forKey:[Utilities getUniqueUid]];
                             [userDefaults setObject:tempDic forKey:@"lastMyNewMsgIdDic"];
                             [userDefaults synchronize];
                             
                             }
                             
                        }

                    }
                    
                }
                
                // 发现tab的红点
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"checkMomentsMsgNew" object:nil];
                
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
    
   
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //NSLog(@"aaa");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground"
                                                        object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"audioDone"
                                                        object:nil];
    
    // 数据上报 add by kate 2015.06.23
    [self doUploadReport];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cctvEnterBackground" object:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"aaa");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ReportObject event:ID_OPEN_APP];//2015.06.23
    
    //---add by kate 2015.04.08--------------------------------------------------------------------------
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *version = [userDefaults objectForKey:@"currentVersion"];
    
    if (version == nil || [currentVersion floatValue] > [version floatValue]) {
        
        // 这里写一些只在某个新版本更新时候需要做的一些特殊事情，比如db表结构变更之类。
        
        // version 2.3 to do -s
        // 变更了校园公告的表结构
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        NSString *uid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"uid"]]];
        
        if ([uid length] > 0) {
            [[NewsListDBDao getDaoInstance] deleteAllData];
            // 需要删除db文件
            [[NewsListDBDao getDaoInstance] deleteDBFile];
            [[NewsListDBDao getDaoInstance] releaseDB];
            [NewsListDBDao getDaoInstance];
            
            [[NewsDetailDBDao getDaoInstance] deleteAllData];
            // 同理
            [[NewsDetailDBDao getDaoInstance] deleteDBFile];
            [[NewsDetailDBDao getDaoInstance] releaseDB];
            [NewsDetailDBDao getDaoInstance];
            // version 2.3 to do -e
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastSubscribeNumDic"];// 2015.05.22

        [userDefaults setObject:currentVersion forKey:@"currentVersion"];
        
    }
    
    //-------------------------------------------------------------------------------------------------
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//iCon角标 要改
    
    [self performSelector:@selector(checkAllRedPoints) withObject:nil afterDelay:1];//check所有红点接口 2015.11.11
    
    [self performSelector:@selector(getSchoolType) withObject:nil afterDelay:2];
    
    
    // 登出 调接口判断是否登出
    // beck test code
//    [self performSelector:@selector(logOutForOtherDeviceOnLine) withObject:nil afterDelay:2];
    
    [self performSelector:@selector(getCustomTabTitle) withObject:nil afterDelay:2];
//    [self performSelector:@selector(getCustomFoundConfiguration) withObject:nil afterDelay:0.1];

//    // 更新主画面new图标 移动到checkAllRedPoints方法中 2015.11.11
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
    // 每次启动重新获取个人资料 add by kate
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {//add 2015.07.08 聊天页文本消息消失问题先这么解决
        
        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
        if([viewName isEqualToString:@"MsgDetailsView"]){
            // 更新聊天详情画面
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
        }else if ([viewName isEqualToString:@"GroupChatDetailView"]){
            // 更新群聊聊天详情页
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP object:nil];
            
        }
    }
    
    NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
    
    if (0 == [userDetailDic count]) {
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        
        if (uid) {
            
            NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_isNewVersionPopupShow"];
            
            if (([@"0"  isEqual: isNewVersion]) || (nil == isNewVersion)) {
                [self performSelector:@selector(doCheckVersion) withObject:nil afterDelay:0.1];
            }
        }

    }else {
        
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        
        if (uid) {
            
            NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_isNewVersionPopupShow"];
            
            if (([@"0"  isEqual: isNewVersion]) || (nil == isNewVersion)) {
              [self performSelector:@selector(doCheckVersion) withObject:nil afterDelay:0.1];
            }
        }
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reflashUserProfile" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:self userInfo:nil];

}

// add by kate 2015.05.27
-(void)changeTab2{
    
    /*2015.10.29 教育局改版
     SchoolListForBureauViewController *schoolListBureau = [[SchoolListForBureauViewController alloc]init];
    schoolListBureau.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:schoolListBureau];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [array replaceObjectAtIndex:1 withObject:customizationNavi];
    [self.tabBarController setViewControllers:array];*/
    
}

//2.9.4
-(void)changeTab3{
    
    MomentsEntranceForTeacherController *schoolListBureau = [[MomentsEntranceForTeacherController alloc]init];
    schoolListBureau.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:schoolListBureau];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [array replaceObjectAtIndex:2 withObject:customizationNavi];
    [self.tabBarController setViewControllers:array];
    
}

-(void)doCheckVersion
{
    NSString *uid = [Utilities getUniqueUidWithoutQuit];

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Version",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          @"2", @"os",
                          uid,@"uid",
                          currentVersion, @"name",
                          nil];

    network = [NetworkUtility alloc];
    network.delegate = self;

    [network sendHttpReq:HttpReq_Version andData:data];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersionPopupShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)doGetSplash
{
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Splash",@"ac",
                          @"2",@"v",
                          @"fetch", @"op",
                          @"2", @"os",
                          uid, @"uid",
                          nil];

    network = [NetworkUtility alloc];

    network.delegate = self;
    [network sendHttpReq:HttpReq_GetSplash andData:data];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if (type == HttpReq_BindServer) {
        if(true == [result intValue]){
            NSLog(@"绑定成功");
        }else{
            NSLog(@"绑定失败");
        }
        
    }else if([@"VersionAction.check"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        __block MicroSchoolAppDelegate *blockSelf = self;
        
        if(true == [result intValue]) {
            // 容错性更改
            NSString *code = [message_info objectForKey:@"code"];
            NSString *note= [message_info objectForKey:@"note"];
            NSString *uptype= [message_info objectForKey:@"type"];
            self->updateUrl = [message_info objectForKey:@"url"];

            int currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue];
            
            if([code intValue] > currentVersion) {
                
                //settingNew
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"settingNew" object:@"1"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"zhixiao_isNewVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (1 == [uptype intValue]) {
                    
                    if (checkUpdateAlert == nil){
                  
                //------update by kate 2014.11.04-----------------------------------------------------
                        
                        /*checkUpdateAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                     message:note
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:@"取消",nil];*/
                        
                        
                        checkUpdateAlert = [[CXAlertView alloc]initWithTitle:@"版本更新" message:note cancelButtonTitle:nil];
                        [checkUpdateAlert addButtonWithTitle:@"暂不更新"
                                                 type:CXAlertViewButtonTypeDefault
                                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                  // Dismiss alertview
                                                  [alertView dismiss];
                                                  blockSelf->checkUpdateAlert = nil;
                                              }];
                        
                        // This is a demo for changing content at realtime.
                        [checkUpdateAlert addButtonWithTitle:@"立即更新"
                                                 type:CXAlertViewButtonTypeCancel
                                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                  
                                                  NSURL *url = [[NSURL alloc]initWithString:blockSelf->updateUrl];
                                                  [[UIApplication sharedApplication ]openURL:url];
                                                  
                                                  [alertView dismiss];

                                                  blockSelf->checkUpdateAlert = nil;
                                              }];
                        
                        
                        
                        [checkUpdateAlert show];
                        
                    }
                    
                    //checkUpdateAlert.message = note;
                    //checkUpdateAlert.tag = 122;
                   
                    
                //---------------------------------------------------------------------------------
                    
                }else {
                    if (checkUpdateAlert == nil) {
                  //------update by kate 2014.11.04-----------------------------------------------------
                        
//                        checkUpdateAlert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                                     message:note
//                                                                    delegate:self
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
                        
                        checkUpdateAlert = [[CXAlertView alloc]initWithTitle:@"版本更新" message:note cancelButtonTitle:nil];
                        
                        // This is a demo for changing content at realtime.
                        [checkUpdateAlert addButtonWithTitle:@"立即更新"
                                                        type:CXAlertViewButtonTypeDefault
                                                     handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                         
                                                         [alertView dismiss];

                                                         blockSelf->checkUpdateAlert = nil;
                                                         
                                                         NSURL *url = [[NSURL alloc]initWithString:blockSelf->updateUrl];
                                                         [[UIApplication sharedApplication ]openURL:url];
                                                         
                                                     }];
                        
                        
                        [checkUpdateAlert show];
                        
                    }
                    
                    //checkUpdateAlert.message = note;
                    //checkUpdateAlert.tag = 122;
                   
                    
                //--------------------------------------------------------------------------------------
                    
                }
            }else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"settingNew" object:@"0"];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 更新左侧栏红点---add 2016.04.27
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leftViewReloadRedPoint" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashschoolHomeRedPoint" object:self userInfo:nil];
            }
        }else {
            // nothing
        }
    }else if([@"SplashAction.fetch"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSString* picUrl = [message_info objectForKey:@"picUrl"];
            NSString* startTime = [message_info objectForKey:@"startTime"];
            NSString* endTime = [message_info objectForKey:@"endTime"];
            
            double end = endTime.integerValue;
            double start = startTime.integerValue;
            
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            double now = time;      //NSTimeInterval返回的是double类型
            
            if ((now <= end) && (now >= start)) {
                NSString *splash_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_splash_url"];
                if ((splash_url != picUrl)) {
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:picUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         
                     } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                     {
                         if (image && finished) {
                             // 保存图片的url，以便下次判断url是否更新。
                             [[NSUserDefaults standardUserDefaults] setObject:picUrl forKey:@"zhixiao_splash_url"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"weixiao_splash_image"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                     }];
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_splash_image"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } else {
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122) {
        if (buttonIndex == 0) {
            NSURL *url = [[NSURL alloc]initWithString:self->updateUrl];
            [[UIApplication sharedApplication ]openURL:url];
        }else{
        }
    }
}

/*
 * 绑定百度云推送-kate
 */
- (void)bindBaiduPush
{
    if (!_isRemoteNotification) {
        [BPush unbindChannel];
        _isRebindBaidu = YES;
        
        _isRemoteNotification = NO;
    }

    
//    [self performSelector:@selector(doBindBaiduPush) withObject:nil afterDelay:0.2f];

//    [BPush bindChannel];

}

- (void)doBindBaiduPush
{
    [BPush bindChannel];
    
}
/*
 * 解除绑定百度云推送-kate
 */

-(void)unbindBaiduPush{
    
    [BPush unbindChannel];
}

//----add by kate 2014.05.04-----------------------------
#pragma mark get message from server

// 启动时间泵
- (void)startMsgTimer
{
    //创建Timer
    getMsgTimer = [NSTimer timerWithTimeInterval:getMsgTimeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中
    [[NSRunLoop currentRunLoop] addTimer:getMsgTimer forMode:NSRunLoopCommonModes];
}

- (void)timerFired
{
    
    /* 以下为老苗 2015.07.01发的邮件里的内容
     针对luke昨晚提出的，聊天功能调取接口频率过高的问题，内部讨论后，给出了一个动态拉取消息策略，大家看如果没有问题就先按照此方案实现，正式环境下个版本更新后再对比效果：
     
     消息动态拉取策略：
     
     1. 在聊天页面：5s/次；
     2. 不在聊天页面，但还在app内部：
     2.1 开始15s/次；
     2.2 15s内无消息，延至30s/次
     2.3 30s内无消息，延至60s/次
     2.4 60s内无消息，延至180s/次
     
     以上，如果某阶段内收到消息了，则恢复到2.1->2.4；如果没有，最多开始180s/次请求。
     
     3. 程序退到后台或关闭 ，则靠推送显示消息，不再主动拉取消息；
     
     额外，程序返回到前台或启动到首页，默认拉取一次消息。
     */
    
    // update by kate 2015.07.03
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isDB_Done = [userDefaults boolForKey:@"DB_DONE"];
    
    
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    // NSLog(@"viewName:%@",viewName);
    
    
    if([viewName isEqualToString:@"MsgDetailsMixView"]){
        // 聊天详情画面
        interval = TIMER_PUMP_SHORT;
        
    }else if ([viewName isEqualToString:@"MsgListMixView"]){
        // 聊天列表画面
        interval = TIMER_PUMP_SHORT;
    }else{
        interval = TIMER_PUMP_LONG;
    }
    
    if (isDB_Done) {
        
        //接收新版聊天消息
        [self getMsg];
        
        if (getMsgTimeInterval != interval) {
            getMsgTimeInterval = interval;
            [getMsgTimer invalidate];
            [self startMsgTimer];
        }
        //NSLog(@"getMsgTimeInterval");
    }
}

-(NSInteger)getMsg{
    
    /**
     * 消息拉取
     * @author luke
     * @date 2016.01.14
     * @args
     *  v=3, ac=Message, op=messages, sid=, cid=, uid=,  last=消息ID
     */
    /**
     * 消息拉取
     * 2016.07.05 结构体添加字段:position 0 管理 1 普通 2 班级
     * 2016.07.05 结构体添加字段:target, 消息at某些人的uid,...
     * @author luke
     * @date 2016.01.14
     * @args
     *  v=3, ac=Message, op=messages, sid=, cid=, uid=
     */
    
    // 单独存放最后一条消息mid，每次接收消息更新它
    NSString *myUserId = [Utilities getUniqueUidWithoutQuit];
    NSString *last = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
    if (!last) {
        last = @"0";
    }
    
    //  long long tempLast = [last longLongValue];
    count = 0;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Message",@"ac",
                          @"3",@"v",
                          @"messagesWithLastID", @"op",
                          nil];
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        long long tempLast = [last longLongValue];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        //NSLog(@"respDic0:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            //            //-----------------------------------------------------------------
            //            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            //            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //            [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
            //            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            //            NSLog(@"step 2:%@",dateString);
            //             [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"step2"];
            //            //------------------------------------------------------------------
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            
            NSArray *message = [dic objectForKey:@"list"];
            
            count = [message count];
            
            NSString *isRead = [NSString stringWithFormat:@"%@",[dic objectForKey:@"last"]];
            
            
            if (count > 0) {
//                // 更新主页单聊数字
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
                
                if([viewName isEqualToString:@"MsgDetailsMixView"]){
                    // 聊天详情画面
                    interval = TIMER_PUMP_SHORT;
                    
                }else if ([viewName isEqualToString:@"MsgListMixView"]){
                    // 聊天列表画面
                    interval = TIMER_PUMP_SHORT;
                }else{
                    interval = TIMER_PUMP_LONG;//收到消息恢复15秒拉取
                }
                
            }else{//add 2015.07.03
                
                if(![viewName isEqualToString:@"MsgDetailsMixView"] && ![viewName isEqualToString:@"MsgListMixView"]){
                    // 聊天详情画面
                    if (interval == TIMER_PUMP_LONG){
                        interval = TIMER_PUMP_LONGER;
                    }else if (interval == TIMER_PUMP_LONGER){
                        interval = TIMER_PUMP_LONGERR;
                    }else if (interval == TIMER_PUMP_LONGERR){
                        interval = TIMER_PUMP_LONGEREST;
                    }
                    
                }
            }
            
            for(int i=0;i<[message count];i++){
                
                NSDictionary *msg = [message objectAtIndex:i];
                //long long userid = [[msg objectForKey:@"uid"] longLongValue];
                long long userid = [[msg objectForKey:@"friend"] longLongValue];//就是原来的fuid
                //NSLog(@"userid:%lli",userid);
                long long uid = [[msg objectForKey:@"uid"] longLongValue];//发送者
                long long myUid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
                NSString *userName = [msg objectForKey:@"name"];// 群聊列表显示的人名
                //NSString *title = [msg objectForKey:@"title"];
                NSString *gid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"gid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"mid"]];
                long long lastMid = [mid longLongValue];
                //long long type = [[msg objectForKey:@"position"] longLongValue];//群聊类型
                long long cid = [[msg objectForKey:@"cid"] longLongValue];//班级
                
                NSString *audioSize = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"size"]]];//add 2011.11.03 2.9.1新需求
                if (lastMid > tempLast) {
                    tempLast = lastMid;
                }
                //---2017.02.28--------------------------------
                
                // 单聊这里应该返回的sid不对
                long long schoolID = [[NSString stringWithFormat:@"%@",[msg objectForKey:@"sid"]] longLongValue];
                NSString *schoolName = [msg objectForKey:@"sname"];
                // 参数返回增加 fsid, fname 对应friend
                //-------------------------------------------------------
                // 更新数据库
                MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
                chatDetail.uid = myUid;
                // 消息的msgID
                chatDetail.msg_id = [[msg objectForKey:@"msgid"] longLongValue];
                if ([gid integerValue] == 0) {//单聊
                    if (myUid == userid) {//如果相同那么userid就是自己 friend收信人
                        chatDetail.user_id = uid;
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                        
                        if ([isRead isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                            
                        }
                        
                    }else if(myUid == uid){//如果相同那么uid就是自己
                        chatDetail.user_id = userid;
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_SEND;
                        
                        if ([isRead isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_SEND_SUCCESS;
                        }
                    }else{
                        continue;
                    }
                }else{//群聊
                    
                    chatDetail.user_id = uid;
                    if(myUid == uid){//如果相同那么uid就是自己
                        
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_SEND;
                        
                        if ([isRead isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_SEND_SUCCESS;
                        }
                    }else{
                        
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                        
                        if ([isRead isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                        }
                        
                    }
                    
                }
                
                chatDetail.userName = userName;//add 2015.07.17
                //消息类型-文本
                NSInteger msgType = [[msg objectForKey:@"type"] integerValue];
                if (msgType == 10 || msgType == 12 ) {
                    chatDetail.msg_type = 3;
                }else if (msgType == 13){
                    chatDetail.msg_type = 4;
                }else if (msgType == 14){
                    chatDetail.msg_type = 5;
                }else{
                    chatDetail.msg_type = msgType;
                }
                
                // 消息内容
                if (chatDetail.msg_type == MSG_TYPE_PIC) {
                    chatDetail.msg_content = @"[图片]";
                    
#if 1
                    NSString *url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_thumb = [NSString stringWithFormat:@"%@%@",url,@"@240w_1l.png"];
                    chatDetail.pic_url_original = url;
#else
                    // 原始图片文件的HTTP-URL地址
                    chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
#endif
                    
                }else if(chatDetail.msg_type == MSG_TYPE_Audio){
                    chatDetail.msg_content = @"[语音]";
                    chatDetail.audio_url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.audioSecond = [audioSize integerValue];//add 2011.11.03 2.9.1新需求
                }else {
                    chatDetail.msg_content = [Utilities replaceNull:[msg objectForKey:@"message"]];
                    NSLog(@"msgContent:%@",[Utilities replaceNull:[msg objectForKey:@"message"]]);
                }
                
                //done: at某人
                NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
                //NSString *username = [userInfo objectForKey:@"username"];//用户名
                
                // 文件名（语音，图片，涂鸦）
                chatDetail.msg_file = @"";
                NSString *timestampStr = [Utilities replaceNull:[msg objectForKey:@"timestamp"]];
                chatDetail.timestamp = [timestampStr longLongValue]*1000;
                //NSLog(@"timestamp:%lli",chatDetail.timestamp);
                chatDetail.groupid = [[Utilities replaceNull:gid] longLongValue];
                chatDetail.headimgurl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"avatar"]]];
                //---2017.02.28--------------------------------
                chatDetail.schoolID = schoolID;
                chatDetail.schoolName = schoolName;
                //--------------------------------------------------
                [chatDetail updateToDB];
                
                MixChatListObject *chatList = [[MixChatListObject alloc] init];
                chatList.gid = chatDetail.groupid;
                chatList.is_recieved = chatDetail.is_recieved;
                chatList.mid = mid;
                //chatList.type = type;
                chatList.cid = cid;
                
                
                //最后一条消息ID
                //if (chatDetail.msg_id > chatList.last_msg_id) {
                
                chatList.last_msg_id = chatDetail.msg_id;
                
                if ([gid integerValue] == 0) {//单聊
                    
                    chatList.last_msg = chatDetail.msg_content;
                    
                }else{//群聊
                    
                    NSString *name = [NSString stringWithFormat:@"@%@",[userInfo objectForKey:@"name"]];//显示的名字
                    if ([chatDetail.msg_content rangeOfString:name].location == NSNotFound) {
                        
                    }else{
                        
                        if (chatList.is_recieved == 1) {
                            
                            if(![viewName isEqualToString:@"MsgDetailsMixView"]){
                                chatList.at_state = 1;//在聊天详情页不存at
                            }
                            
                        }
                        
                    }
                    
                    if(myUid == uid){
                        
                        chatList.last_msg = chatDetail.msg_content;
                        
                    }else{
                        
                        // 聊天的最后一条消息内容
                        if (msgType!= 10 && msgType!= 12 && msgType!= 13 && msgType!= 14) {
                            
                            chatList.last_msg = [NSString stringWithFormat:@"%@:%@",chatDetail.userName,chatDetail.msg_content];
                            //chatList.last_msg = title;
                            
                        }else{//系统消息
                            chatList.last_msg = chatDetail.msg_content;
                            
                        }
                    }
                }
                
                //}
                // 聊天的最后一条消息的类型
                chatList.last_msg_type= chatDetail.msg_type;
                
                //该条消息状态
                chatList.msg_state = chatDetail.msg_state;
                if([gid integerValue] == 0){
                    chatList.user_id = chatDetail.user_id;
                }else{
                    chatList.user_id = 0;
                }
                
                //时间戳
                chatList.timestamp = chatDetail.timestamp;
                
                if ([userName length] > 0) {
                    chatList.title = userName;
                } else {
                    chatList.title = NO_NAME_USER;
                }
                
                NSLog(@"lastMsg:%@",chatList.last_msg);
                
                //---2017.02.28--------------------------------
                
                if ([gid longLongValue] == 0) {
                    chatList.schoolID = schoolID;
                    chatList.schoolName = schoolName;
                }
                
                if (![chatList isExistInDB]) {
                    
                }else{
                    
                    if([chatList isStick]){
                        chatList.stick = chatList.timestamp;
                    }
                }
                //------------------------------------------------------
                
                BOOL isExist = [chatList updateToDB];
                
                // 获取群头像url存在一个数据表中，判断chatList中是否有gid了，如果没有就拉取群头像，有就不拉
                if (!isExist) {//不存在
                    
                    if(chatDetail.groupid > 0){//群聊
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"GroupChat",@"ac",
                                              @"2",@"v",
                                              @"getGroupAvatar", @"op",
                                              [NSString stringWithFormat:@"%lli",chatList.gid],@"gid",
                                              nil];
                        
                        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                            
                            NSDictionary *respDic = (NSDictionary*)responseObject;
                            NSString *result = [respDic objectForKey:@"result"];
                            
                            if(true == [result intValue]) {
                                
                                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
                                //name 群名字
                                NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
                                chatList.title = groupName;
                                [chatList updateGroupName];//更新群名字
                                
                                GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
                                headObject.gid = chatList.gid;
                                [headObject deleteData];
                                
                                for (int i =0; i<[tempArray count]; i++) {
                                    
                                    long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                                    NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                                    NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                                    
                                    headObject.user_id = headUid;
                                    headObject.headUrl = headUrl;
                                    headObject.name = name;
                                    [headObject insertData];
                                    
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];
                                });
                                
                            }
                            
                            
                        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                            
                        }];
                        
                    }
                    
                }
                
                // 如果有图片资源此处需要开线程下载图片，此时先拉取缩略图，点击查看大图时再拉取大图
                if ([chatDetail.pic_url_thumb length] > 0) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:chatDetail.user_id msgid:chatDetail.msg_id];
                        //}
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                        });
                        
                        
                    });
                    
                    
                }
                if([chatDetail.audio_url length] > 0){
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        {
                            
                            BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //---update 2015.07.07-----------------------------------------------
                                if (isGot) {
                                    
                                    NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                                    NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                                    
                                    NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                                    
                                    if ([audioSize length]>0 && [audioSize integerValue]!=0) {
                                        
                                    }else{
                                        
                                        RecordAudio *recordAudio = [[RecordAudio alloc] init];
                                        
                                        NSInteger audioSecond = [recordAudio dataDuration:fileData];
                                        chatDetail.audioSecond = audioSecond;
                                        [chatDetail updateAudio];
                                    }
                                    
                                    if (fileData == nil || [fileData length] == 0){
                                        
                                    }else{
                                        chatDetail.audio_r_status = 1;
                                        [chatDetail updateRAudioState];
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOT_CHAT_REFRESH object:chatDetail];
                                    }
                                    
                                }
                                //--------------------------------------------------------------------
                                
                            });
                            
                        }
                        
                        
                    });
                    
                }
                
            }
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count > 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知画面刷新
                    [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                });
                
                /**
                 * 更新聊天记录(群聊,单聊)lastID,
                 * 保存客户端读取的最后消息, 用于拉取消息接口
                 * @author luke
                 * @date 2016.07.12
                 * @args
                 *      v=3 ac=Message op=read sid= uid= last=消息ID
                 *///2016.07.12
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"Message",@"ac",
                                      @"3",@"v",
                                      @"read", @"op",
                                      [NSString stringWithFormat:@"%lli",tempLast],@"last",
                                      nil];
                //NSLog(@"data:%@",data);
                [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                    
                    NSLog(@"success");
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                    
                }];
                
                
            }
            
            //});
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%lli",tempLast] forKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
            [defaults synchronize];
            
        }else{
            
            if(![viewName isEqualToString:@"MsgDetailsMixView"] && ![viewName isEqualToString:@"MsgListMixView"]){
                // 聊天详情画面
                if (interval == TIMER_PUMP_LONG){
                    interval = TIMER_PUMP_LONGER;
                }else if (interval == TIMER_PUMP_LONGER){
                    interval = TIMER_PUMP_LONGERR;
                }else if (interval == TIMER_PUMP_LONGERR){
                    interval = TIMER_PUMP_LONGEREST;
                }
                
            }
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        if(![viewName isEqualToString:@"MsgDetailsMixView"] && ![viewName isEqualToString:@"MsgListMixView"]){
            // 聊天详情画面
            if (interval == TIMER_PUMP_LONG){
                interval = TIMER_PUMP_LONGER;
            }else if (interval == TIMER_PUMP_LONGER){
                interval = TIMER_PUMP_LONGERR;
            }else if (interval == TIMER_PUMP_LONGERR){
                interval = TIMER_PUMP_LONGEREST;
            }
            
        }
        
    }];
    
    return count;
}

#if 0
// 2016.01.19
//done:接收新版聊天消息
-(NSInteger)getMsg{
    
    /**
     * 消息拉取
     * @author luke
     * @date 2016.01.14
     * @args
     *  v=3, ac=Message, op=messages, sid=, cid=, uid=,  last=消息ID
     */
    // 单独存放最后一条消息mid，每次接收消息更新它
    NSString *myUserId = [Utilities getUniqueUidWithoutQuit];
    NSString *last = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
    if (!last) {
        last = @"0";
    }
    
    //  long long tempLast = [last longLongValue];
    count = 0;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Message",@"ac",
                          @"3",@"v",
                          @"messages", @"op",
                          last,@"last",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        long long tempLast = [last longLongValue];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic0:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            NSArray *message = [respDic objectForKey:@"message"];
            
            count = [message count];
            
            NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
            if (count > 0) {
                // 更新主页单聊数字
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
                
                if([viewName isEqualToString:@"MsgDetailsMixView"]){
                    // 聊天详情画面
                    interval = TIMER_PUMP_SHORT;
                    
                }else if ([viewName isEqualToString:@"MsgListMixView"]){
                    // 聊天列表画面
                    interval = TIMER_PUMP_SHORT;
                }else{
                    interval = TIMER_PUMP_LONG;//收到消息恢复15秒拉取
                }
                
            }else{//add 2015.07.03
                
                if(![viewName isEqualToString:@"MsgDetailsMixView"] && ![viewName isEqualToString:@"MsgListMixView"]){
                    // 聊天详情画面
                    if (interval == TIMER_PUMP_LONG){
                        interval = TIMER_PUMP_LONGER;
                    }else if (interval == TIMER_PUMP_LONGER){
                        interval = TIMER_PUMP_LONGERR;
                    }else if (interval == TIMER_PUMP_LONGERR){
                        interval = TIMER_PUMP_LONGEREST;
                    }
                    
                }
            }
            
            for(int i=0;i<[message count];i++){
                
                NSDictionary *msg = [message objectAtIndex:i];
                //long long userid = [[msg objectForKey:@"uid"] longLongValue];
                long long userid = [[msg objectForKey:@"friend"] longLongValue];//就是原来的fuid
                //NSLog(@"userid:%lli",userid);
                long long uid = [[msg objectForKey:@"uid"] longLongValue];//发送者
                long long myUid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
                NSString *userName = [msg objectForKey:@"name"];// 群聊列表显示的人名
                NSString *title = [msg objectForKey:@"title"];
                NSString *gid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"gid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"mid"]];
                long long lastMid = [mid longLongValue];
                NSString *audioSize = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"size"]]];//add 2011.11.03 2.9.1新需求
                if (lastMid > tempLast) {
                    tempLast = lastMid;
                }
                
                // 更新数据库
                MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
                // 消息的msgID
                chatDetail.msg_id = [[msg objectForKey:@"msgid"] longLongValue];
                if ([gid integerValue] == 0) {//单聊
                    if (myUid == userid) {//如果相同那么userid就是自己 friend收信人
                        chatDetail.user_id = uid;
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                        
                        if ([last isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                            
                        }
                        
                    }else if(myUid == uid){//如果相同那么uid就是自己
                        chatDetail.user_id = userid;
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_SEND;
                        
                        if ([last isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_SEND_SUCCESS;
                        }
                    }else{
                        continue;
                    }
                }else{//群聊
                    
                    chatDetail.user_id = uid;
                    if(myUid == uid){//如果相同那么uid就是自己
                        
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_SEND;
                        
                        if ([last isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_SEND_SUCCESS;
                        }
                    }else{
                        
                        // 消息的发送(0)接收(1)区分
                        chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                        
                        if ([last isEqualToString:@"0"]) {
                            chatDetail.msg_state = MSG_READ_FLG_READ;
                            
                        }else{
                            // 消息状态：发送，已读，未读，失败等
                            chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                            
                        }
                        
                    }
                    
                    
                }
                
                chatDetail.userName = userName;//add 2015.07.17
                //消息类型-文本
                NSInteger msgType = [[msg objectForKey:@"type"] integerValue];
                if (msgType == 10 || msgType == 12 ) {
                    chatDetail.msg_type = 3;
                }else if (msgType == 13){
                    chatDetail.msg_type = 4;
                }else if (msgType == 14){
                    chatDetail.msg_type = 5;
                }else{
                    chatDetail.msg_type = msgType;
                }
                
                // 消息内容
                if (chatDetail.msg_type == MSG_TYPE_PIC) {
                    chatDetail.msg_content = @"[图片]";
                    
#if 1
                    NSString *url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_thumb = [NSString stringWithFormat:@"%@%@",url,@"@240w_1l.png"];
                    chatDetail.pic_url_original = url;
#else
                    // 原始图片文件的HTTP-URL地址
                    chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
#endif
                    
                }else if(chatDetail.msg_type == MSG_TYPE_Audio){
                    chatDetail.msg_content = @"[语音]";
                    chatDetail.audio_url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.audioSecond = [audioSize integerValue];//add 2011.11.03 2.9.1新需求
                }else {
                    chatDetail.msg_content = [Utilities replaceNull:[msg objectForKey:@"message"]];
                    NSLog(@"msgContent:%@",[Utilities replaceNull:[msg objectForKey:@"message"]]);
                }
                
                // 文件名（语音，图片，涂鸦）
                chatDetail.msg_file = @"";
                NSString *timestampStr = [Utilities replaceNull:[msg objectForKey:@"timestamp"]];
                chatDetail.timestamp = [timestampStr longLongValue]*1000;
                //NSLog(@"timestamp:%lli",chatDetail.timestamp);
                chatDetail.groupid = [[Utilities replaceNull:gid] longLongValue];
                chatDetail.headimgurl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"avatar"]]];
                [chatDetail updateToDB];
                
                MixChatListObject *chatList = [[MixChatListObject alloc] init];
                //chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", userid];
                //chatList.cid = chatDetail.cid;
                chatList.gid = chatDetail.groupid;
                chatList.is_recieved = chatDetail.is_recieved;
                chatList.mid = mid;
                //最后一条消息ID
                //if (chatDetail.msg_id > chatList.last_msg_id) {
                
                chatList.last_msg_id = chatDetail.msg_id;
                
                if ([gid integerValue] == 0) {//单聊
                    
                    chatList.last_msg = chatDetail.msg_content;
                    
                }else{//群聊
                    
                    if(myUid == uid){
                        
                        chatList.last_msg = chatDetail.msg_content;
                        
                    }else{
                        
                        // 聊天的最后一条消息内容
                        if (msgType!= 10 && msgType!= 12 && msgType!= 13 && msgType!= 14) {
                            
                            chatList.last_msg = [NSString stringWithFormat:@"%@:%@",userName,chatDetail.msg_content];
                            //chatList.last_msg = title;
                            
                        }else{//系统消息
                            chatList.last_msg = chatDetail.msg_content;
                            
                        }
                    }
                }
                
                
                //}
                // 聊天的最后一条消息的类型
                chatList.last_msg_type= chatDetail.msg_type;
                
                //该条消息状态
                chatList.msg_state = chatDetail.msg_state;
                if([gid integerValue] == 0){
                    chatList.user_id = chatDetail.user_id;
                }else{
                    chatList.user_id = 0;
                }
                
                //时间戳
                chatList.timestamp = chatDetail.timestamp;
                
                if ([userName length] > 0) {
                    chatList.title = userName;
                } else {
                    chatList.title = NO_NAME_USER;
                }
                
                NSLog(@"lastMsg:%@",chatList.last_msg);
                
                BOOL isExist = [chatList updateToDB];
                
                // 获取群头像url存在一个数据表中，判断chatList中是否有gid了，如果没有就拉取群头像，有就不拉
                if (!isExist) {//不存在
                    
                    if(chatDetail.groupid > 0){//群聊
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"GroupChat",@"ac",
                                              @"2",@"v",
                                              @"getGroupAvatar", @"op",
                                              [NSString stringWithFormat:@"%lli",chatList.gid],@"gid",
                                              nil];
                        
                        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                            
                            NSDictionary *respDic = (NSDictionary*)responseObject;
                            NSString *result = [respDic objectForKey:@"result"];
                            
                            if(true == [result intValue]) {
                                
                                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
                                //name 群名字
                                NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
                                chatList.title = groupName;
                                [chatList updateGroupName];//更新群名字
                                
                                GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
                                headObject.gid = chatList.gid;
                                [headObject deleteData];
                                
                                for (int i =0; i<[tempArray count]; i++) {
                                    
                                    long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                                    NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                                    NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                                    
                                    headObject.user_id = headUid;
                                    headObject.headUrl = headUrl;
                                    headObject.name = name;
                                    [headObject insertData];
                                    
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];
                                });
                                
                            }
                            
                            
                        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                            
                        }];
                        
                    }
                    
                }
                
                // 如果有图片资源此处需要开线程下载图片，此时先拉取缩略图，点击查看大图时再拉取大图
                if ([chatDetail.pic_url_thumb length] > 0) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //                            if (chatDetail.user_id == 0) {
                        //                                // get message from server
                        //                                [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:myUid msgid:chatDetail.msg_id];
                        //                            }else{
                        
                        [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:chatDetail.user_id msgid:chatDetail.msg_id];
                        //}
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                        });
                        
                        
                    });
                    
                    
                }
                if([chatDetail.audio_url length] > 0){
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        
                        /*if (chatDetail.user_id == 0) {
                         
                         BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:myUid msgid:chatDetail.msg_id];
                         dispatch_async(dispatch_get_main_queue(), ^{
                         
                         //---update 2015.07.07-----------------------------------------------
                         if (isGot) {
                         
                         if ([audioSize length]>0 && [audioSize integerValue]!=0) {
                         
                         }else{
                         RecordAudio *recordAudio = [[RecordAudio alloc] init];
                         
                         NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                         NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                         
                         NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                         NSInteger audioSecond = [recordAudio dataDuration:fileData];
                         chatDetail.audioSecond = audioSecond;
                         [chatDetail updateAudio];
                         }
                         
                         
                         }
                         //--------------------------------------------------------------------
                         
                         });
                         
                         }else*/{
                             
                             BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 //---update 2015.07.07-----------------------------------------------
                                 if (isGot) {
                                     
                                     if ([audioSize length]>0 && [audioSize integerValue]!=0) {
                                         
                                     }else{
                                         RecordAudio *recordAudio = [[RecordAudio alloc] init];
                                         
                                         NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                                         NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                                         
                                         NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                                         NSInteger audioSecond = [recordAudio dataDuration:fileData];
                                         chatDetail.audioSecond = audioSecond;
                                         [chatDetail updateAudio];
                                     }
                                     
                                     
                                 }
                                 //--------------------------------------------------------------------
                                 
                             });
                             
                         }
                        
                        //BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                        
                        //                            dispatch_async(dispatch_get_main_queue(), ^{
                        //
                        //                                //---update 2015.07.07-----------------------------------------------
                        //                                if (isGot) {
                        //
                        //                                    if ([audioSize length]>0 && [audioSize integerValue]!=0) {
                        //
                        //                                    }else{
                        //                                        RecordAudio *recordAudio = [[RecordAudio alloc] init];
                        //
                        //                                        NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                        //                                        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                        //
                        //                                        NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                        //                                        NSInteger audioSecond = [recordAudio dataDuration:fileData];
                        //                                        chatDetail.audioSecond = audioSecond;
                        //                                        [chatDetail updateAudio];
                        //                                    }
                        //
                        //
                        //                                }
                        //                                //--------------------------------------------------------------------
                        //
                        //                            });
                        
                        
                    });
                    
                }
                
            }
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count > 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知画面刷新
                    [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                });
                
            }
            
            //});
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%lli",tempLast] forKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
            [defaults synchronize];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
    
    return count;
}
#endif

#if 0
// 2015.06.01
-(NSInteger)getGroupMsg{
    
    /*
     * 接收聊天消息
     * @author luke
     * @date    2015.05.26
     * @args
     *  op=receive, sid=, uid=
     */
    
    count = 0;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"receive", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic0:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            NSMutableArray *lasMsgIdArray = [[NSMutableArray alloc] init];//存储lasmsgid的数组用于更新群已读消息
            
            NSArray *message = [respDic objectForKey:@"message"];
            
            count = [message count];
            
             NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
            if (count > 0) {
                
                if ([@"ClassDetail" isEqualToString:viewName]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshClassDetailNew" object:nil];
                }
             
                
                if([viewName isEqualToString:@"MsgDetailsView"]){
                    // 聊天详情画面
                    interval = TIMER_PUMP_SHORT;
                    
                }else if ([viewName isEqualToString:@"MsgListView"]){
                    // 聊天列表画面
                    interval = TIMER_PUMP_SHORT;
                }else if ([viewName isEqualToString:@"GroupChatDetailView"]){//add 2015.06.01
                    // 群聊聊天详情页
                    interval = TIMER_PUMP_SHORT;
                    
                }else if ([viewName isEqualToString:@"GroupMsgListView"]){//add 2015.06.01
                    // 群聊聊天列表页
                    interval = TIMER_PUMP_SHORT;
                    
                }else{
                    interval = TIMER_PUMP_LONG;//收到消息恢复15秒拉取
                }
                
            }else{//add 2015.07.03
                
                if(![viewName isEqualToString:@"MsgDetailsView"] && ![viewName isEqualToString:@"MsgListView"] && ![viewName isEqualToString:@"GroupChatDetailView"] && ![viewName isEqualToString:@"GroupMsgListView"]){
                    // 聊天详情画面
                    if (interval == TIMER_PUMP_LONG){
                        interval = TIMER_PUMP_LONGER;
                    }else if (interval == TIMER_PUMP_LONGER){
                        interval = TIMER_PUMP_LONGERR;
                    }else if (interval == TIMER_PUMP_LONGERR){
                        interval = TIMER_PUMP_LONGEREST;
                    }
                    
                }
            }
            
            [chatArray removeAllObjects];
            
            // 起一个线程，把for循环扔进去 add 2015.08.12
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              
                for(int i=0;i<[message count];i++){
                    
                    NSDictionary *msg = [message objectAtIndex:i];
                    long long userid = [[msg objectForKey:@"uid"] longLongValue];
                    
                    NSString *userName = [msg objectForKey:@"name"];// 人名
                    NSString *gid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"gid"]];
                    NSString *mid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"mid"]];
                    
                    //---构造lasMsgIdArray数组-------------------------------------------------------------
                    // done:接收消息成功,将每个群的最后一条lastmsgid告知服务器
                    
                    NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:gid,@"gid",mid,@"mid",nil];
                    BOOL isAdd = YES;
                    
                    for (int j=0; j<[lasMsgIdArray count]; j++) {
                        
                        NSString *tempGid = [[lasMsgIdArray objectAtIndex:j] objectForKey:@"gid"];
                        NSString *tempMsgid = [[lasMsgIdArray objectAtIndex:j] objectForKey:@"mid"];
                        
                        if ([tempGid isEqualToString:gid]) {
                            
                            if ([mid longLongValue] > [tempMsgid longLongValue]) {
                                [lasMsgIdArray replaceObjectAtIndex:j withObject:tempDic];
                                isAdd = NO;
                            }
                            
                        }
                        
                    }
                    
                    if (isAdd) {
                        [lasMsgIdArray addObject:tempDic];
                    }
                    
                    if (i == [message count]-1) {
                        
                        /**
                         * 更新群已读消息
                         * @author luke
                         * @date 2015.05.26
                         * @args
                         *  op=read, sid=, uid=, gid=, last=消息ID
                         */
                        
                        for (int k = 0; k<[lasMsgIdArray count]; k++) {
                            
                            NSLog(@"lasMsgIdArray:%@",lasMsgIdArray);
                            
                            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  @"GroupChat",@"ac",
                                                  @"2",@"v",
                                                  @"read", @"op",
                                                  [[lasMsgIdArray objectAtIndex:k] objectForKey:@"gid"], @"gid",
                                                  [[lasMsgIdArray objectAtIndex:k] objectForKey:@"mid"],@"last",
                                                  nil];
                            
                            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                                
                                
                                
                            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                                
                            }];
                            
                        }
                        
                    }
                    
                    //--------------------------------------------------------------------------------------------
                    NSString *audioSize = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"size"]]];//add 2011.11.03 2.9.1新需求
                    // 更新数据库
                    GroupChatDetailObject *chatDetail = [[GroupChatDetailObject alloc] init];
                    // 消息的msgID
                    chatDetail.msg_id = [[msg objectForKey:@"msgid"] longLongValue];
                    chatDetail.user_id = userid;
                    // 消息的发送(0)接收(1)区分
                    chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                    chatDetail.userName = userName;//add 2015.07.17
                    //消息类型-文本
                    NSInteger msgType = [[msg objectForKey:@"type"] integerValue];
                    if (msgType == 10 || msgType == 12 ) {
                        chatDetail.msg_type = 3;
                    }else if (msgType == 13){
                        chatDetail.msg_type = 4;
                    }else if (msgType == 14){
                        chatDetail.msg_type = 5;
                    }else{
                        chatDetail.msg_type = msgType;
                    }
                    
                    // 消息状态：发送，已读，未读，失败等
                    chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                    // 消息内容
                    if (chatDetail.msg_type == MSG_TYPE_PIC) {
                        chatDetail.msg_content = @"[图片]";
                        
#if 1
                        NSString *url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                        chatDetail.pic_url_thumb = [NSString stringWithFormat:@"%@%@",url,@"@240w_1l.png"];
                        chatDetail.pic_url_original = url;
#else
                        // 原始图片文件的HTTP-URL地址
                        chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                        chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
#endif
                        
                    }else if(chatDetail.msg_type == MSG_TYPE_Audio){
                        chatDetail.msg_content = @"[语音]";
                        chatDetail.audio_url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                        chatDetail.audioSecond = [audioSize integerValue];//add 2011.11.03 2.9.1新需求
                    }else {
                        chatDetail.msg_content = [Utilities replaceNull:[msg objectForKey:@"message"]];
                        NSLog(@"msgContent:%@",[Utilities replaceNull:[msg objectForKey:@"message"]]);
                    }
                    
                    // 文件名（语音，图片，涂鸦）
                    chatDetail.msg_file = @"";
                    NSString *timestampStr = [Utilities replaceNull:[msg objectForKey:@"dateline"]];
                    chatDetail.timestamp = [timestampStr longLongValue]*1000;
                    //NSLog(@"timestamp:%lli",chatDetail.timestamp);
                    chatDetail.cid = [[Utilities replaceNull:[msg objectForKey:@"cid"]] longLongValue];
                    chatDetail.groupid = [[Utilities replaceNull:gid] longLongValue];
                    chatDetail.headimgurl = [msg objectForKey:@"avatar"];
                    [chatDetail updateToDB];
                    
                    [chatArray addObject:chatDetail];//add 2015.08.13
                    
                    GroupChatList *chatList = [[GroupChatList alloc] init];
                    chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", userid];
                    chatList.cid = chatDetail.cid;
                    chatList.gid = chatDetail.groupid;
                    chatList.is_recieved = MSG_IO_FLG_RECEIVE;
                    //最后一条消息ID
                    chatList.last_msg_id= chatDetail.msg_id;
                    // 聊天的最后一条消息的类型
                    chatList.last_msg_type= chatDetail.msg_type;
                    // 聊天的最后一条消息内容
                    if (msgType!= 10 && msgType!= 12 && msgType!= 13 && msgType!= 14) {
                        chatList.last_msg = [NSString stringWithFormat:@"%@:%@",userName,chatDetail.msg_content];
                        
                    }else{
                        chatList.last_msg = chatDetail.msg_content;
                        
                    }
                    //该条消息状态
                    chatList.msg_state = MSG_RECEIVED_SUCCESS;
                    chatList.user_id = userid;
                    chatList.mid = [msg objectForKey:@"mid"];//add 2015.01.25
                    //时间戳
                    chatList.timestamp = chatDetail.timestamp;
                    
                    BOOL isExist = [chatList updateToDB];
                    
                    // 获取群头像url存在一个数据表中，判断chatList中是否有gid了，如果没有就拉取群头像，有就不拉
                    if (!isExist) {//不存在
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"GroupChat",@"ac",
                                              @"2",@"v",
                                              @"getGroupAvatar", @"op",
                                              [NSString stringWithFormat:@"%lli",chatList.gid],@"gid",
                                              nil];
                        
                        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                            
                            NSDictionary *respDic = (NSDictionary*)responseObject;
                            NSString *result = [respDic objectForKey:@"result"];
                            
                            if(true == [result intValue]) {
                                
                                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
                                //name 群名字
                                NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
                                chatList.title = groupName;
                                [chatList updateGroupName];//更新群名字
                                
                                GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
                                headObject.gid = chatList.gid;
                                [headObject deleteData];
                                
                                for (int i =0; i<[tempArray count]; i++) {
                                    
                                    long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                                    NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                                    NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                                    
                                    headObject.user_id = headUid;
                                    headObject.headUrl = headUrl;
                                    headObject.name = name;
                                    [headObject insertData];
                                    
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];
                                });
                                
                            }
                            
                            
                        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                            
                        }];
                        
                    }
                    
                    // 如果有图片资源此处需要开线程下载图片，此时先拉取缩略图，点击查看大图时再拉取大图
                    if ([chatDetail.pic_url_thumb length] > 0) {
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            // get message from server
                            [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:chatDetail.user_id msgid:chatDetail.msg_id];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //[self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:chatArray waitUntilDone:YES];//2015.08.13
                                [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                            });
                            
                            
                        });
                        
                        
                    }
                    if([chatDetail.audio_url length] > 0){
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //---update 2015.07.07-----------------------------------------------
                                if (isGot) {
                                    
                                    if ([audioSize length]>0 && [audioSize integerValue]!=0) {
                                        
                                    }else{
                                        RecordAudio *recordAudio = [[RecordAudio alloc] init];
                                        
                                        NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                                        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                                        
                                        NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                                        NSInteger audioSecond = [recordAudio dataDuration:fileData];
                                        chatDetail.audioSecond = audioSecond;
                                        [chatDetail updateAudio];
                                    }
                                    
                                    
                                }
                                //--------------------------------------------------------------------
                                
                            });
                            
                            
                        });
                        
                    }
                    
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (count > 0) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 通知画面刷新
                            //[self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:chatArray waitUntilDone:YES];// update 2015.08.13
                            [self performSelectorOnMainThread:@selector(updateUIOnMain:) withObject:nil waitUntilDone:YES];//2015.08.27
                            
                            //------2.9.4----------------------------------------------------------------------------
                            GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                            NSDictionary *user = [g_userInfo getUserDetailInfo];
                            NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                            
                            if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype]){
                                //通知第三个tab是否显示红点
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowNewOnTab3" object:nil];
                                
                            }
                            //---------------------------------------------------------------------------------------------
                            
                        });
                        
                    }
                    
                });
                
                
            });
            
            
        }
       
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];

    return count;
}
#endif

- (void)updateUIOnMain:(id)object
{
    
    /*if ([self.viewController.navigationController.visibleViewController isKindOfClass:[MsgListViewController class]]) {
        // 更新聊天列表画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];
    } else if ([self.viewController.navigationController.visibleViewController isKindOfClass:[MsgDetailsViewController class]]) {
        // 更新聊天详情画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
    } else {
//        // 更新主画面new图标
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:nil];
        
    }*/
#if 0
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    NSLog(@"viewName:%@",viewName);
    if([viewName isEqualToString:@"MsgDetailsView"]){
        // 更新聊天详情画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
    }else if ([viewName isEqualToString:@"MsgListView"]){
        // 更新聊天列表画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];
        
    }else if ([viewName isEqualToString:@"GroupChatDetailView"]){//add 2015.06.01
        // 更新群聊聊天详情页
//        NSMutableArray *tempArray = (NSMutableArray*)object;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP object:tempArray];//2015.08.13
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP object:nil];//2015.08.27
        
    }else if ([viewName isEqualToString:@"GroupMsgListView"]){//add 2015.06.01
        // 更新群聊聊天列表页 update 2015.08.13
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP object:nil];

    }else if ([viewName isEqualToString:@"GroupMsgListViewForTeacher"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP_TEACHER object:nil];
        
    }
#endif
    // 更新主页单聊数字
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    NSLog(@"viewName:%@",viewName);
    if([viewName isEqualToString:@"MsgDetailsMixView"]){
        // 更新聊天详情画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
        // 更新聊天列表画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];
        
    }else if ([viewName isEqualToString:@"MsgListMixView"]){
        // 更新聊天列表画面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];
        
    }
    
}
//---------------------------------------------------------------------------------------------

//- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
//{
//    NSString * key = [identifierComponents lastObject];
//    if([key isEqualToString:@"MMDrawer"]){
//        return self.window.rootViewController;
//    }
//    else if ([key isEqualToString:@"MMExampleCenterNavigationControllerRestorationKey"]) {
//        return ((MMDrawerController *)self.window.rootViewController).centerViewController;
//    }
//    else if ([key isEqualToString:@"MMExampleRightNavigationControllerRestorationKey"]) {
//        return ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
//    }
//    else if ([key isEqualToString:@"MMExampleLeftNavigationControllerRestorationKey"]) {
//        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
//    }
//    else if ([key isEqualToString:@"MMExampleLeftSideDrawerController"]){
//        UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
//        if([leftVC isKindOfClass:[UINavigationController class]]){
//            return [(UINavigationController*)leftVC topViewController];
//        }
//        else {
//            return leftVC;
//        }
//        
//    }
//    else if ([key isEqualToString:@"MMExampleRightSideDrawerController"]){
//        UIViewController * rightVC = ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
//        if([rightVC isKindOfClass:[UINavigationController class]]){
//            return [(UINavigationController*)rightVC topViewController];
//        }
//        else {
//            return rightVC;
//        }
//    }
//    return nil;
//}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}


-(void)doWriteDebugLogPushLogout:(NSString *)str
{
    NSString *uuid = [Utilities getUniqueUidWithoutQuit];
    if (nil == uuid) {
        uuid = @"null";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: 
                          REQ_URL, @"url",
                          @"Debug",@"ac",
                          @"2",@"v",
                          @"log", @"op",
                          uuid,@"uid",
                          @"pushLogout",@"action",
                          str,@"message",
                          nil];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [network sendHttpReq:HttpReq_DebugLog andData:data];
}

-(void)doWriteDebugLogCheckLogout:(NSString *)str
{
    NSString *uuid = [Utilities getUniqueUidWithoutQuit];
    if (nil == uuid) {
        uuid = @"null";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Debug",@"ac",
                          @"2",@"v",
                          @"log", @"op",
                          uuid,@"uid",
                          @"checkLogout",@"action",
                          str,@"message",
                          nil];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [network sendHttpReq:HttpReq_DebugLog andData:data];
}

/*
 * 安装上报 add by kate 2015.06.23
 */
- (void)uploadInstallationReport:(NSString *)reportString
{
    [FRNetPoolUtils uploadInstallationReport:reportString];
}

/*
 * 其他后台上报 add by kate 2015.06.23
 */
- (void)doUploadReport
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *installStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"InstallReportString"]]];
    if ([installStr length] > 0) {
        [self uploadInstallationReport:installStr];
    }
    
    [FRNetPoolUtils uploadDailyReport:@"2"];
}

/*
 * 实时监察网络状态 add by kate 2015.06.26
 */
-(void)netWorkStatus:(id)sender{
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 手机自带网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //这是单例＋模型，用来记录网络状态
        FileManager *maa = [FileManager shareFileManager];
        
        /*if (status == 0) {
            int type = [Utilities getNetWorkStates];
            if (type > 0) {
                status = AFNetworkReachabilityStatusReachableViaWWAN;
            }
        }*/
        
        maa.netState = status;
        NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
        
        // 发送消息告知需要显示neworkbar的类,目前只第一个tab与第三个tab显示无网提示条
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnected" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnectedForMoments" object:nil];
//------以下为其他tab页需要显示上方无网提示条的通知，先注释了，用的时候再打开
//
        GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        
        if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype]){
            // 教师身份
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnectedForMyClassList" object:nil];

        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnectedForMyClassList" object:nil];

            // 学生身份
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnectedForClassDetail" object:nil];
        }
        
        
        NSString *schoolType =  [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
        if ([@"bureau" isEqualToString:schoolType]) {
        // 教育局版本
         [[NSNotificationCenter defaultCenter] postNotificationName:@"isConnectedForSchoolListForBureau" object:nil];
        }
        
    }];
}

@end
