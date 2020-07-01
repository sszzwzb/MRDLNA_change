//
//  MyClassViewController.h
//  MicroSchool
//
//  Created by jojo on 14-1-3.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "MyClassTableViewCell.h"
#import "FriendCommonViewController.h"
#import "ChatDetailObject.h"

@interface MyClassViewController : BaseViewController<HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *array_class;
    NSString *cid;
}

@property(nonatomic,copy)NSString *toViewName;
@property(nonatomic,copy)NSString *rowNum;
@property(nonatomic,strong)NSString *friendType;
@property (nonatomic, strong) ChatDetailObject *entity;

@end
