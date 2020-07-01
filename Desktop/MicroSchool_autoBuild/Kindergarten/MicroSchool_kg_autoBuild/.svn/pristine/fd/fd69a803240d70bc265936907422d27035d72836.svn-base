//
//  MyTabBarController.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MyTabBarController.h"
#import "ImageResourceLoader.h"
#import "MicroSchoolAppDelegate.h"
#import "PublicConstant.h"
#import "ScanViewController.h"
#import "LeftViewController.h"
#import "ParksHomeViewController.h"
#import "MyClassDetailViewController.h"
//#import "EditCustomStoryViewController.h"
//#import "CreateCircleViewController.h"



#define TAB_VIEW_COUNT 3
//#3.20
@interface MyTabBarController()<ShowLeftOrRightView>{
    NSString *strNum;
}



@end

@implementation MyTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize tabLables;

- (id)initWithSelectIndex:(NSInteger)Index
{
    self = [super init];
    if (self) {
        self.currentSelectedIndex = Index;
    }
    
    isRightButtonClicked = false;

    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelectorOnMainThread:@selector(hideRealTabBar) withObject:nil waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(customTabBar) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setTabTitle) withObject:nil waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCustomTabTitle:)
                                                 name:@"setCustomTabTitle"
                                               object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    // modify by kate 2014.08.17
    if (centerView == nil) {
        
        if (IS_IPHONE_5) {
            centerView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 60)/2, 568-49-10, 60, 60)];
        }else{
            centerView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 60)/2, 480-49-10, 60, 60)];
        }
        
        
//        // 中间圈button
//        button_center = [UIButton buttonWithType:UIButtonTypeCustom];
//        button_center.frame = CGRectMake(0, 0, 60, 60);;
//        
//        [button_center setBackgroundImage:[UIImage imageNamed:@"err-on.png"] forState:UIControlStateNormal] ;
//       
//        
//        [button_center addTarget:self action:@selector(center_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//        
//        [centerView addSubview:button_center];
//        [self.view addSubview:centerView];
        
    }
   
}

/*- (IBAction)center_btnclick:(id)sender
{
    if (!isRightButtonClicked) {
        
        [button_center setBackgroundImage:[UIImage imageNamed:@"err-on_press.png"] forState:UIControlStateNormal] ;
        
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height)];
        //UIView * mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
//        mask.backgroundColor =[UIColor clearColor];
//        mask.opaque = NO;
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,20,320,[UIScreen mainScreen].applicationFrame.size.height)];
//        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        [imageView_bgMask setBackgroundColor:[UIColor clearColor]];

        imageView_bgMask.userInteractionEnabled = YES;
        
        
        UIButton *circleBtn = [[UIButton alloc] initWithFrame:CGRectMake((320-60)/2.0, [UIScreen mainScreen].applicationFrame.size.height - 60, 60, 60)];
        [imageView_bgMask addSubview:circleBtn];
        
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [circleBtn addGestureRecognizer:singleTouch];
        
        // 选项菜单
        if (IS_IPHONE_5) {
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              0,
                                                                              [UIScreen mainScreen].applicationFrame.size.height-206,
                                                                              320,
                                                                              206)];
        }else{
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              0,
                                                                              [UIScreen mainScreen].applicationFrame.size.height-206,
                                                                              320,
                                                                              206)];
        }
       
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
//        [imageView_rightMenu setImage:[UIImage imageNamed:@"friend/bg_contacts_more.png"]];
//        [imageView_rightMenu setBackgroundColor:[[UIColor alloc] initWithRed:19/255.0f green:64/255.0f blue:105/255.0f alpha:1]];
        imageView_rightMenu.image = [UIImage imageNamed:@"pop_bg.png"];
        
        // 搜索button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x + 10+8,
                                         imageView_rightMenu.frame.origin.y + 10+30,
                                         60,
                                         60);
        
        [button_search setImage:[UIImage imageNamed:@"saoyisao.png"] forState:UIControlStateNormal];
        [button_search setImage:[UIImage imageNamed:@"saoyisao_p.png"] forState:UIControlStateHighlighted];
        
//        [button_search setTitle:@"查找好友" forState:UIControlStateNormal];
//        [button_search setTitle:@"查找好友" forState:UIControlStateHighlighted];
//        
//        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button_search setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_search addTarget:self action:@selector(searchFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        //---- add by kate 2014.08.17
        UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(button_search.frame.origin.x, button_search.frame.origin.y+button_search.frame.size.height, button_search.frame.size.width, 21.0)];
        scanLabel.backgroundColor = [UIColor clearColor];
        scanLabel.text = @"扫一扫";
        scanLabel.textColor = [UIColor colorWithRed:156.0/225.0 green:194.0/225.0 blue:224.0/225.0 alpha:1];
        scanLabel.textAlignment = NSTextAlignmentCenter;
        //-------------------------------------
        
        // 多人发送button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x + button_search.frame.size.width+46+8,
                                            button_search.frame.origin.y,
                                            60,
                                            60);
        
//        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_drfs_d.png"]];
//        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_drfs_p.png"]];
        
        [button_multiSend setImage:[UIImage imageNamed:@"xiegushi.png"] forState:UIControlStateNormal];
        [button_multiSend setImage:[UIImage imageNamed:@"xiegushi_p.png"] forState:UIControlStateHighlighted];
        //---- add by kate 2014.08.17
        UILabel *writeStoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(button_multiSend.frame.origin.x, button_multiSend.frame.origin.y+button_multiSend.frame.size.height, button_multiSend.frame.size.width, 21.0)];
        writeStoryLabel.backgroundColor = [UIColor clearColor];
        writeStoryLabel.text = @"写故事";
        writeStoryLabel.textColor = [UIColor colorWithRed:156.0/225.0 green:194.0/225.0 blue:224.0/225.0 alpha:1];
         writeStoryLabel.textAlignment = NSTextAlignmentCenter;
        //---------------------------------------
        
//        [button_multiSend setTitle:@"多人发送" forState:UIControlStateNormal];
//        [button_multiSend setTitle:@"多人发送" forState:UIControlStateHighlighted];
//        
//        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button_multiSend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_multiSend addTarget:self action:@selector(multiSend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        // 添加朋友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_addFriend.frame = CGRectMake(
                                            320-(imageView_rightMenu.frame.origin.x + 10+8)-60.0,
                                            button_multiSend.frame.origin.y,
                                            60,
                                            60);
        
//        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_tjpy_d.png"]];
//        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_tjpy_p.png"]];
        
        [button_addFriend setImage:[UIImage imageNamed:@"cjquanzi_p.png"] forState:UIControlStateNormal];
        [button_addFriend setImage:[UIImage imageNamed:@"cjquanzi.png"] forState:UIControlStateHighlighted];
        
//        [button_addFriend setTitle:@"添加朋友" forState:UIControlStateNormal];
//        [button_addFriend setTitle:@"添加朋友" forState:UIControlStateHighlighted];
//        
//        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button_addFriend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [button_addFriend addTarget:self action:@selector(addFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        //---- add by kate 2014.08.17
        UILabel *createCircleLabel = [[UILabel alloc] initWithFrame:CGRectMake(button_addFriend.frame.origin.x, button_addFriend.frame.origin.y+button_addFriend.frame.size.height, button_addFriend.frame.size.width+20, 21.0)];
        createCircleLabel.backgroundColor = [UIColor clearColor];
        createCircleLabel.text = @"创建圈子";
        createCircleLabel.textColor = [UIColor colorWithRed:156.0/225.0 green:194.0/225.0 blue:224.0/225.0 alpha:1];
        //---------------------------------------

        
        [imageView_bgMask addSubview:imageView_rightMenu];
        [imageView_bgMask addSubview:button_search];
        [imageView_bgMask addSubview:button_multiSend];
        [imageView_bgMask addSubview:button_addFriend];
        
        //-----add by kate
        [imageView_bgMask addSubview:scanLabel];
        [imageView_bgMask addSubview:writeStoryLabel];
        [imageView_bgMask addSubview:createCircleLabel];
        //-------------------------
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [button_center setBackgroundImage:[UIImage imageNamed:@"err-on.png"] forState:UIControlStateNormal] ;
        [viewMask removeFromSuperview];
        isRightButtonClicked = false;
    }
}*/

// 去二维码扫描页
- (IBAction)searchFriend_btnclick:(id)sender
{
    [self dismissKeyboard:nil];
//    ScanViewController *scanView = [[ScanViewController alloc]init];
//    scanView.fromName = @"bottle";
//    
//     UINavigationController *tabBarControllerNavi = (UINavigationController *)self.selectedViewController;
//    
//    [tabBarControllerNavi pushViewController:scanView animated:YES];
}

// 写故事
- (IBAction)multiSend_btnclick:(id)sender
{
    [self dismissKeyboard:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chinaStory_notShowMenuButton" object:self userInfo:nil];

//    EditCustomStoryViewController *customStoryView = [[EditCustomStoryViewController alloc]init];
//    customStoryView.fromName = @"writeS";
//    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.selectedViewController;
//    
//    [tabBarControllerNavi pushViewController:customStoryView animated:YES];

}

// 创建圈子
- (IBAction)addFriend_btnclick:(id)sender
{
    [self dismissKeyboard:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"chinaStory_notShowMenuButton" object:self userInfo:nil];
    
//    CreateCircleViewController *createCircleV = [[CreateCircleViewController alloc]init];
//    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.selectedViewController;
//    
//    [tabBarControllerNavi pushViewController:createCircleV animated:YES];
    
}

-(void)dismissKeyboard:(id)sender{
    
    isRightButtonClicked = NO;
    [viewMask removeFromSuperview];
    [button_center setBackgroundImage:[UIImage imageNamed:@"err-on.png"] forState:UIControlStateNormal] ;
}

- (void)hideRealTabBar
{
	for (UIView *view in self.view.subviews) {
		if([view isKindOfClass:[UITabBar class]]) {
			view.hidden = YES;
			break;
		}
	}

}

- (void)customTabBar
{
	//创建按钮
    //self.selectedIndex = 0;
//    self.currentSelectedIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];//去掉tabbar黑边
	int viewCount = TAB_VIEW_COUNT;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = [[UIScreen mainScreen] bounds].size.width / viewCount;
	double _height = HEIGHT_TAB_BAR; //self.tabBar.frame.size.height;
	for (int index = 0; index < viewCount; index++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(index*_width, [[UIScreen mainScreen] bounds].size.height - HEIGHT_TAB_BAR, _width+0.5, _height);//iphone6/iphone6 plus直接用屏幕尺寸除以tab个数setBackImage会有空隙，不造为嘛啊。。。需要加0.5
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
		btn.tag = index + 1;
        [self setTabButtonBgImage:btn];
		[self.buttons addObject:btn];
		[self.view addSubview:btn];
	}
    
    beforeSelectedIndex = -1;
	[self selectedTab:[self.buttons objectAtIndex:self.currentSelectedIndex]];
}

//---add by kate------------------------------------------------------------
// 自定义tabTitle
-(void)setCustomTabTitle:(NSNotification*)notification{
    
    NSMutableArray *titleList  =  (NSMutableArray*)[notification object];
    
    if (titleList!=nil) {
        if ([titleList count]>0) {
            int viewCount = TAB_VIEW_COUNT;
            for (int i = 0; i < viewCount; i++) {
                
                UILabel *label = (UILabel*)[self.view viewWithTag:500+i];
                label.text = [[titleList objectAtIndex:i] objectForKey:@"name"];
                
            }
        }
    }
    
}
//-------------------------------------------------------------------------

- (void)setTabTitle
{
    NSMutableArray *titleArray = nil;
    
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"tabTitles"];
    
    if([tempArray count] > 0){
        titleArray = [[NSMutableArray alloc] initWithArray:tempArray];
    }else{
        titleArray = [NSMutableArray arrayWithObjects:@"校园", @"班级",@"乐园", nil];

    }
    
    int viewCount = TAB_VIEW_COUNT;
    self.tabLables = [NSMutableArray arrayWithCapacity:viewCount];
    double _width = [[UIScreen mainScreen] bounds].size.width / viewCount;
    for (int index = 0; index < viewCount; index++) {
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(index*_width, [[UIScreen mainScreen] bounds].size.height - HEIGHT_TAB_BAR + 35, _width, 10)];
        titleLabel.tag = 500+index;
        titleLabel.text = [titleArray objectAtIndex:index];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:10.0];
        
        if(currentSelectedIndex == 0 && index == 0){
            
            titleLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            
        }
        
        [self.tabLables addObject:titleLabel];
        [self.view addSubview:titleLabel];
        //[titleLabel release];
    }
    
}
-(void)goright{
    NSString *str;
    str =@"1";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"leftoright" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)selectedTab:(UIButton *)button
{
	if (self.currentSelectedIndex != button.tag - 1) {
        if (button) {
            self.currentSelectedIndex = button.tag - 1;
        }
        self.selectedIndex = self.currentSelectedIndex;
	}
    
    int selected = self.selectedIndex;
    if (selected > 3) {
        selected = 0;
        self.selectedIndex = 0;
    }
    if (selected != beforeSelectedIndex) {
        [self setPressButtonBgImage:selected];
    }
    UINavigationController * navigation = self.selectedViewController;
    for (UIViewController * controller  in navigation.viewControllers) {
        NSLog(@"%@",NSStringFromClass([controller class]));
        if ([controller isKindOfClass:[SchoolHomeViewController class]]) {
            SchoolHomeViewController * schollController = (SchoolHomeViewController*) controller;
            schollController.delegate = self;
//#4.1  通知wws恢复主页面位置
            strNum =@"2";
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            return;
        }
    }

    
    NSLog(@"");
}
//#end
- (void)setTabButtonBgImage:(UIButton *)button
{
    UIImage *NorImage;
    UIImage *PressImage;
    switch (button.tag) {
        case 1:
            NorImage = [UIImage imageNamed:@"bg_tabbar1_normal.png"];
            PressImage = [UIImage imageNamed:@"bg_tabbar1_press.png"];
            break;
        case 2:
            NorImage = [UIImage imageNamed:@"bg_tabbar2_normal.png"];
            PressImage = [UIImage imageNamed:@"bg_tabbar2_press.png"];
            break;
        case 3:{
            NorImage = [UIImage imageNamed:@"bg_tabbar3_normal.png"];
            PressImage = [UIImage imageNamed:@"bg_tabbar3_press.png"];
        }
            break;
        default:
            NorImage = [UIImage imageNamed:@"bg_tabbar4_normal.png"];
            PressImage = [UIImage imageNamed:@"bg_tabbar4_press.png"];
            break;
    }
//    [button setBackgroundImage:[NorImage stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateNormal];
//    [button setBackgroundImage:[PressImage stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateHighlighted];
    [button setBackgroundImage:NorImage  forState:UIControlStateNormal];
    [button setBackgroundImage:PressImage  forState:UIControlStateHighlighted];
}

- (void)setPressButtonBgImage:(int)buttonIndex
{
//    for(UIButton*btn in self.buttons){
//        [self setTabButtonBgImage:btn]; 
//    }
    if (beforeSelectedIndex < 0) {
        beforeSelectedIndex = 0;
    }
    UIImage *NorImage;
    switch (beforeSelectedIndex) {
        case 0:{
            
            UILabel *label0 = (UILabel*)[self.view viewWithTag:500];
            label0.textColor = [UIColor lightGrayColor];

            NorImage = [UIImage imageNamed:@"bg_tabbar1_normal.png"];
        
        }
            break;
        case 1:{
            
            UILabel *label1 = (UILabel*)[self.view viewWithTag:501];
            label1.textColor = [UIColor lightGrayColor];

            NorImage = [UIImage imageNamed:@"bg_tabbar2_normal.png"];
        
             }
            break;
        case 2:{
            
            UILabel *label2 = (UILabel*)[self.view viewWithTag:502];
            label2.textColor = [UIColor lightGrayColor];

            NorImage = [UIImage imageNamed:@"bg_tabbar3_normal.png"];
        }
            break;
        default:{
            
            UILabel *label3 = (UILabel*)[self.view viewWithTag:503];
            label3.textColor = [UIColor lightGrayColor];

            NorImage = [UIImage imageNamed:@"bg_tabbar4_normal.png"];
        }
            break;
    }
    UIButton *beforeButton = (UIButton *)[self.buttons objectAtIndex:beforeSelectedIndex];
//    [beforeButton setBackgroundImage:[NorImage stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal];
    [beforeButton setBackgroundImage:NorImage forState:UIControlStateNormal];
    
    UIImage *HighlightedImage;
    switch (buttonIndex) {
        case 0:{
            
            UILabel *label0 = (UILabel*)[self.view viewWithTag:500];
            label0.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            HighlightedImage = [UIImage imageNamed:@"bg_tabbar1_press.png"];
        }
            break;
        case 1:{
            
            UILabel *label1 = (UILabel*)[self.view viewWithTag:501];
            label1.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            HighlightedImage = [UIImage imageNamed:@"bg_tabbar2_press.png"];
            
           }
            break;
        case 2:{
            
            UILabel *label2 = (UILabel*)[self.view viewWithTag:502];
            label2.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            HighlightedImage = [UIImage imageNamed:@"bg_tabbar3_press.png"];
            
           }
            break;
        default:{
            
            UILabel *label3 = (UILabel*)[self.view viewWithTag:503];
            label3.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            HighlightedImage = [UIImage imageNamed:@"bg_tabbar4_press.png"];
            UINavigationController *tabBarControllerNavi = (UINavigationController *)self.selectedViewController;
            [tabBarControllerNavi popToRootViewControllerAnimated:NO];
            
           }
            break;
    }
    UIButton *selectButton = (UIButton *)[self.buttons objectAtIndex:buttonIndex];
//    [selectButton setBackgroundImage:[HighlightedImage stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:HighlightedImage forState:UIControlStateNormal];
    
    beforeSelectedIndex = buttonIndex;
}

- (void) dealloc
{
    [buttons removeAllObjects];
	//[buttons release];
    [tabLables removeAllObjects];
   // [tabLables release];
    
	//[super dealloc];
}

/* 设置tabBar是否隐藏 */
+ (void)setTabBarHidden:(BOOL)bHide
{
    int normalY = [[UIScreen mainScreen] bounds].size.height - HEIGHT_TAB_BAR;
    int normalLabelY = [[UIScreen mainScreen] bounds].size.height - HEIGHT_TAB_BAR + 35;
    
    if (bHide) {
        normalY = [[UIScreen mainScreen] bounds].size.height;
        normalLabelY = [[UIScreen mainScreen] bounds].size.height + 35;
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *subviews = appDelegate.tabBarController.view.subviews;
    
    if (!appDelegate.tabBarController) {
        NSLog(@"isNil");
    }
    
    for (int i = 0; i < [subviews count]; i++) {
        id subview = [subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *image = (UIImageView *)[subviews objectAtIndex:i];
            CGRect frame = image.frame;
            frame.origin.y = normalY;
            image.frame = frame;
        } else if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)[subviews objectAtIndex:i];
            CGRect frame = button.frame;
            frame.origin.y = normalY;
            button.frame = frame;
        } else if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)[subviews objectAtIndex:i];
            CGRect frame = label.frame;
            frame.origin.y = normalLabelY;
            label.frame = frame;
        } else if ([subview isKindOfClass:[UITabBar class]]) {
            UITabBar *tabbar = (UITabBar *)[subviews objectAtIndex:i];
            CGRect frame = tabbar.frame;
            frame.origin.y = normalY;
            tabbar.frame = frame;
        }else if ([subview isKindOfClass:[UIView class]]) {
            
            UIView *view = (UIView *)[subviews objectAtIndex:i];
                for (UIButton *button in [view subviews]) {
                    if ([button isKindOfClass:[UIButton class]]) {
                        
                        if (bHide) {
                            [button setHidden:YES];
                        }else{
                            [button setHidden:NO];
                        }
                       
                    }
                }
        }
    }
    
    [UIView commitAnimations];
}
//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
