//
//  teacherListViewController.h
//  MicroSchool
//
//  Created by Kate on 15-2-4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface teacherListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EGORefreshTableDelegate>{
    
    NSMutableArray *listArray;
    NSMutableArray *searchListArray;
    MBProgressHUD *HUD;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    NSString *searchStartNum;
    
    UILabel *noDataView;
    
    //UISearchDisplayController *searchDisplayController;
    
}

@end
