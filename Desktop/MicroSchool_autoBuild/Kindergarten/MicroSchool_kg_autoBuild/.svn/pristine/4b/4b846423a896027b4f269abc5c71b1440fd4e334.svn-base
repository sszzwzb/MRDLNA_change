//
//  SubscribeNumListViewController.h
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

@interface SubscribeNumListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    MBProgressHUD *HUD;
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    NSDictionary *diction;
    NSMutableArray *listArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSString *startNum;
    
    NSString *lasts;
    
    NSInteger *isFirst;
    
    UIView *noDataView;
    UIView *noNetworkV;
    
}


@property(nonatomic,strong) NSString *titleName;
@property(nonatomic,strong) NSDictionary *newsDic;//2015.11.12
@property(nonatomic,strong) NSString *mid;//2016.02.19
@property(nonatomic,strong) NSString *lastSubscribeId;
@end
