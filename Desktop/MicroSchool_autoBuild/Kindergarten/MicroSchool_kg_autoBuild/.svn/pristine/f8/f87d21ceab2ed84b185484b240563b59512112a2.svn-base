//
//  SetIdentityViewController.m
//  MicroSchool
//
//  Created by jojo on 14-9-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetIdentityViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "SetPersonalViewController.h"//add by kate 2016.06.17
#import "ChildrenViewController.h"//add by kate 2016.06.17
#import "AddClassApplyViewController.h"
#import "IdentityTableViewCell.h"
#import "MyClassDetailViewController.h"
#import "IdentityTableViewCell.h"
#import "LeftViewController.h"

@interface SetIdentityViewController ()

@end

@implementation SetIdentityViewController

extern UINavigationController *navigation_Signup;
extern UINavigationController *navigation_NoUserType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        identity = @"student";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"请选择"];
    [self.navigationItem setHidesBackButton:YES];
    
    // add by ht 20140915 为了确定登录状态，增加userDefaults变量
    // 保存身份信息
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
    // 保存是否是注册登录流程
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    // 设置背景scrollView
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              320,
                                                              300) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
#if BUREAU_OF_EDUCATION
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
#else
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
#endif
    
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_scrollerView addSubview:_tableView];
    
    // 保存button
    btn_next = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_next.frame = CGRectMake(15, 210, 290, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    btn_next.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    btn_next.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_next setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn_next.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [btn_next setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [btn_next setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [btn_next addTarget:self action:@selector(next_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    [btn_next setTitle:@"下一步" forState:UIControlStateHighlighted];
    
#if BUREAU_OF_EDUCATION
    [_scrollerView addSubview:btn_next];
#else
    //[_scrollerView addSubview:btn_next];
#endif
    
    //切换账号按钮
    btn_changeProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_changeProfile.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80.0)/2.0, btn_next.frame.origin.y+40+10, 80.0, 40);
    [btn_changeProfile addTarget:self action:@selector(changeProfile:) forControlEvents: UIControlEventTouchUpInside];
    [btn_changeProfile setTitle:@"切换账号" forState:UIControlStateNormal];
    [btn_changeProfile setTitle:@"切换账号" forState:UIControlStateHighlighted];
    btn_changeProfile.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [btn_changeProfile setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_changeProfile setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_scrollerView addSubview:btn_changeProfile];
    
}

- (IBAction)next_btnclick:(id)sender
{
    // test 本来应该写在请求服务器返回成功里面，代表身份添加成功，这个地方tbd
    // add by ht 20140915 为了确定登录状态，增加userDefaults变量
    // 保存身份信息
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
    [[NSUserDefaults standardUserDefaults] setObject:identity forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 保存是否是注册登录流程
    //    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
#if BUREAU_OF_EDUCATION
    
    // 到个人信息页面
    SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
    personalViewCtrl.iden = identity;
    personalViewCtrl.viewType = @"chooseIden";
    [self.navigationController pushViewController:personalViewCtrl animated:YES];
#else
    
    if ([identity isEqualToString:@"teacher"]) {
        
        // 到个人信息页面
        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
        personalViewCtrl.iden = identity;
        personalViewCtrl.viewType = @"chooseIden";
        [self.navigationController pushViewController:personalViewCtrl animated:YES];
        
    }else{
        
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"UserProfile", @"ac",
                              @"2", @"v",
                              @"student", @"op",
                              @"2", @"sex",
                              @"0", @"cid",
                              @"游客", @"name",
                              nil];
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result boolValue]) {
                
                // 保存注册完毕信息
                [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存是否是注册登录流程
                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [Utilities showTextHud:[[respDic objectForKey:@"message"] objectForKey:@"alert"] descView:self.view];
                [self performSelector:@selector(gotoMain) withObject:nil afterDelay:0.8];
                
                
                
            }else{
                
                
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
            
        }];
      
    }
    
    
#endif
    
}

//切换账号
-(void)changeProfile:(id)sender{
    
    TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
        
        NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
        NSLog(@"fromNameToHome:%@",fromNameToHome);
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        if ([fromNameToHome isEqualToString:@"noUserName_splash"] || [fromNameToHome isEqualToString:@"noUserType"]){
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
            [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
            [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
            [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
            [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
            [userDefaults synchronize];
            
            [appDelegate unbindBaiduPush];//解绑 2015.12.08
            if(appDelegate.window.rootViewController!=appDelegate.splash_viewController){
                appDelegate.window.rootViewController = appDelegate.splash_viewController;//重置rootview add by kate 2015.10.23
            }
            [appDelegate removeDefaultsInfo];
            [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
        }else{
            [appDelegate unbindBaiduPush];//解绑 2015.12.08
            [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    };
    NSArray *itemsArr =
    @[TSItemMake(@"退出", TSItemTypeHighlight, handlerTest)];
    [Utilities showPopupView:@"您确定退出当前账号进入登录/注册页面吗？" items:itemsArr];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 301) {
        if (buttonIndex == 1) {
            NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
            NSLog(@"fromNameToHome:%@",fromNameToHome);
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            if ([fromNameToHome isEqualToString:@"noUserName_splash"] || [fromNameToHome isEqualToString:@"noUserType"]){
                
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                [userDefaults synchronize];
                
                [appDelegate unbindBaiduPush];//解绑 2015.12.08
                if(appDelegate.window.rootViewController!=appDelegate.splash_viewController){
                    appDelegate.window.rootViewController = appDelegate.splash_viewController;//重置rootview add by kate 2015.10.23
                }
                [appDelegate removeDefaultsInfo];
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else{
                [appDelegate unbindBaiduPush];//解绑 2015.12.08
                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
#if BUREAU_OF_EDUCATION
    return 1;
#else
    return 2;
    
#endif
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
#if BUREAU_OF_EDUCATION
    if (0 == section) {
        return 3;
    }
    return 0;
#else
    return 1;
#endif
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if BUREAU_OF_EDUCATION
    //指定行的高度
    return 50;
#else
    //指定行的高度
    return 101;
#endif
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //IdentityTableViewCell
    static NSString *GroupedTableIdentifier = @"IdentityTableViewCell";
    IdentityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"IdentityTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section == 0) {
        
        cell.imgV.image = [UIImage imageNamed:@"signup/identity_teacher"];
        cell.titleLabel.text = @"我是教师";
        
    }else{
        
        cell.imgV.image = [UIImage imageNamed:@"signup/identity_other"];
        cell.titleLabel.text = @"我是家长";
        
    }

    
    return cell;
    
}

#if BUREAU_OF_EDUCATION

#else

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 7.0;
    }else{
        return 30.0;
    }
}

#endif



//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
#if BUREAU_OF_EDUCATION
    for (int i=0; i<3; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        NameAndImgTableViewCell *cell = (NameAndImgTableViewCell*)[tableView cellForRowAtIndexPath:index];
        
        [cell.imageView_img setImage:[UIImage imageNamed:@"signup/invate"]];
    }
    
    NameAndImgTableViewCell *cell = (NameAndImgTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView_img setImage:[UIImage imageNamed:@"signup/invate_p"]];
    
    if (0 == indexPath.row) {
        identity = @"teacher";
    } else if (1 == indexPath.row) {
        identity = @"student";
    } else if (2 == indexPath.row) {
        identity = @"parent";
    }
    
#else
    
    if (indexPath.section == 0) {
        
        identity = @"teacher";
        
    }else if (indexPath.section == 1){
        
        identity = @"parent";
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
    [[NSUserDefaults standardUserDefaults] setObject:identity forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([identity isEqualToString:@"teacher"]) {
        
        // 到个人信息页面
        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
        personalViewCtrl.iden = identity;
        personalViewCtrl.viewType = @"chooseIden";
        [self.navigationController pushViewController:personalViewCtrl animated:YES];
        
    }else{
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"UserProfile", @"ac",
                              @"2", @"v",
                              @"parent", @"op",
                              @"-1",@"parent",
                              @"2", @"sex",
                              @"0", @"cid",
                              @"游客", @"name",
                              nil];
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result boolValue]) {
                
                // 保存注册完毕信息
                [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存是否是注册登录流程
                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [self getMyProfile];
                
                //[Utilities showTextHud:[[respDic objectForKey:@"message"] objectForKey:@"alert"] descView:self.view];
                [self performSelector:@selector(gotoMain) withObject:nil afterDelay:0.8];
                
            }else{
                
                NSDictionary *msg = [respDic objectForKey:@"message"];
                NSString *alert = [msg objectForKey:@"alert"];
                [Utilities showTextHud:alert descView:self.view];
                
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
            
        }];
        
    }
    
#endif
    
}

-(void)getMyProfile{
    NSString *uid= [Utilities getUniqueUid];
    
    if (uid) {
        // 登录成功后去服务器获取个人详细信息
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"view", @"op",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            if(true == [result intValue]) {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[msg objectForKey:@"profile"]];
                
                NSDictionary *vip = [msg objectForKey:@"vip"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                
                [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[msg objectForKey:@"role"]];
                } else {
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
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

-(void) gotoMain
{
    
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
        classV.hidesBottomBarWhenPushed = YES;
        classDetailV.hidesBottomBarWhenPushed = YES;
        parkV.hidesBottomBarWhenPushed = YES;
        schoolV.title = @"校园";
        classV.title = @"班级";
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
        //}
        //-----------------------------------------------------------------------------------------------
        
        
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


@end
