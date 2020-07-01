//
//  WeeklyRecipesViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 3/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "WeeklyRecipesTableViewCell.h"

@interface WeeklyRecipesViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) NSString *titleName;

// 菜谱列表
@property(nonatomic,retain) NSMutableArray *recipesAry;
@property(nonatomic,retain) NSMutableArray *recipesAryHeight;
// 后台返回数据
@property(nonatomic,retain) NSMutableDictionary *contentDic;

@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,retain) UIView *noDataView;

@end
