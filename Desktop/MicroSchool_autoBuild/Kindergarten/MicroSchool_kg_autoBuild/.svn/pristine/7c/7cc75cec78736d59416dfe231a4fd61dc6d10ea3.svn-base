//
//  AuthorZoneViewController.h
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

#import "KnowledgePayItemViewController.h"

@interface AuthorZoneViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    NSString *isSubscribe;
    NSString *knowledgeCount;
    NSDictionary *diction;
    NSMutableArray *listArray;
    MBProgressHUD *HUD;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;

}

@property(nonatomic,strong)NSString *tid;
@end

