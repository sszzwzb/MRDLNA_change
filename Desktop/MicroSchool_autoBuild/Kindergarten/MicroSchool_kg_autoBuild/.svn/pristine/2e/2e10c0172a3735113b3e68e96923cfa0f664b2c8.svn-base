//
//  CalltipsViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-2.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "CalltipsViewController.h"

@interface CalltipsViewController ()

@end

@implementation CalltipsViewController

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
    [super setCustomizeTitle:@"使用协议"];
    [super setCustomizeLeftButton];

    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44)];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"calltips" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath isDirectory:NO]]];

    [webView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: webView];
    
    [ReportObject event:ID_OPEN_CALL_TIPS];//2015.06.25
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
