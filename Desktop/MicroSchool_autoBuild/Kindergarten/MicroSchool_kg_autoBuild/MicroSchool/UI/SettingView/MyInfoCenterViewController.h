//
//  MyInfoCenterViewController.h
//  MicroSchool
//  个人中心
//  Created by Kate on 14-10-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "MessageCenterViewController.h"
#import "MyQRCodeViewController.h"

#import "SetPersonalViewController.h"

@interface MyInfoCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    UIImage *image_head;
    UITableView *_tableView;
    UIImageView *imgView;
    UIImageView *headImgView;
    UIImageView *settingNewImg;
    UIImageView *settingNewImgForFeedback;
    UIImageView *pointNewImg;//2015.08.21
    NSString *isNewVersion;
    NSString *isNewFeedback;
    
    UILabel *_redLabel;//add by kate 2014.12.03
    
    UILabel *label_name;
    UILabel *label_sign;
    UILabel *userNameLabel;
    
    UIButton *label_sign_mask;
    UILabel *label_class;
    UIButton *button_req;
    
    UIImageView *imgView_gender;
    
    UIView *headerView;
    
    NSString *reason;
    
    UIImageView *noticeImgVForMsg;// 个人中心消息红点 add by kate 2014.12.03
    UIImageView *imgNew;


    NSDictionary *pointsDic;

}
@property(nonatomic,strong)NSString *count;//add by kate 2014.12.03

// 2015.06.05 add by ht
@property(nonatomic,strong)NSMutableArray *itemsArr;

@property(nonatomic,retain) UIImageView *settingImgView;

@end
