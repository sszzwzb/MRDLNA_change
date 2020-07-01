//
//  KnowledgeSearchViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "KnowledgeSearchTableViewCell.h"

@interface KnowledgeSearchViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,EGORefreshTableDelegate, HttpReqCallbackDelegate, UITextFieldDelegate>
{
    // 上下刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSString *startNum;
    NSString *endNum;
    NSString* cid;

    NSString* eventType;
    NSMutableArray* listDataArray;
    NSMutableArray* eidList;
    NSMutableArray* joinedList;
    NSMutableArray* subuidList;

    UITextField *textField_search;
    NSString *searchText;
}

// http请求返回结果
-(void)reciveHttpData:(NSData*)data andType:(HttpReqType)type;
-(void)reciveHttpDataError:(NSError*)err;

@end
