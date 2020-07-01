//
//  CCTVListViewController.h
//  MicroSchool
//
//  Created by jojo on 15/8/19.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "CCTVViewController.h"

@interface CCTVListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain) NSString *titleName;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataArr;

@end
