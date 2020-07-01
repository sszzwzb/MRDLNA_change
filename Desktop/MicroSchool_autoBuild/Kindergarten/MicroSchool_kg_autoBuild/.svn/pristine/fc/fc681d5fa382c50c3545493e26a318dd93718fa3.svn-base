//
//  SettingViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SettingViewController.h"
#import "FRNetPoolUtils.h"
#import "MicroSchoolAppDelegate.h"
#import "HelpViewController.h"
#import "BaseViewController.h"


@interface SettingViewController ()

@end

extern UINavigationController *navigation_Signup;
extern UINavigationController *navigation_NoUserType;
extern GuideViewController *guide_viewCtrl;

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        _aboutImgView = [[UIImageView alloc] init];
        _contactUsImgView = [[UIImageView alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"系统设置"];
    [super setCustomizeLeftButton];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(switchPush)
//                                                 name:NOTIFICATION_PUSH_Switch
//                                               object:nil];
    
    imgView = [[UIImageView alloc]init];
//    imgView.frame = CGRectMake(100, 85+(50-18)/2, 30, 18);
//    imgView.image = [UIImage imageNamed:@"icon_forNew.png"];//意见反馈的new
    imgView.image = [UIImage imageNamed:@"icon_new.png"];
    imgView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40.0, 85+(50.0-10.0)/2, 10.0, 10.0);
    
    cacheNewImg = [[UIImageView alloc]init];
    cacheNewImg.image = [UIImage imageNamed:@"icon_forNew.png"];

    
//    imgViewMsg = [[UIImageView alloc]init];
//    imgViewMsg.frame = CGRectMake(92, 45, 30, 18);
//    imgViewMsg.image = [UIImage imageNamed:@"icon_forNew"];
    
//    imgVersion = [[UIImageView alloc]init];
//    imgVersion.frame = CGRectMake(100, 45+5+50, 30, 18);
//    imgVersion.image = [UIImage imageNamed:@"icon_forNew.png"];
    
//    if ([_isNewVersion intValue] == 1) {
//        [tableViewIns addSubview:imgVersion];
//    }else{
//        [imgVersion removeFromSuperview];
//    }
    
    //[self checkNew];
    
    [ReportObject event:ID_OPEN_SYSTEM_SETTING];//2015.06.25
    
}


-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //[tableViewIns reloadData];
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    [MyTabBarController setTabBarHidden:YES];
    
    NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
    
    if ((nil == isNewVersion) || ([_isNewVersion intValue] == 1)) {
    }else {
        [_aboutImgView removeFromSuperview];
    }
    
    _isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    if ((nil == _isNewFeedback) || ([_isNewFeedback intValue] == 1)) {
    }else {
        [imgView removeFromSuperview];
    }

}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;

    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];

    // 设置背景scrollView
//    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44)];
//    scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height);
//    //scrollerView.scrollEnabled = YES;
//    scrollerView.scrollEnabled = NO;// update by kate 2014.11.6
//    scrollerView.delegate = self;
//    //scrollerView.bounces = YES;
//    scrollerView.bounces = NO;// update by kate 2014.11.6
//    scrollerView.alwaysBounceHorizontal = NO;
//    scrollerView.alwaysBounceVertical = YES;
//    scrollerView.directionalLockEnabled = YES;
//    [self.view addSubview:scrollerView];

    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44) style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    tableViewIns.scrollEnabled = YES;
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;

    [self.view addSubview:tableViewIns];
    //[scrollerView addSubview:tableViewIns];

    /*// 退出button
    UIButton *button_create = [UIButton buttonWithType:UIButtonTypeCustom];


    //button.center = CGPointMake(160.0f, 140.0f);
    
    // 设置aligment 属性
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    //button.backgroundColor = [UIColor clearColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
    
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_create addTarget:self action:@selector(quit_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"退出登录" forState:UIControlStateNormal];
    [button_create setTitle:@"退出登录" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_create];*/
    

//    if (iPhone5)
//    {
//        scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height +50);
//        
//        button_create.frame = CGRectMake(20, scrollerView.contentSize.height - 70, 280, 40);
//    }
//    if (iPhone4){
//        
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//        {
//            scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height +100);
//            
//            //button_create.frame = CGRectMake(15, scrollerView.contentSize.height - 70, 290, 40);
//        }
//        else
//        {
//            scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height);
//            
//            //button_create.frame = CGRectMake(15, scrollerView.contentSize.height - 70, 290, 40);
//        }
//    }
    
   // button_create.frame = CGRectMake(15, scrollerView.frame.size.height - 60, 290, 40);
    
}

//---检查意见反馈红点
-(void)checkNew{
    
    //lastIDForFeedback
    NSString *lastIDForFeedback = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastIDForFeedback"];

    if ([lastIDForFeedback length] > 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSString *flag = [FRNetPoolUtils isNewForFeedbackMsg:lastIDForFeedback];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if ([flag intValue] > 0) {
                    
                    [tableViewIns addSubview:imgView];
                    
                }else{
                  
                    [imgView removeFromSuperview];
                }
                
            });
            
        });
        
    }
    
}

- (IBAction)quit_btnclick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确认退出登录么？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定退出"
                              , nil];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (99 == alertView.tag) {
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];

            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"2",@"v",
                                  @"Profile", @"ac",
                                  @"quit", @"op",
                                  nil];
            
            [network sendHttpReq:HttpReq_QuitSchool andData:data];
        }
    }else if (345 == alertView.tag){
        
        if (buttonIndex == 1) {
        
            [self clearSight];
            [self clearTmpPics];
            [ReportObject event:ID_OK_CLEAR_CACHE];
            
        }else{
            [ReportObject event:ID_CACEL_CLEAR_CACHE];
        }
        
    }else{
        if (buttonIndex == 1) {
            
            //[self performSelectorInBackground:@selector(unbind) withObject:nil];
            
            [self unbind];
            
//            [self removeDefaultsInfo];
//
//            //MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] init];
//            //[self presentViewController:login animated:YES completion:nil];
//            NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
//            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//            
//            [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
//                if([fromNameToHome isEqualToString:@"splash"]){
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
//                }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
//                    
//                    [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
//                    
//                    
//                }else if ([fromNameToHome isEqualToString:@"noUserType"]){
//                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
//                }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
//                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
//                }
//            }];
//            appDelegate.tabBarController = nil;
            
            /*if([fromNameToHome isEqualToString:@"splash"]){
                
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                
                [navigation_Signup dismissViewControllerAnimated:YES completion:^{
                    [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                    appDelegate.tabBarController = nil;
                }];
                
                
            }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                [navigation_NoUserType dismissViewControllerAnimated:NO completion:^{
                    [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                    appDelegate.tabBarController = nil;
                }];
            }else{
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
            }*/
            
        }
        else {
            // nothing
            //---测试代码---------------------------------------------------
//            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate doLogOut:@"111"];
            //----------------------------------------------------------------------
            
        }
    }
}

// 清理存在userdefaults中的内容
-(void)removeDefaultsInfo{

    // 清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
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
    [defaults setObject:@"" forKey:@"viewName"];//
    [defaults setObject:nil forKey:@"weixiao_userDynamicModule"];//add by kate
    [defaults setBool:NO forKey:@"HelpNew_Done"];
    [defaults setObject:nil forKey:@"tabTitles"];
    [defaults setObject:nil forKey:@"isKnowledge"];// add by kate 2015.03.04
    [defaults setObject:nil forKey:@"knowledgeName"];// add by kate 2015.03.31
    [defaults setObject:nil forKey:@"knowledgeName"];// add by kate 2015.03.31
    [defaults setObject:nil forKey:@"foundModule"];// add by kate 2015.03.31
    [defaults setObject:nil forKey:@"momentEnter"];//add by kate 2015.03.31
    [defaults setObject:nil forKey:USER_LOGIN_TOKEN];//add by kate 2015.03.31
    [defaults setObject:nil forKey:@"MyPoints"];//add by kate 2015.08.05
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
    
    // add by ht 20140915 如果注册完毕并且登录成功后，清空用户信息，以便下一次直接进入主界面，增加userDefaults变量
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 清除登录时候的个人信息
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userSettingDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDynamicModule"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"zhixiao_autoLogin_"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*            NSString *dbFileStr = [[Utilities getMyInfoDir] stringByAppendingPathComponent:@"WeixiaoChat.db"];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if([fileManager removeItemAtPath:dbFileStr error:nil]){
     NSLog(@"1");
     }else{
     NSLog(@"0");
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
    
}

-(void)unbind{
    
    //GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    NSDictionary *user = [g_userInfo getUserDetailInfo];
//    NSString *uid= [user objectForKey:@"uid"];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [userDefaults objectForKey:@"Baidu_UserID"];
    NSString *channelid = [userDefaults objectForKey:@"Baidu_ChannelID"];
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
    
    [Utilities showProcessingHud:self.view];
    
     MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate unbindBaiduPush];//解绑 2015.12.08
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       BOOL isSuccess = [FRNetPoolUtils unBindServer:uid sid:G_SCHOOL_ID cid:@"0" clientId:userid channelId:channelid type:usertype];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];
        
            if (isSuccess) {
                
                //[userDefaults setBool:NO forKey:@"Bind_Server"];
                
                [self removeDefaultsInfo];
                
                NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
                //MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                if(appDelegate.window.rootViewController!=appDelegate.splash_viewController){
                     appDelegate.window.rootViewController = appDelegate.splash_viewController;//重置rootview add 2015.10.23
                    if([fromNameToHome isEqualToString:@"splash"]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                    }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                        
                        [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                        
                        
                    }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                        [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                    }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                        
                        if (guide_viewCtrl) {
                            [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                        [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                    }
                    
                     appDelegate.tabBarController = nil;
                    
                }else{
                    [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                        if([fromNameToHome isEqualToString:@"splash"]){
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                        }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                            
                            [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                            
                            
                        }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                            [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                        }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                            
                            if (guide_viewCtrl) {
                                [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                            }
                            
                            [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                        }
                    }];
                    appDelegate.tabBarController = nil;
                }
               
                
            }else{
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"退出登录失败"
                                                               message:@"点击确定再试一次或点击取消稍后再试。"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确定",nil];
                alert.tag = 399;
                [alert show];
                
            }
            
        });
    
    });
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //这个方法用来告诉表格有几个分组
    //return 3;
    
    return 3;
}

// - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 2) {
//        if (iPhone5) {
//            return 60;
//        } else {
//            return 80;
//        }
//    }
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    if (0 == section) {
        rowCount = 2;
    }else if(1 == section) {
        rowCount = 2;
    }else if(2 == section) {
        rowCount = 1;
    }
    
    return rowCount;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 40;// update 2015.04.14
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (iPhone5)
//    {
//        tableViewIns.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height + 20);
//    }
//    else
//    {
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//        {
//            tableViewIns.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height + 90);
//        }
//        else
//        {
//            tableViewIns.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height + 30);
//        }
//    }
    if (2 == [indexPath section] && 0 == [indexPath row]){
        
        static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier0";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
        
    }else {
        static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //cell.backgroundColor =   [UIColor clearColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        /*if (0 == [indexPath section] && 0 == [indexPath row]) {
         cell.textLabel.text = @"个人资料";
         }else if (0 == [indexPath section] && 1 == [indexPath row]){
         cell.textLabel.text = @"联系方式";
         }else if (0 == [indexPath section] && 2 == [indexPath row]){
         cell.textLabel.text = @"账号绑定";
         }else if (0 == [indexPath section] && 3 == [indexPath row]){
         cell.textLabel.text = @"退出学校";
         }else if (1 == [indexPath section] && 0 == [indexPath row]){
         cell.textLabel.text = @"通知栏提醒";
         UISwitch *push = [[UISwitch alloc] init];
         if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
         push.on = NO;
         } else {
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         NSString *msgSwitch = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"MessageSwitch"]];
         if ([msgSwitch isEqualToString:@"2"]) {
         push.on = NO;
         } else {
         push.on = YES;
         }
         }
         [push addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
         cell.accessoryView = push;
         }else if (1 == [indexPath section] && 1 == [indexPath row]){
         cell.textLabel.text = @"隐私筛选";
         }else if (1 == [indexPath section] && 2 == [indexPath row]){
         cell.textLabel.text = @"修改密码";
         }else if (2 == [indexPath section] && 0 == [indexPath row]){
         cell.textLabel.text = @"意见反馈";
         }else if (2 == [indexPath section] && 1 == [indexPath row]){
         cell.textLabel.text = @"用户帮助";
         }else if (2 == [indexPath section] && 2 == [indexPath row]){
         cell.textLabel.text = @"关于知校";
         }else{
         return nil;
         }*/
        
        cell.textLabel.textColor = [UIColor blackColor];
        
        if (0 == [indexPath section] && 0 == [indexPath row]){
            
            float size = [self getCache];
            
            // NSString *clearCacheName = size >= 1 ? [NSString stringWithFormat:@"%.2fM",size] : [NSString stringWithFormat:@"%.2fK",size * 1024];
            
            NSString *tempSize;
            
            if (size >= 1) {
                
                if (size >= 1024) {
                    tempSize = [NSString stringWithFormat:@"%.2fG",size/1024.0];
                }else{
                    tempSize = [NSString stringWithFormat:@"%.2fM",size];
                }
                
                
            }else{
                tempSize = [NSString stringWithFormat:@"%.2fK",size * 1024];
                
            }
            
            if (size == 0) {
                tempSize = @"0M";
            }
            
            cell.textLabel.text = @"清除本地缓存";
            cell.detailTextLabel.text = tempSize;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            //        NSString *cacheNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheNew"];
            //
            //        if (nil == cacheNew) {
            //            cacheNewImg.frame = CGRectMake(97+30.0, (44 - 18)/2+2, 32, 20);
            //            cacheNewImg.image = [UIImage imageNamed:@"icon_forNew.png"];
            //
            //            [cell addSubview:cacheNewImg];
            //        }else {
            //            [cacheNewImg removeFromSuperview];
            //        }
            
        }else if(0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"意见反馈";
            if ([_isNewFeedback intValue] == 1) {
                
                imgView.frame = CGRectMake(cell.frame.size.width - 40.0,(40.0 - 10)/2-0.5 , 10.0, 10.0);
                imgView.image = [UIImage imageNamed:@"icon_new.png"];
                
                [cell addSubview:imgView];
            }else {
                [imgView removeFromSuperview];
            }
            
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"关于知校";
            
            //NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
            
            //if ((nil == isNewVersion) || ([_isNewVersion intValue] == 1)) {
            if ([_isNewVersion intValue] == 1) {
           
//                _aboutImgView.frame = CGRectMake(97, (44 - 18)/2+2, 32, 20);
//                _aboutImgView.image = [UIImage imageNamed:@"icon_forNew.png"];
                
                _aboutImgView.frame = CGRectMake(cell.frame.size.width - 40.0,(40.0 - 10)/2-0.5 , 10.0, 10.0);
                _aboutImgView.image = [UIImage imageNamed:@"icon_new.png"];
                
                [cell addSubview:_aboutImgView];
            }else {
                [_aboutImgView removeFromSuperview];
            }
            
            //cell.textLabel.text = @"用户帮助";
        }else if (1 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"联系我们";
            //cell.textLabel.text = @"用户帮助";
            
            //contactUsImgView
            /*去掉new标实 2015.07.28
             NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNewForConctactUs"];
             
             if (!isNewVersion) {
             
             _contactUsImgView.frame = CGRectMake(97, (44 - 18)/2+2, 32, 20);
             _contactUsImgView.image = [UIImage imageNamed:@"icon_forNew.png"];
             [cell addSubview:_contactUsImgView];
             
             }else {
             [_contactUsImgView removeFromSuperview];
             }*/
            
            
        }else if (2 == [indexPath section] && 0 == [indexPath row]){
            
            
        }
        //    else if (0 == [indexPath section] && 2 == [indexPath row]){
        //        cell.textLabel.text = @"关于知校";
        //    }
        return cell;
    }
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后的反显颜色即刻消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*if (0 == [indexPath section] && 0 == [indexPath row]) {
        PersonalInfoViewController *personalViewCtrl = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:personalViewCtrl animated:YES];
        personalViewCtrl.title = @"个人资料";
    }else if (0 == [indexPath section] && 1 == [indexPath row]){
        ContactViewController *contactViewCtrl = [[ContactViewController alloc] init];
        [self.navigationController pushViewController:contactViewCtrl animated:YES];
        contactViewCtrl.title = @"联系方式";
    }else if (0 == [indexPath section] && 2 == [indexPath row]){
        [self.view makeToast:@"敬请期待."
                    duration:0.5
                    position:@"center"
                       title:nil];
//        AccountViewController *accountViewCtrl = [[AccountViewController alloc] init];
//        [self.navigationController pushViewController:accountViewCtrl animated:YES];
//        accountViewCtrl.title = @"账号绑定";
    }else if (0 == [indexPath section] && 3 == [indexPath row]){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"退出学校后，您的个人信息将保留，但学校相关信息将被清空，请慎重操作！"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定退出",nil];
        alert.tag = 99;
        [alert show];
    }else if (1 == [indexPath section] && 0 == [indexPath row]){
//        [self.view makeToast:@"敬请期待."
//                    duration:0.5
//                    position:@"center"
//                       title:nil];
//        MessageViewController *messageViewCtrl = [[MessageViewController alloc] init];
//        [self.navigationController pushViewController:messageViewCtrl animated:YES];
//        messageViewCtrl.title = @"消息提醒";
    }else if (1 == [indexPath section] && 1 == [indexPath row]){
        [self.view makeToast:@"敬请期待."
                    duration:0.5
                    position:@"center"
                       title:nil];
//        PrivateViewController *privateViewCtrl = [[PrivateViewController alloc] init];
//        [self.navigationController pushViewController:privateViewCtrl animated:YES];
//        privateViewCtrl.title = @"隐私筛选";
    }else if (1 == [indexPath section] && 2 == [indexPath row]){
        PasswordViewController *passwordViewCtrl = [[PasswordViewController alloc] init];
        [self.navigationController pushViewController:passwordViewCtrl animated:YES];
        passwordViewCtrl.title = @"修改密码";
    }else if (2 == [indexPath section] && 0 == [indexPath row]){
        CommentViewController *commentViewCtrl = [[CommentViewController alloc] init];
        [self.navigationController pushViewController:commentViewCtrl animated:YES];
        commentViewCtrl.title = @"意见反馈";
    }else if (2 == [indexPath section] && 1 == [indexPath row]){
        [self.view makeToast:@"敬请期待."
                    duration:0.5
                    position:@"center"
                       title:nil];
//        HelpViewController *helpViewCtrl = [[HelpViewController alloc] init];
//        [self.navigationController pushViewController:helpViewCtrl animated:YES];
//        helpViewCtrl.title = @"用户帮助";
    }else if (2 == [indexPath section] && 2 == [indexPath row]){
        AboutViewController *aboutViewCtrl = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutViewCtrl animated:YES];
        aboutViewCtrl.title = @"关于知校";
    }*/
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {//清理本地缓存
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"cacheNew"];
        
        [tableViewIns reloadData];
        
        [ReportObject event:ID_CLICK_CLEAR_CACHE];
        
        if ([self getCache] > 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 345;
            [alert show];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时不用清除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        
    }else if (0 == [indexPath section] && 1 == [indexPath row]){//意见反馈
        
        [imgView removeFromSuperview];
        
        MsgDetailsViewController *msgDetailV = [[MsgDetailsViewController alloc]initWithFromName:@"feedback"];
        [self.navigationController pushViewController:msgDetailV animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isNewFeedback"];
        [[NSUserDefaults standardUserDefaults] synchronize];//意见返回存储

    }else if (1 == [indexPath section] && 0 == [indexPath row]){//关于知校
        
        AboutViewController *aboutViewCtrl = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutViewCtrl animated:YES];
        aboutViewCtrl.title = @"关于知校";
        
    }else if (1 == [indexPath section] && 1 == [indexPath row]){//联系我们
        
        [_contactUsImgView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNewForConctactUs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ContactUsViewController *contactUs = [[ContactUsViewController alloc] init];
        [self.navigationController pushViewController:contactUs animated:YES];
        
    }else if (2 == [indexPath section] && 0 == [indexPath row]){//退出登录
        
        [self quit_btnclick:nil];
        
    }
}

-(void)removeMaskView{
    [Utilities dismissProcessingHud:self.view];
}

//-(void)switchPushOn{
//    
//    [switchButton];
//    
//}
//
//-(void)switchPushOff{
//    
//    
//}

/*
 * 推送提醒 1:打开  2:关闭
 */
- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            [switchButton setOn:NO];
            
            
            // 提醒用户到系统的设置中进行修改
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请在iPhone的“设置”-“通知”功能中找到应用程序“东方高中”进行修改。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil,nil];
            alertView.tag = 98;
            [alertView show];
            //[alertView release];
        } else {
            // 向服务器请求打开推送通知开关
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];
            [switchButton setOn:YES];

        }
    } else {
        // 向服务器请求关闭推送通知开关
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_UNBIND_BAIDU_PUSH object:nil];
        [switchButton setOn:NO];
        
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        // 清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
        // 清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
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
        [defaults setObject:@"" forKey:@"viewName"];//
        [defaults setObject:nil forKey:@"weixiao_userDynamicModule"];//add by kate
        [defaults setBool:NO forKey:@"HelpNew_Done"];
        [defaults setObject:nil forKey:@"tabTitles"];
        [defaults synchronize];
        
        // 清除发布作业保存之前的标题
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"homeworkTitle"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // add by ht 20140915 如果注册完毕并且登录成功后，清空用户信息，以便下一次直接进入主界面，增加userDefaults变量
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDetailInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDynamicModule"];
        [[NSUserDefaults standardUserDefaults] synchronize];

       /* NSString *dbFileStr = [[Utilities getMyInfoDir] stringByAppendingPathComponent:@"WeixiaoChat.db"];
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

//        MicroSchoolLoginViewController *login = [[MicroSchoolLoginViewController alloc] init];
////        [self presentViewController:login animated:YES completion:nil];
//        
//        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        [appDelegate.window addSubview:login.view];
        
        NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
            if([fromNameToHome isEqualToString:@"splash"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                
                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                
                
            }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
            }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }
        }];
        appDelegate.tabBarController = nil;
        /*if([fromNameToHome isEqualToString:@"splash"]){
         
            [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
            appDelegate.tabBarController = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
        }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
            
            [navigation_Signup dismissViewControllerAnimated:YES completion:^{
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
            }];
            
            
        }else if ([fromNameToHome isEqualToString:@"noUserType"]){
            [navigation_NoUserType dismissViewControllerAnimated:NO completion:^{
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
            }];
        }else{
            [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
            appDelegate.tabBarController = nil;
        }*/
        
        [ReportObject event:ID_LOGOUT];//2015.06.25
        
    }
    else
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

// 清除缓存
- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    //NSLog(@"clear disk");
    
    [tableViewIns reloadData];
    
    [Utilities showSuccessedHud:@"清除成功" descView:self.view];
    
}


- (void)clearSight
{

    NSString *sightDocPath = [Utilities getFilePath:PathType_SightPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager removeItemAtPath:sightDocPath error:nil];
}

// 获取缓存大小
-(float)getCache{
    
    NSUInteger tmpSize =[[SDImageCache sharedImageCache] getSize];
    
    NSString *amrDocPath = [Utilities getFilePath:PathType_SightPath];
    NSUInteger sightSize = [self folderSizeAtPath:amrDocPath];
    
    float size = (tmpSize+sightSize)/1024.0/1024.0;
    
    return size;
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{

    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

@end
