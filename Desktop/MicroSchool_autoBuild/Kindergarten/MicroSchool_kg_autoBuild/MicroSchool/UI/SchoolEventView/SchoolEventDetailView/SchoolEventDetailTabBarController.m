//
//  SchoolEventDetailTabBarController.m
//  MicroSchool
//
//  Created by jojo on 13-11-24.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SchoolEventDetailTabBarController.h"

@interface SchoolEventDetailTabBarController ()

@end

@implementation SchoolEventDetailTabBarController

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
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, WIDTH, 49)];
        
        [self initTabBarItem:CGRectMake(80, 0, 80, 49) andName:@"成员" andTag:1];
        [self initTabBarItem:CGRectMake(160, 0, 80, 49) andName:@"照片" andTag:2];
        [self initTabBarItem:CGRectMake(240, 0, 80, 49) andName:@"留言" andTag:3];
        [self initTabBarItem:CGRectMake(0, 0, 80, 49) andName:@"详情" andTag:0];
        
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
    CGSize buttonSize;
    buttonSize.width = 80;
    buttonSize.height = 49;

    UIImage *newImage_d;
    UIImage *newImage_p;
    UIImage *image_d1;
    UIImage *image_p1;

    // 默认状态图片
    UIImage *image_d = [UIImage imageNamed:@"btn_event_detil_d.png"];
    image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 选择状态图片
    UIImage *image_p = [UIImage imageNamed:@"btn_event_detil_p.png"];
    image_p = [image_p resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    if (tag == 0)
    {
        image_d1 = [UIImage imageNamed:@"icon_jinri_d.png"];
        image_p1 = [UIImage imageNamed:@"icon_jinri_p.png"];
    }
    else if (tag == 1)
    {
        image_d1 = [UIImage imageNamed:@"icon_faqi_d.png"];
        image_p1 = [UIImage imageNamed:@"icon_faqi_p.png"];
    }
    else if (tag == 2)
    {
        image_d1 = [UIImage imageNamed:@"icon_huiying_d.png"];
        image_p1 = [UIImage imageNamed:@"icon_huiying_p.png"];
    }
    else if (tag == 3)
    {
        image_d1 = [UIImage imageNamed:@"icon_yiwang_d.png"];
        image_p1 = [UIImage imageNamed:@"icon_yiwang_p.png"];
    }
    else
    {
        NSLog(@"err");
    }
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_d drawInRect:CGRectMake(0,0,buttonSize.width,49)];
    [image_d1 drawInRect:CGRectMake((buttonSize.width-15)/2-15,(buttonSize.height-15)/2,15,15)];
    
    newImage_d = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_p drawInRect:CGRectMake(0,0,buttonSize.width,49)];
    [image_p1 drawInRect:CGRectMake((buttonSize.width-15)/2-15,(buttonSize.height-15)/2,15,15)];
    
    newImage_p = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];

    button.frame  = rect;
    [button setBackgroundImage:newImage_d forState:UIControlStateNormal];
    [button setBackgroundImage:newImage_p forState:UIControlStateSelected];
    button.tag = tag;
    
    // 如果为第一个tag，则为默认
    if(0 == tag)
    {
        button.selected = YES;
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
        }
        else if (_lastButton.tag == 1)
        {
        }
        else if (_lastButton.tag == 2)
        {
        }
        else if (_lastButton.tag == 3)
        {
        }
        
    }
    // 通过修改索引切换视图控制器
    self.selectedIndex = button.tag;
    
    if (button.tag == 0)
    {
    }
    else if (button.tag == 1)
    {
    }
    else if (button.tag == 2)
    {
    }
    else if (button.tag == 3)
    {
    }
    
    //NSLog(@"self.selectedIndex = %lu",(unsigned long)self.selectedIndex);
    
    button.selected = YES;
    _lastButton = button;
}
@end

