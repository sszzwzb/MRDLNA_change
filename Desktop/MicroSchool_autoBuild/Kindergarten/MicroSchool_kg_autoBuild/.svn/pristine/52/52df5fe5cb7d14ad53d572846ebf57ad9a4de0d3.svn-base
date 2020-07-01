//
//  FriendCommonViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-25.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "FriendTableViewCell.h"
#import "FriendNewFriendTableViewCell.h"
#import "FriendAddReqViewController.h"
#import "FriendMultiSelectViewController.h"
#import "FriendProfileViewController.h"

#import "pinyin.h"
#import "ChineseString.h"
#import "UserObject.h"
#import "PinYinForObjc.h"


@interface FriendCommonViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate,UISearchBarDelegate>
{
    UITableView *_tableView;
    
    NSString *req_op;
    NSString *title_name;
    
    // 添加好友前面的加号图片
    UIImage *buttonImg_d;
    UIImage *buttonImg_p;
    
     //UserObject *user;//add by kate
    //-------add by kate 2015.05.05------------------------------
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *mutableArrayOrign;
    NSString *schoolType;
    //-------------------------------------------------
    
}

- (id)initWithVar:(FriendViewType)type;

@property (retain, nonatomic) NSString *classid;
@property (nonatomic) FriendViewType viewType;
@property (nonatomic,retain) NSString *titleName;
@property (nonatomic,strong) NSString *fromTitle;
@property (retain, nonatomic) NSString *gid;

@property (nonatomic, retain) NSMutableArray *friendNewArray;

@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
//@property(nonatomic, retain) UserObject *user;//add by kate

@property (nonatomic, retain) NSMutableArray *sortedArrForArraysFilter;//add by kate 2015.05.05
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeysFilter;//add by kate 2015.05.05

@end
