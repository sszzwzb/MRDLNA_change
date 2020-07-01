//
//  SchoolModuleListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FRNetPoolUtils.h"

#import "DiscussViewController.h"
#import "NewsDetailViewController.h"

@interface SchoolModuleListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *listArray;
    
    UIView *noNetworkV;
    
}

@property(nonatomic,strong)NSString *otherSid;//其他学校学校id
@property(nonatomic,strong)NSString *otherSchoolName;//其他学校名字
@property(nonatomic,strong)NSString *favorite;//是否收藏

@property(nonatomic,strong)NSString *fromView;
@property(nonatomic,strong)NSString *special;

@end
