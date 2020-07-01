//
//  SchoolEventDetailViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolEventDetailTabBarController.h"

#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"

#import "EventDetailViewController.h"
#import "EventMemberViewController.h"
#import "EventPhotoViewController.h"
#import "EventTopicViewController.h"

@interface SchoolEventDetailViewController : BaseViewController<HttpReqCallbackDelegate>
{
    SchoolEventDetailTabBarController *schEventDetailTabbar;
    
    UIButton *button;
    
    UIImageView *imgView_thumb;
    UIImageView *imgView_status;
    UIImageView *imgView_category;
    UIImageView *imgView_time;
    UIImageView *imgView_location;

    // 地点
    UILabel *label_location;
    
    // 时间
    UILabel *label_time;

    // 种类
    UILabel *label_category;
    
    UILabel *label_title;
    
    EventDetailViewController *eventDetail;
    EventMemberViewController *eventMember;
    EventPhotoViewController *eventPhoto;
    EventTopicViewController *eventTopic;
    
    NSString *joinStr;
    NSString *statusStr;
}

@property (retain, nonatomic) NSString *eid;

@end
