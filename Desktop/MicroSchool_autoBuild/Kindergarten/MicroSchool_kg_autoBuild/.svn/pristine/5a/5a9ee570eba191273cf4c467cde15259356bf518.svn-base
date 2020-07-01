//
//  ClassMainViewController.h
//  MicroSchool
//
//  Created by kate on 3/11/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingletonUserInfo.h"
#import "NetworkUtility.h"
#import "BaseViewController.h"

#import "FriendViewController.h"
#import "PhonebookViewController.h"
#import "MBProgressHUD+Add.h"

@interface ClassMainViewController : BaseViewController{
    
    //GlobalSingletonUserInfo* g_userInfo;
    //LoadingMask *mask;
    //UIView * maskView;
    //NetworkUtility *network;
    UIImageView *iconNoticeImgV;
    UIImageView *iconHNoticeImgV;
    
    NSDictionary *listDic;
    
    NSString *joinperm;// 加入方式
    MBProgressHUD *HUD;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
    UIButton *button_setAdmin;
    UIButton *button_addFriend;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;

}

@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *cId;// 班级id
@property (assign, nonatomic) BOOL isAdmin;
@end
