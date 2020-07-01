//
//  SplashViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-23.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SplashViewController.h"
//---add by kate----------------------------------------
#import "GlobalSingletonUserInfo.h"
#import "MicroSchoolAppDelegate.h"
#import "SubUINavigationController.h"
#import "SchoolHomeViewController.h"
//#import "ClassHomeViewController.h"
#import "ParksHomeViewController.h"
#import "MyClassDetailViewController.h"
#import "MyClassListViewController.h"
#import "LeftViewController.h"
#import "WWSideslipViewController.h"
//------------------------------------------------------


@interface SplashViewController ()

@end

extern UINavigationController *navigation_NoUserType;

GuideViewController *guide_viewCtrl;

@implementation SplashViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    
#if 1
    NSString *uid = @"";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    if (nil != userInfo) {
        // 单例里面有值的话，用单例里的值。
        uid = [userInfo objectForKey:@"uid"];
        if (nil == uid) {
            // 单例里值为空的话，把uid置""
            uid = @"";
        }
    }

    if (uid.longLongValue > 0) {
        // 2.7版本增加了token，老版本只获取一次
        NSString *getTokenFlag = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_7_GET_TOKEN_SUCCESS];
        
        NSString *getToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
        
        if (nil == getToken) {
            if (nil == getTokenFlag) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"Login",@"ac",
                                      @"2",@"v",
                                      @"token", @"op",
                                      nil];
                
                [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:IS_NEW_VERSION_2_7_GET_TOKEN_SUCCESS];
                    [userDefaults synchronize];
                    
                    NSDictionary *respDic = (NSDictionary*)responseObject;
                    NSString *result = [respDic objectForKey:@"result"];
                    
                    if(true == [result intValue]) {
                        NSString *token = [respDic objectForKey:@"message"];
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:token forKey:USER_LOGIN_TOKEN];
                        [userDefaults synchronize];
                    } else {
                        // 获取失败了，则认为此用户之前登录过，重新登录
                        [network cancelCurrentRequest];
                        
                        MicroSchoolAppDelegate* appdele = (MicroSchoolAppDelegate*)[[UIApplication sharedApplication] delegate];
                        [appdele doLogOut:@"用户状态异常，请重新登录试试。"];
                    }
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                }];
            }
        }
    }
    
#endif
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"111");
    // 闪屏显示1秒后执行TheAnimation
    
}

// 退出登录重新拉取且解决登出再登录问题
-(void)logOutRefresh{
    
    //[self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(TheAnimation) withObject:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    //reloadSplash
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logOutRefresh)
                                                 name:@"reloadSplash"
                                               object:nil];
    
    //将闪屏图片放入imgView中
    if (iPhone5)
    {
        
            imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20)];
        
       
    }
    else
    {
        imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height+20)];
    }
    
    UIImage *image;
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_splash_image"];
    
    if(imageData != nil)
    {
        image = [UIImage imageWithData:imageData];
    }
    else
    {
        if (iPhone3gs) {
            image = [UIImage imageNamed:@"spl_320_480.png"];
        }else if (iPhone4) {
            image = [UIImage imageNamed:@"spl_640_960.png"];
        }else {
            image = [UIImage imageNamed:@"spl_640_1136.png"];
        }
    }
    imgView.image=image;
    
    //alloc一个uiView
    if (iPhone5)
    {
        if (isOSVersionLowwerThan(@"7.0")){
            splashView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height+20)];
        }else{
            splashView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height+20)];
        }
    }
    else
    {
        splashView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height+20)];
    }
    
    // 将imgView放入到闪屏view中
    [splashView addSubview:imgView];
    
    [self.view addSubview:splashView];
    
    
    if(imageData != nil){//2.9.1新需求 原3张图变成2张
        // 已经与后台调试完成，这里延迟一秒即可，已经替换
        [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1.0];//update by kate 2014.12.31
//        [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:2.0];//2015.11.02闪屏暂定显示2秒 2.9.1新需求
    }else{
        //[self performSelector:@selector(TheAnimation) withObject:nil afterDelay:0.5];//无节日闪屏 不delay
        [self TheAnimation];
    }

}

- (void)TheAnimation
{
    NSString *isShowGuide = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_9_2_GUIDE_VIEW];

    // 判断UserDefaults是否有上一次登录的信息
    NSDictionary *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userLoginIndex"];
    
    NSLog(@"value = %@",value);
    NSString *loginIndex = [value objectForKey:@"loginIndex"];
    
    if ([@"1"  isEqual: loginIndex])
    {
        if (nil == isShowGuide) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IS_NEW_VERSION_2_9_2_GUIDE_VIEW];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //GuideViewController *guide_viewCtrl = [[GuideViewController alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{//present方法有延时，要放在主线程里才能立即执行 2015.11.05
                guide_viewCtrl = [[GuideViewController alloc] init];
                guide_viewCtrl.viewType = @"newVersionGuide";
                [self presentViewController:guide_viewCtrl animated:YES completion:nil];
            });
        }else {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            
            NSString *identity = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
            
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
            
            NSString *regStatus = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
            
            NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
            
            NSString *regSuccess = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
            
            if ([@"yes"  isEqual: regStatus]) {
                if (nil == identity) {
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //
                    //                [self presentViewController:navigation animated:YES completion:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{//present方法有延时，要放在主线程里才能立即执行 2015.11.05
                        navigation_NoUserType = [[SubUINavigationController alloc]initWithRootViewController:setIdentity_viewCtrl];
                        [self presentViewController:navigation_NoUserType animated:YES completion:nil];

                    });
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserName_splash" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                } else if (nil == realName) {
                    // 2014.09.17 update by ht 修正注册过程中退出，返回的是身份选择页面
#if 0
                    SetPersonalViewController *setPersonal_viewCtrl = [[SetPersonalViewController alloc] init];
                    setPersonal_viewCtrl.iden = identity;
                    UINavigationController *navigation = [[UINavigationController alloc] init];
                    [navigation setTitle:@"testNavigation"];
                    [navigation initWithRootViewController:setPersonal_viewCtrl];
                    
                    [self presentViewController:navigation animated:YES completion:nil];
#else
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //
                    //                [self presentViewController:navigation animated:YES completion:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{//present方法有延时，要放在主线程里才能立即执行 2015.11.05
                        navigation_NoUserType = [[SubUINavigationController alloc]initWithRootViewController:setIdentity_viewCtrl];
                        [self presentViewController:navigation_NoUserType animated:YES completion:nil];
                    });
                    
                  
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserName_splash" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
#endif
                }
            } else {
                // 是否是从注册页面直接到主界面的，如果是则进行登录，不是则直接进入主界面
                if ([@"regSuccess"  isEqual: regSuccess]) {
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Login", @"ac",
                                          @"2", @"v",
                                          @"unique", @"op",
                                          [dic objectForKey:@"username"], @"username",
                                          [dic objectForKey:@"password"], @"password",
                                          nil];
                    
                    network = [NetworkUtility alloc];
                    network.delegate = self;
                    [network sendHttpReq:HttpReq_Login andData:data];
                    
                } else {
                    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
                    // 判断是否存在用户基本信息，如存在，则标志用户没有退出，直接进入主界面
                    // 如为空，则进入登录页面。
                    if (nil == userInfo) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{//present方法有延时，要放在主线程里才能立即执行 2015.11.05
                            MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] initWithNibName:@"MicroSchoolLoginViewController" bundle:nil];
                            [self presentViewController:login animated:YES completion:nil];
                        });

                        
                       } else {
                        
                        //---update by kate----------------------------------
                        /*MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
                         
                         MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
                         [navigation initWithRootViewController:mainMenuViewCtrl];
                         
                         //[navigation pushViewController:signUp animated:YES];
                         [self presentViewController:navigation animated:YES completion:nil];*/
                        [[NSUserDefaults standardUserDefaults]setObject:@"noUserName_splash" forKey:@"fromNameToHome"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [self initTabBarController];
                        
                        //-----------------------------------------------------------------------------
                        // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
//                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
                        
                           
//#3.20   解决左划页面显示问题。
                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                           LeftViewController * leftController = [[LeftViewController alloc] init];
                           WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
                        appDelegate.window.rootViewController = wwsideslioController;
                        
                        //-------------------------------------------------------------------------------
                    }
                }
            }
            
            
#if 0
            // 去userDefaults取用户名和密码
            NSDictionary *namePwd = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserLoginInfo];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Login", @"ac",
                                  @"unique", @"op",
                                  [namePwd objectForKey:@"username"], @"username",
                                  [namePwd objectForKey:@"password"], @"password",
                                  nil];
            
            if ((nil != [namePwd objectForKey:@"username"])
                || (nil != [namePwd objectForKey:@"password"])) {
                
                // 判断在userDefaults中是否有用户的真实姓名，如没有，则进入注册个人信息完善页面。
                NSDictionary *isName = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userLoginIsName"];
                NSString *name = [isName objectForKey:@"name"];
                
                if (nil == name) {
                    SetPersonalViewController *setPersonal_viewCtrl = [[SetPersonalViewController alloc] init];
                    
                    UINavigationController *navigation = [[UINavigationController alloc] init];
                    [navigation setTitle:@"testNavigation"];
                    [navigation initWithRootViewController:setPersonal_viewCtrl];
                    
                    [self presentViewController:navigation animated:YES completion:nil];
                } else {
                    network = [NetworkUtility alloc];
                    network.delegate = self;
                    [network sendHttpReq:HttpReq_Login andData:data];
                }
            } else {
                MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] initWithNibName:@"MicroSchoolLoginViewController" bundle:nil];
                [self presentViewController:login animated:YES completion:nil];
            }
#endif
        }
        
    }
    else
    {
        //GuideViewController *guide_viewCtrl = [[GuideViewController alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{//present方法有延时，要放在主线程里才能立即执行 2015.11.05
            guide_viewCtrl = [[GuideViewController alloc] init];
            [self presentViewController:guide_viewCtrl animated:YES completion:nil];
        });
        
       
       
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IS_NEW_VERSION_2_9_2_GUIDE_VIEW];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

      
    }
}







#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        NSString* uid= [message_info objectForKey:@"uid"];
        NSString* username= [message_info objectForKey:@"username"];

//        // add by ht 20140915 如果注册完毕并且登录成功后，清空注册信息，以便下一次直接进入主界面，增加userDefaults变量
        NSString *uid1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
//        // 清空注册完毕信息
//        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid1]];
//        [[NSUserDefaults standardUserDefaults] synchronize];

        // 保存用户名和密码
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:uid, @"uid", username, @"username",nil];

        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:[NSString stringWithFormat:@"zhixiao_LoginUserNamePwd"]];
        [[NSUserDefaults standardUserDefaults] synchronize];        
        
        
        // 可以往NSUserDefaults里面存储一个字典数据，
        // 每次成功登录完都可以更新一下
        NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:uid, @"uid", username, @"username",nil];

        // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:G_NSUserDefaults_UserLoginInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // 保存程序内部唯一的合法uid。
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // 和服务器绑定
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
        NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];

        if (uid) {
            
            MicroSchoolAppDelegate *appDelegate = [[MicroSchoolAppDelegate alloc]init];
            NSString *token = appDelegate.token;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                BOOL isSuccess =  [FRNetPoolUtils bindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:userid channelId:channelid type:@"" token:token];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if (isSuccess) {
                        
                        //[userDefaults setBool:YES forKey:@"Bind_Server"];
                        [userDefaults setObject:@"1" forKey:@"MessageSwitch"];
                    }
                
                });
            
            });
            
        }

        /*---update by kate----------------------------------
         // 到下一画面
        MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
        
        MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
        [navigation initWithRootViewController:mainMenuViewCtrl];
        
        //[navigation pushViewController:signUp animated:YES];
        [self presentViewController:navigation animated:YES completion:nil];*/
         [[NSUserDefaults standardUserDefaults]setObject:@"splash" forKey:@"fromNameToHome"];
        [self initTabBarController];
        //-----------------------------------------------------------------------------
        // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
        //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        LeftViewController * leftController = [[LeftViewController alloc] init];
        WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
        appDelegate.window.rootViewController = wwsideslioController;
        
        //-------------------------------------------------------------------------------
        //--------------------------------------------------------
    }
    else
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
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
    // 登录失败，清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:G_NSUserDefaults_UserLoginInfo];
    [defaults removeObjectForKey:G_NSUserDefaults_UserUniqueUid];
    [defaults synchronize];
    
    MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] initWithNibName:@"MicroSchoolViewController" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
}

/*
 * 自定义tabbar add by kate
 */
- (void)initTabBarController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!appDelegate.tabBarController) {
        
        [appDelegate bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
        // 校园
        SchoolHomeViewController *schoolV = [[SchoolHomeViewController alloc] init];
        // 班级
        NSDictionary *userD = [g_userInfo
                               getUserDetailInfo];
        // 数据部分
        if (nil == userD) {
            userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        
        NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"role_id"]];
        
        NSString *cid = @"0";
        
        
        MyClassListViewController *classV = [[MyClassListViewController alloc] init];
        
        MyClassDetailViewController *classDetailV = [[MyClassDetailViewController alloc] init];
        
        ParksHomeViewController *parkV = [[ParksHomeViewController alloc]init];
        
        
        //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
        schoolV.hidesBottomBarWhenPushed = YES;
        classDetailV.hidesBottomBarWhenPushed = YES;
        classV.hidesBottomBarWhenPushed = YES;
        parkV.hidesBottomBarWhenPushed = YES;
        schoolV.title = @"校园";
        classDetailV.title = @"班级";
        parkV.title = @"乐园";
        
        UINavigationController *schoolNavi = [[UINavigationController alloc] initWithRootViewController:schoolV];
        
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:classDetailV];
        
        UINavigationController *ParkNavi = [[UINavigationController alloc]initWithRootViewController:parkV];
        
        NSArray *controllers;
      
            if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype])
            {
                
                customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
                
            }
            else
            {
                cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
                if(cid == nil){
                    cid = @"0";
                }else{
                    if([cid length] == 0){
                        cid = @"0";
                    }
                }
                if([cid isEqualToString:@"0"]){
                    customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
                }
                classDetailV.fromName = @"tab";
            }
            classDetailV.cId = cid;
        
        controllers = [NSArray arrayWithObjects:schoolNavi, customizationNavi,ParkNavi, nil];

        //设置tabbar的控制器
        MyTabBarController *tabBar = [[MyTabBarController alloc] initWithSelectIndex:0];
        

        tabBar.viewControllers = controllers;
        tabBar.selectedIndex = 0;
        appDelegate.tabBarController = tabBar;
        
    }
    
    [appDelegate.tabBarController selectedTab:[[appDelegate.tabBarController buttons] objectAtIndex:0]];
    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
    [tabBarControllerNavi popToRootViewControllerAnimated:NO];
    
    
    
    

    appDelegate.tabBarController.view.frame = [[UIScreen mainScreen] bounds];
        //    [self.window setRootViewController:self.tabBarController];
    //    [self.window bringSubviewToFront:self.tabBarController.view];
    
}

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//侧滑代码


@end
