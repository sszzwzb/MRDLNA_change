//
//  AboutViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CalltipsViewController.h"
#import "ServerViewController.h"
#import "CXAlertView.h"
#import "SingleWebViewController.h"

@interface AboutViewController : BaseViewController<HttpReqCallbackDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    UIImageView *image_icon;
    
    UILabel *label_name;
    UILabel *label_sign;
    CXAlertView *checkUpdateAlert;
    
    int isFirst;//进入页面检查更新还是点击检查更新
    
}

@property(nonatomic,retain) UIImageView *featueImgView;

@end
