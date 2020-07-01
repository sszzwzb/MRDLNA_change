//
//  GuideViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-17.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "GuideViewController.h"

#import "MicroSchoolAppDelegate.h"
#import "MyInfoCenterViewController.h"
#import "ClassDetailViewController.h"
#import "MyClassListViewController.h"
#import "MomentsEntranceForTeacherController.h"
#import "SchoolHomeViewController.h"
//#import "ClassHomeViewController.h"
#import "ParksHomeViewController.h"
#import "MyClassDetailViewController.h"
#import "LeftViewController.h"
#import "WWSideslipViewController.h"
@interface GuideViewController ()

@end

extern UINavigationController *navigation_NoUserType;

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    //UIView *view = [ [ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height)];
    
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    [self initImg];
}

-(void) initImg
{
    //创建UIScrollView
    scrollViewIns = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].bounds.size.height)];
    scrollViewIns.pagingEnabled = YES; //是否分页
    scrollViewIns.contentSize = CGSizeMake(WIDTH*4, [UIScreen mainScreen].applicationFrame.size.height);
    scrollViewIns.showsHorizontalScrollIndicator = NO;
    scrollViewIns.showsVerticalScrollIndicator = NO;
    scrollViewIns.backgroundColor = [UIColor clearColor];
    scrollViewIns.delegate = self;
    scrollViewIns.bounces = NO;
    [self.view addSubview:scrollViewIns];

    UIImage *img1;
    UIImage *img2;
    UIImage *img3;
    UIImage *img4;

    if ([@"newVersionGuide"  isEqual: _viewType]) {//不管原来是否登录都显示这四张
        if (iPhone4) {
            img1 = [UIImage imageNamed:@"guidePic/1_for4.png"];
            img2 = [UIImage imageNamed:@"guidePic/2_for4.png"];
            img3 = [UIImage imageNamed:@"guidePic/3_for4.png"];
            img4 = [UIImage imageNamed:@"guidePic/4_for4.png"];
        }else {
            img1 = [UIImage imageNamed:@"guidePic/1"];
            img2 = [UIImage imageNamed:@"guidePic/2"];
            img3 = [UIImage imageNamed:@"guidePic/3"];
            img4 = [UIImage imageNamed:@"guidePic/4"];
        }
    }else {//如果登录了就不显示这四张
        if (iPhone4) {
            img1 = [UIImage imageNamed:@"bg_splash_1"];
            img2 = [UIImage imageNamed:@"bg_splash_2"];
            img3 = [UIImage imageNamed:@"bg_splash_3"];
            img4 = [UIImage imageNamed:@"bg_splash_4"];
        }else {
            img1 = [UIImage imageNamed:@"bg_splash_1"];
            img2 = [UIImage imageNamed:@"bg_splash_2"];
            img3 = [UIImage imageNamed:@"bg_splash_3"];
            img4 = [UIImage imageNamed:@"bg_splash_4"];
        }

      
    }
    
    //创建第一张图片
    UIImageView *image1 = [[UIImageView alloc] initWithImage:img1];
    //如果要触发事件，必须设置为yes
    image1.userInteractionEnabled = YES;
    //image1.contentMode = UIViewContentModeCenter;
    image1.backgroundColor = [UIColor blackColor];
    image1.contentMode = UIViewContentModeScaleToFill;
    image1.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].bounds.size.height);
    
    //创建第二张图片
    UIImageView *image2 = [[UIImageView alloc] initWithImage:img2];
    image2.userInteractionEnabled = YES;
    image2.frame = CGRectMake(WIDTH, 0, WIDTH, [UIScreen mainScreen].bounds.size.height);
    image2.contentMode = UIViewContentModeCenter;
    image2.backgroundColor = [UIColor blackColor];
    image2.contentMode = UIViewContentModeScaleToFill;

    //创建第三张图片
    UIImageView *image3 = [[UIImageView alloc] initWithImage:img3];
    image3.userInteractionEnabled = YES;
    image3.tag = 101;
    image3.frame = CGRectMake(WIDTH *2, 0, WIDTH, [UIScreen mainScreen].bounds.size.height);
    image3.contentMode = UIViewContentModeCenter;
    image3.backgroundColor = [UIColor blackColor];
    image3.contentMode = UIViewContentModeScaleToFill;

    //创建第四张图片
    UIImageView *image4 = [[UIImageView alloc] initWithImage:img4];
    image4.userInteractionEnabled = YES;
    image4.frame = CGRectMake(WIDTH *3, 0, WIDTH, [UIScreen mainScreen].bounds.size.height);
    image4.contentMode = UIViewContentModeCenter;
    image4.backgroundColor = [UIColor blackColor];
    image4.contentMode = UIViewContentModeScaleToFill;

    if (![@"newVersionGuide"  isEqual: _viewType]) {
        //创建分页控件
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen] .applicationFrame.size.height - 5, WIDTH, 20)];
        pageControl.numberOfPages = 4;
        pageControl.currentPage = 0;
        //pageControl.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.3];
        //[self.view addSubview:pageControl];//去掉点 2.9.4
    }
    
    if ([@"newVersionGuide"  isEqual: _viewType]) {
        [scrollViewIns addSubview:image1];
        [scrollViewIns addSubview:image2];
        [scrollViewIns addSubview:image3];
        [scrollViewIns addSubview:image4];

        scrollViewIns.contentSize = CGSizeMake(WIDTH*4, [UIScreen mainScreen].applicationFrame.size.height);
    }else {
        [scrollViewIns addSubview:image1];
        [scrollViewIns addSubview:image2];
        [scrollViewIns addSubview:image3];
        [scrollViewIns addSubview:image4];
    }
    
    // 创建login button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, [UIScreen mainScreen] .applicationFrame.size.height -60, WIDTH-60, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    // 设置aligment 属性
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    //button.backgroundColor = [UIColor redColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
    
    if ([@"newVersionGuide"  isEqual: _viewType]) {
        if (iPhone4) {
            button.frame = CGRectMake(30, [UIScreen mainScreen] .applicationFrame.size.height - 78, 260, 35);
        }else {
            button.frame = CGRectMake(30, [UIScreen mainScreen] .applicationFrame.size.height - 93, WIDTH-60, 40);
        }

        [button setBackgroundImage:[UIImage imageNamed:@"guidePic/button_03"] forState:UIControlStateNormal] ;
        [button setBackgroundImage:[UIImage imageNamed:@"guidePic/buttonanxia_03"] forState:UIControlStateHighlighted] ;
        
        //设置title
        [button setTitle:@"点击进入" forState:UIControlStateNormal];
        [button setTitle:@"点击进入" forState:UIControlStateHighlighted];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_experience_d.png"] forState:UIControlStateNormal] ;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_experience_p.png"] forState:UIControlStateHighlighted] ;
        
        //设置title
        [button setTitle:@"立即体验" forState:UIControlStateNormal];
        [button setTitle:@"立即体验" forState:UIControlStateHighlighted];
    }

    // 添加 action
    [button addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    button.alpha=0.7;

    
    if ([@"newVersionGuide"  isEqual: _viewType]) {
        [image4 addSubview:button];
    }else {
        [image4 addSubview:button];
    }

}

- (IBAction)create_btnclick:(id)sender
{
    
    if ([@"newVersionGuide"  isEqual: _viewType]) {
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
                navigation_NoUserType = [[SubUINavigationController alloc]initWithRootViewController:setIdentity_viewCtrl];
                [self presentViewController:navigation_NoUserType animated:YES completion:nil];
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
                navigation_NoUserType = [[SubUINavigationController alloc]initWithRootViewController:setIdentity_viewCtrl];
                [self presentViewController:navigation_NoUserType animated:YES completion:nil];
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
                    
                    
                    MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] initWithNibName:@"MicroSchoolLoginViewController" bundle:nil];
                    [self presentViewController:login animated:YES completion:nil];
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
                    
                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    LeftViewController * leftController = [[LeftViewController alloc] init];
                    WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
                    appDelegate.window.rootViewController = wwsideslioController;
                    
                    //-------------------------------------------------------------------------------
                    //----------------------------------------------
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
        
        
    }else {
        
        MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] initWithNibName:@"MicroSchoolViewController" bundle:nil];
        
        //    UINavigationController *navigation = [[UINavigationController alloc] init];
        //    [navigation setTitle:@"testNavigation"];
        //    [navigation initWithRootViewController:login];
        
        //[navigation pushViewController:signUp animated:YES];
        
        // 向userDefaults里面添加是否是第一次登陆的信息
        NSDictionary *userLoginIndex = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"loginIndex", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:userLoginIndex forKey:@"weixiao_userLoginIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self presentViewController:login animated:YES completion:nil];
        
    }
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![@"newVersionGuide"  isEqual: _viewType]) {
        //计算分页的索引
        float x = scrollView.contentOffset.x;
        NSLog(@"x---------------------:%f",x);
        int indexPage = x /320;
        pageControl.currentPage = indexPage;
    }
}

//- (void) updateDots
//
//{
//    
//    NSArray *subView = pageControl.subviews;
//    
//    
//    for (int i =0; i < [subView count]; i++)
//        
//    {
//        
//        UIImageView *dot = [subView objectAtIndex:i];
//        
//        dot.image = (self.currentPage == i ? imagePageStateHightlighted : imagePageStateNormal);
//        
//    }
//    
//}

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
            //--------------------------------------------------------------
            
            controllers = [NSArray arrayWithObjects:schoolNavi, customizationNavi,ParkNavi, nil];
            
        //}
        
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
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
