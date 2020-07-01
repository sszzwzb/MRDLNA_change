//
//  HomeworkTabBarController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeworkTabBarController.h"

@interface HomeworkTabBarController ()

@end

@implementation HomeworkTabBarController

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
        _tabView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1];
        g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype])
        {
            [self initTabBarItem:CGRectMake(80, 0, 80, 49) andName:@"我发布的" andTag:1];
            [self initTabBarItem:CGRectMake(160, 0, 80, 49) andName:@"我回应的" andTag:2];
            [self initTabBarItem:CGRectMake(240, 0, 80, 49) andName:@"以往作业" andTag:3];
            [self initTabBarItem:CGRectMake(0, 0, 80, 49) andName:@"今日作业" andTag:0];
        }
        else
        {
            [self initTabBarItem:CGRectMake(107, 0, 107, 49) andName:@"我回应的" andTag:2];
            [self initTabBarItem:CGRectMake(214, 0, 107, 49) andName:@"以往作业" andTag:3];
            [self initTabBarItem:CGRectMake(0, 0, 107, 49) andName:@"今日作业" andTag:0];
        }
        
        [self.view addSubview:_tabView];;
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
    CGSize buttonSize;
    if([@"7"  isEqual: usertype])
    {
        buttonSize.width = [UIScreen mainScreen].bounds.size.width/4.0;
        buttonSize.height = 49;
    }
    else
    {
        buttonSize.width = [UIScreen mainScreen].bounds.size.width/3.0;
        buttonSize.height = 49;
    }

    UIImage *newImage_d;
    UIImage *newImage_p;
    UIImage *image_d1;
    UIImage *image_p1;

    // 默认状态图片
    //UIImage *image_d = [UIImage imageNamed:@"bg_b.png"];//update by kate 2013.12.10
   // image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 选择状态图片
    //UIImage *image_p = [UIImage imageNamed:@"bg_g.png"];//update by kate 2014.12.10
    //image_p = [image_p resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    if (tag == 0)
    {
        //---update by kate 2014.12.10
//        image_d1 = [UIImage imageNamed:@"icon_jinri_d.png"];
//        image_p1 = [UIImage imageNamed:@"icon_jinri_p.png"];
        
        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype]) {
            image_d1 = [UIImage imageNamed:@"icon_jrzy_d.png"];
            image_p1 = [UIImage imageNamed:@"icon_jrzy_p.png"];
        }else {
            image_d1 = [UIImage imageNamed:@"icon_jrzy_d_1.png"];
            image_p1 = [UIImage imageNamed:@"icon_jrzy_p_1.png"];
        }
    }
    else if (tag == 1)
    {
        //---update by kate 2014.12.10
//        image_d1 = [UIImage imageNamed:@"icon_faqi_d.png"];
//        image_p1 = [UIImage imageNamed:@"icon_faqi_p.png"];
        image_d1 = [UIImage imageNamed:@"icon_wfbd_d.png"];
        image_p1 = [UIImage imageNamed:@"icon_wfbd_p.png"];
        
    }
    else if (tag == 2)
    {
        //---update by kate 2014.12.10
//        image_d1 = [UIImage imageNamed:@"icon_huiying_d.png"];
//        image_p1 = [UIImage imageNamed:@"icon_huiying_p.png"];
        
        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype]) {
            image_d1 = [UIImage imageNamed:@"icon_whyd_d.png"];
            image_p1 = [UIImage imageNamed:@"icon_whyd_p.png"];
        }else {
            image_d1 = [UIImage imageNamed:@"icon_whyd_d_1.png"];
            image_p1 = [UIImage imageNamed:@"icon_whyd_p_1.png"];
        }

    }
    else if (tag == 3)
    {
        //---update by kate 2014.12.10
//        image_d1 = [UIImage imageNamed:@"icon_yiwang_d.png"];
//        image_p1 = [UIImage imageNamed:@"icon_yiwang_p.png"];

        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype]) {
            image_d1 = [UIImage imageNamed:@"icon_ywzy_d.png"];
            image_p1 = [UIImage imageNamed:@"icon_ywzy_p.png"];
        }else {
            image_d1 = [UIImage imageNamed:@"icon_ywzy_d_1.png"];
            image_p1 = [UIImage imageNamed:@"icon_ywzy_p_1.png"];
        }

    }
    else
    {
        NSLog(@"err");
    }
    
   /* UIGraphicsBeginImageContext(buttonSize);
    [image_d drawInRect:CGRectMake(0,0,buttonSize.width,49)];
    [image_d1 drawInRect:CGRectMake((buttonSize.width-30)/2,3,30,30)];
    
    newImage_d = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContext(buttonSize);
    [image_p drawInRect:CGRectMake(0,0,buttonSize.width,49)];
    [image_p1 drawInRect:CGRectMake((buttonSize.width-30)/2,3,30,30)];
    
    newImage_p = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -30, 0)];

    button.frame  = rect;
//    [button setBackgroundImage:newImage_d forState:UIControlStateNormal];
//    [button setBackgroundImage:newImage_p forState:UIControlStateSelected];
    [button setBackgroundImage:image_d1 forState:UIControlStateNormal];
    [button setBackgroundImage:image_p1 forState:UIControlStateSelected];
    
    if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype]) {
        button.tag = tag;
    }else {
        if (tag != 0) {
            tag = tag - 1;
        }
        button.tag = tag;
    }
    
    
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
