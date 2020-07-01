//
//  FriendFilterViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 5/14/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendTableViewCell.h"

#import "pinyin.h"
#import "ChineseString.h"
#import "PinYinForObjc.h"
#import "UserObject.h" 


@interface FriendFilterViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, HttpReqCallbackDelegate>
{
    UITableView *_tableView;
    NSMutableArray *mutableArrayOrign;
    
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
}


@property (retain, nonatomic) NSString *classid;

@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@property (nonatomic, retain) NSMutableArray *sortedArrForArraysFilter;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeysFilter;

@end

