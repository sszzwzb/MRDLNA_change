//
//  SchoolEventViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-22.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SchoolEventViewController.h"

@interface SchoolEventViewController ()

@end

@implementation SchoolEventViewController

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
    //[super setCustomizeTitle:@"校园活动"];
    [super setCustomizeTitle:_titleName];//update by kate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToEventDetailView:) name:@"Weixiao_changeToEventDetailView" object:nil];
}

-(void)changeToEventDetailView:(NSNotification *)notification
{
    NSLog(@"changeToEventDetailView");
    NSDictionary *dic = [notification userInfo];

    SchoolEventDetailViewController *eventDetailViewCtrl = [[SchoolEventDetailViewController alloc] init];
    eventDetailViewCtrl.eid = [dic objectForKey:@"eventid"];
    [self.navigationController pushViewController:eventDetailViewCtrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
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

- (void)loadView
{
//    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
//    self.view = view;
    
    if (iPhone5)
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];
        
//        UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
//        self.view = view;
    }
    else
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];
    }

    //NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
    //NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);

    SchEventTabbar = [[SchoolEventTabBarController alloc]init];
    //SchEventTabbar.tabBar.frame = CGRectMake(0,0,320,44);

    AllEventViewController *allEvent = [[AllEventViewController alloc] init];
    allEvent.titleName = _titleName;// update by kate
    ActivityEventViewController *activityEvent = [[ActivityEventViewController alloc] init];
    CloseEventViewController *closeEvent = [[CloseEventViewController alloc] init];
    MyEventViewController *myEvent = [[MyEventViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:allEvent,activityEvent,closeEvent,myEvent, nil];
    [SchEventTabbar setViewControllers:viewControllers];

    [self.view addSubview:SchEventTabbar.view];
}

// update by kate
- (id)initWithVar:(NSString *)newsName
{
    if(self = [super init])
    {
        _titleName = newsName;
    }
    
    return self;
}

@end
