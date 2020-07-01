//
//  ContactUsViewController.m
//  MicroSchool
//
//  Created by jojo on 15/6/6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
}

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"联系我们"];
    [super setCustomizeLeftButton];
    [self buildWebView];
    //    [ReportObject event:ID_OPEN_CONTACT_US];//2015.06.25
}
- (void)buildWebView
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    NSURLRequest *request;
    
#if IS_TEST_SERVER
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://test.5xiaoyuan.cn/open/index.php/WebView/ContactUs/index"]];
#else
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.5xiaoyuan.cn/open/index.php/WebView/ContactUs/index"]];
#endif
    
    [self.view addSubview:webView];
    [webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
