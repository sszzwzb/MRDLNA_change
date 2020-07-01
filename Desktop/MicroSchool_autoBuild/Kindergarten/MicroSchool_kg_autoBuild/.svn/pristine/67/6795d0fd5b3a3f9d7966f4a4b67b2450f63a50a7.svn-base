//
//  NewsDetailOtherViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "NewsDetailOtherViewController.h"
#import "SingleWebViewController.h"

@interface NewsDetailOtherViewController ()

@end

@implementation NewsDetailOtherViewController

@synthesize newsid;
@synthesize newsDate;
@synthesize updatetime;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:_titleName];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    [self doGetCommentCount];
}

- (void)doGetCommentCount
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          _otherSid, @"sid",
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
            
            [_btn_comment setTitle:count forState:UIControlStateNormal];
            [_btn_comment setTitle:count forState:UIControlStateHighlighted];
        } else {
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
    }];
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
#define TITLE_LABEL_Y_OFFSET		(10)
    
    _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];

    label_titil = [[UILabel alloc] initWithFrame:CGRectMake(10, TITLE_LABEL_Y_OFFSET, 300, 45)];
    //设置title自适应对齐
    label_titil.lineBreakMode = NSLineBreakByWordWrapping;
    label_titil.font = [UIFont systemFontOfSize:17.0f];
    label_titil.numberOfLines = 2;
    //label_contentDetail.adjustsFontSizeToFitWidth = YES;
    label_titil.lineBreakMode = NSLineBreakByTruncatingTail;
    label_titil.textAlignment = NSTextAlignmentLeft;
    label_titil.textColor = [UIColor blackColor];
    label_titil.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_titil];
    
    // 日期
    label_date = [[UILabel alloc] initWithFrame:CGRectMake(10, label_titil.frame.origin.y + label_titil.frame.size.height, 280, 25)];
    label_date.font = [UIFont systemFontOfSize:12.0f];
    label_date.textColor = [UIColor grayColor];
    label_date.backgroundColor = [UIColor clearColor];
    label_date.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:label_date];
    
    [self performSelector:@selector(doGetNewsDetail) withObject:nil afterDelay:0.05];
    
}

-(void)doGetNewsDetail
{
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"News", @"ac",
                          @"2", @"v",
                          @"viewDetail", @"op",
                          _otherSid, @"sid",
                          self.newsid, @"newsid",
                          @"290",@"width",
                          nil];

    [network sendHttpReq:HttpReq_NewsDetail andData:data];
}

-(void)doShowContent:(NSDictionary *)dic
{
    label_titil.text = [dic objectForKey:@"title"];
    
    Utilities *util = [Utilities alloc];
    label_date.text = [util linuxDateToString:self.newsDate andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    
    imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(10, label_date.frame.origin.y + label_date.frame.size.height, 300, 1)];
    imgView_line.image=[UIImage imageNamed:@"hengxian.jpg"];
    [self.view addSubview:imgView_line];
    
    NSString *webContent = [dic objectForKey:@"message"];
    NSLog(@"html:%@",webContent);
    
    if([NSNull null] == webContent) {
        UILabel *nullContent = [[UILabel alloc]initWithFrame:CGRectMake(10, imgView_line.frame.origin.y + imgView_line.frame.size.height + 10, 300, 18)];
        nullContent.font = [UIFont systemFontOfSize:17.0f];
        nullContent.textColor = [UIColor blackColor];
        nullContent.backgroundColor = [UIColor clearColor];
        nullContent.textAlignment = NSTextAlignmentLeft;
        
        nullContent.text = @"无详细内容";
        
        [self.view addSubview: nullContent];
    }else {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(
                                                              10,
                                                              imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
                                                              300,
                                                              [UIScreen mainScreen].applicationFrame.size.height - label_date.frame.size.height - label_titil.frame.size.height - imgView_line.frame.size.height - 44 - 20)];
        [webView loadHTMLString:webContent baseURL:nil];//加载内容
        //webView.scrollView.bounces = NO;
        [webView setBackgroundColor:[UIColor clearColor]];
        webView.delegate = self;
        
        [self.view addSubview: webView];
        
        //addTapOnWebView
        [self addTapOnWebView];
    }
    
    if ([@"1"  isEqual: [dic objectForKey:@"iscomment"]]) {
        //        _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_comment.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 90,
                                        [UIScreen mainScreen].applicationFrame.size.height - 100 , 70, 30);
        
        // 设置颜色和字体
        [_btn_comment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn_comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _btn_comment.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [_btn_comment setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        
        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"news/button_03_n"] forState:UIControlStateNormal] ;
        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"news/button_03_p"] forState:UIControlStateHighlighted] ;
        // 添加 action
        [_btn_comment addTarget:self action:@selector(comment_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.view addSubview:_btn_comment];
    }

}

- (IBAction)comment_btnclick:(id)sender
{
    NewsCommentViewController *newsCommentViewCtrl = [[NewsCommentViewController alloc] init];
    newsCommentViewCtrl.newsId = self.newsid;
    newsCommentViewCtrl.cmtSid = _otherSid;
    
    [self.navigationController pushViewController:newsCommentViewCtrl animated:YES];
}

- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [self enableLeftAndRightKey];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue]) {
        
        [Utilities dismissProcessingHud:self.view];// 2015.05.12
        NSDictionary *dic = [resultJSON objectForKey:@"message"];
        
        _pics = [dic objectForKey:@"pics"];
        
        [self doShowContent:[resultJSON objectForKey:@"message"]];
        
    }else {
        
        [Utilities dismissProcessingHud:self.view];// 2015.05.12
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取信息错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}


-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
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
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
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
