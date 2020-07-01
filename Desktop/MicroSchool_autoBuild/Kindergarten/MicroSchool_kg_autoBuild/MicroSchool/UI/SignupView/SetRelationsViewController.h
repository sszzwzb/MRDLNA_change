//
//  SetRelationsViewController.h
//  MicroSchool
//
//  Created by jojo on 15/10/10.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SetRelationsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *dataArr;

@end
