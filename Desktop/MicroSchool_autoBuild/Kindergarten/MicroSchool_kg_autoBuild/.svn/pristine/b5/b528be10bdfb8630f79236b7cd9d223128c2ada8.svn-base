//
//  MessageCenterViewController.h
//  MicroSchool
//
//  Created by jojo on 14/11/10.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "MsgCenterTableViewCell.h"
#import "ActCmdOpenViewController.h"
#import "AnswerQuestionViewController.h"
#import "EduQuesDetailViewController.h"
#import "SingleWebViewController.h"
#import "SetAdminMemberListViewController.h"
#import "DiscussDetailViewController.h"

#import "TestReportDetailViewController.h"
#import "HealthDetailViewController.h"
#import "ScoreDetailViewController.h"
#import "NewsCommentViewController.h"

#import "ReadStatusObject.h"
#import "ReadStatusDBDao.h"

@interface MessageCenterViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, HttpReqCallbackDelegate, EGORefreshTableDelegate>
{
    UITableView *_tableView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;
    
    NSString *_titleName;

    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    NSMutableArray* dataArr;
    
    BOOL isFirstShow;

    NSIndexPath *deleteIndexPath;
    
    UIView *noDataView;//add by kate 2015.01.27
    
    
}

@property (nonatomic, retain) NSString *lastId;

@end
