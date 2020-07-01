//
//  SingleWebViewController.m
//  MicroSchool
//
//  Created by jojo on 14/12/2.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SingleWebViewController.h"
#import "PublishMomentsViewController.h"
#import "NSString+URL.h"
#import "MicroSchoolAppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyPointsViewController.h"

@interface SingleWebViewController ()

@end

@implementation SingleWebViewController

- (void)viewDidLoad {
//#3.28
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:_titleName];
    
    [super setCustomizeLeftButton];
    self.view.backgroundColor = [UIColor clearColor];
    if (_isFromEvent) {
    currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 20)];
    }else{
    currentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
    }
    [currentWebView setBackgroundColor:[UIColor clearColor]];
    currentWebView.delegate = self;
    
    if (_webType == SWFile) {//2015.11.16 从附件类型进来图片太大需要很长时间滑动的问题
        
        currentWebView.opaque = NO;
        currentWebView.scalesPageToFit = YES;
        [currentWebView setUserInteractionEnabled:YES];
        
    }else if (_webType == SWLoadURl){
        currentWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        currentWebView.scalesPageToFit=YES;
        
        currentWebView.multipleTouchEnabled=YES;
        
        currentWebView.userInteractionEnabled=YES;
    }
    
    [self.view addSubview: currentWebView];

#if 0
    if ([_fromName isEqualToString:@"subsribe"]) {
        
        [self getData];
        
        [ReportObject event:ID_SUBSCRIPTION_DETAIL];//2015.06.25
        
    }else if ([_fromName isEqualToString:@"message"]){
        
        [Utilities showProcessingHud:self.view];
        
        [currentWebView loadRequest:[NSURLRequest requestWithURL:_url]];
        
        isClose = NO;
        
    }else if ([_fromName isEqualToString:@"scan"]){
        
        [Utilities showProcessingHud:self.view];
        
        [currentWebView loadHTMLString:_loadHtmlStr baseURL:nil];
        
        isClose = NO;
        
    }else{
        
        [Utilities showProcessingHud:self.view];
        
        NSLog(@"requestUrl:%@",_requestURL);
        
        //NSURL *url = [NSURL URLWithString:_requestURL];
        
        //[_requestURL]
        
        // 某些网址需要转成utf8才好用
        //NSString *encodedString=[_requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //NSString *encodedString = [self encodeToPercentEscapeString:_requestURL];
        
        //encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encodedString, nil, nil, kCFStringEncodingUTF8));
        
        NSString *encodedString = [_requestURL URLEncodedString];
        
        NSURL *webUrl = [NSURL URLWithString:encodedString];
        //
        
        NSLog(@"webUrl:%@",webUrl);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
        NSLog(@"cachePolicy:%d",request.cachePolicy);
        
        //[currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
        [currentWebView loadRequest:request];
        
        //webView自己点击空白处右上角菜单就会消失。。。不用加手势
        
        isClose = NO;
    }
#endif
    
    switch (_webType) {
            
        case SWSubsribe:{
            
            [self getData];
            
            [ReportObject event:ID_SUBSCRIPTION_DETAIL];//2015.06.25
        }
            break;
            
        case SWLoadURl:{
            
            [Utilities showProcessingHud:self.view];
            
            [currentWebView loadRequest:[NSURLRequest requestWithURL:_url]];
            
            isClose = NO;
        }
            break;
            
        case SWLoadHtml:{
            
            [Utilities showProcessingHud:self.view];
            
            [currentWebView loadHTMLString:_loadHtmlStr baseURL:nil];
            
            isClose = NO;
        }
            break;
            
        case SWFile:{
            
            NSURLRequest *request = [NSURLRequest requestWithURL:_url];
            
            [currentWebView loadRequest:request];//加载内容
            
        }
            break;
            
        case SWLoadRequest:{
            
            [Utilities showProcessingHud:self.view];
            
            NSString *encodedString = [_requestURL URLEncodedString];
            
            NSURL *webUrl = [NSURL URLWithString:encodedString];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
            
            [currentWebView loadRequest:request];
            
            isClose = NO;
        }
            break;
            
        default:{
            
            [Utilities showProcessingHud:self.view];
            
            NSString *encodedString = [_requestURL URLEncodedString];
            
            NSURL *webUrl = [NSURL URLWithString:encodedString];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
            //NSLog(@"cachePolicy:%d",request.cachePolicy);
            
            [currentWebView loadRequest:request];
            
            isClose = NO;
            
        }
            break;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = NO;
    self.navigationController.navigationBarHidden = NO;
    [MyTabBarController setTabBarHidden:YES];
}

// 订阅文章详情接口
-(void)getData{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *width =  [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.width];
        
        //NSLog(@"aid:%@",_aid);
        
        NSDictionary *result = [FRNetPoolUtils getSubsribeArticleDetail:_aid width:width];
        
        NSDictionary *dic = [result objectForKey:@"message"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            
            if (!result) {
                
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"错误" message:@"网络异常，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                return;
                
            }
       
            if([[result objectForKey:@"result"] integerValue]==1 ){
                if (dic == nil) {
                    
                    //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    
                }else{
                    
                    /*
                     message =     {
                     aid = 19;
                     dateline = 1429779826;
                     number = 1;
                     pic = "http://test.5xiaoyuan.com/attachment/201504/23/1429766858713.png";
                     pics =         (
                     "http://test.5xiaoyuan.cn/ueditor/php/upload1/201504/23/14297737735175.jpg",
                     "http://test.5xiaoyuan.cn/attachment/201504/23/14297737736755.jpg"
                     );
                     "read_num" = "<null>";
                     title = luke;
                     url = "http://test.5xiaoyuan.cn/open/index.php/Home/article/detail/19";
                     };
                     protocol = "SchoolSubscriptionAction.viewArticle";
                     result = 1;
                     }
                     */
                    
                    diction = [[NSDictionary alloc] initWithDictionary:dic];
                    
                    if ([diction objectForKey:@"pics"]) {
                        pics = [[NSArray alloc]initWithArray:(NSArray*)[diction objectForKey:@"pics"]];
                        [self addTapOnWebView];
                    }
                    
                    _currentHeadImgUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"pic"]]];
                    
                    _requestURL = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"url"]]];
                    NSString *encodedString = [_requestURL URLEncodedString];
                    
                    NSURL *webUrl = [NSURL URLWithString:encodedString];
                    
                    [currentWebView loadRequest:[NSURLRequest requestWithURL:webUrl]];
                    [currentWebView reload];
                    
                }
                
            }else{
               
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"错误" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                
                //[Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
        });
        
    });
    
    
}

//-------------------------------------------------------------------------------
// 点击webview查看大图
-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [currentWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:currentWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    //NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSString *urlToSave = [currentWebView stringByEvaluatingJavaScriptFromString:imgURL];
    //NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        
        if([urlToSave rangeOfString:@"face"].location == NSNotFound )//非表情图片
        {
            //[self showImageURL:urlToSave point:pt];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor clearColor];
            if(IS_IPHONE_5){
                imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
            }else{
                imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
            }
            
            NSInteger pos = [Utilities findStringPositionInArray:pics andStr:urlToSave];
            
            if (-1 != pos) {
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = pos;
                
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[pics count]];
                
                for (int i = 0; i<[pics count]; i++) {
                    NSString *pic_url = [pics objectAtIndex:i];
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.save = NO;
                    photo.url = [NSURL URLWithString:pic_url];
                    photo.srcImageView = imageView;
                    [photos addObject:photo];
                }
                
                browser.photos = photos;
                [browser show];
            }
            
#if 0
            // 1.封装图片数据
            //设置所有的图片。photos是一个包含所有图片的数组。
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.save = NO;
            photo.url = [NSURL URLWithString:urlToSave]; // 图片路径
            photo.srcImageView = imageView; // 来源于哪个UIImageView
            [photos addObject:photo];
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
#endif
        }
    }
}
//---------------------------------------------------------------------------

-(void)setTitle:(NSString*)title{
    
    UIView *tools =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    tools.backgroundColor = [UIColor clearColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag = 235;
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 5.5, 24, 33);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton2.tag = 234;
    [leftButton2 setBackgroundColor:[UIColor clearColor]];
    leftButton2.frame = CGRectMake(24+5, 5.5, 40, 33);
    [leftButton2 setTitle:@"关闭" forState:UIControlStateNormal];
    leftButton2.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftButton2 addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    
    if (![tools viewWithTag:234]) {
        [tools addSubview:leftButton2];
    }
    
    if (![tools viewWithTag:235]) {
        [tools addSubview:leftButton];
    }
    
    self.navigationItem.leftBarButtonItems = nil;
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.leftBarButtonItem = myBtn;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closePage{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back{
    
    [self dismissKeyboard:nil];//Bug 1605 Spring提出
    
    if (currentWebView.canGoBack) {
        
        [currentWebView goBack];
        isClose = YES;
        
    }else{
        
        if (_closeVoice) {
            NSString *str = @"about:blank";
            [currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

}

-(void)selectLeftAction:(id)sender
{
    [self dismissKeyboard:nil];//Bug 1605 Spring提出
    
    if (currentWebView.canGoBack) {
        
        [currentWebView goBack];
        isClose = YES;
        
    }else{
        
        if (_closeVoice) {
            NSString *str = @"about:blank";
            [currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [Utilities dismissProcessingHud:self.view];
    _currentTitle  = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    
    _currentURL = webView.request.URL.absoluteString;
    NSLog(@"title-%@--url-%@--",_currentTitle,_currentURL);
    
    //NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    //_currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
#if 0
    if ([_fromName isEqualToString:@"moments"] || [_fromName isEqualToString:@"message"] || [_fromName isEqualToString:@"momentsEntrance"] || [_fromName isEqualToString:@"MyPoints"]){//从校友圈/班级动态/个人动态 来 //to beck: 如果其他模块需要跳到该webView分享链接，请添加fromName判断
       
        if (isClose) {
            
            ((UILabel *)self.navigationItem.titleView).frame = CGRectMake(((UILabel *)self.navigationItem.titleView).frame.origin.x,  ((UILabel *)self.navigationItem.titleView).frame.origin.y, 100.0, ((UILabel *)self.navigationItem.titleView).frame.size.height);
            ((UILabel *)self.navigationItem.titleView).text = _currentTitle;
            if ([_currentTitle length] == 0) {
                ((UILabel *)self.navigationItem.titleView).text = _titleName;
            }
            
            [self setTitle:_currentTitle];
           
        }else{

            ((UILabel *)self.navigationItem.titleView).text = _currentTitle;
            
            if ([_currentTitle length] == 0) {
                ((UILabel *)self.navigationItem.titleView).text = _titleName;
            }
        }
        
        if (nil == _isShowSubmenu) {
            [super setCustomizeRightButton:@"friend/icon_contacts_more.png"];

        }

        
    }else if ([_fromName isEqualToString:@"subsribe"]){
        
        [HUD hide:YES];
        
        if (nil == _isShowSubmenu) {
            [super setCustomizeRightButton:@"friend/icon_contacts_more.png"];
            
        }

        
    }
#endif
    // 2015.09.23
    if (_webType == SWLoadHtml || _webType == SWFile) {
        
    }else if (_webType == SWSubsribe){
        
        [HUD hide:YES];
        
        if (nil == _isShowSubmenu) {
            [super setCustomizeRightButton:@"friend/icon_contacts_more.png"];
            
        }
    }else{
       
        if (isClose) {
            
            ((UILabel *)self.navigationItem.titleView).frame = CGRectMake(((UILabel *)self.navigationItem.titleView).frame.origin.x,  ((UILabel *)self.navigationItem.titleView).frame.origin.y, 100.0, ((UILabel *)self.navigationItem.titleView).frame.size.height);
            ((UILabel *)self.navigationItem.titleView).text = _currentTitle;
            if ([_currentTitle length] == 0) {
                ((UILabel *)self.navigationItem.titleView).text = _titleName;
            }
            
            [self setTitle:_currentTitle];
            
        }else{
            
            ((UILabel *)self.navigationItem.titleView).text = _currentTitle;
            
            if ([_currentTitle length] == 0) {
                ((UILabel *)self.navigationItem.titleView).text = _titleName;
            }
        }
        
        if (nil == _isShowSubmenu) {
            [super setCustomizeRightButton:@"friend/icon_contacts_more.png"];
            
        }
    }
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;

    //教师节活动页 点击领取1000积分 去积分详情页
    context[@"receiveCredit"] = ^() {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf gotoMyPointView];
            
        });
        
    };
    
}

-(void)gotoMyPointView{
    
    MyPointsViewController *myPoint = [[MyPointsViewController alloc]init];
    myPoint.titleName = @"我的积分";
    [self.navigationController pushViewController:myPoint animated:YES];
    
}

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

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)selectRightAction:(id)sender{
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                          5,
                                                                          128,
                                                                          122)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        [imageView_rightMenu setImage:[UIImage imageNamed:@"friend/bg_contacts_more.png"]];
        
        NSString *_foundModuleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"foundModule"];
        
        if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
            _foundModuleName = @"校友圈";
#endif
            _foundModuleName = @"师生圈";//2016.01.05
        }
        
        // 搜索button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x,
                                         imageView_rightMenu.frame.origin.y + 10,
                                         120,
                                         35);
        
        UIImage *buttonImg_d;
        UIImage *buttonImg_p;
        
        //        CGSize tagSize = CGSizeMake(20, 20);
        //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_fxdpyq_d_.png"]];
        //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"ficon_fxdpyq_p_.png"]];
        
        buttonImg_d = [UIImage imageNamed:@"icon_fxdpyq_d_.png"];
        buttonImg_p = [UIImage imageNamed:@"ficon_fxdpyq_p_.png"];
        
        [button_search setImage:buttonImg_d forState:UIControlStateNormal];
        [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        
        [button_search setTitle:[NSString stringWithFormat:@"分享到%@",_foundModuleName] forState:UIControlStateNormal];
        [button_search setTitle:[NSString stringWithFormat:@"分享到%@",_foundModuleName] forState:UIControlStateHighlighted];
        
        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_search setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_search addTarget:self action:@selector(shareUrl:) forControlEvents: UIControlEventTouchUpInside];
        
        // 多人发送button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x,
                                            button_search.frame.origin.y + button_search.frame.size.height,
                                            108,
                                            35);
        
        //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_fzlj_d_.png"]];
        //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_fzlj_p_.png"]];
        
        buttonImg_d = [UIImage imageNamed:@"icon_fzlj_d_.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_fzlj_p_.png"];
        
        [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_multiSend setTitle:@"复制链接    " forState:UIControlStateNormal];
        [button_multiSend setTitle:@"复制链接    " forState:UIControlStateHighlighted];
        
        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 0)];
        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_multiSend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_multiSend addTarget:self action:@selector(copyUrl:) forControlEvents: UIControlEventTouchUpInside];
        
        // 添加朋友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_addFriend.frame = CGRectMake(
                                            button_multiSend.frame.origin.x,
                                            button_multiSend.frame.origin.y + button_multiSend.frame.size.height,
                                            108,
                                            35);
        
        //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_llqdk_d_.png"]];
        //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_llqdk_p_.png"]];
        
        buttonImg_d = [UIImage imageNamed:@"icon_llqdk_d_.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_llqdk_d_.png"];
        
        
        [button_addFriend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_addFriend setTitle:@"浏览器打开" forState:UIControlStateNormal];
        [button_addFriend setTitle:@"浏览器打开" forState:UIControlStateHighlighted];
        
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_addFriend addTarget:self action:@selector(openUrlBySafari:) forControlEvents: UIControlEventTouchUpInside];
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        [imageView_bgMask addSubview:button_search];
        [imageView_bgMask addSubview:button_multiSend];
        [imageView_bgMask addSubview:button_addFriend];
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
    
    
}

-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

// 分享到校友圈
-(void)shareUrl:(id)sender{
    
    //UIImage *img = [self capture:self.view];
    PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
    publish.flag = 2;
    publish.shareUrl = _currentURL;
#if 0
    if ([_fromName isEqualToString:@"moments"] || [_fromName isEqualToString:@"message"]) {
        // 分享到校友圈
        publish.shareImgUrl = _currentHeadImgUrl;
        publish.shareTitle = _currentTitle;
        [self.navigationController pushViewController:publish animated:YES];
        
    }else if ([_fromName isEqualToString:@"subsribe"]){
        
        publish.shareImgUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"pic"]]];
        publish.shareTitle = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"title"]]];
        [self.navigationController pushViewController:publish animated:YES];
    }
#endif
    // 2015.09.23
    if (_webType == SWSubsribe) {
        
        publish.shareImgUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"pic"]]];
        publish.shareTitle = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"title"]]];
        [self.navigationController pushViewController:publish animated:YES];
        
    }else{
        
        // 分享到校友圈
        publish.shareImgUrl = _currentHeadImgUrl;
        publish.shareTitle = _currentTitle;
        [self.navigationController pushViewController:publish animated:YES];
    }
    
    [self dismissKeyboard:nil];
    
}

// 复制网址
-(void)copyUrl:(id)sender{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_currentURL];
    
    [self dismissKeyboard:nil];
    
}

// 用浏览器打开
-(void)openUrlBySafari:(id)sender{
    
    NSURL *url = [[NSURL alloc]initWithString:_currentURL];
    [[UIApplication sharedApplication] openURL:url];
    
    [self dismissKeyboard:nil];
    
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}


//#pragma mark 截图
//- (UIImage *)capture:(UIView *)view
//{
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}

//---add by kate 2015.05.04---------------------------

-(NSUInteger)supportedInterfaceOrientations
{
    
    if ([@"1"  isEqual: _isRotate]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
    
}
//
-(BOOL)shouldAutorotate
{
    if ([@"1"  isEqual: _isRotate]) {
        return NO;
    }
    return YES;
}

/*-(void)noApplePush{
    
    NSLog(@"------进入--------");
    
    //    GNAppDelegate.shouldNotAlert = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldNotAlert"];
    //---------- add by kate 2015.05.04---------------------
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI/2);
    self.view.transform = transform;
//    CGPoint center = self.view.window.center;
//    [self.view setCenter:CGPointMake(center.x+170, center.y+220)];
    //------------------------------------------------------
    
//    CGAffineTransform transform = CGAffineTransformRotate(self.view.window.rootViewController.view.transform, M_PI / 2);
//    
//     transform = CGAffineTransformIdentity;
//    
//     [UIView beginAnimations:@"rotate" context:nil ];
//    
//     [UIView setAnimationDuration:0.1];
//    
//     [UIView setAnimationDelegate:self];
//    
//     [self.view.window.rootViewController.view setTransform:transform];
//    
//     [UIView commitAnimations];
//    
//    
//    
//     self.view.window.rootViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height );
//    
//     [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    
    
}
//
-(void)receiveApplePush{
    
    NSLog(@"------退出--------");
    
    //    GNAppDelegate.shouldNotAlert = NO;
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldNotAlert"];
//    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.view.transform = transform;
//    CGPoint center = self.view.window.center;
//    [self.view setCenter:CGPointMake(center.x+230, center.y+140)];
    
}*/
//-----------------------------------------------------

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"0");
    }else{
        NSLog(@"1");
    }
    
}

@end
