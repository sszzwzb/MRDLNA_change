//
//  ParenthoodListForParentTableViewController.h
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ParentBindListTableViewCell.h"

@interface ParenthoodListForParentTableViewController : BaseViewController<UITableViewDataSource,UITabBarDelegate,ParentBindListDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *listArray;
    NSString *sIndex;
}

@end
