//
//  HomeworkStateListViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 2/3/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "HomeworkStateDetailViewController.h"

@interface HomeworkStateListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

// notDone      未完成
// notComment   未批改
// done         已完成
@property(nonatomic,retain) NSString *viewType;
@property(nonatomic,retain) NSString *titleName;

@property(nonatomic,retain) NSString *cid;
@property(nonatomic,retain) NSString *tid;

@property(nonatomic,retain) NSMutableArray* dataArr;

@property(nonatomic,retain) UITableView *tableView;

@end
