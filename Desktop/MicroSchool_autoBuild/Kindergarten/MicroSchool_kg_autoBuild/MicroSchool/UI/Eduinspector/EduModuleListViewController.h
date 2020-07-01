//
//  EduModuleListViewController.h
//  MicroSchool
//
//  Created by jojo on 14-8-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EduModuleDetailViewController.h"

@interface EduModuleListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@property (retain, nonatomic) NSMutableArray *eduInsModuleList;

@end
