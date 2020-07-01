//
//  FileViewerViewController.m
//  MicroSchool
//
//  Created by jojo on 14-9-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FileViewerViewController.h"

@interface FileViewerViewController ()

@end

@implementation FileViewerViewController

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
    
    [super setCustomizeTitle:_titlea];
    [super setCustomizeLeftButton];
    
    [Utilities showProcessingHud:self.view];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(
                                                          10,
                                                          10,
                                                          300,
                                                          [UIScreen mainScreen].applicationFrame.size.height - 44)];
    
    _webView.delegate = self;
    
    _webView.opaque = NO;
    _webView.scalesPageToFit = YES;

//    [_webView setUserInteractionEnabled:NO];//是否支持交互 update by kate bug420
    [_webView setUserInteractionEnabled:YES];
//    [self.webView setAllowsInlineMediaPlayback:YES];
//    [self.webView setMediaPlaybackRequiresUserAction:NO];
    
    _webView.backgroundColor = [[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];

    //禁止UIWebView拖动
    //    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
//    [_webView setScalesPageToFit:YES];
    
#if 0
    [_webView loadHTMLString:nil baseURL:_requestURL];//加载内容
#endif
    
    
#if 0
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *imagePath = [imageDocPath stringByAppendingPathComponent:@"xxxx"];
    
    NSURL *url = [NSURL fileURLWithPath:imagePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:_detailInfo ofType:nil];
    //
    //    NSURL *url = [NSURL fileURLWithPath:path];
    //
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    [webView loadRequest:request];
    
    
    
    
    
    
    //    NSURL *url = [NSURL fileURLWithPath:_detailInfo];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    [webView loadRequest:request];//加载内容
#endif
    
#if 1
    //    NSURL *url = [NSURL fileURLWithPath:_detailInfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:_requestURL];
    
    [_webView loadRequest:request];//加载内容
    
#endif
    
    //webView.scrollView.bounces = NO;
    [_webView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: _webView];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
}

-(void)selectLeftAction:(id)sender
{
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Utilities dismissProcessingHud:self.view];
//    [_webView setUserInteractionEnabled:YES];//是否支持交互 update by kate bug420

    //    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    //    CGRect newFrame = webView.frame;
    //    newFrame.size.height = actualSize.height;
    //    webView.frame = newFrame;
    //    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //    webHight = [string floatValue];
    //
    //    [webViewContent setFrame:CGRectMake(
    //                                        0,
    //                                        imgView_line2.frame.origin.y + imgView_line2.frame.size.height,
    //                                        320,
    //                                        webHight)];
    //
    //    _scrollerView.contentSize = CGSizeMake(320, webHight + imgView_line2.frame.origin.y + 2);
    //    //    [_scrollerView setFrame:CGRectMake(
    //    //                                       0,
    //    //                                       0,
    //    //                                       320,
    //    //                                       webHight + 1136)];
    //    
    //    webViewContentHiden.hidden = true;
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL *requestURL =[request URL];
//    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
//        
//        return YES;
//        
//        //        return ![[UIApplication sharedApplication] openURL:requestURL];
//    }else {
//        return YES;
//    }
//}

@end
