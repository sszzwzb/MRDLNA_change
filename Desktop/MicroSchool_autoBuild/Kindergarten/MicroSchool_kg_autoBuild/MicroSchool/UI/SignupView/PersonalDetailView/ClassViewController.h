//
//  ClassViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-19.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HttpReqCallbackDelegate>
{
    UITableView *_tableViewIns;
    
    NSArray* classArray;
    NSMutableArray* cidList;

}


@end
