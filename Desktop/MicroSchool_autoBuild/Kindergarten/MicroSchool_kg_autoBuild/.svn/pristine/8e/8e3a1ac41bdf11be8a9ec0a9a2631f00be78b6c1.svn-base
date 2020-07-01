//
//  KnowledgeTabBarViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeTabBarViewController.h"

@interface KnowledgeTabBarViewController ()

@end

@implementation KnowledgeTabBarViewController

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
        
#define TABBAR_HEIGHT 49
        
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TABBAR_HEIGHT)];
        
        [self initTabBarItem:CGRectMake(80, 0, 80, TABBAR_HEIGHT) andName:@"我的订阅" andTag:1];
        [self initTabBarItem:CGRectMake(160, 0, 80, TABBAR_HEIGHT) andName:@"订阅的人" andTag:2];
        [self initTabBarItem:CGRectMake(240, 0, 80, TABBAR_HEIGHT) andName:@"我的收藏" andTag:3];
        [self initTabBarItem:CGRectMake(0, 0, 80, TABBAR_HEIGHT) andName:@"知识库" andTag:0];
        
        UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,TABBAR_HEIGHT)];
        [imgView_bg setImage:[UIImage imageNamed:@"knowledge/dh.png"]];
        [self.view addSubview:imgView_bg];
        
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
#if 9
    // 默认状态图片
    UIImage *image_d;
    
    // 选择状态图片
    UIImage *image_p;
    
    // 指定为拉伸模式，伸缩后重新赋值
    CGSize buttonSize;
    
    buttonSize.width = 80;
    buttonSize.height = 49;
    
    UIImage *newImage_d;
    UIImage *newImage_p;

#endif
    
    if (tag == 0)
    {
        image_d = [UIImage imageNamed:@"knowledge/icon_zsk_d.png"];
        image_p = [UIImage imageNamed:@"knowledge/icon_zsk_p.png"];
        
        // 小三角
        imgView_sj0 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj0.image=[UIImage imageNamed:@"knowledge/arrow.png"];
    }
    else if (tag == 1)
    {
        image_d = [UIImage imageNamed:@"knowledge/icon_wddy_d.png"];
        image_p = [UIImage imageNamed:@"knowledge/icon_wddy_p.png"];

        imgView_sj1 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj1.image=[UIImage imageNamed:@"knowledge/arrow.png"];
    }
    else if (tag == 2)
    {
        image_d = [UIImage imageNamed:@"knowledge/icon_gzdr_d.png"];
        image_p = [UIImage imageNamed:@"knowledge/icon_gzdr_p.png"];

        imgView_sj2 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj2.image=[UIImage imageNamed:@"knowledge/arrow.png"];
    }
    else if (tag == 3)
    {
        image_d = [UIImage imageNamed:@"knowledge/icon_wdsc_d.png"];
        image_p = [UIImage imageNamed:@"knowledge/icon_wdsc_p.png"];

        imgView_sj3 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj3.image=[UIImage imageNamed:@"knowledge/arrow.png"];
    }
    else
    {
        NSLog(@"err");
    }
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_d drawInRect:CGRectMake((buttonSize.width-22)/2,3,22,22)];
    
    newImage_d = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_p drawInRect:CGRectMake((buttonSize.width-22)/2,3,22,22)];
    
    newImage_p = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitleColor:[[UIColor alloc] initWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor alloc] initWithRed:129/255.0f green:175/255.0f blue:216/255.0f alpha:1.0] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -15, 0)];

    button.frame  = rect;
    //button.adjustsImageWhenHighlighted = NO;
    //button.showsTouchWhenHighlighted = NO;

    [button setBackgroundImage:newImage_d forState:UIControlStateNormal];
    [button setBackgroundImage:newImage_p forState:UIControlStateSelected];
    button.tag = tag;
    
    
    imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(2,TABBAR_HEIGHT-3,76,2)];
    imgView_line.image=[UIImage imageNamed:@"knowledge/blue.png"];
    
    
    // 如果为第一个tag，则为默认
    if(0 == tag)
    {
        button.selected = YES;
        [_tabView addSubview:imgView_sj0];
        [_tabView addSubview:imgView_line];
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
        
        [imgView_line removeFromSuperview];
        
        if (_lastButton.tag == 0)
        {
            [imgView_sj0 removeFromSuperview];
        }
        else if (_lastButton.tag == 1)
        {
            [imgView_sj1 removeFromSuperview];
        }
        else if (_lastButton.tag == 2)
        {
            [imgView_sj2 removeFromSuperview];
        }
        else if (_lastButton.tag == 3)
        {
            [imgView_sj3 removeFromSuperview];
        }
        
    }
    // 通过修改索引切换视图控制器
    self.selectedIndex = button.tag;
    
    imgView_line.frame = CGRectMake(80*button.tag + 2,TABBAR_HEIGHT-3,76,2);
    
    if (button.tag == 0)
    {
        [_tabView addSubview:imgView_sj0];
        [_tabView addSubview:imgView_line];
    }
    else if (button.tag == 1)
    {
        [_tabView addSubview:imgView_sj1];
        [_tabView addSubview:imgView_line];
    }
    else if (button.tag == 2)
    {
        [_tabView addSubview:imgView_sj2];
        [_tabView addSubview:imgView_line];
    }
    else if (button.tag == 3)
    {
        [_tabView addSubview:imgView_sj3];
        [_tabView addSubview:imgView_line];
    }
    
    //NSLog(@"self.selectedIndex = %lu",(unsigned long)self.selectedIndex);
    
    button.selected = YES;
    _lastButton = button;
}

@end
