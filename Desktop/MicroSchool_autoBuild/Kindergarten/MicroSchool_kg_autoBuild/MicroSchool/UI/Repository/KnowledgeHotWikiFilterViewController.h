//
//  KnowledgeHotWikiFilterViewController.h
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "UIViewController+MMDrawerController.h"
#import "MMNavigationController.h"

#import "KnowledgeHotWikiViewController.h"

@interface KnowledgeHotWikiFilterViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *data;

@end
