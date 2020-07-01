//
//  HomeworkViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-18.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "HomeworkViewController.h"
#import "DiscussDetailViewController.h"
@interface HomeworkViewController ()

@end

@implementation HomeworkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    
    // 导航右菜单，编辑
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
    if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype])
    {
        [super setCustomizeRightButton:@"icon_edit_forums.png"];
    }
    [super setCustomizeLeftButton];
}

-(void)selectRightAction:(id)sender
{
    HomeworkSubmitViewController *submitViewCtrl = [[HomeworkSubmitViewController alloc] init];
    [self.navigationController pushViewController:submitViewCtrl animated:YES];
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];

//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
//                                          animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToHomeworkDetailView:) name:@"Weixiao_changeToHomeworkDetailView" object:nil];
}

-(void)changeToHomeworkDetailView:(NSNotification *)notification
{
    NSLog(@"changeToHomeworkDetailView");
    NSDictionary *dic = [notification userInfo];

    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid =  [dic objectForKey:@"tid"];
    [disscussDetailViewCtrl setFlag:3];
    disscussDetailViewCtrl.disTitle = _titleName;
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];

    _tabBarHomework = [[HomeworkTabBarController alloc]init];
    //_tabBarHomework.tabBar.frame = CGRectMake(0,0,320,44);
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }

    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
    if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype])
    {
        TodayWorkViewController *todayWork = [[TodayWorkViewController alloc] init];
        HistoryWorkViewController *historyWork = [[HistoryWorkViewController alloc] init];
        MeWorkViewController *meWork = [[MeWorkViewController alloc] init];
        PostWorkViewController *postWork = [[PostWorkViewController alloc] init];
        
        NSArray *viewControllers = [NSArray arrayWithObjects:todayWork,meWork,postWork,historyWork, nil];
        [_tabBarHomework setViewControllers:viewControllers];
    }
    else
    {
        TodayWorkViewController *todayWork = [[TodayWorkViewController alloc] init];
        HistoryWorkViewController *historyWork = [[HistoryWorkViewController alloc] init];
        PostWorkViewController *postWork = [[PostWorkViewController alloc] init];
        
        NSArray *viewControllers = [NSArray arrayWithObjects:todayWork,postWork,historyWork, nil];
        [_tabBarHomework setViewControllers:viewControllers];
    }
    
    [self.view addSubview:_tabBarHomework.view];
}

@end
