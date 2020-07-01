//
//  ParenthoodListForChildTableViewController.h
//  MicroSchool
//
//  Created by Kate on 14-11-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ParenthoodListForChildTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *listArray;
}

@end
