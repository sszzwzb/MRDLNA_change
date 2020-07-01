//
//  DiscussViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "DiscussTableViewCell.h"
#import "MyInitiatorViewController.h"
#import "MyResponseViewController.h"
#import "SubmitViewController.h"
#import "DiscussDetailViewController.h"
#import "DiscussListData.h"
#import "FriendProfileViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "UIImageView+WebCache.h"

@interface DiscussViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    UILabel* label_name;
    UIImageView* image_head;
    UIImageView* image_head_bg;

    // 我发起的话题
    UIButton* button_initiator;
    UILabel* label_initiator_num;
    
    // 我参与的话题
    UIButton* button_response;
    UILabel* label_response_num;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSMutableArray* discussArray;
    NSMutableArray* tidList;
    
    NSString *startNum;
    NSString *endNum;
    
    NSInteger reflashFlag;
    
    NSInteger isReflashViewType;
    
    NSString *mythreads;
    NSString *myposts;
    
    UIView *noDataView;

}
@property(nonatomic,retain) NSString *titleName;//update by kate

// 班级讨论区/讨论区
// 校校通进来的讨论区 schoolExhi
@property(nonatomic,strong) NSString *fromName;

// 校校通tab的sid
@property(nonatomic,strong) NSString *schoolExhiId;

@property(nonatomic,strong) NSString *cId;// 班级id
@end
