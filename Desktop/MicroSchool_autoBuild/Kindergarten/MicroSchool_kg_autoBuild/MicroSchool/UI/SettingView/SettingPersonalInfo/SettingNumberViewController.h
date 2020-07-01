//
//  SettingNumberViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingNumberViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HttpReqCallbackDelegate>
{
    UITableView *tableViewIns;
    UITextField *text_title;
}


@end
