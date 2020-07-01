//
//  SettingBirthViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingBirthViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HttpReqCallbackDelegate>
{
    UITableView *_tableView;
    UITextField *text_title;

    UIDatePicker *datePicker;
    NSLocale *datelocale;
    
}

@end
