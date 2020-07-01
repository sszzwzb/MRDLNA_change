//
//  ContactViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface ContactViewController : BaseViewController<HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *_tableView;
    
    UILabel *_labelPhone;
    UITextField *_textFieldMail;
    UITextField *_textFieldQq;
    UITextField *_textFieldMsn;
    
    UIButton *button_save;
}


@end
