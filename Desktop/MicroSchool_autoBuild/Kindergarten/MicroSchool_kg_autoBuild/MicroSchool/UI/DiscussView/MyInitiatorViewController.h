//
//  MyInitiatorViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-13.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "UIImageView+WebCache.h"

#import "MyTableViewCell.h"
#import "DiscussDetailViewController.h"

@interface MyInitiatorViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSMutableArray* initiatorArray;
    NSMutableArray* tidList;

    NSString *startNum;
    NSString *endNum;
    
    NSInteger isReflashViewType;
    
    UIView *noDataView;
    
}
@property(nonatomic,retain)NSString *nextPageTitle;
@end
