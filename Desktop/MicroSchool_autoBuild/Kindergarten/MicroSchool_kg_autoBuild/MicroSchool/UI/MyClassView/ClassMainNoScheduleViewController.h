//
//  ClassMainNoScheduleViewController.h
//  MicroSchool
//
//  Created by kate on 6/19/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingletonUserInfo.h"
#import "NetworkUtility.h"
#import "BaseViewController.h"
#import "PhonebookViewController.h"
#import "MBProgressHUD+Add.h"

@interface ClassMainNoScheduleViewController : BaseViewController{
    
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
    UIButton *button_addFriend;
    UIButton *button_setAdmin;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
}

@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *cId;// 班级id
@property (assign, nonatomic) BOOL isAdmin;
@end
