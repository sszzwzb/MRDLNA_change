//
//  NewListViewController.h
//  MicroSchool
//  个人动态消息列表
//  Created by Kate on 14-12-18.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "FRNetPoolUtils.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface NewListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *listArray;
    MBProgressHUD *HUD;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;

    UIView *noDataView;
    
    NSString *lastIdStr;

}
//@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,retain) NSDictionary *newsDic;//2015.11.12
@property(nonatomic,retain)NSString *cid;
@end
