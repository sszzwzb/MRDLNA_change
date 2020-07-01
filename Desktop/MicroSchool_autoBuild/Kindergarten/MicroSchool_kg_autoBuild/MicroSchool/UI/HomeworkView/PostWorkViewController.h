//
//  PostWorkViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkTableViewCell.h"
#import "BaseViewController.h"
#import "Utilities.h"
#import "NetworkUtility.h"
#import "GlobalSingletonUserInfo.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface PostWorkViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSString *startNum;
    NSString *endNum;
    
    NSMutableArray* homeworkArray;
    NSMutableArray* tidList;
    NSMutableArray *homworkTimeList;
    
    NetworkUtility *network;
    NSString *cid;
    NSInteger isReflashViewType;
    
    UIView *noDataView;

}


@end
