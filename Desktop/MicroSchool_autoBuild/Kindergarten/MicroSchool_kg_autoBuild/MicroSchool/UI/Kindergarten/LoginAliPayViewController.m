//
//  LoginAliPayViewController.m
//  MicroSchool
//
//  Created by banana on 16/7/27.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "LoginAliPayViewController.h"
#import "MyTabBarController.h"
#import "TSNetworking.h"
@interface LoginAliPayViewController ()<UIWebViewDelegate>{
UIWebView *currentWebView;
    UIButton *leftButton;
}

@end

@implementation LoginAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setBackgroundColor:[UIColor cyanColor]];
//    leftButton.frame = CGRectMake(0, 25, 33, 33);
//    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
//    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:leftButton];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildWebView];
}
- (void)buildWebView{
    currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, [UIScreen mainScreen].applicationFrame.size.height )];
    [currentWebView setBackgroundColor:[UIColor clearColor]];
    currentWebView.delegate = self;
//    //原始320 568
    currentWebView.userInteractionEnabled = YES;
    currentWebView.scalesPageToFit = YES;
//    [(UIScrollView *)[[currentWebView subviews] objectAtIndex:0] setBounces:NO];
//    currentWebView.scrollView.contentSize = CGSizeMake(0, 600);
    //VIPUrl是原始的 url  然后在此  经过两次拼接   获得最后的 URL
//    NSString *urlStr = [Utilities appendUrlParams:_passUrl];
//    NSDictionary * userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
//    NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
//    NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&student_number_id=%@", urlStr, cid, [userD objectForKey:@"student_number_id"]];
    NSURL *url = [[NSURL alloc]initWithString:_passUrl];
    [currentWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.navigationController.navigationBar.hidden = YES;
    [MyTabBarController setTabBarHidden:YES];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(0, 0, WIDTH, 20);
    topLabel.backgroundColor = [UIColor colorWithRed:82.0 / 255 green:166.0 / 255 blue:154.0 / 255 alpha:1];
    [self.view addSubview:topLabel];
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 25, 63, 33);
//    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: currentWebView];
    [self.view addSubview:leftButton];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%@", request.URL.absoluteString); //可以直接拿到发送请求的网址
    if ([request.URL.absoluteString containsString:@"5xiaoyuan.cn/weixiao/alipay/call_back_url.php"]) {
        //        return YES;
        leftButton.frame = CGRectMake(0, 32, 63, 33);
            [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
            [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    }
    
    else if ([request.URL.absoluteString containsString:@"alipay.com/service/rest.htm?"]) {
//        LoginAliPayViewController *login = [[LoginAliPayViewController alloc] init];
//        login.passUrl = request.URL.absoluteString;
//        [self.navigationController pushViewController:login animated:YES];
//        return NO;
    }
    return YES;
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
