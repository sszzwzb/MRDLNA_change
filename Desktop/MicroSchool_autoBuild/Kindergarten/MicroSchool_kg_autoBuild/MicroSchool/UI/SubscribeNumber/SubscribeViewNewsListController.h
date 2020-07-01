//
//  SubscribeViewNewsListController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FRNetPoolUtils.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface SubscribeViewNewsListController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    MBProgressHUD *HUD;
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    NSDictionary *diction;
    NSMutableArray *listArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
 
    NSString *last;
    
    UIView *noDataView;
    UIView *noNetworkV;
    
}


@property(nonatomic,strong)NSString *number;//订阅号id
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *subscribNumName;//订阅号名字
@end
