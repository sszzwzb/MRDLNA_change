//
//  SingleWebViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "SingleWebViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#define WebViewNav_TintColor [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]

@interface SingleWebViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *currentWebView;


@property (strong, nonatomic) UIProgressView *progressView;//webView进度条
@property (assign, nonatomic) NSUInteger loadCount;//算进度的


@property (nonatomic,strong) NSString *currentTitle;
@property (nonatomic,strong) NSString *currentURL;

@property (nonatomic,assign) BOOL isFirstWebPag;  //  是不是第一个页面

@end

@implementation SingleWebViewController

@synthesize currentWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setCustomizeTitle:_fromName];
    [self setCustomizeLeftButton];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (![Utilities isConnected]) {
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    
    currentWebView = [[UIWebView alloc]init];
    currentWebView.delegate = self;
    [self.view addSubview:currentWebView];
    currentWebView.backgroundColor = [UIColor clearColor];
    
    
    [self upProgress];
    
    
    currentWebView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenNavigationBarHeight);
    
    if (_webType == SWLoadRequest || _webType == SWLoadRequestSingle) {
        
        
    }
    
    if (_webType == SWLoadRequestHidden) {
        currentWebView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, KScreenWidth, KScreenHeight - STATUS_BAR_HEIGHT);
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, STATUS_BAR_HEIGHT)];
        topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:topView];
        
        [self.navigationController setNavigationBarHidden:YES];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(8, KScreenTabBarIndicatorHeight + 30.0, 24.0, 24.0);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navicons_03"] forState:UIControlStateNormal] ;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navicons_03"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:backBtn];
    }
    
    
    if (_webType == SWLoadRequestClose) {
        
        _isFirstWebPag = YES;
        
    }
    
    
    _requestURL = [_requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedString = [_requestURL stringByRemovingPercentEncoding];
    NSURL *webUrl = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
    [currentWebView loadRequest:request];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomizeLeftButtonAndClose
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(8, 0, 33, 33);
    [leftButton setImage:[UIImage imageNamed:@"navicons_03.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navicons_03.png"] forState:UIControlStateSelected];
    
    UIButton *leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton2 setBackgroundColor:[UIColor clearColor]];
    leftButton2.frame = CGRectMake(0, 0, 33, 33);
    [leftButton2 setTitle:@"关闭" forState:(UIControlStateNormal)];
    [leftButton2 setTitleColor:color_gray forState:(UIControlStateNormal)];
    leftButton2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [leftButton2 addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton2];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        /** *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
         *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;  //  修改位置
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton, leftBarButton2, nil];
        
    }else{
        self.navigationItem.leftBarButtonItems = @[leftBarButton,leftBarButton2];
    }
}

-(void)selectLeftAction:(id)sender
{
    [self canPopViewController];
}

- (BOOL)gestureRecognizerShouldBegin{
    [self canPopViewController];
    
    return NO;
}

-(void)canPopViewController
{
    if (currentWebView.canGoBack) {
        
        [currentWebView goBack];
//        NSString *str = @"about:blank";
//        [currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
    }else{
        
        [self popViewController];
    }
}

-(void)popViewController
{
    if (_webType == SWLoadRequestHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)upProgress
{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    [self.view insertSubview:currentWebView belowSubview:_progressView];
}

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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.loadCount --;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    self.loadCount --;
    
    _currentTitle  = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    _currentURL = webView.request.URL.absoluteString;
    NSLog(@"title-%@--url-%@--",_currentTitle,_currentURL);
    
    [self setCustomizeTitle:_currentTitle];
    
    
    if (_webType == SWLoadRequestClose && _isFirstWebPag == NO) {
        [self setCustomizeLeftButtonAndClose];
    } else
        _isFirstWebPag = NO;
    
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __weak typeof(self) weakSelf = self;
    
    context[@"pushWindowHasTitle"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        
        NSString *jsUrl = [NSString string];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
            jsUrl = [NSString stringWithFormat:@"%@" ,jsVal];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf pushNewWebViewWithUrl:jsUrl];
        });
    };
    
    
    context[@"closeWindow"] = ^() {
        NSLog(@"点击导航栏的关闭按钮");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self popViewController];
            
        });
        
    };
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(_webType == SWLoadRequestSingle && _currentURL != nil) {
        return NO;
    }
    //  iOS 11  在跳转页面的时候，好像会先执行这个语句，然后才会执行 web 加载成功的代理。
    //   不执行成功之后在执行下一句了，可以多线程执行了
    _currentURL = [Utilities replaceNull:_currentURL];
    return YES;
}

-(void)pushNewWebViewWithUrl:(NSString *)jsUrl{
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWLoadRequest;
    fileViewer.requestURL = jsUrl;
    [self.navigationController pushViewController:fileViewer animated:YES];
    
}


@end
