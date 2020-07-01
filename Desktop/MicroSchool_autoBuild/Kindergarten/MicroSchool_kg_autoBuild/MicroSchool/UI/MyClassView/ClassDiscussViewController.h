//
//  ClassDiscussViewController.h
//  MicroSchool
//
//  Created by kate on 3/12/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
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

@interface ClassDiscussViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
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
    NSString* cid;
    
    NSInteger reflashFlag;
    
    NSInteger isReflashViewType;
    
    NSString *mythreads;
    NSString *myposts;
    
    UIView *noDataView;
    
}
@property(nonatomic,strong) NSString* cId;
@property(nonatomic,strong) NSString *fromName;
@property(nonatomic,strong) NSString *titleName;
@property(nonatomic,strong) NSString *mid;//从班级模块来的id
@end

