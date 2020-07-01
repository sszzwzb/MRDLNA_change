//
//  SettingGenderViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingGenderViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HttpReqCallbackDelegate>
{
    UITableView *_tableViewIns;
    
    NSString *genderFlag;//female/male
    
}

@end
