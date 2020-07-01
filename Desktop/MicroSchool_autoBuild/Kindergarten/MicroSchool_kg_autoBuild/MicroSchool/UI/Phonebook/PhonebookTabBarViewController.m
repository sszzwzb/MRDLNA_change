//
//  ContactTabBarViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PhonebookTabBarViewController.h"
#import "DBDao.h"
#import "PublicConstant.h"

@interface PhonebookTabBarViewController ()

@end

@implementation PhonebookTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#define TABBAR_HEIGHT 49
        
        //-----add by kate 2015.01.25----------------------------
#if 0 // 2015.11.18
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addNewCount)name:@"addNewCount"
                                                   object:nil];
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addNewCount:)name:@"addNewCount"
                                                   object:nil];//2015.11.18
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeNew)name:@"removeNew"
                                                   object:nil];
        _redLabel = [[UILabel alloc]initWithFrame:CGRectMake(92, 90+50.0+7-10 , 20, 20)];
        //----------------------------------------------
#if 0 // 2016.01.15
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TABBAR_HEIGHT)];
        //---update by kate 2015.03.02-----------
        //        [self initTabBarItem:CGRectMake(160, 0, 160, TABBAR_HEIGHT) andName:@"聊天" andTag:1];
        //        [self initTabBarItem:CGRectMake(0, 0, 160, TABBAR_HEIGHT) andName:@"通讯录" andTag:0];
        //        [self initTabBarItem:CGRectMake(160, 0, 160, TABBAR_HEIGHT) andName:@"通讯录" andTag:1];
        //        [self initTabBarItem:CGRectMake(0, 0, 160, TABBAR_HEIGHT) andName:@"聊天" andTag:0];
        
        
        [self initTabBarItem:CGRectMake(160, 0, 160, TABBAR_HEIGHT) andTag:1];// 通讯录
        [self initTabBarItem:CGRectMake(0, 0, 160, TABBAR_HEIGHT) andTag:0];// 聊天
        
        //---------------------------------------
        
        [self.view addSubview:_tabView];
#endif
        
#if 0 // 2015.11.18
        //-----add by kate 2015.01.25----------------------------
        
        [self addNewCount];
        //------------------------------------------
#endif
    }
    return self;
}

#if 0
// 所有消息总数
-(void)addNewCount{
    
    //------add 2015.01.25--------------------------------
    
    [_redLabel removeFromSuperview];
    
    NSString *sql = [NSString stringWithFormat:@"select * from msgList"];
    
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    int userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
        //NSLog(@"objectDict:%@",objectDict);
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
    }
    //----------------------------------------------------
    
    
    //UIButton *btn = (UIButton*)[_tabView viewWithTag:1];
    UIButton *btn = (UIButton*)[_tabView viewWithTag:0];//update by kate 2015.03.02
    NSString *countAll = [NSString stringWithFormat:@"%d",count];
    
    if([countAll intValue] > 0){
        int length = [countAll length];
        
        _redLabel.frame = CGRectMake(88, 1 , length*15, 20);
        
        if (length == 1) {
            
            _redLabel.frame = CGRectMake(88, 1 , 20, 20);
        }
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.text = countAll;
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.layer.cornerRadius = 10.0;
        _redLabel.layer.masksToBounds = YES;
        _redLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:_redLabel];
        
    }
    
}
#endif

// To do:聊天记录Tab上显示最新的未读数量 2015.11.18
-(void)addNewCount:(NSNotification*)notify{
    
    [self removeNew];
    NSString *count  = (NSString*)[notify object];
    UIButton *btn = (UIButton*)[_tabView viewWithTag:0];
    
    if ([count integerValue] > 0) {
        
        int length = [count length];
        
        _redLabel.frame = CGRectMake(88, 1 , length*15, 20);
        
        if (length == 1) {
            
            _redLabel.frame = CGRectMake(88, 1 , 20, 20);
        }
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.text = count;
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.layer.cornerRadius = 10.0;
        _redLabel.layer.masksToBounds = YES;
        _redLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:_redLabel];
    }else{
        [self removeNew];
    }
    
}



-(void)removeNew{
    
    [_redLabel removeFromSuperview];
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
    // 默认状态图片
    UIImage *image_d;
    
    // 选择状态图片
    UIImage *image_p;
    
    // 指定为拉伸模式，伸缩后重新赋值
    CGSize buttonSize;
    
    buttonSize.width = 160;
    buttonSize.height = 49;
    
    UIImage *newImage_d;
    UIImage *newImage_p;
    
    //if (tag == 0)
    if (tag == 1)//update by kate 2015.03.02
    {
        image_d = [UIImage imageNamed:@"friend/icon_txl_d.png"];
        image_p = [UIImage imageNamed:@"friend/icon_txl_p.png"];
        
        imgView_sj1 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj1.image=[UIImage imageNamed:@"knowledge/arrow.png"];
        
        
    }else if (tag == 0)//update by kate 2015.03.02 //else if (tag == 1)
    {
        image_d = [UIImage imageNamed:@"friend/icon_lt_d.png"];
        image_p = [UIImage imageNamed:@"friend/icon_lt_p.png"];
        
        // 小三角
        imgView_sj0 =[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x+(rect.size.width-13)/2,rect.origin.y+rect.size.height-9,13,5)];
        imgView_sj0.image=[UIImage imageNamed:@"knowledge/arrow.png"];
    }
    else
    {
        NSLog(@"err");
    }
    
    //    UIGraphicsBeginImageContext(buttonSize);
    //    [image_d drawInRect:CGRectMake((buttonSize.width-22)/2,3,22,22)];
    //
    //    newImage_d = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    UIGraphicsBeginImageContext(buttonSize);
    //    [image_p drawInRect:CGRectMake((buttonSize.width-22)/2,3,22,22)];
    //
    //    newImage_p = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    newImage_d = image_d;
    newImage_p = image_p;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitleColor:[[UIColor alloc] initWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor alloc] initWithRed:129/255.0f green:175/255.0f blue:216/255.0f alpha:1.0] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    //---update by kate 2015.07.01--------------------------------------------
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -30, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, -20, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 10, 0)];
    //------------------------------------------------------------------------
    
    button.frame  = rect;
    //button.adjustsImageWhenHighlighted = NO;
    //button.showsTouchWhenHighlighted = NO;
    
    //---update by kate 2015.07.01--------------------------------------------
    //    [button setBackgroundImage:newImage_d forState:UIControlStateNormal];
    //    [button setBackgroundImage:newImage_p forState:UIControlStateSelected];
    [button setImage:newImage_d forState:UIControlStateNormal];
    [button setImage:newImage_p forState:UIControlStateSelected];
    //------------------------------------------------------------------------
    
    
    button.tag = tag;
    
    imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(2,TABBAR_HEIGHT-3,156,2)];
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

// add by kate 2015.07.01
-(void)initTabBarItem:(CGRect) rect andTag:(NSUInteger)tag{
    
    // 默认状态图片
    UIImage *image_d;
    
    // 选择状态图片
    UIImage *image_p;
    
    // 指定为拉伸模式，伸缩后重新赋值
    CGSize buttonSize;
    
    buttonSize.width = 160;
    buttonSize.height = 49;
    
    if (tag == 1)
    {
        image_d = [UIImage imageNamed:@"friend/btn_txl_d.png"];
        image_p = [UIImage imageNamed:@"friend/btn_txl_p.png"];
        
    }else if (tag == 0)
    {
        //        image_d = [UIImage imageNamed:@"friend/btn_lt_d.png"];
        //        image_p = [UIImage imageNamed:@"friend/btn_lt_p.png"];
        
        image_d = [UIImage imageNamed:@"friend/btn_lt_p.png"];
        image_p = [UIImage imageNamed:@"friend/btn_lt_d.png"];
        
    }
    else
    {
        NSLog(@"err");
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[[UIColor alloc] initWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor alloc] initWithRed:129/255.0f green:175/255.0f blue:216/255.0f alpha:1.0] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    button.frame = rect;
    [button setBackgroundImage:image_d forState:UIControlStateNormal];
    //[button setBackgroundImage:image_p forState:UIControlStateSelected];
    
    button.tag = tag;
    
    // 把homeButton赋值给_lastButton;
    _lastButton = button;
    [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:button];
    
}

- (void)tabAction:(UIButton *)button
{
    if (_lastButton != button) {
        _lastButton.selected = NO;
        
        [imgView_line removeFromSuperview];
        
        if (_lastButton.tag == 0)
        {
            
            [_lastButton setBackgroundImage:[UIImage imageNamed:@"friend/btn_lt_d.png"] forState:UIControlStateNormal];
        }
        else if (_lastButton.tag == 1)
        {
            
            [_lastButton setBackgroundImage:[UIImage imageNamed:@"friend/btn_txl_d.png"] forState:UIControlStateNormal];
            
        }
    }
    // 通过修改索引切换视图控制器
    self.selectedIndex = button.tag;
    
    imgView_line.frame = CGRectMake(160*button.tag + 2,TABBAR_HEIGHT-3,156,2);
    
    if (button.tag == 0)
    {
        
        [button setBackgroundImage:[UIImage imageNamed:@"friend/btn_lt_p.png"] forState:UIControlStateNormal];
    }
    else if (button.tag == 1)
    {
        
        [button setBackgroundImage:[UIImage imageNamed:@"friend/btn_txl_p.png"] forState:UIControlStateNormal];
    }
    
    button.selected = YES;
    _lastButton = button;
}

@end
