//
//  LoginViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-6.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "NetworkUtility.h"

#import "MicroSchoolMainMenuViewController.h"
#import "MicroSchoolMainMenuNaviViewController.h"
#import "GetBackPwdViewController.h"
#import "MyTabBarController.h"

@interface LoginViewController : BaseViewController <HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView *tableViewIns;
    
    UITextField *_textFieldOri;
    UITextField *_textFieldNew;
    
    UIImageView *imgView_name;
    UIImageView *imgView_pwd;
    
    UIButton *getBackPwd;
    CGFloat keyboardHeight;
    
    UIScrollView* scrollerView;
   
}

@end
