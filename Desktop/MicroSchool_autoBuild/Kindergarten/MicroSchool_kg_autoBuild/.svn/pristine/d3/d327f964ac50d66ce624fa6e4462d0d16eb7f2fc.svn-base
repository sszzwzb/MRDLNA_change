//
//  NetworkGuideViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "NetworkGuideViewController.h"
#import "MyTabBarController.h"

@interface NetworkGuideViewController ()

@end

@implementation NetworkGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MyTabBarController setTabBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"网络无法连接"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [MyTabBarController setTabBarHidden:NO];
}

@end
