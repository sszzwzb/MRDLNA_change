//
//  KnowledgeOrderItemViewController.h
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "KnowledgeOrderItemModel.h"

#import "MBProgressHUD+Add.h"

@interface KnowledgeOrderItemViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD *progressHud;
    
    UIView *noDataView;
}

// 数据model
@property (nonatomic,retain) KnowledgeOrderItemModel *model;

// 教师id
@property (nonatomic,retain) NSString *tid;

// order id
@property (nonatomic,retain) NSString *iid;

// 背景scrollview
@property (nonatomic,retain) UIScrollView *scrollView;

// 显示tableview
@property (nonatomic, retain) UITableView *tableView;

// 付款类型
@property (nonatomic,retain) NSString *payType;

// 是否是跳转到safari之后回到支付页面
@property (nonatomic,assign) BOOL isBackFromSafari;

@end
