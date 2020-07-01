//
//  StudentsStatusListViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 15/12/14.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "StudentGrowthSpaceViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface StudentsStatusListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate>{
    
    UIView *noDataView;//add by kate 2016.03.07

}

@property(nonatomic,retain) NSString *viewType;
@property(nonatomic,retain) NSString *titleName;

@property(nonatomic,retain) NSString *cid;

@property(nonatomic,retain) NSMutableArray* dataArr;

@property(nonatomic,retain) UITableView *tableView;

// tableView refresh view
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,retain) EGORefreshTableFooterView *refreshFooterView;

@property(nonatomic,assign) BOOL reloading;

@property(nonatomic,retain) NSString *page;
@property(nonatomic,retain) NSString *size;

@property(nonatomic,assign) NSInteger reflashFlag;
@property(nonatomic,assign) NSInteger isReflashViewType;


@end
