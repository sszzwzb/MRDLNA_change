//
//  NewsDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-11.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "SingleWebViewController.h"

#import "MicroSchoolMainMenuViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

@synthesize newsid;
@synthesize newsDate;
@synthesize updatetime;

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
    
    [super setCustomizeTitle:_titleName];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [ReportObject event:ID_OPEN_NEWS_DETAIL module:_titleName];//2015.06.23
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MyTabBarController setTabBarHidden:YES];
    
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    [self doGetCommentCount];
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        UIViewController *v = [viewControllers objectAtIndex:viewControllers.count-2];
        
        if ([Utilities isNeedShowTabbar:v]) {
            // 上层view是否是需要显示tabbar的view
            [MyTabBarController setTabBarHidden:NO];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) checkPushOrPop:(UIViewController*) uiViewController{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-1] == uiViewController) {
        //堆栈里最后一个 当前显示的
        return 0;
    } else if ([viewControllers indexOfObject:uiViewController] != NSNotFound) {
        //在堆栈里 但是当前不显示的
        return 1;
    }
    //不在堆栈里
    return -1;
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
#define TITLE_LABEL_Y_OFFSET		(10)
    
    label_titil = [UILabel new];;
    [self.view addSubview:label_titil];
    [label_titil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(300,45));
    }];
    //设置title自适应对齐
    label_titil.lineBreakMode = NSLineBreakByWordWrapping;
    label_titil.font = [UIFont systemFontOfSize:16.0f];
    label_titil.numberOfLines = 2;
    //label_contentDetail.adjustsFontSizeToFitWidth = YES;
    label_titil.lineBreakMode = NSLineBreakByTruncatingTail;
    label_titil.textAlignment = NSTextAlignmentLeft;
    label_titil.textColor = [UIColor blackColor];
    label_titil.backgroundColor = [UIColor clearColor];
    
    
    _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];

    
    label_author = [UILabel new];
     [self.view addSubview:label_author];
    [label_author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_titil.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(280,15));
    }];
    //设置title自适应对齐
    label_author.font = [UIFont systemFontOfSize:12.0f];
    label_author.textColor = [UIColor grayColor];
    label_author.backgroundColor = [UIColor clearColor];
    label_author.textAlignment = NSTextAlignmentLeft;
   
    
    
    // 日期
    label_date = [UILabel new];
    [self.view addSubview:label_date];
    [label_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_titil.mas_bottom).with.offset(-6);
        make.left.equalTo(self.view).with.offset(WIDTH/2+15);
        make.size.mas_equalTo(CGSizeMake(120,25));
    }];
    label_date.font = [UIFont systemFontOfSize:12.0f];
    label_date.textColor = [UIColor grayColor];
    label_date.backgroundColor = [UIColor clearColor];
    label_date.textAlignment = NSTextAlignmentLeft;
    
    
//日期图片
    _viewTime = [UIImageView new];
    [self.view addSubview:_viewTime];
    [_viewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_titil.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(WIDTH/2);
        make.size.mas_equalTo(CGSizeMake(12,12));
    }];
    [_viewTime setImage:[UIImage imageNamed:@"viewTime.png"]];
    _viewTime.hidden = YES;
    
    
    // 浏览次数图片
    _imgView_viewnum =[UIImageView new];
    [self.view addSubview:_imgView_viewnum];
    [_imgView_viewnum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_titil.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(WIDTH-60);
        make.size.mas_equalTo(CGSizeMake(12,12));
    }];
    _imgView_viewnum.image=[UIImage imageNamed:@"icon_liulan.png"];
    _imgView_viewnum.hidden = YES;
    
    
    label_viewnum = [UILabel new];
     [self.view addSubview:label_viewnum];
    [label_viewnum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_titil.mas_bottom).with.offset(-4);
        make.left.equalTo(_imgView_viewnum.mas_right).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(80,20));
    }];
    label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
    label_viewnum.font = [UIFont systemFontOfSize:12.0f];
    label_viewnum.numberOfLines = 0;
    label_viewnum.textColor = [UIColor grayColor];
    label_viewnum.backgroundColor = [UIColor clearColor];
    label_viewnum.lineBreakMode = NSLineBreakByTruncatingTail;
   

    
    if ([@"innerLink"  isEqual: _viewType]) {
        [self doGetInnerLinkData];
        
        label_titil.hidden = YES;
        label_date.hidden = YES;
    }else {
        // 去db里面查找是否有存在的newsid，有则取出来直接显示，没有去服务器取。
        NSDictionary *dic = [[NewsDetailDBDao getDaoInstance] getDataFromNewsId:newsid];
        
        NSString *pics = [dic objectForKey:@"pics"];
        _pics = [pics componentsSeparatedByString:@"|"];
        
        if (0 == [dic count]) {
            [self performSelector:@selector(doGetNewsDetail) withObject:nil afterDelay:0.05];
        }else {
            // 服务器上新闻的详细可能会更新，列表会更新时间戳，然后用列表新的时间戳与详细DB中的时间戳做比较，
            // 如果列表的新，则重新去服务器更新详细。
            NSString *tm = [dic objectForKey:@"updatetime"];
            //        long long tmL = [tm longLongValue];
            //        long long upL = [newsDate longLongValue];
            
            if([tm longLongValue]<[newsDate longLongValue]) {
                [self performSelector:@selector(doGetNewsDetail) withObject:nil afterDelay:0.05];
            }else {
                [self doShowContent:dic];
            }
        }
    }
    
//    [self doGetCommentCount];
    
    
}

- (void)doGetCommentCount
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"News", @"ac",
                          @"2", @"v",
                          @"getCommentCount", @"op",
                          self.newsid, @"newsid",
                          nil];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSString *count = [respDic objectForKey:@"message"];
            
            if (999 < [count integerValue]) {
                count = @"999";
            }
//#3.23评论数拿掉
//            [_btn_comment setTitle:count forState:UIControlStateNormal];
//            [_btn_comment setTitle:count forState:UIControlStateHighlighted];
        } else {
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
    }];
}

- (void)doGetInnerLinkData
{
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:_innerLinkReqData successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities dismissProcessingHud:self.view];

            NSDictionary *dic = [respDic objectForKey:@"message"];
            _pics = [dic objectForKey:@"pics"];
            
            [self doShowContent:[respDic objectForKey:@"message"]];
        } else {
            [Utilities dismissProcessingHud:self.view];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[respDic objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        if (![Utilities isConnected]) {//2015.06.30
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            
        }
    }];
    
    //    [network sendHttpReq:HttpReq_NewsDetail andData:data];
}

-(void)doGetNewsDetail
{
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"News", @"ac",
                          @"2", @"v",
                          @"viewDetail", @"op",
                          self.newsid, @"newsid",
                          @"290",@"width",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            
            NewsDetailObject *newsDetail = [[NewsDetailObject alloc] init];
            newsDetail.newsid = [dic objectForKey:@"newsid"];
            newsDetail.title = [dic objectForKey:@"title"];
            newsDetail.updatetime = [dic objectForKey:@"updatetime"];
            newsDetail.message = [dic objectForKey:@"message"];
            newsDetail.iscomment = [dic objectForKey:@"iscomment"];
            newsDetail.name = [dic objectForKey:@"name"];
            newsDetail.viewnum = [dic objectForKey:@"viewnum"];

            _pics = [dic objectForKey:@"pics"];
            
            NSString *picsString;
            picsString = [_pics componentsJoinedByString:@"|"];
            
            newsDetail.pics = picsString;
            
            [newsDetail updateToDB];
            
            NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _newsMid, [dic objectForKey:@"newsid"]];
            ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
            rsObj.readId = readId;
            rsObj.status = @"1";
            [rsObj updateToDB];

            [self doShowContent:[respDic objectForKey:@"message"]];
        } else {
            [Utilities dismissProcessingHud:self.view];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[respDic objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        if (![Utilities isConnected]) {//2015.06.30
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            
        }
    }];

//    [network sendHttpReq:HttpReq_NewsDetail andData:data];
}

-(void)doShowContent:(NSDictionary *)dic
{
    label_titil.text = [dic objectForKey:@"title"];
    
    Utilities *util = [Utilities alloc];
    label_date.text = [util linuxDateToString:[dic objectForKey:@"updatetime"] andFormat:@"%@-%@-%@" andType:DateFormat_YMDHM];
    
    label_author.text = [NSString stringWithFormat:@"管理员：%@", [dic objectForKey:@"name"]];
    if ((nil == _viewNum) || ([@""  isEqual: _viewNum])) {
        label_viewnum.text = [dic objectForKey:@"viewnum"];
    }else {
        label_viewnum.text = _viewNum;
    }
    _imgView_viewnum.hidden = NO;
    _viewTime.hidden = NO;

    imgView_line =[UILabel new];
    [self.view addSubview:imgView_line];
    [imgView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_date.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH-20,0.5));
    }];
//    imgView_line.image=[UIImage imageNamed:@"CommonIconsAndPics/newsDetail_line"];
    imgView_line.backgroundColor = [UIColor lightGrayColor];
    

    
    NSString *webContent = [dic objectForKey:@"message"];
    NSLog(@"html:%@",webContent);
    
    if([NSNull null] == webContent) {
        UILabel *nullContent = [UILabel new];
         [self.view addSubview: nullContent];
        [nullContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView_line.mas_bottom).with.offset(10);
            make.left.equalTo(self.view).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(300,18));
        }];
        nullContent.font = [UIFont systemFontOfSize:17.0f];
        nullContent.textColor = [UIColor blackColor];
        nullContent.backgroundColor = [UIColor clearColor];
        nullContent.textAlignment = NSTextAlignmentLeft;
        
        nullContent.text = @"无详细内容";
        
       
    }else {
        webView = [UIWebView new];
        [self.view addSubview: webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView_line.mas_bottom).with.offset(10);
            make.left.equalTo(self.view).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(300, [UIScreen mainScreen].applicationFrame.size.height - label_date.frame.size.height - label_titil.frame.size.height - imgView_line.frame.size.height - 44 - 20-20));
        }];
        [webView loadHTMLString:webContent baseURL:nil];//加载内容
        //webView.scrollView.bounces = NO;
        [webView setBackgroundColor:[UIColor clearColor]];
        webView.delegate = self;
        
        
        
        //addTapOnWebView
        [self addTapOnWebView];
    }
    
    if ([@"innerLink"  isEqual: _viewType]) {
        imgView_line.hidden = YES;
        label_author.hidden = YES;
        label_viewnum.hidden = YES;
        _imgView_viewnum.hidden = YES;
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(10);
            make.left.equalTo(self.view).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(300,[UIScreen mainScreen].applicationFrame.size.height - 44 - 20));
        }];
    }
    
    if ([@"1"  isEqual: [dic objectForKey:@"iscomment"]]) {
//        _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _btn_comment.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 90,
                                        [UIScreen mainScreen].applicationFrame.size.height - 100 , 70, 30);
        
//#3.23校园公告右上角添加评价
        [super setCustomizeRightButtonWithName:@"评论"];
//        [_btn_comment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_btn_comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        _btn_comment.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//        
//        [_btn_comment setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//
//        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"news/button_03_n"] forState:UIControlStateNormal] ;
//        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"news/button_03_p"] forState:UIControlStateHighlighted] ;
//        // 添加 action
//        [_btn_comment addTarget:self action:@selector(comment_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//        
//        [self.view addSubview:_btn_comment];
    }
}
-(void)selectRightAction:(id)sender{
    NewsCommentViewController *newsCommentViewCtrl = [[NewsCommentViewController alloc] init];
    newsCommentViewCtrl.newsId = self.newsid;
    newsCommentViewCtrl.cmtSid = G_SCHOOL_ID;
    
    [self.navigationController pushViewController:newsCommentViewCtrl animated:YES];
    
}

- (IBAction)comment_btnclick:(id)sender
{
    NewsCommentViewController *newsCommentViewCtrl = [[NewsCommentViewController alloc] init];
    newsCommentViewCtrl.newsId = self.newsid;
    newsCommentViewCtrl.cmtSid = G_SCHOOL_ID;
    
    [self.navigationController pushViewController:newsCommentViewCtrl animated:YES];
}

- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [self enableLeftAndRightKey];

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue]) {
        [Utilities dismissProcessingHud:self.view];

        NSDictionary *dic = [resultJSON objectForKey:@"message"];
        
        NewsDetailObject *newsDetail = [[NewsDetailObject alloc] init];
        newsDetail.newsid = [dic objectForKey:@"newsid"];
        newsDetail.title = [dic objectForKey:@"title"];
        newsDetail.updatetime = [dic objectForKey:@"updatetime"];
        newsDetail.message = [dic objectForKey:@"message"];
        newsDetail.iscomment = [dic objectForKey:@"iscomment"];
        newsDetail.name = [dic objectForKey:@"name"];

        _pics = [dic objectForKey:@"pics"];
        
        NSString *picsString;
        picsString = [_pics componentsJoinedByString:@"|"];
        
        newsDetail.pics = picsString;
        
        [newsDetail updateToDB];
        
        [self doShowContent:[resultJSON objectForKey:@"message"]];
    }else {
        [Utilities dismissProcessingHud:self.view];

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:[resultJSON objectForKey:@"message"]
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

- (id)initWithVar:(NSString *)newsName;
{
    if(self = [super init])
    {
        _titleName = newsName;
    }
    
    return self;
}

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webView addGestureRecognizer:singleTap];
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
    CGPoint pt = [sender locationInView:webView];

    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString *tagName = [webView stringByEvaluatingJavaScriptFromString:js];

    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    
    
    if (tagName && [tagName caseInsensitiveCompare:@"IMG"] == NSOrderedSame) {
        //NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
        NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
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
                
                NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:urlToSave];
                
                if (-1 != pos) {
                    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                    browser.currentPhotoIndex = pos;
                    
                    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_pics count]];
                    
                    for (int i = 0; i<[_pics count]; i++) {
                        NSString *pic_url = [_pics objectAtIndex:i];
                        
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
//    else {
//        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
////        fileViewer.webType = SWLoadURl;
////        fileViewer.url = [NSURL URLWithString:imgURL];
//        fileViewer.requestURL = imgURL;
//        fileViewer.titleName = @"内容";
//        
//        [self.navigationController pushViewController:fileViewer animated:YES];
//    }
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    
    NSString *urlStr = [requestURL resourceSpecifier];
    NSArray *arrayDot = [urlStr componentsSeparatedByString:@"."];
    NSString *type = [arrayDot objectAtIndex:[arrayDot count]-1];
    
//    NSString *scheme = [requestURL scheme];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        if (([@"rar"  isEqual: type]) ||
            ([@"zip"  isEqual: type]))
            {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"不支持此格式，无法打开。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else if (([@"txt"  isEqual: type]) ||
                  ([@"doc"  isEqual: type]) ||
                  ([@"docx"  isEqual: type]) ||
                  ([@"xls"  isEqual: type]) ||
                  ([@"xlsx"  isEqual: type]) ||
                  ([@"pptx"  isEqual: type]) ||
                  ([@"ppt"  isEqual: type]) ||
                  ([@"pdf"  isEqual: type]) ||
                  ([@"png"  isEqual: type]) ||
                  ([@"jpg"  isEqual: type]) ||
                  ([@"gif"  isEqual: type])) {
            // 为了使iOS 7以及以下可以在app内部打开文件，这里再做个判断
#if 0
            FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
            fileViewer.requestURL = requestURL;
            fileViewer.titlea = @"内容";
#endif
            // 2015.09.23
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            fileViewer.webType = SWFile;
            fileViewer.url = requestURL;
            fileViewer.titleName = @"内容";
            
            [self.navigationController pushViewController:fileViewer animated:YES];
        }else {
            // 网页的话，iOS 8以上就可以内部打开，以下去safari
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
#if 0
                FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
                fileViewer.requestURL = requestURL;
                fileViewer.titlea = @"内容";
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWFile;
                fileViewer.url = requestURL;
                fileViewer.titleName = @"内容";
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }else {
                [[UIApplication sharedApplication] openURL:requestURL];
            }
        }
#if 0
        // 仅支持下述类型
        if (([@"xls"  isEqual: type]) ||
            ([@"xlsx"  isEqual: type]) ||
            ([@"doc"  isEqual: type]) ||
            ([@"docx"  isEqual: type]) ||
            ([@"pptx"  isEqual: type]) ||
            ([@"ppt"  isEqual: type]) ||
            ([@"pdf"  isEqual: type]) ||
            ([@"txt"  isEqual: type]) ||
            ([@"gif"  isEqual: type]) ||
            ([@"jpeg"  isEqual: type]) ||
            ([@"jpg"  isEqual: type]) ||
            ([@"png"  isEqual: type]) ||
            ([@"com/"  isEqual: type]) ||
            ([@"com"  isEqual: type])
            ) {
            
            FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
            fileViewer.requestURL = requestURL;
            fileViewer.titlea = @"内容";
            [self.navigationController pushViewController:fileViewer animated:YES];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"不支持此格式，无法打开。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
#endif
        return NO;
    }else {
        return YES;
    }
}

@end
