//
//  GuideViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-17.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MicroSchoolLoginViewController.h"

#import "ClassDetailViewController.h"
#import "MomentsEntranceTableViewController.h"
#import "SchoolListForBureauViewController.h"

#import "NetworkUtility.h"

@interface GuideViewController : UIViewController<UIScrollViewDelegate, HttpReqCallbackDelegate>
{
    //滚动视图
    UIScrollView *scrollViewIns;
    //分页控件
    UIPageControl *pageControl;
    
    NSInteger *bHiddenBar;
    
    GlobalSingletonUserInfo* g_userInfo;
    
    NetworkUtility *network;

}

// newVersionGuide 为新版本的教育页面
@property (retain, nonatomic) NSString *viewType;

@end
