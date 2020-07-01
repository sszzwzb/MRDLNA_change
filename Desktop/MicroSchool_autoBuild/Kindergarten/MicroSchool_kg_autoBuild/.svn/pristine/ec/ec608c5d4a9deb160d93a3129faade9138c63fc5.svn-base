//
//  MyClassListViewController.h
//  MicroSchool
//
//  Created by Kate on 14-9-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "networkBar.h"
#import "FileManager.h"
#import "NetworkGuideViewController.h"

@interface MyClassListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,EGORefreshTableDelegate,UIGestureRecognizerDelegate>{
    
    NSMutableArray *listArray;
    BOOL isAdmin;
    NSDictionary *newListDic;
    UIImageView *noticeImgVForMsg;
    NSString *titleName;
    CGSize winSize;
    
    NSInteger reflashFlag;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    networkBar *networkVC;
    
    //UIImageView *noDataImgV;
    UIView *noNetworkV;
    
    NSMutableArray *redImgArray;//红点数组
    NSDictionary *newsDic;//传给班级详情的最新的红点数组
    
    UIView *noDataView;
    NSString *isNewVersion;
}
@property(strong, nonatomic)UILabel *redLabel;

@property(strong, nonatomic) UIView *tipsView;
@property(strong, nonatomic) UILabel *tipsLabel;
@property(strong, nonatomic) UIButton *tipsButton;

//@property(strong, nonatomic) UIView *teacherNoClassView;

@property(strong, nonatomic) NSString *classId;
@property(strong, nonatomic) NSString *aid;

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIImageView *noRecipesView;
@end
