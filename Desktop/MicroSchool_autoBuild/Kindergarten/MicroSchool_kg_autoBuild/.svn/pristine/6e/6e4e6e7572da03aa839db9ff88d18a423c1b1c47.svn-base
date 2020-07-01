//
//  HelpViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "HelpViewController.h"
#import "MyTabBarController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    
    [super setCustomizeTitle:@"用户帮助"];
    [super setCustomizeLeftButton];
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    // 课表
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/about/about.php?identity=%@",SERVER_URL,usertype];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44)];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    [webView setBackgroundColor:[UIColor clearColor]];
    webView.delegate = self;
    
    [self.view addSubview: webView];
    
    [Utilities showProcessingHud:self.view];
    
    [ReportObject event:ID_OPEN_USER_HELP];//2015.06.25
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MyTabBarController setTabBarHidden:YES];
}
-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Utilities dismissProcessingHud:self.view];
}

// add by kate 2015.06.30
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [Utilities dismissProcessingHud:self.view];
    //httpError 200-400 是正常的
    
    //NSLog(@"code:%d",error.code);
    
    if ([error code] == NSURLErrorCancelled){//错误标实
        //在一个网页中进入下一级网页，加载中途会取消前一个url，所以会报错，这种情况不给用户提示
        //NSLog(@"Canceled request: %@", [webView.request.URL absoluteString]);
    }else{
        
        NSString *errorResult = [error.userInfo objectForKey:@"NSLocalizedDescription"];//错误描述
        //NSLog(@"userInfo:%@",error.userInfo);
        
        if ([errorResult length] > 0) {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"网页加载失败" message:errorResult delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertV.delegate = self;
            [alertV show];
        }
        
    }
    
}

// add by kate 2015.06.30
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
