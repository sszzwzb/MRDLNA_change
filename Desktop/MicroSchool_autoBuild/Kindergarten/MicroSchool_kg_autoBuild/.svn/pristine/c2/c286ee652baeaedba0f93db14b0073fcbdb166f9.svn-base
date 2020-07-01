//
//  SchoolListByCityViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FRNetPoolUtils.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface SchoolListByCityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    MBProgressHUD *HUD;
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    NSDictionary *diction;
    NSMutableArray *listArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
}

@property(nonatomic,strong)NSString *cid;
@end
