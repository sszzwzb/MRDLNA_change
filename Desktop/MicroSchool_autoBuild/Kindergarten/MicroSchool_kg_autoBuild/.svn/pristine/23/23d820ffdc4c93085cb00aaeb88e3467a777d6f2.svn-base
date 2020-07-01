//
//  AllEventViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-25.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventTableViewCell.h"
#import "Utilities.h"
#import "NetworkUtility.h"
#import "GlobalSingletonUserInfo.h"
#import "SchoolEventDetailViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface AllEventViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSString *startNum;
    NSString *endNum;
    NSString* uid;
    
    NSMutableArray* eventArray;
    NSString* eventType;
    NSMutableArray* eidList;
    NSMutableArray* joinedList;
    
    NetworkUtility *network;
    
    UIView *noDataView;
}
@property(nonatomic,retain)NSString* titleName;

// http请求返回结果
-(void)reciveHttpData:(NSData*)data andType:(HttpReqType)type;
-(void)reciveHttpDataError:(NSError*)err;

@end


