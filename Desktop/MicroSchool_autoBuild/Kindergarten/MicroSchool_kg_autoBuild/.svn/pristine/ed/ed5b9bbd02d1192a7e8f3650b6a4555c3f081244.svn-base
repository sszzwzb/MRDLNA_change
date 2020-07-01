//
//  PhonebookViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "PhonebookTabBarViewController.h"
#import "FriendAddSearchViewController.h"
#import "FriendFilterViewController.h"
#import "FriendMultiSelectViewController.h"

#import "FriendViewController.h"
#import "ScanViewController.h"

#import "ContactsViewController.h"
#import "GroupChatDetailViewController.h"

@interface PhonebookViewController : BaseViewController
{
    PhonebookTabBarViewController *contactTabbar;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
    UIButton *button_addFriend;
    UIButton *button_scan;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    NSMutableArray *tagArray;
    NSString *tag;
    UISegmentedControl *segmentedControl;
    
    
}

@property (retain, nonatomic) NSString *classid;
@property (retain, nonatomic) NSString *titleName;

@end
