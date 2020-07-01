//
//  SwitchChildViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 6/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SwitchChildViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSDictionary *UnbindChildDic;//
}

@property(nonatomic,retain) NSString *titleName;

// switchChild 切换子女
// managerChild 管理子女
@property(nonatomic,retain) NSString *viewType;

@property(nonatomic,assign) NSInteger selectedChild;
@property(nonatomic,assign) BOOL isSwitchingChild;

// 列表
@property(nonatomic,retain) NSMutableArray *dataAry;
@property(nonatomic,retain) UITableView *tableView;

@property (nonatomic,strong) UIView *blankView;

@end
