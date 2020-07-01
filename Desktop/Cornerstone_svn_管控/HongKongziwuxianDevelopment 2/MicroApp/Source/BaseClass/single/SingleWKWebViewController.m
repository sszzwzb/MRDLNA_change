//
//  SingleWKWebViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "SingleWKWebViewController.h"

#import <WebKit/WebKit.h>


#define WebViewNav_TintColor [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]

@interface SingleWKWebViewController () <WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *currentWkWebView;
@property (nonatomic, strong) UIProgressView *wKprogressView;

@property (nonatomic,strong) NSString *currentTitle;
@property (nonatomic,strong) NSString *currentURL;

@property (nonatomic,assign) BOOL isFirstWebPag;  //  是不是第一个页面

@end

@implementation SingleWKWebViewController

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
    
    [self upWKWebView];
    
    [self upProgressView];
    
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
    if (_currentWkWebView.canGoBack) {
        
        [_currentWkWebView goBack];
//        NSString *str = @"about:blank";
//        [currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
    }else{
        
        //  进来是的状态
        if (_isPreviousNavBarIsHiddenAndBackIsShow) {
            [self.navigationController setNavigationBarHidden:YES];
        }
        
        [self popViewController];
    }
}

-(void)popViewController
{
    if (_webType == SWKWLoadRequestHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor clearColor];
    progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    [self.view addSubview:progressView];
    progressView.backgroundColor = [UIColor clearColor];
    self.wKprogressView = progressView;
}


-(void)upWKWebView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    config.preferences = [WKPreferences new];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc]init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 注入JS对象名称toMy，当JS通过toMy来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"pushWindowHasTitle"];
    [config.userContentController addScriptMessageHandler:self name:@"closeWindow"];
    
    
    _currentWkWebView = [[WKWebView alloc] initWithFrame:
                         CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenNavigationBarHeight)
                                           configuration:config];
    
    [self.view addSubview:_currentWkWebView];
    _currentWkWebView.backgroundColor = [UIColor whiteColor];
    _currentWkWebView.scrollView.backgroundColor = [UIColor whiteColor];
    
    
    //  进来是的状态
    if (_isPreviousNavBarIsHiddenAndBackIsShow) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    if (_webType == SWKWLoadRequest) {
        
        
    }
    
    if (_webType == SWKWLoadRequestHidden) {
        _currentWkWebView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, KScreenWidth, KScreenHeight - STATUS_BAR_HEIGHT - KScreenTabBarIndicatorHeight);
        
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
    
    
    if (_webType == SWKWLoadRequestClose) {
        
        _isFirstWebPag = YES;
        
    }
    
    
    _requestURL = [_requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_currentWkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
    
    
    
    
    
    // 导航代理
    _currentWkWebView.navigationDelegate = self;
    // 与webview UI交互代理
    _currentWkWebView.UIDelegate = self;
    
    [_currentWkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_currentWkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [_currentWkWebView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"计算wkWebView进度条 = %lf",_currentWkWebView.estimatedProgress);
    if (object == self.currentWkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        [self.wKprogressView setAlpha:1.0f];
        [self.wKprogressView setProgress:_currentWkWebView.estimatedProgress animated:YES];
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.wKprogressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                self.wKprogressView.hidden = YES;
                [self.wKprogressView setProgress:0.0f animated:NO];
            }];
        }else {
            self.wKprogressView.hidden = NO;
            [self.wKprogressView setProgress:newprogress animated:YES];
        }
    }
    
    
    if (object == _currentWkWebView && [keyPath isEqualToString:@"title"]){//网页title
        _currentTitle = _currentWkWebView.title;
        [self setCustomizeTitle:_currentWkWebView.title];
    }
    
    if (object == _currentWkWebView && [keyPath isEqualToString:@"URL"]){//网页URL
        NSLog(@"新的url = %@", _currentWkWebView.URL.absoluteString);
    }
    
}

#pragma mark - delegate
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
//    _currentTitle  = navigationResponse.response.;//获取当前页面的title
    _currentURL = navigationResponse.response.URL.absoluteString;
    NSLog(@"跳转新的 title-%@--url-%@--",_currentTitle,_currentURL);
    
    if (_webType == SWKWLoadRequestClose && _isFirstWebPag == NO) {
        [self setCustomizeLeftButtonAndClose];
    } else
        _isFirstWebPag = NO;
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
    
    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"新的 , 有的不好用 url %@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}


#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}



// 记得取消监听
- (void)dealloc {
    [self.currentWkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS 交互 %@",message.body);
    
    __weak typeof(self) weakSelf = self;
    if ([message.name isEqualToString:@"pushWindowHasTitle"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pushNewWebViewWithUrl:message.body];
        });
        
    }
    
    if ([message.name isEqualToString:@"closeWindow"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewController];
        });
        
    }
    
}

-(void)pushNewWebViewWithUrl:(NSString *)jsUrl{
    
    SingleWKWebViewController *fileViewer = [[SingleWKWebViewController alloc] init];
    fileViewer.webType = SWKWLoadRequest;
    fileViewer.requestURL = jsUrl;
    [self.navigationController pushViewController:fileViewer animated:YES];
    
}

@end
