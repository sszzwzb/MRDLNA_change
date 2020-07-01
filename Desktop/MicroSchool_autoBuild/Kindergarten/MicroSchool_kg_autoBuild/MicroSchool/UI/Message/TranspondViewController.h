//
//  TranspondViewController.h
//  MicroSchool
//
//  Created by Kate on 15-3-24.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChatDetailObject.h"
#import "MBProgressHUD+Add.h"

@interface TranspondViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *chatListArray;
    MBProgressHUD *HUD;
    NSString *userID;
    NSString *userName;
}
@property (nonatomic, strong) NSMutableArray *chatListArray;
@property (nonatomic, strong) ChatDetailObject *entity;

@end
