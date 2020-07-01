//
//  EventDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize joined;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 查看活动详情
    [ReportObject event:ID_OPEN_EVENT_DETAIL];//2015.06.23
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(240, 105, 70, 23);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
    [button setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [button addTarget:self action:@selector(buttonJoin:) forControlEvents: UIControlEventTouchUpInside];
    
//    //设置title
//    [button setTitle:@"退出" forState:UIControlStateNormal];
//    [button setTitle:@"退出" forState:UIControlStateHighlighted];
    
    [self.view addSubview:button];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 179, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-179-44)];
    webView.delegate = self;
    [self.view addSubview: webView];
    
    [self addTapOnWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailMsg:(NSString*)msg andPics:(NSArray *)pics
{
    [webView loadHTMLString:msg baseURL:nil];//加载内容
    [webView setBackgroundColor:[UIColor clearColor]];
    
    _pics = pics;
}

- (IBAction)buttonJoin:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_joinSchoolEvent" object:self userInfo:Nil];
}

-(void) getJoined:(NSString*) jonied andStatus:(NSString*) status andNum:(NSString*) num
{
    self.joined = jonied;

    if ([@"1"  isEqual: jonied]) {
        //设置title
        [button setTitle:@"退出" forState:UIControlStateNormal];
        [button setTitle:@"退出" forState:UIControlStateHighlighted];
    } else {
        //设置title
        NSString *buttonStr = [NSString stringWithFormat:@"参加 %@", num];
        [button setTitle:buttonStr forState:UIControlStateNormal];
        [button setTitle:buttonStr forState:UIControlStateHighlighted];
    }
    
    if (1 == status.integerValue)
    {
        button.alpha = 0.7;
        button.enabled = NO;
    }
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
            
            NSString *imgUrl = urlToSave;
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
            photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
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
    
    NSString *scheme = [requestURL scheme];
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
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 requestURL, @"requestURL",
                                 nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_gotoFileView" object:self userInfo:dic];
        }else {
            // 网页的话，iOS 8以上就可以内部打开，以下去safari
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     requestURL, @"requestURL",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_gotoFileView" object:self userInfo:dic];
            }else {
                [[UIApplication sharedApplication] openURL:requestURL];
            }
        }
        
        return NO;
    }else {
        return YES;
    }
}

@end
