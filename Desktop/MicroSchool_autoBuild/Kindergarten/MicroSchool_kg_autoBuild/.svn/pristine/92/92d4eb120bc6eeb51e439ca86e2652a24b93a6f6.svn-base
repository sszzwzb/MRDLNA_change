//
//  FriendViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-24.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendTableViewCell.h"
#import "FriendCommonViewController.h"
#import "MyClassViewController.h"
#import "FriendProfileViewController.h"

#import "pinyin.h"
#import "ChineseString.h"
#import "Toast+UIView.h"

#import "EGORefreshTableHeaderView.h"

@interface FriendViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate>
{
    UITableView *_tableView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;

    NSInteger reflashFlag;

    NSInteger isReflashViewType;
    
    NSString *schoolType;// 学校类型 教育局 幼儿园 其他 2015.05.05

}

@property (retain, nonatomic) NSString *classid;

@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@property (retain, nonatomic) NSString *deleteUid;

@end
