//
//  DiscussHistoryViewController.h
//  MicroSchool
//
//  Created by jojo on 14/12/8.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "DiscussHistoryTableViewCell.h"
#import "FriendProfileViewController.h"

#import "Toast+UIView.h"

@interface DiscussHistoryViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate>
{
    UITableView *_tableView;
    
    NSArray *historyDic;
}
@property (nonatomic, assign) BOOL isFromNewsDetail;
@property (retain, nonatomic) NSString *tid;
@property (retain, nonatomic) NSString *cid;

@end
