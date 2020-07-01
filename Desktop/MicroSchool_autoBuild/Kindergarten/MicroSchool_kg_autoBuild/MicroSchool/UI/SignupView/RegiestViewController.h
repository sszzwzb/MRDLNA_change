//
//  RegiestViewController.h
//  MicroSchool
//
//  Created by jojo on 13-11-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "RegiestTableViewCell.h"
#import "SetIdentityViewController.h"

@interface RegiestViewController : BaseViewController <HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView *tableViewIns;
    
    UITextField *_textFieldOri;
    UITextField *_textFieldNew;
    UITextField *_textFieldVeri;
}

@end
