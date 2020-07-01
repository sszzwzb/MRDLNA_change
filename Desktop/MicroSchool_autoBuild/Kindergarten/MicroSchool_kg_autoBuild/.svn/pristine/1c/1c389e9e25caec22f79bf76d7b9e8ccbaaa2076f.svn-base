//
//  FriendAddReqViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-26.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "UIImageView+WebCache.h"

@interface FriendAddReqViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView* _scrollerView;
    
    UILabel *label_name;
    UILabel *label_sign;
    UILabel *label_class;
    
    UIImageView *imgView_gender;
    UIImageView *imgView;
 
    UIButton *button_sendReq;
    
    UITextField *_textFieldNote;
    
    UITextView *text_content;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *spacenote;
@property (copy, nonatomic) NSString *avatar;

@property (copy, nonatomic) NSString *title;

@end
