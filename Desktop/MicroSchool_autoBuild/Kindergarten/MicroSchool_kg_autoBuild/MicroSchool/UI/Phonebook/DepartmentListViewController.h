//
//  DepartmentListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FRNetPoolUtils.h"
#import "MBProgressHUD+Add.h"

@interface DepartmentListViewController : BaseViewController<UITableViewDataSource,UITabBarDelegate>{
    
    MBProgressHUD *HUD;
    NSMutableArray *listArray;
    
}
@property(nonatomic,strong)NSString *fromName;//本单位 或 下属单位
@property(nonatomic,strong)NSString *toViewName;//从通讯录主页来还是从转发页来
@property (nonatomic, strong) ChatDetailObject *entity;
@end
