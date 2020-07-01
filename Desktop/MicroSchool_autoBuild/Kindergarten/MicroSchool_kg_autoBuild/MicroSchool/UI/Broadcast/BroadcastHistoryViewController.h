//
//  BroadcastHistoryViewController.h
//  MicroSchool
//
//  Created by jojo on 15/1/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "MBProgressHUD+Add.h"

#import "BroadcastHistTableViewCell.h"
#import "BroadcastViewController.h"

@interface BroadcastHistoryViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate>
{
    MBProgressHUD *progressHud;

    NSString *startNum;
    NSString *endNum;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSInteger reflashFlag;

    NSMutableDictionary *dataDic;
    NSMutableArray *dataArr;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *otherSid;//其他学校的sid add by kate 2015.04.22

// 模块名字
@property (nonatomic,retain) NSString *moduleName;

@end
