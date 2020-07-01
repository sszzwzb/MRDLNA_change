//
//  SchoolEventTabBarController.m
//  MicroSchool
//
//  Created by jojo on 13-11-24.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SchoolEventTabBarController.h"

@interface SchoolEventTabBarController ()

@end

@implementation SchoolEventTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
        NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);
        
        NSLog(@"x = %f",[ UIScreen mainScreen].applicationFrame.origin.x);
        NSLog(@"y = %f",[ UIScreen mainScreen].applicationFrame.origin.y);
        
        // 自定义一个tabBar的view
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//        {
//            _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
//        }
//        else
//        {
//            _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 320, 49)];
//        }

        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];

        [self initTabBarItem:CGRectMake(80, 0, 80, 49) andName:@"活动中" andTag:1];
        [self initTabBarItem:CGRectMake(160, 0, 80, 49) andName:@"已结束" andTag:2];
        [self initTabBarItem:CGRectMake(240, 0, 80, 49) andName:@"我的活动" andTag:3];
        [self initTabBarItem:CGRectMake(0, 0, 80, 49) andName:@"全部" andTag:0];

        [self.view addSubview:_tabView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTabBarItem:(CGRect) rect andName:(NSString*) name andTag:(NSUInteger) tag
{
    //    CGFloat top = 25; // 顶端盖高度
    //    CGFloat bottom = 25 ; // 底端盖高度
    //    CGFloat left = 10; // 左端盖宽度
    //    CGFloat right = 10; // 右端盖宽度
    
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    // 默认状态图片
    UIImage *image_d = [UIImage imageNamed:@"btn_event_detil_d.png"];
    image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 选择状态图片
    UIImage *image_p = [UIImage imageNamed:@"btn_event_detil_p.png"];
    image_p = [image_p resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    if (tag == 0)
    {
        // 小三角
//        imgView_sj0 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+30,rect.origin.y+rect.size.height,20,10)];
//        imgView_sj0.image=[UIImage imageNamed:@"icon_activities_down.png"];
    }
    else if (tag == 1)
    {
//        imgView_sj1 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+30,rect.origin.y+rect.size.height,20,10)];
//        imgView_sj1.image=[UIImage imageNamed:@"icon_activities_down.png"];
    }
    else if (tag == 2)
    {
//        imgView_sj2 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+30,rect.origin.y+rect.size.height,20,10)];
//        imgView_sj2.image=[UIImage imageNamed:@"icon_activities_down.png"];
    }
    else if (tag == 3)
    {
//        imgView_sj3 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+30,rect.origin.y+rect.size.height,20,10)];
//        imgView_sj3.image=[UIImage imageNamed:@"icon_activities_down.png"];
    }
    else
    {
        NSLog(@"err");
    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    button.frame  = rect;
    [button setBackgroundImage:image_d forState:UIControlStateNormal];
    [button setBackgroundImage:image_p forState:UIControlStateSelected];
    button.tag = tag;
    
    // 如果为第一个tag，则为默认
    if(0 == tag)
    {
        button.selected = YES;
//        [_tabView addSubview:imgView_sj0];
    }
    
    // 把homeButton赋值给_lastButton;
    _lastButton = button;
    [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:button];
}

- (void)tabAction:(UIButton *)button
//- (void)tabAction:(id) sender
{
    if (_lastButton != button) {
        _lastButton.selected = NO;
        
        if (_lastButton.tag == 0)
        {
//            [imgView_sj0 removeFromSuperview];
        }
        else if (_lastButton.tag == 1)
        {
//            [imgView_sj1 removeFromSuperview];
        }
        else if (_lastButton.tag == 2)
        {
//            [imgView_sj2 removeFromSuperview];
        }
        else if (_lastButton.tag == 3)
        {
//            [imgView_sj3 removeFromSuperview];
        }

    }
    // 通过修改索引切换视图控制器
    self.selectedIndex = button.tag;
    
    if (button.tag == 0)
    {
//        [_tabView addSubview:imgView_sj0];
    }
    else if (button.tag == 1)
    {
//        [_tabView addSubview:imgView_sj1];
    }
    else if (button.tag == 2)
    {
//        [_tabView addSubview:imgView_sj2];
    }
    else if (button.tag == 3)
    {
//        [_tabView addSubview:imgView_sj3];
    }

    //NSLog(@"self.selectedIndex = %lu",(unsigned long)self.selectedIndex);

    button.selected = YES;
    _lastButton = button;
}

@end
