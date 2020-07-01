//
//  SchoolYearViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-19.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SchoolYearViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HttpReqCallbackDelegate>
{
    UITableView *_tableViewIns;
    
    NSArray* schoolYearArray;
}


@end
