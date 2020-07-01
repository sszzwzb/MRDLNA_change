//
//  MyInfoWebViewController.m
//  MicroSchool
//
//  Created by banana on 16/8/16.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MyInfoWebViewController.h"
#import "MyTabBarController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface MyInfoWebViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
}


@end
#define WebViewNav_TintColor [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]
@implementation MyInfoWebViewController

- (void)viewDidLoad {
    self.view.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    [super viewDidLoad];
    //    self.tabBarController.tabBar.hidden = YES;
    if ([self.titleName isEqualToString:@"成长VIP"] ||[self.titleName isEqualToString:@"我的工资"] || [self.titleName isEqual:@"考勤"] || _ifShowNavi) {
        self.navigationController.navigationBar.hidden = NO;
        [self setCustomizeTitle:self.titleName];
    }else{
    
        self.navigationController.navigationBar.hidden = YES;
    }
    [self setCustomizeLeftButton];
    [MyTabBarController setTabBarHidden:YES];
    [self buildWebView];
    // Do any additional setup after loading the view.
}
- (void)buildWebView{
    
    //[Utilities showProcessingHud:self.view];
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
   
    webView = [[UIWebView alloc] init];
    if ([self.titleName isEqualToString:@"成长VIP"]||[self.titleName isEqualToString:@"我的工资"] || [self.titleName isEqual:@"考勤"] || _ifShowNavi) {
        webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  -44 - 20);
        webView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
        [self setCustomizeTitle:self.titleName];
        progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        
        
    }else{
        
        webView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -20);
        webView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:52.0 / 255 green:52.0 / 255 blue:57.0 / 255 alpha:1];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        [self.view addSubview:view];
        
         progressView.frame = CGRectMake(0, 20, self.view.frame.size.width, 0);
        
    }
//    webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  -44);
    webView.delegate = self;
    //    NSString *urlStr = @"http://baijia.baidu.com/";
    NSString *url = self.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [webView loadRequest:request];
    
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    //[self.view addSubview:webView];
    [self.view insertSubview:webView belowSubview:progressView];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
}

-(void)selectLeftAction:(id)sender
{
    if ([_titleName isEqualToString:@"题组选题"] || [_titleName isEqualToString:@"题库选题"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyView" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
     self.loadCount --;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [Utilities dismissProcessingHud:self.view];
     self.loadCount --;
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    context[@"closeWindow"] = ^() {
        NSLog(@"sbbbbb");
        
        [self performSelectorOnMainThread:@selector(toHistoryView) withObject:nil waitUntilDone:YES];
        
    };
    if (_ifShowCurrentWebViewTitle) {
        
        [self setCustomizeTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }else{
    
    }
    
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
- (BOOL)gestureRecognizerShouldBegin{
    //    [self cancelAction];
    BOOL isBack = NO;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    

    return isBack;
}

- (void)toHistoryView
{
    if ([_titleName isEqualToString:@"题组选题"] || [_titleName isEqualToString:@"题库选题"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyView" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"sbbb");
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
     self.loadCount ++;
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    
//    NSLog(@"%@", request.URL.absoluteString); //可以直接拿到发送请求的网址
//    if ([request.URL.absoluteString containsString:_startUrl]) {
//        self.navigationController.navigationBar.hidden = NO;
//        [MyTabBarController setTabBarHidden:NO];
//        [self.navigationController popViewControllerAnimated:YES];
//        self.navigationController.tabBarController.tabBar.hidden = NO;
//        self.navigationController.navigationController.navigationBar.hidden = NO;
//        return NO;
//    }else{
//        //        SeconedKnowledgeViewController *seconedKnowledge = [[SeconedKnowledgeViewController alloc] init];
//        //        seconedKnowledge.passUrl = request.URL.absoluteString;
//        //        seconedKnowledge.tabBarController.tabBar.hidden = YES;
//        //        seconedKnowledge.navigationController.navigationBar.hidden = YES;
//        //        [self.navigationController pushViewController:seconedKnowledge animated:YES];
//        //        return NO;
//    }
//    return YES;
//    
//}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}


@end
