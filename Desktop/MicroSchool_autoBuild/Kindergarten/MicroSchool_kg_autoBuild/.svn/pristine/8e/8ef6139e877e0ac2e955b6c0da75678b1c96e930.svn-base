//
//  KnowlegeHomePageViewController.h
//  MicroSchool
//
//  Created by Kate on 15-2-3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FRNetPoolUtils.h"
#import "MBProgressHUD+Add.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "MMDrawerController.h"
#import "MMNavigationController.h"
#import "MMDrawerController.h"

#import "KnowledgeHotWikiViewController.h"
#import "KnowledgeHotWikiFilterViewController.h"
#import "KnowledgeHotWikiBaseViewController.h"

@interface KnowlegeHomePageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,EGORefreshTableDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *listArray;
    NSMutableArray *searchListArray;
    NSDictionary *diction;
    NSMutableArray *tagArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    NSString *searchStartNum;
    UILabel *noDataView;
    UIView *noNetworkV;
    
    UIImageView *noticeImgV;
    NSString *subscribedWikiCount;
    NSString *subscriberCount;
    
}

@property (nonatomic,strong) MMDrawerController * drawerController;

@end
