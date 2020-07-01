//
//  ClassMainViewNewViewController.h
//  MicroSchool
//
//  Created by Kate on 14-11-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingletonUserInfo.h"
#import "LoadingMask.h"
#import "NetworkUtility.h"
#import "BaseViewController.h"

#import "FriendViewController.h"
#import "PhonebookViewController.h"
#import "MBProgressHUD+Add.h"

@interface ClassMainViewNewViewController : BaseViewController{
    
    UIImageView *iconNoticeImgV;
    UIImageView *iconHNoticeImgV;
    UIImageView *iconDNoticeImgV;
    
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
    
    NSArray *displayArray;
    
    CGSize winSize;
    
}

@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *cId;// 班级id
@property (assign, nonatomic) BOOL isAdmin;

@end
