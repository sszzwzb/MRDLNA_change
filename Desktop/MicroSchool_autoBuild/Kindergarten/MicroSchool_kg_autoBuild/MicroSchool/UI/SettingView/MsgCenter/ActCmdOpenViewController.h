//
//  ActCmdOpenViewController.h
//  MicroSchool
//
//  Created by jojo on 14/11/17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ActCmdOpenViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate,UITextFieldDelegate>{
    
    NSString *rejectReason;
    UITextField *reasonTF;
}

@property (retain, nonatomic) NSDictionary *action_msg;

@property (nonatomic, retain) UIScrollView *scrollViewBg;

@property (nonatomic, retain) UILabel *label_title;
@property (nonatomic, retain) UILabel *label_name;
@property (nonatomic, retain) UILabel *label_msg;
@property (nonatomic, retain) UILabel *label_time;

@property (nonatomic, retain) NSString *actType;
@property (nonatomic, retain) NSString *mid;
@property (nonatomic, assign) int btn_tag;

@property (nonatomic, retain) UIImageView *imageView_img;

@property(nonatomic,strong) NSDictionary *actDiction;

@property(nonatomic,strong) UIImageView *imgView_teacher;

@end
