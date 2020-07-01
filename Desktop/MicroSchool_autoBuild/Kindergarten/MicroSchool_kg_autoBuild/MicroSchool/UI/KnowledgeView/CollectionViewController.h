//
//  CollectionViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "NetworkUtility.h"
#import "GlobalSingletonUserInfo.h"
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "CollectionTableViewCell.h"

@interface CollectionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    
    // 网络请求
    NetworkUtility *network;

    // 上下刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSString *startNum;
    NSString *endNum;
    NSString* uid;
    
    NSString* eventType;
    NSMutableArray* listDataArray;
    NSMutableArray* eidList;
    NSMutableArray* joinedList;
    
    UIView *noDataView;
}

// http请求返回结果
-(void)reciveHttpData:(NSData*)data andType:(HttpReqType)type;
-(void)reciveHttpDataError:(NSError*)err;

@end
