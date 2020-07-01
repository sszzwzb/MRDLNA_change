//
//  ContactViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PhonebookViewController.h"
#import "MsgListViewController.h"
#import "DepartmentListViewController.h"
#import "MsgListMixViewController.h"
#import "MsgDetailsMixViewController.h"

@interface PhonebookViewController ()

@end

@implementation PhonebookViewController

@synthesize classid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isRightButtonClicked = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[super setCustomizeTitle:_titleName];//测试代码
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactsGoToGroupChatDetail:)
                                                 name:@"contactsGoToGroupChatDetail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToFriendCommonView:) name:@"Weixiao_changeToFriendCommonView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMsgDetailView:) name:@"Weixiao_goToMsgDetailView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMsgDetailsMixView:) name:@"Weixiao_goToMsgDetailsMixView" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMsgDetailsMixViewFromContact:) name:@"Weixiao_goToMsgDetailMixView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToMyClassView:) name:@"Weixiao_changeToMyClassView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromFriendView2ProfileView" object:nil];
    
    //---kate 2016.01.14--------------------------------------------------------------------------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRightBarItem:) name:@"setRightBarItem" object:nil];
    
    // 导航栏上加segment
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"聊天",@"通讯录",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.frame = CGRectMake(0.0, 0.0, 100, 30.0);
    //[segmentedControl sizeToFit];
    // to do:弄成完全的圆角 边缘线就会缺一块 why
    segmentedControl.layer.cornerRadius = CGRectGetHeight(segmentedControl.frame) / 2.0f;
    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //[segmentedControl sizeToFit];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    
    [segmentedControl addTarget:self  action:@selector(changeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    //方法1
    //[self.navigationController.navigationBar.topItem setTitleView:segmentedControl];
    //方法2
    [self.navigationItem setTitleView:segmentedControl];
    
    tagArray = [[NSMutableArray alloc] initWithObjects:@"发起群聊",@"聊天管理", nil];
    //---------------------------------------------------------------------------------------------
    
}

-(void)changeForSegmentedControl:(UISegmentedControl *)Seg{
    
    [self dismissKeyboard:nil];
    
    if (Seg.selectedSegmentIndex == 1) {
        
        [tagArray removeAllObjects];
        [tagArray addObject:@"发起群聊"];
        
        MsgListViewController *msgLVC = [contactTabbar.viewControllers objectAtIndex:0];
        
        if (msgLVC.chatsListTableView.editing) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDeleteMsg" object:nil];
            [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
            
        }
        
    }else{
        [tagArray removeAllObjects];
        [tagArray addObject:@"发起群聊"];
        [tagArray addObject:@"聊天管理"];
        
    }
    
    contactTabbar.selectedIndex = Seg.selectedSegmentIndex;
    
}

// 设置右上角
-(void)setRightBarItem:(NSNotification*)notify{
    NSDictionary *dicInfo = [notify userInfo];
    
    if ([@"noChatListLeft"  isEqual: [dicInfo objectForKey:@"info"]]) {
        [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
    }else {
        MsgListViewController *msgLVC = [contactTabbar.viewControllers objectAtIndex:0];
        
        if (msgLVC.chatsListTableView.editing) {
            [self setCustomizeRightButtonWithName:@"完成"];
        }else{
            [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
            
        }
    }
    
    
}

-(void)doGoToProfileView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
}

-(void)changeToFriendCommonView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    FriendCommonViewController *friendCommonViewCtrl = [[FriendCommonViewController alloc] initWithVar:(FriendViewType)([NSString stringWithFormat:@"%@", [dic objectForKey:@"row"]].integerValue)];
    friendCommonViewCtrl.classid = [dic objectForKey:@"classid"];
    [self.navigationController pushViewController:friendCommonViewCtrl animated:YES];
    
}

-(void)changeToMyClassView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    //---update by kate 2015.05.05--------------------------------------------------------------
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    //schoolType = @"bureau";//测试代码
    
    if ([@"bureau" isEqualToString:schoolType]) {//教育局
        
        //1. 本单位进入直接是成员列表（原型）；
        //2. 下属单位进入是各个学校列表，再进入是成员列表 ，成员后缀和本单位的成员一样 。
        if ([[dic objectForKey:@"row"] integerValue] == 0) {
            
            DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
            
            departV.fromName = @"department";
            
            //        if ([[dic objectForKey:@"row"] integerValue] == 0) {
            //            departV.fromName = @"subdepart";
            //        }
            [self.navigationController pushViewController:departV animated:YES];
            
            //----------------
            //            FriendCommonViewController *friendCommonViewCtrl = [[FriendCommonViewController alloc] init];
            //            friendCommonViewCtrl.titleName = @"本单位";
            //            friendCommonViewCtrl.fromTitle = @"本单位";
            //            friendCommonViewCtrl.classid = @"0";
            //            [self.navigationController pushViewController:friendCommonViewCtrl animated:YES];
            //------------------
            
        }else{
            // 去科室列表
            DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
            if ([[dic objectForKey:@"row"] integerValue] == 0) {//update by kate 2015.06.18又改回去...
                departV.fromName = @"department";
            }else{
                departV.fromName = @"subdepart";
            }
            
            //        if ([[dic objectForKey:@"row"] integerValue] == 0) {
            //            departV.fromName = @"subdepart";
            //        }
            [self.navigationController pushViewController:departV animated:YES];
        }
        
        
    }else{
        MyClassViewController *myClassViewCtrl = [[MyClassViewController alloc] init];
        myClassViewCtrl.toViewName = [dic objectForKey:@"toViewName"];
        myClassViewCtrl.rowNum = [NSString stringWithFormat:@"%@", [dic objectForKey:@"row"]];
        [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        myClassViewCtrl.title = @"我的班级";
    }
    
    //-------------------------------------------------------------------------------------------
    
    
}

-(void)gotoMsgDetailView:(NSNotification *)notification
{
    
    NSDictionary *dic = [notification userInfo];
    MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
    chatDeatilController.user = [dic objectForKey:@"user"];
    chatDeatilController.frontName = [dic objectForKey:@"frontName"];
    [chatDeatilController getChatDetailData];
    [self.navigationController pushViewController:chatDeatilController animated:YES];
    
    
}

-(void)goToMsgDetailsMixView:(NSNotification *)notification{
    
    NSDictionary *dic = [notification userInfo];
    UserObject *chatUser = [dic objectForKey:@"user"];
    if (!chatUser) {
        chatUser = [[UserObject alloc] init];
        chatUser.user_id = 0;
    }
    MixChatListObject *chatListObject = [dic objectForKey:@"mixChatListObject"];
    MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
    chatDeatilController.gid = chatListObject.gid;
    chatDeatilController.titleName = chatListObject.title;
    chatDeatilController.groupChatList = chatListObject;
    chatDeatilController.user  = chatUser;
    if (chatListObject.last_msg_type == 4 || chatListObject.last_msg_type == 5) {
        
        if (chatListObject.user_id == [[Utilities getUniqueUidWithoutQuit] longLongValue]) {
            chatDeatilController.isViewGroupMember = 0;
        }else{
            chatDeatilController.isViewGroupMember = 1;
        }
        
    }else{
        chatDeatilController.isViewGroupMember = 1;
    }
    [self.navigationController pushViewController:chatDeatilController animated:YES];
    [UIView setAnimationsEnabled:YES];

}

-(void)goToMsgDetailsMixViewFromContact:(NSNotification *)notification{
    
    NSDictionary *dic = [notification userInfo];
    UserObject *chatUser = [dic objectForKey:@"user"];
    if (!chatUser) {
        chatUser = [[UserObject alloc] init];
        chatUser.user_id = 0;
    }
    MixChatListObject *chatListObject = [dic objectForKey:@"mixChatListObject"];
    MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
    if (chatListObject) {
        chatDeatilController.gid = chatListObject.gid;
        chatDeatilController.titleName = chatListObject.title;
        chatDeatilController.groupChatList = chatListObject;
    }else{
        chatDeatilController.gid = 0;
        if (chatUser.schoolID > 0) {
            chatDeatilController.sid = [NSString stringWithFormat:@"%lld", chatUser.schoolID];
        }
        chatDeatilController.titleName = chatUser.name;
    }
    chatDeatilController.user  = chatUser;
    //    NSString *userNumber = [dic objectForKey:@"userNumber"];
    //    if (userNumber) {
    //        chatDeatilController.userNumber = userNumber;
    //    }
    
    if (chatListObject.last_msg_type == 4 || chatListObject.last_msg_type == 5) {
        
        if (chatListObject.user_id == [[Utilities getUniqueUidWithoutQuit] longLongValue]) {
            chatDeatilController.isViewGroupMember = 0;
        }else{
            chatDeatilController.isViewGroupMember = 1;
        }
        
    }else{
        chatDeatilController.isViewGroupMember = 1;
    }
    [self.navigationController pushViewController:chatDeatilController animated:YES];
    
    [UIView setAnimationsEnabled:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    self.navigationController.navigationBarHidden = NO;
    
    // 导航右菜单，更多
    //[super setCustomizeRightButton:@"friend/icon_contacts_more.png"];
    
    [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
    
    [viewMask removeFromSuperview];
    
    [MyTabBarController setTabBarHidden:YES];
}


-(void)selectLeftAction:(id)sender
{
    [UIView setAnimationsEnabled:YES];

    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    // 退回到上个画面
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

/*
 -(void)selectRightAction:(id)sender
 {
 if (!isRightButtonClicked) {
 viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height)];
 
 imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-44)];
 [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
 imageView_bgMask.userInteractionEnabled = YES;
 UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
 [imageView_bgMask addGestureRecognizer:singleTouch];
 
 // 选项菜单
 imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
 [UIScreen mainScreen].applicationFrame.size.width - 128 - 10 -10,
 5,
 140,
 122 + 45
 )];
 imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
 [imageView_rightMenu setImage:[UIImage imageNamed:@"friend/bg_contacts_more.png"]];
 //[self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
 
 // 搜索button
 button_search = [UIButton buttonWithType:UIButtonTypeCustom];
 button_search.frame = CGRectMake(
 imageView_rightMenu.frame.origin.x + 10,
 imageView_rightMenu.frame.origin.y + 15,
 108,
 32);
 
 UIImage *buttonImg_d;
 UIImage *buttonImg_p;
 
 //        CGSize tagSize = CGSizeMake(20, 20);
 //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_czhy_d.png"]];
 //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_czhy_p.png"]];
 
 buttonImg_d = [UIImage imageNamed:@"friend/icon_czhy_d_"];
 buttonImg_p = [UIImage imageNamed:@"friend/icon_czhy_p_"];
 
 [button_search setImage:buttonImg_d forState:UIControlStateNormal];
 [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
 
 [button_search setTitle:@"查找好友" forState:UIControlStateNormal];
 [button_search setTitle:@"查找好友" forState:UIControlStateHighlighted];
 
 button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
 [button_search setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
 [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [button_search setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
 button_search.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
 
 [button_search addTarget:self action:@selector(searchFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
 
 // 多人发送button
 button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
 button_multiSend.frame = CGRectMake(
 button_search.frame.origin.x,
 button_search.frame.origin.y + button_search.frame.size.height + 5,
 108,
 32);
 
 //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_drfs_d.png"]];
 //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_drfs_p.png"]];
 
 buttonImg_d = [UIImage imageNamed:@"friend/icon_drfs_d_"];
 buttonImg_p = [UIImage imageNamed:@"friend/icon_drfs_p_"];
 
 [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
 [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
 
 [button_multiSend setTitle:@"多人发送" forState:UIControlStateNormal];
 [button_multiSend setTitle:@"多人发送" forState:UIControlStateHighlighted];
 
 button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
 [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
 [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [button_multiSend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
 button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
 
 [button_multiSend addTarget:self action:@selector(multiSend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
 
 // 添加朋友button
 button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
 button_addFriend.frame = CGRectMake(
 button_multiSend.frame.origin.x,
 button_multiSend.frame.origin.y + button_multiSend.frame.size.height + 5,
 108,
 32);
 
 //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_tjpy_d.png"]];
 //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_tjpy_p.png"]];
 
 buttonImg_d = [UIImage imageNamed:@"friend/icon_tjpy_d_"];
 buttonImg_p = [UIImage imageNamed:@"friend/icon_tjpy_p_"];
 
 [button_addFriend setImage:buttonImg_d forState:UIControlStateNormal];
 [button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted];
 
 [button_addFriend setTitle:@"添加朋友" forState:UIControlStateNormal];
 [button_addFriend setTitle:@"添加朋友" forState:UIControlStateHighlighted];
 
 button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
 [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
 [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [button_addFriend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
 button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
 
 [button_addFriend addTarget:self action:@selector(addFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
 
 
 button_scan = [UIButton buttonWithType:UIButtonTypeCustom];
 button_scan.frame = CGRectMake(
 button_addFriend.frame.origin.x,
 button_addFriend.frame.origin.y + button_addFriend.frame.size.height + 5,
 108,
 32);
 
 //        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_wdewm_"]];
 //        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"icon_wdewm_"]];
 
 buttonImg_d = [UIImage imageNamed:@"friend/icon_sys_d_"];
 buttonImg_p = [UIImage imageNamed:@"friend/icon_sys_p_"];
 
 [button_scan setImage:buttonImg_d forState:UIControlStateNormal];
 [button_scan setImage:buttonImg_p forState:UIControlStateHighlighted];
 
 [button_scan setTitle:@"扫一扫   " forState:UIControlStateNormal];
 [button_scan setTitle:@"扫一扫   " forState:UIControlStateHighlighted];
 
 //        button_scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
 
 //        button_scan.titleLabel.textAlignment = NSTextAlignmentLeft;
 [button_scan setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
 [button_scan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [button_scan setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
 button_scan.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
 
 [button_scan addTarget:self action:@selector(scan_btnclick:) forControlEvents: UIControlEventTouchUpInside];
 
 [imageView_bgMask addSubview:imageView_rightMenu];
 [imageView_bgMask addSubview:button_search];
 [imageView_bgMask addSubview:button_multiSend];
 [imageView_bgMask addSubview:button_addFriend];
 [imageView_bgMask addSubview:button_scan];
 
 [viewMask addSubview:imageView_bgMask];
 
 [self.view addSubview:viewMask];
 
 isRightButtonClicked = true;
 } else {
 
 [viewMask removeFromSuperview];
 
 isRightButtonClicked = false;
 
 }
 }*/

// 2016.01.15
-(void)selectRightAction:(id)sender{
    
    [UIView setAnimationsEnabled:YES];

    MsgListViewController *msgLVC = [contactTabbar.viewControllers objectAtIndex:0];
    if (msgLVC.chatsListTableView.editing) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDeleteMsg" object:nil];
        
        [self setRightBarItem:nil];
        
    }else{
        
        if (!isRightButtonClicked) {
            
            viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
            
            imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
            [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
            imageView_bgMask.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
            [imageView_bgMask addGestureRecognizer:singleTouch];
            
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]init];
            imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
            //UIImage *bgViewRcv = [UIImage imageNamed:@"popViewSingle.png"];//to do:
            UIImage *bgViewRcv = [UIImage imageNamed:@"ClassKin/bg_contacts_more.png"];
            //[imageView_rightMenu setImage:bgViewRcv];
            imageView_rightMenu.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(20.0,5.2, 5.2, 5.2)];
            //imageView_rightMenu.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
            
            imageView_rightMenu.frame = CGRectMake(
                                                   [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                   5,
                                                   128,
                                                   35.0*[tagArray count]+10);
            
            [imageView_bgMask addSubview:imageView_rightMenu];
            
            for (int i=0; i<[tagArray count]; i++) {
                
                NSString *tagName = [tagArray objectAtIndex:i];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 400+i;
                button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+9+35.0*i, 128.0, 35.0);
                [button setTitle:tagName forState:UIControlStateNormal];
                [button setTitle:tagName forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                
                [button addTarget:self action:@selector(selectTag:) forControlEvents: UIControlEventTouchUpInside];
                
                UIImageView *lineV = [[UIImageView alloc] init];
                lineV.image = [UIImage imageNamed:@"ClassKin/bg_contacts_line.png"];
                lineV.frame = CGRectMake(10, button.frame.size.height-1, button.frame.size.width-20, 1);
                if (i<[tagArray count]-1) {
                    [button addSubview:lineV];
                }
                
                
                [imageView_bgMask addSubview:button];
                
            }
            
            
            [viewMask addSubview:imageView_bgMask];
            
            [self.view addSubview:viewMask];
            
            isRightButtonClicked = true;
            
            
        }else{
            
            [viewMask removeFromSuperview];
            
            isRightButtonClicked = false;
            
        }
    }
    
}

-(void)selectTag:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    tag = [NSString stringWithFormat:@"%ld",button.tag - 400];
    
    [self dismissKeyboard:nil];
    
    if ([tag integerValue] == 1) {
        //聊天管理/删除消息 通知MsgListViewController
        
        //        MsgListViewController *msgList = [contactTabbar.viewControllers objectAtIndex:0];
        //        [msgList clickDeleteMsg];
        //clickDeleteMsg
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDeleteMsg" object:nil];
        
        
    }else{
        // 发起群聊入口 to beck
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickCreateGroupChat" object:nil];
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];
        
        if([@"7"  isEqual: role_id] || [@"9"  isEqual: role_id]) {
            if ([@"1"  isEqual: role_checked]) {
                
                ContactsViewController *vc = [[ContactsViewController alloc] init];
                vc.viewType = @"chatMemberSelect";
                //        [self.navigationController pushViewController:vc animated:YES];
                
                SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if ([@"2"  isEqual: role_checked]) {
                [Utilities showTextHud:@"您还未获得教师身份，请递交申请." descView:self.view];
            }else if ([@"0"  isEqual: role_checked]) {
                [Utilities showTextHud:@"请耐心等待审批." descView:self.view];
            }
        }else{
            
            ContactsViewController *vc = [[ContactsViewController alloc] init];
            vc.viewType = @"chatMemberSelect";
            //        [self.navigationController pushViewController:vc animated:YES];
            
            SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        
    }
    
}


- (IBAction)scan_btnclick:(id)sender
{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.viewType = @"scanView";
    [self.navigationController pushViewController:scan animated:YES];
}

- (IBAction)searchFriend_btnclick:(id)sender
{
    FriendFilterViewController *friendFilterViewCtrl = [[FriendFilterViewController alloc] init];
    friendFilterViewCtrl.classid = classid;
    [self.navigationController pushViewController:friendFilterViewCtrl animated:YES];
}

- (IBAction)multiSend_btnclick:(id)sender
{
    FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
    friendSelectViewCtrl.classid = classid;
    friendSelectViewCtrl.friendType = @"friend";
    friendSelectViewCtrl.fromName = @"firstPage";
    [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
}

- (IBAction)addFriend_btnclick:(id)sender
{
    FriendAddSearchViewController *friendSearchViewCtrl = [[FriendAddSearchViewController alloc] init];
    [self.navigationController pushViewController:friendSearchViewCtrl animated:YES];
}

-(void)dismissKeyboard:(id)sender{
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-29)];
    self.view.backgroundColor = [UIColor redColor];
    
    contactTabbar = [[PhonebookTabBarViewController alloc]init];
    contactTabbar.view.backgroundColor = [UIColor greenColor];
    
    ContactsViewController *friendView = [[ContactsViewController alloc] init];
    friendView.viewType = @"contactsList";
    //    friendView.classid = classid;
    
    //MsgListViewController *msgList  = [[MsgListViewController alloc]init];
    
    MsgListMixViewController *msgList = [[MsgListMixViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:msgList,
                                friendView,
                                nil];//update by kate 2015.03.02
    
    [contactTabbar setViewControllers:viewControllers];
    
    [self.view addSubview:contactTabbar.view];
}

// 去群聊详细页
-(void)contactsGoToGroupChatDetail:(NSNotification*)notification{
    
    // To do:生成群成功接收消息走此方法 刷新群聊列表 跳转至聊天详细页
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
    //[self getChatListData];// 获取最新群聊列表数据显示
    
    MixChatListObject *groupChatList = (MixChatListObject*)[notification object];
    //    _cid = [NSString stringWithFormat:@"%lli",groupChatList.cid];
    
    MsgDetailsMixViewController *groupDetailV = [[MsgDetailsMixViewController alloc]init];
    groupDetailV.fromName = @"createGroup";
    groupDetailV.titleName = groupChatList.title;
    groupDetailV.gid = groupChatList.gid;
    groupDetailV.cid = groupChatList.cid;
    groupDetailV.isViewGroupMember = 1;
    groupDetailV.groupChatList = groupChatList;
    [self.navigationController pushViewController:groupDetailV animated:YES];
    segmentedControl.selectedSegmentIndex = 0;
    contactTabbar.selectedIndex = 0;//为了从详情页返回的时候到聊天记录列表页
    
}

//// add 2015.05.04
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
//
// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
