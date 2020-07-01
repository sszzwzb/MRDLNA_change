//
//  ToolsPageViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/19.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "ToolsPageViewController.h"

#import "ToolsPageView.h"


#import "SingleWebViewController.h"
#import "SingleWKWebViewController.h"


@interface ToolsPageViewController () <ToolsPageViewDelegate>

@end

@implementation ToolsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setCustomizeTitle:@""];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self up_ToolsPageView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)up_ToolsPageView
{
    ToolsPageView *view = [[ToolsPageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:view];
    view.delegate = self;
    
}

#pragma mark - ToolsPageViewDelegate
-(void)selectButWithTag:(NSInteger)tag title:(NSString *)title url:(NSString *)url
{
    if (tag == 0) {
        NSLog(@"老板端");
    }
    if (tag == 1) {
        NSLog(@"航务管理");
    }
    if (tag == 2) {
        NSLog(@"运行控制");
    }
    if (tag == 3) {
        NSLog(@"飞行管理");
    }
    if (tag == 4) {
        NSLog(@"外采报销");
    }
    if (tag == 5) {
        NSLog(@"交通机票补助");
    }
    
    
    [self pushWebViewWithTitle:title url:url];
}


-(void)pushWebViewWithTitle:(NSString *)title url:(NSString *)url
{
    SingleWKWebViewController *webVC = [[SingleWKWebViewController alloc]init];
    webVC.requestURL = [NSString stringWithFormat:@"%@?loginid=%@",url , [UtilitiesData getLoginUserName]];
    webVC.fromName = title;
    webVC.webType = SWKWLoadRequestClose;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
