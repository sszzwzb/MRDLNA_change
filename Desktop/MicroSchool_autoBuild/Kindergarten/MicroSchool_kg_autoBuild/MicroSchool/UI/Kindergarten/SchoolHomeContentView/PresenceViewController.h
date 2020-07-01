//
//  PresenceViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 3/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "PresenceTableViewCell.h"
#import "NewsDetailViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface PresenceViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate>

@property(nonatomic,retain) NSString *titleName;

// 列表
@property(nonatomic,retain) NSMutableArray *dataAry;
// 后台返回数据
@property(nonatomic,retain) NSMutableDictionary *contentDic;

@property(nonatomic,retain) UITableView *tableView;

// tableView refresh view
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,retain) EGORefreshTableFooterView *refreshFooterView;

@property(nonatomic,assign) BOOL reloading;

@property(nonatomic,retain) NSString *page;
@property(nonatomic,retain) NSString *size;

@property(nonatomic,assign) NSInteger reflashFlag;
@property(nonatomic,assign) NSInteger isReflashViewType;

@property (nonatomic,strong) UIView *blankView;

@end
