//
//  TestWebViewController.m
//  MicroSchool
//
//  Created by Kate on 15-3-18.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TestWebViewController.h"

@interface TestWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://v.youku.com/v_show/id_XOTEyNjE5NDE2_ev_1.html?from=y1.3-idx-grid-1519-9909.86808-86807.1-1"];
    
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url];
    //[_webView loadRequest:_requestURL];//加载内容
     [_webView loadRequest:urlR];//加载内容

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
