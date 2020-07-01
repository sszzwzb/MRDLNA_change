//
//  SettingViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Toast+UIView.h"

#import "BaseViewController.h"

#import "PersonalInfoViewController.h"
#import "ContactViewController.h"
#import "PasswordViewController.h"
#import "CommentViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"

#import "MicroSchoolLoginViewController.h"
#import "ContactUsViewController.h"
#import "DBDao.h"

@interface SettingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate>
{
    UITableView *tableViewIns;
    UIImageView *imgView;
    
    UIImageView *imgViewMsg;
    
    UIImageView *imgVersion;
    
    UIImageView *cacheNewImg;//2015.08.21
}

@property(nonatomic,strong) NSString *isNewVersion;
@property(nonatomic,strong) NSString *isNewFeedback;
@property(nonatomic,retain) UIImageView *aboutImgView;
@property(nonatomic,retain) UIImageView *contactUsImgView;


@end