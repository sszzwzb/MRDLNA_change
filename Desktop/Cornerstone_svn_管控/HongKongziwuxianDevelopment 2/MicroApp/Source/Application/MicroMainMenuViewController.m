//
//  MicroMainMenuViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/7/16.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MicroMainMenuViewController.h"

#import "AppDelegate.h"
#import "LoginPageViewController.h"

#import "ToolsPageViewController.h"

#import "OnlyEditViewController.h"

@interface MicroMainMenuViewController ()

@end

@implementation MicroMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initTabBarController
{
    
    RootTabBarViewController *rootvc = [[RootTabBarViewController alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = rootvc;
    
}


+ (void)initLoginController
{
    
    LoginPageViewController *rootvc = [[LoginPageViewController alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UINavigationController *rootnvc = [[UINavigationController alloc]initWithRootViewController:rootvc];
    
    appDelegate.window.rootViewController = rootnvc;
    
}

+ (void)initToolsController
{
    
    ToolsPageViewController *rootvc = [[ToolsPageViewController alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    UINavigationController *rootnvc = [[UINavigationController alloc]initWithRootViewController:rootvc];
    
    appDelegate.window.rootViewController = rootnvc;
    
}

+ (void)initOnlyEditController
{
    
    OnlyEditViewController *rootvc = [[OnlyEditViewController alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    UINavigationController *rootnvc = [[UINavigationController alloc]initWithRootViewController:rootvc];
    
    appDelegate.window.rootViewController = rootnvc;
    
}

@end
