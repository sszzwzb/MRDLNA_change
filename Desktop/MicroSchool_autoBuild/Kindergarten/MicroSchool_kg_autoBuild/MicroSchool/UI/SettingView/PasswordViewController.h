//
//  PasswordViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "PasswordTableViewCell.h"

@interface PasswordViewController : BaseViewController<HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *tableViewIns;
    
    UITextField *_textFieldOri;
    UITextField *_textFieldNew;
    UITextField *_textFieldVeri;
    
    UIButton *button_save;
}

@end
