//
//  EventMemberViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkUtility.h"
#import "Utilities.h"

#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "EventMemberCell.h"

@interface EventMemberViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;

    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSMutableArray* memberArray;
    
    NSString *startNum;
    NSString *endNum;
    
    NetworkUtility* networkDetail;
    UIButton *button;
    
    NSString *joined;
}

@property (retain, nonatomic) NSString *eid;

-(void) getMember:(NSString*) eidValue andJoined:(NSString *) jonied andStatus:(NSString*) status andNum:(NSString*) num;

@end
