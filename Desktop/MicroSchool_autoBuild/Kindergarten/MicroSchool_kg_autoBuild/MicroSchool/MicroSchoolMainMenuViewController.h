//
//  MicroSchoolMainMenuViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-6.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BaseViewController.h"

#import "SettingViewController.h"
#import "NewsViewController.h"
#import "SchoolEventViewController.h"
#import "DiscussViewController.h"
#import "HomeworkViewController.h"
#import "SetPersonalTeacherViewController.h"
#import "MyClassViewController.h"
#import "ScheduleDetailViewController.h"
#import "KnowledgeViewController.h"
#import "EduinspectorViewController.h"
#import "SchoolExhibitionViewController.h"
#import "MomentsViewController.h"
#import "BroadcastViewController.h"
#import "NewsDetailViewController.h"
#import "CCTVListViewController.h"

#import "ClassMainViewController2.h"

#import "PlayVedioViewController.h"

#import "MicroSchoolMainMenuTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "MyTabBarController.h"// add by kate 2014.12.26

#import "TestApiTSNetworkingViewController.h"
#import "GroupChatSettingViewController.h"
#import "networkBar.h"

#import "HomeworkDetailViewController.h"

@interface MicroSchoolMainMenuViewController : BaseViewController <UIScrollViewDelegate, HttpReqCallbackDelegate, UITableViewDelegate, UITableViewDataSource,EGORefreshTableDelegate,UIGestureRecognizerDelegate>
{
   // UIScrollView* _scrollerView;
    
    UILabel *label_name;
    UILabel *label_sign;

    UIButton *label_sign_mask;
    UIButton *label_class;
    
    UIImageView *imgView_gender;
    UIImageView *imgView;

    UIButton *button_req;
    
    NSString *reason;
    
    UIImageView *iconNoticeImgV;//校园公告
    UIImageView *noticeImgVForMsg;//个人中心消息红点 add by kate 2014.12.03
    UIImageView *noticeImgVForMsgTab;// add by kate 2015.11.19
    UIImageView *iconNoticeForMsg;// 通讯录红点
    UILabel *redLabelForMsg;
    UIImageView *noticeImgVForMyMsg;// add by kate 2016.2.22

    
    UITableView *_tableView;
    NSArray *_tableData;
    
    NSMutableDictionary *user_info;
    NSMutableArray *customizeModuleList;
    
    NSInteger classType; // 0 只有课程表 1 只有作业 2 课程表作业都有 3 课程表作业都没有
    
    NSString *updateUrl;
    
    NSString *countNew;//add by kate 2014.12.03
    
    //----add by kate------------------------------
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    UILabel *refreshMsglabel;
    
    int totalCount;//红点总数 add by kate 2015.01.28
    //----------------------------------------------
    
    NSString *schoolType;// 学校类型 教育局 其他 add 2015.05.05
    
    UIImageView *imgV;// 2015.05.22
    
    UIView *viewMasking;
    
    networkBar *networkVC;
    
    UIImageView *videoNewImg;//new 标记 视频监控 2015.09.10
    
    NSDictionary *newsDic;//2015.11.12
    
    BOOL isRefresh;//检查是否是下拉刷新
    
    BOOL isFirst;//是否是第一次 //2015.12.28 大退红点修改
    
    NSString *lastMsgId;//动态消息id
    
    NSString *lastSubscribeId;//校园导读id 2016.02.19
    
    UILabel *redLabForMyMsg;//右上角我的消息数量
    
}


@end
