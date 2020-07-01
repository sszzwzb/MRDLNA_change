//
//  ClassMainViewController2.h
//  MicroSchool
//
//  Created by kate on 6/3/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingletonUserInfo.h"
#import "NetworkUtility.h"
#import "BaseViewController.h"
#import "PhonebookViewController.h"

@interface ClassMainViewController2 : BaseViewController<UIAlertViewDelegate>{
    
    UIImageView *iconNoticeImgV;
    UIImageView *iconHNoticeImgV;
    
    NSDictionary *listDic;
    
    NSString *joinperm;// 加入方式
    
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
    
    NSMutableArray *displayArray;
    
    NSString *schoolType;// 学校类型 教育局 幼儿园 其他 add 2015.05.05
    
    NSString *resultCid;// 用于判断是否刷新班级 非0就刷新
}

@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *cId;// 班级id
@property (retain, nonatomic) NSString *joined;

// 是否是在审核中的状态，如果是，则隐藏加入按钮。
@property (retain, nonatomic) NSString *applied;

@property (retain, nonatomic) NSString *fromName;
@property (assign, nonatomic) BOOL isAdmin;

@end
