//
//  SignupViewController.h
//  MicroSchool
//
//  Created by jojo on 13-11-3.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Toast+UIView.h"

#import "BaseViewController.h"

#import "RegiestViewController.h"
#import "SetIdentityViewController.h"

@interface SignupViewController : BaseViewController <UITextFieldDelegate, HttpReqCallbackDelegate>
{
    UIButton *button_getCode;
    
    UITextField *text_name;
    UITextField *text_verify;
    UITextField *text_pwd;

    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
}

@end
