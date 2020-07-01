//
//  AccountandPrivacyViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface AccountandPrivacyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HttpReqCallbackDelegate>{
    
    UITableView *_tableView;
    NSMutableDictionary *user;
    
    UIImageView *imgView;
    
    UIImageView *imgViewForAddFriend;
}

@end
