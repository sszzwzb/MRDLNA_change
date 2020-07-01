//
//  FriendProfileViewController.h
//  MicroSchool
//
//  Created by jojo on 14/10/23.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkUtility.h"
#import "NameAndImgTableViewCell.h"
#import "MsgDetailsViewController.h"
#import "FriendAddReqViewController.h"
#import "DBDao.h"
#import "MyTabBarController.h"

//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "NetworkUtility.h"

#import "SubUINavigationController.h"

#import "FriendProfileTableViewCell.h"

@interface FriendProfileViewController :BaseViewController <HttpReqCallbackDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView *_scrollerView;
    UITableView *_tableView;
    
    UIButton *btn_thumb;
    UIImageView *imgView_head;
    UILabel *label_name;
    UIImageView *imgView_gender;
    UIButton *btn_click;
    UILabel *label_sign;
    
    NSMutableDictionary *infoDic;
    NSMutableArray* profileIinfoArray;
    NSMutableArray* childrenArray;
    
    NSString *btnName;
    
    BOOL isBinded;
    
    int tableHeaderViewHeight;
    UIView *headerView;
    
    UIView *cellLineV;
    
    UIButton *_btn_name;
    UIButton *delBtn;
    
//    NetworkUtility *network;
//    GlobalSingletonUserInfo* g_userInfo;

    // 是否变更了隐藏师生圈的状态
    BOOL _changeCircleHiddenStatus;
    BOOL _circleHiddenStatus;

}

@property (retain, nonatomic) NSString *fuid;
@property (retain, nonatomic) NSString *fsid;

@property (retain, nonatomic) NSString *fromName;
@property (retain,nonatomic) NSString *code;
@property (retain, nonatomic) NSDictionary *infoDic;

// 渐进的navigation
@property(nonatomic, retain) UIView *alphaView;

// 个人信息页面属性
@property(nonatomic,strong) NSMutableArray *itemsArr;

// 个性签名等的高度
@property(nonatomic,assign) NSInteger spacenoteHeight;
@property(nonatomic,assign) NSInteger parentHeight;

//
@property(nonatomic, retain) UIButton *btn_addFriendAndSendMsg;
@property(nonatomic, retain) UIButton *btn_deleteFriend;

@property(nonatomic, retain) UIImageView *imgView_default;

@end
