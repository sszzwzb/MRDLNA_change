//
//  ServerViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-2.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

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
    [super setCustomizeTitle:@"版权说明"];
    [super setCustomizeLeftButton];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44)];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath isDirectory:NO]]];
    
    [webView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: webView];
    
    [ReportObject event:ID_OPEN_SERVER];//2015.06.25
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
