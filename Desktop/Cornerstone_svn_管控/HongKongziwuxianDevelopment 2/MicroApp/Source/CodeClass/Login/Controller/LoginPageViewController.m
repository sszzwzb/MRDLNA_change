//
//  LoginPageViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "LoginPageViewController.h"

#import "LoginPageView.h"
#import "AppDelegate.h"


@interface LoginPageViewController () <LoginPageViewDelegate,HttpReqCallbackDelegate>

@property (nonatomic,strong) NSString *userName;

@end

@implementation LoginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    
    _userName = [NSString string];
    
    [self upView];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void)upView
{
    LoginPageView *Lv = [[LoginPageView alloc]initWithFrame:
                         self.view.frame];
    [self.view addSubview:Lv];
    
    Lv.delegate = self;
}

#pragma mark - LoginPageViewDelegate
-(void)slectButDetermineWithName:(NSString *)name pwd:(NSString *)pwd
{
    NSLog(@"账号 = %@   密码 = %@",name, pwd);
    
    if ([[Utilities replaceNull:name] isEqualToString:@""]) {
        [Utilities showTextHud:@"请输入用户名" descView:self.view];
    } else if ([[Utilities replaceNull:pwd] isEqualToString:@""]) {
        [Utilities showTextHud:@"请输入密码" descView:self.view];
    } else {
        
        _userName = name;
        
        [self up_dataWithName:name pwd:pwd];
    }
    
}

-(void)TheAnimation
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (!appDelegate.tabBarController) {
            
            UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
            [tabBarControllerNavi popToRootViewControllerAnimated:NO];
            
            
            [MicroMainMenuViewController initTabBarController];
            
        }
        
    });
}

-(void)toolsView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (!appDelegate.tabBarController) {
            
            UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
            [tabBarControllerNavi popToRootViewControllerAnimated:NO];
            
            
            [MicroMainMenuViewController initToolsController];
            
        }
        
    });
}

-(void)OnlyEditView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (!appDelegate.tabBarController) {
            
            UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
            [tabBarControllerNavi popToRootViewControllerAnimated:NO];
            
            
            [MicroMainMenuViewController initOnlyEditController];
            
        }
        
    });
}



-(void)up_dataWithName:(NSString *)name pwd:(NSString *)pwd
{
    /**
     
     登录接口
     http://app.meridianjet.vip/login.svc/LoginCheck?username=%E6%8A%80%E6%9C%AF%E4%B8%AD%E5%BF%83&password=12345678
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0
     app_code  手机型号版本     iphone 6 什么的
     app_way   区分Android，iOS，PC 途径     Android 0，iOS 1，PC 2 或其他
     
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [Utilities getCurrentDeviceModel];
    // 去掉型号里面的空格
    mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    NSString *app_code = [NSString stringWithFormat:@"%@_%@",mobile_model,os_version];
    
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/LoginCheck",
                           
                           @"username":name,
                           @"password":pwd,
                           @"app":appVersion,
                           @"appId":@"0",
                           @"app_way":@"1",
                           @"app_code":app_code
                           };
    
    [network sendHttpReq:HttpReq_GetLogin andData:data];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"LoginPageViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
    
    //   登录
    if (type == HttpReq_GetLogin) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            [Utilities showTextHud:@"登录成功" descView:self.view];
            
            //   用户登录名称
            [UtilitiesData setLoginUserName:_userName];
            
            [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1.f];
            
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
    }
}




@end
