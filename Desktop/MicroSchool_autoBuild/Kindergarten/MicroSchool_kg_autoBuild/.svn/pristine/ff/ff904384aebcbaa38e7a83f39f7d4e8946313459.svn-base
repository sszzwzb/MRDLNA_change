//
//  KnowledgeViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeViewController.h"

@interface KnowledgeViewController ()

@end

@implementation KnowledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:_titleName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToKnowledgeDetailView:) name:@"Weixiao_changeToKnowledgeDetailView" object:nil];
}

-(void)changeToKnowledgeDetailView:(NSNotification *)notification
{
    NSLog(@"changeToKnowledgeDetailView");
    NSDictionary *dic = [notification userInfo];
    
    KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
    knowledgeDetailViewCtrl.tid = [dic objectForKey:@"tid"];
    knowledgeDetailViewCtrl.subuid = [dic objectForKey:@"subuid"];
    [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    // 导航右菜单，搜索
    [super setCustomizeRightButton:@"knowledge/icon_search.png"];
}

-(void)selectLeftAction:(id)sender
{
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    // search view
    KnowledgeSearchViewController *searchViewCtrl = [[KnowledgeSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewCtrl animated:YES];
    searchViewCtrl.title = @"知识库";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-29)];

//    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(80,4,2,25)];
//    [imgView_line1 setImage:[UIImage imageNamed:@"title_line.png"]];
//    [imgView_line1 setTag:999];
//    [self.view addSubview:imgView_line1];

    knowledgeTabbar = [[KnowledgeTabBarViewController alloc]init];

    KnowledgeLibViewController *knowledgeLibView = [[KnowledgeLibViewController alloc] init];
    SubscribeViewController *subscribeView = [[SubscribeViewController alloc] init];
    CollectionViewController *collectionView = [[CollectionViewController alloc] init];
    SubscribePeopleViewController *subscribePeopleView = [[SubscribePeopleViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:knowledgeLibView,subscribeView,subscribePeopleView,collectionView, nil];
    [knowledgeTabbar setViewControllers:viewControllers];
    
    [self.view addSubview:knowledgeTabbar.view];
}

@end
