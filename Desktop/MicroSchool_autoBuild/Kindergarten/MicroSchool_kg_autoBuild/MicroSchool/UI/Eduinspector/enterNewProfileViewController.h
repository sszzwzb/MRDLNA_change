//
//  enterNewProfileViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"

@interface enterNewProfileViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;
    UITextField *text_title;
    MBProgressHUD *HUD;
    
}

@property(nonatomic,retain)NSString *fromName;//从设置电话来/职务/单位来

@end
