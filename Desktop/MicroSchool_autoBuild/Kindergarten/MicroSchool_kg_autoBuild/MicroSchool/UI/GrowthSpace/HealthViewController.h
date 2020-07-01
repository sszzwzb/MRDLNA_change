//
//  HealthViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/26.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "HealthSubmitViewController.h"
#import "HealthHistoryViewController.h"

@interface HealthViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *dic;
}
@property(nonatomic,strong) NSString *titleName;
@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *number;

// 蒙版页面
@property (nonatomic, retain) UIView *viewMasking;

@end
