//
//  EduModuleDetailViewController.m
//  MicroSchool
//
//  Created by jojo on 14-8-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduModuleDetailViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SingleWebViewController.h"

@interface EduModuleDetailViewController ()

@end

@implementation EduModuleDetailViewController

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
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(
                                                          10,
                                                          10,
                                                          300,
                                                          [UIScreen mainScreen].applicationFrame.size.height - 44)];
    
    webView.delegate = self;
    
    //    webView.opaque = NO;
    //    webView.scalesPageToFit = YES;
    //    [webView setUserInteractionEnabled:YES];//是否支持交互
    
    //禁止UIWebView拖动
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
    [webView setScalesPageToFit:NO];
    
    [webView loadHTMLString:_detailInfo baseURL:nil];//加载内容
    
    //webView.scrollView.bounces = NO;
    [webView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: webView];
    
    [self addTapOnWebView];
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
        
        return NO;
    }else {
        return YES;
    }
}

//-----add by kate 获取webView中图片 点击查看大图-------------------------------

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self.showWebView addGestureRecognizer:singleTap];
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
    //CGPoint pt = [sender locationInView:self.showWebView];
    CGPoint pt = [sender locationInView:webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    //NSString *fileURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", pt.x, pt.y];
    
    NSString *imgUrlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
    //NSString *fileUrlToSave = [webView stringByEvaluatingJavaScriptFromString:fileURL];
    
    //NSURL *aaaurl=[NSURL URLWithString:fileUrlToSave];
    
    //NSLog(@"image url=%@", urlToSave);
    if (imgUrlToSave.length > 0) {
        
            NSString *imgUrl = imgUrlToSave;
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor clearColor];
            if(IS_IPHONE_5){
                imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
            }else{
                imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
            }
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
        
    }
}
//--------------------------------------------------------------------------------------------------

@end
