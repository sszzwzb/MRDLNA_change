//
//  BindPhoneNumberViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/8/11.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BindPhoneNumberViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
}

@property(nonatomic,strong) NSString *fromName;//绑定手机/更改手机

@end
