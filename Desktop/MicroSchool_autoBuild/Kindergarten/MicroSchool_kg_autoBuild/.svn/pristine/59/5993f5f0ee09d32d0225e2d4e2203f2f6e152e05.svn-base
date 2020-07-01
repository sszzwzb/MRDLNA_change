//
//  ToReplyListViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface ToReplyListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *listArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
}

@end
