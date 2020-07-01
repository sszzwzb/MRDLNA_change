//
//  SchoolHomeViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"
#import "UIImageView+WebCache.h"

#import "ScrolledBanner.h"
#import "SchoolHomeTableViewCell.h"
#import "NewsViewController.h"
#import "WeeklyRecipesViewController.h"
#import "PresenceViewController.h"
#import "MyTabBarController.h"
#import "FullImageViewController.h"
#import "TSImageSelectView.h"
#import "MyClassListViewController.h"
#import "SubscribeNumListViewController.h"
#import "RecipeUploadViewController.h"
#import "WWSideslipViewController.h"

#import "RecordSightViewController.h"
#import "SightPlayerViewController.h"

//#3.20
@protocol ShowLeftOrRightView


- (void) showLeft;
- (void) showRight;

@end


@interface SchoolHomeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, ScrolledBannerDelegate, TSImageSelectViewSelectDelegate, TSImageSelectViewSelectDelegate>{
    
    //---add by kate -------------------------------
    NSDictionary *newsDic;//add by kate 2016.03.19
    BOOL isFirst;//是否是第一次  大退红点修改
    BOOL isRefresh;//检查是否是下拉刷新
    NSInteger reflashFlag;
    UIImageView *noticeImgVForMsg;//个人中心消息红点
    UIImageView *noticeImgVForMsgTab;// add by kate
    //UIImageView *iconNoticeForMsg;// 通讯录红点
    UILabel *redLabelForMsg;//通讯录红色数字
    //UIImageView *noticeImgVForMyMsg;//
    NSMutableArray *moduleFromServer;//用于获取mid 红点相关
    NSMutableArray *redImgArray;//红点数组
    //-------------------------------------------------
    NSString *isNewVersion;
}

// 菜谱列表
@property(nonatomic,retain) NSMutableArray *recipesAry;
// 后台返回数据
@property(nonatomic,retain) NSMutableDictionary *contentDic;

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UIView *tableViewHeaderView;
@property(nonatomic,retain) UIView *tableViewFooterView;

// 模块列表
@property(nonatomic,retain) NSMutableArray *moduleAry;
@property(nonatomic,retain) NSMutableArray *moduleMoreAry;

@property(nonatomic,retain) TSImageSelectView *moduleSelectView;

// 滚动banner的view
@property(nonatomic,retain) ScrolledBanner *scrolledBannerView;
// 模块列表view
@property(nonatomic,retain) UIView *modulesView;

// tableView refresh view
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,retain) EGORefreshTableFooterView *refreshFooterView;

@property(nonatomic,assign) BOOL reloading;

@property(nonatomic,retain) NSString *page;
@property(nonatomic,retain) NSString *size;

@property(nonatomic,assign) NSInteger reflashFlag;
@property(nonatomic,assign) NSInteger isReflashViewType;

//#3.20
@property (nonatomic,weak) id <ShowLeftOrRightView> delegate;
@property(nonatomic,strong)NSMutableArray *itemsArr;

@property(nonatomic,retain) UIImageView *preLoadingImageView;

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIImageView *noRecipesView;

@end
