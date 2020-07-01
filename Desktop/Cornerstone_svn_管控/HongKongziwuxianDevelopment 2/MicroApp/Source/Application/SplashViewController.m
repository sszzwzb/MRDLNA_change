//
//  SplashViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/16.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "SplashViewController.h"

#import "AppDelegate.h"


#import "RootTabBarViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
//    NSLog(@"当前app信息 = %@",[[NSBundle mainBundle] infoDictionary]);
    
    NSArray *UILaunchImagesArr = [Utilities replaceArrNull:[[NSBundle mainBundle] infoDictionary][@"UILaunchImages"]];
    
    NSString *imgStr = @"LaunchImage-800-667h";
    for (NSDictionary *dic in UILaunchImagesArr) {
        NSString *UILaunchImageSizeStr = [Utilities replaceNull:dic[@"UILaunchImageSize"]];
        NSString *curSizeStr = [NSString stringWithFormat:@"{%.0lf, %.0lf}",KScreenWidth,KScreenHeight];
        if ([UILaunchImageSizeStr isEqualToString:curSizeStr]) {
            imgStr = [Utilities replaceNull:dic[@"UILaunchImageName"]];
        }
    }
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:
                         CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:imgV];
    imgV.image = [UIImage imageNamed:imgStr];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    if ( ![[Utilities replaceNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"SplashViewController_v1.2.0"]] isEqualToString:@"YES"]) {
        //初始化应用语言，只执行一次
        [ChangeLanguage initUserLanguage];
        NSLog(@"初始化 获取自定义当前语言  =  %@",[ChangeLanguage userLanguage]);
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"SplashViewController_v1.2.0"];
    
    
    if ([[UtilitiesData getLoginUserName] isEqualToString:@""]) {
        //  登录
        [self performSelector:@selector(loginView) withObject:nil afterDelay:1.f];
    } else {
        //  闪屏时间
        [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1.f];
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

-(void)loginView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (!appDelegate.tabBarController) {
            
            UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
            [tabBarControllerNavi popToRootViewControllerAnimated:NO];
            
            
            [MicroMainMenuViewController initLoginController];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
