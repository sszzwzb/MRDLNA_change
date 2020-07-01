//
//  GrowVIPViewController.m
//  MicroSchool
//
//  Created by banana on 16/7/25.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "GrowVIPViewController.h"
#import "MyTabBarController.h"
#import "TSNetworking.h"
#import "LoginAliPayViewController.h"
@interface GrowVIPViewController ()<UIWebViewDelegate>{
    UIWebView *currentWebView;
    BOOL isAgree;
    NSString *currentURL;
    UIButton *leftButton;
    NSInteger count;
}

@end

@implementation GrowVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count = 0;
    
    [self setCustomizeTitle:@""];
//    [self buildWebView];
}
- (void)buildWebView{
    if (isAgree) {

        count = count + 1;
        if (nil == currentWebView) {
            currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20 - 44)];

        }
        currentWebView.frame = CGRectMake(0, 64, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20 - 44);
    [currentWebView setBackgroundColor:[UIColor clearColor]];
    currentWebView.delegate = self;
        NSURL *url = [[NSURL alloc]initWithString:currentURL];
        [currentWebView loadRequest:[NSURLRequest requestWithURL:url]];
        self.navigationController.navigationBar.hidden = YES;
        [MyTabBarController setTabBarHidden:YES];
        
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.frame = CGRectMake(0, 0, WIDTH, 20);
        topLabel.backgroundColor = [UIColor colorWithRed:82.0 / 255 green:166.0 / 255 blue:154.0 / 255 alpha:1];
        [self.view addSubview:topLabel];
        
        UILabel *midLabel = [[UILabel alloc] init];
        midLabel.frame = CGRectMake(0, 18, WIDTH, 44);
        midLabel.backgroundColor = [UIColor colorWithRed:82.0 / 255 green:166.0 / 255 blue:154.0 / 255 alpha:1];
        [self.view addSubview:midLabel];
        
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.frame = CGRectMake(0, 25, 63, 33);
            [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
            [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        [midLabel addSubview:leftButton];
        [self.view addSubview:leftButton];
        [self.view addSubview: currentWebView];
//        [Utilities showProcessingHud:self.view];
    }else{
        if (nil == currentWebView) {
            currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20 )];
            
        }

//        currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20)];
        [currentWebView setBackgroundColor:[UIColor clearColor]];
        currentWebView.delegate = self;
        //原始320 568
        [(UIScrollView *)[[currentWebView subviews] objectAtIndex:0] setBounces:NO];
        currentWebView.scrollView.contentSize = CGSizeMake(0, 580);
        //VIPUrl是原始的 url  然后在此  经过两次拼接   获得最后的 URL
        NSString *urlStr = [Utilities appendUrlParams:_VIPUrl];
        NSDictionary * userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
        NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&student_number_id=%@", urlStr, cid, [userD objectForKey:@"student_number_id"]];
        NSURL *url = [[NSURL alloc]initWithString:reqUrl];
        [currentWebView loadRequest:[NSURLRequest requestWithURL:url]];
        self.navigationController.navigationBar.hidden = YES;
        [MyTabBarController setTabBarHidden:YES];
        
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.frame = CGRectMake(0, 25, 33, 33);
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview: currentWebView];
        [self.view addSubview:leftButton];

    
    }


}
//在UIScrollView没有什么方法，不过有一个方法可以达到你的目标，这是我的方法： -
-(void)disableBounce {
    
    for (id subview in
         self.view.subviews)
        
        if ([[subview class] isSubclassOfClass:
             [UIScrollView class]])
            
            ((UIScrollView *)subview).bounces =
            NO;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } 
} 

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildWebView];
    [Utilities showProcessingHud:self.view];
}
#if  1
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Utilities dismissProcessingHud:self.view];
    NSString *currentTitle  = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    ((UILabel *)self.navigationItem.titleView).frame = CGRectMake(((UILabel *)self.navigationItem.titleView).frame.origin.x,  ((UILabel *)self.navigationItem.titleView).frame.origin.y, 100.0, ((UILabel *)self.navigationItem.titleView).frame.size.height);
//    ((UILabel *)self.navigationItem.titleView).text = currentTitle;
    UILabel *labeletitle = [[UILabel alloc] init];
    labeletitle.frame = CGRectMake((WIDTH - 120) / 2, 30, 120, 20);
    labeletitle.text = currentTitle;
    labeletitle.backgroundColor = [UIColor clearColor];
    labeletitle.textAlignment = NSTextAlignmentCenter;
    labeletitle.textColor = [UIColor whiteColor];
    [self.view addSubview:labeletitle];
//    [self setTitle:currentTitle];
//    [self setCustomizeTitle:currentTitle];
}
#endif
-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", request.URL.absoluteString); //可以直接拿到发送请求的网址
    if ([request.URL.absoluteString containsString:@"5xiaoyuan.cn/wap/m/growth_term.html"]) {
        currentURL = [NSString stringWithFormat:@"%@", request.URL.absoluteString];
        isAgree = YES;
        if (count == 0) {
                    [currentWebView removeFromSuperview];
            
            [self buildWebView];
//            [Utilities showProcessingHud:self.view];
        }
        isAgree = NO;
        return YES;
    }

    else if ([request.URL.absoluteString containsString:@"alipay.com/service/rest.htm?"]) {
        LoginAliPayViewController *login = [[LoginAliPayViewController alloc] init];
        login.passUrl = request.URL.absoluteString;
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    NSLog(@"webViewDidStartLoad");
//    [Utilities showProcessingHud:self.view];

}


-(void)webView:(UIWebView*)webView  didFailLoadWithError:(NSError*)error{
    [Utilities dismissProcessingHud:self.view];
//    NSLog(@"DidFailLoadWithError");
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(0, 0, WIDTH, 20);
    topLabel.backgroundColor = [UIColor colorWithRed:82.0 / 255 green:166.0 / 255 blue:154.0 / 255 alpha:1];
    [self.view addSubview:topLabel];
    
    UILabel *midLabel = [[UILabel alloc] init];
    midLabel.frame = CGRectMake(0, 18, WIDTH, 44);
    midLabel.backgroundColor = [UIColor colorWithRed:82.0 / 255 green:166.0 / 255 blue:154.0 / 255 alpha:1];
    [self.view addSubview:midLabel];

    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 25, 63, 33);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *elseView = [[UIView alloc] init];
//    elseView.frame = CGRectMake(0, 64, WIDTH, [UIScreen mainScreen].bounds.size.height - 64);
//    [self.view addSubview:elseView];
//    [self.view addSubview: currentWebView];
    [self.view addSubview:leftButton];

    //判断网络情况  无网就上一个空白页
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        [self.view addSubview:noNetworkV];
        return;
    }
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
