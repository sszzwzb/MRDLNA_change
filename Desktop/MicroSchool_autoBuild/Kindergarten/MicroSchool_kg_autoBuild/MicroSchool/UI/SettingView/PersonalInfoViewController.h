//
//  PersonalInfoViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "SetPersonalInfoViewController.h"

#import "UIImageView+WebCache.h"

@interface PersonalInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;

    UIImageView *image_head;
    UIImageView *imgView_gender;
    
    UILabel *label_name;
    UILabel *label_sign;

    UITableView *tableViewIns;
    
    NSDictionary *infoDic;

}

@end
