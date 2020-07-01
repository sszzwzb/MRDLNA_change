//
//  HealthHistoryViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 15/12/2.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "PhysicalRecordTableViewCell.h"
#import "TestReportTableViewCell.h"
#import "TestReportDetailViewController.h"
#import "HealthDetailViewController.h"

// 用于已读未读
#import "ReadStatusObject.h"
#import "ReadStatusDBDao.h"


@interface HealthHistoryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate>

// conditions 身体记录
// scores 评测记录
// studentConditions 教师查看学生的成长空间的身体记录
// studentScores 教师查看学生的成长空间的评测记录
@property(nonatomic,retain) NSString *viewType;
@property(nonatomic,retain) NSString *titleName;

@property(nonatomic,retain) NSString *cid;
@property(nonatomic,retain) NSString *number;

@property(nonatomic,retain) UITableView *tableView;

// tableView refresh view
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,retain) EGORefreshTableFooterView *refreshFooterView;

@property(nonatomic,assign) BOOL reloading;

@property(nonatomic,retain) NSString *page;
@property(nonatomic,retain) NSString *size;

@property(nonatomic,assign) NSInteger reflashFlag;
@property(nonatomic,assign) NSInteger isReflashViewType;

@property(nonatomic,retain) NSMutableArray* dataArr;

@property(nonatomic,retain) UIView *noDataView;

@end
