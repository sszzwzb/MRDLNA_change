//
//  ClassDetailViewController.h
//  MicroSchool
//
//  Created by Kate on 14-12-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ClassDetailTableViewCell.h"
#import "networkBar.h"
#import "FileManager.h"
#import "NetworkGuideViewController.h"

#import "StudentsStatusListViewController.h"

@interface ClassDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate,ClassDetailTableViewCellDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    
    UIImageView *iconNoticeImgV;
    UIImageView *iconHNoticeImgV;
    UIImageView *iconDNoticeImgV;
    
    NSDictionary *listDic;
    
    NSString *joinperm;// 加入方式
    
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
    
    NSMutableArray *displayArray;
    
    CGSize winSize;
    
    NSMutableArray *newListArray;
    BOOL flag;
    
    UIImageView *noticeImgVForMsg;//班级tab红点
    
    //----add by kate----------------------------
    NSInteger reflashFlag;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
     NSString *schoolType;// 学校类型 教育局 幼儿园 其他 add 2015.05.05
    NSMutableArray *redImgArray;//红点数组
    UIImageView *imgViewNew;// 群聊新功能new标记
    NSInteger groupChatIndex;
    //--------------------------------------------
    UIImageView *imgV;//蒙版
    
    networkBar *networkVC;
    UIView *topBar;
    
    NSString *status;// 联网状态 add 2015.07.23
    
    NSMutableDictionary *redPointDic;//2015.12.18
    
    NSString *lastMsgId;
    
    NSString *lastLeaveId;// 请假lastId
    
    NSString *isNumber;// 0 或 其他 0是未绑定
    
    NSString *spaceUrl;//黄条问号的url 点我了解什么是成长空间
    
    NSInteger spaceIndex;//成长空间的index
    
    NSString *statusForSpace;//成长空间状态
    
    NSString *spaceForClass;//班级是否有学籍
    
    NSString *unbindIntroduceUrl;//老师身份班级未绑定学籍介绍页url
    

}
@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *cId;// 班级id
@property (assign, nonatomic) BOOL isAdmin;
@property (nonatomic,strong) NSString *fromName;
@property (nonatomic,strong)NSDictionary *newsDic;//2015.11.13
@property (nonatomic,strong)NSDictionary *dicToDetail;//老师身份传过来的最新的红点数组

// 蒙版页面
@property (nonatomic, retain) UIView *viewMasking;

@end
