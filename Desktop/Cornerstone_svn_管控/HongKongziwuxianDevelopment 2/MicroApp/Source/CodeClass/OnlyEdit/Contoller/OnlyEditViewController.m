//
//  OnlyEditViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditViewController.h"

#import "OnlyEditPerViewController.h"

#import "AppDelegate.h"

@interface OnlyEditViewController ()

@end

@implementation OnlyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setCustomizeTitle:@"子午线"];
    
    [self up_segmentView];
    
    
    [self setCustomizeRightButtonWithName:@"退出" color:[UIColor whiteColor]];
    [self setCustomizeLeftButtonWithName:@"切换文字" color:[UIColor whiteColor]];
}

-(void)selectLeftAction:(id)sender
{
    NSLog(@"修改语言");
    
    //修改语言
    NSString *language = [ChangeLanguage userLanguage];
    
    if ([language isEqualToString:@"en"]) {
        [ChangeLanguage setUserlanguage:@"zh-Hans"];
    } else {
        [ChangeLanguage setUserlanguage:@"en"];
    }
    
    NSLog(@"获取当前语言  =  %@",[ChangeLanguage userLanguage]);
    
    
    [self performSelector:@selector(reOpenApp) withObject:nil afterDelay:1.f];
    
}

-(void)selectRightAction:(id)sender
{
    NSLog(@"退出登录");
    
    [Utilities showTextHud:@"退出登录成功！" descView:nil];
    
    [UtilitiesData setLoginUserName:@""];
    
    //  登录
    [self performSelector:@selector(loginView) withObject:nil afterDelay:1.f];
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

-(void)reOpenApp
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


-(void)up_segmentView
{
    self.segmentHighlightColor = color_blue;
    self.segmentBorderColor = color_blue;
    self.segmentTitleColor = rgb(153, 153, 153);
    self.segmentBackgroundColor = [UIColor whiteColor];
    
    
    self.segmentControl.frame = CGRectMake(0, 0, KScreenWidth, 49);
    self.scrollView.frame = CGRectMake(0, 49, KScreenWidth, KScreenHeight - 49);
    
    
    NSArray *arrM = @[
                      @{
                          @"classVC":@"OnlyEditPerViewController",
                          @"title":@"工作任务",
                          @"type":@"0"
                          },
                      @{
                          @"classVC":@"OnlyEditPerViewController",
                          @"title":@"待上传",
                          @"type":@"1"
                          },
                      @{
                          @"classVC":@"OnlyEditPerViewController",
                          @"title":@"已完成",
                          @"type":@"2"
                          },
                      ];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arrM enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        OnlyEditPerViewController *vc = [NSClassFromString(dict[@"classVC"]) new];
        vc.title = dict[@"title"];
        
        vc.type = dict[@"type"];
        
        [arr addObject:vc];
    }];
    
    self.viewControllers = arr;
}

@end
