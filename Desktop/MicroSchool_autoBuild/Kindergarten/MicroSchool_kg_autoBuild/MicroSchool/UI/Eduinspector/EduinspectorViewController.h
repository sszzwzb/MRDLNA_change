//
//  EduinspectorViewController.h
//  MicroSchool
//
//  Created by jojo on 14-8-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "EduModuleDetailViewController.h"
#import "EduModuleListViewController.h"
#import "EduQuestionTableViewCell.h"
#import "EduQuizViewController.h"
#import "EduQuesDetailViewController.h"
#import "EduinspectorDetailViewController.h"

#import "Utilities.h"
#import "UIImageView+WebCache.h"

@interface EduinspectorViewController : BaseViewController <HttpReqCallbackDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate>
{
//    UIScrollView *_scrollerView;
    UITableView *_tableView;

    // 我要提问btn位置
    NSInteger questionPos;
    NSInteger btnStartYPos;

    // 督学模块btn数组
    NSMutableArray *eduInsModuleBtnArr;
    
    // 督学人
    NSMutableArray *eduInspectorsArr;

    // 督学回答list
    NSMutableArray *eduInterractionsArr;
    
    NSMutableArray* questionArr;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;

    //NSString *startNum;
    NSString *endNum;

    //滚动视图
    UIScrollView *scrollViewIns;
    //分页控件
    UIPageControl *pageControl;
    
    NSString *startNum;
    
    // 当前选择的督学人
    NSUInteger selectInspector;
    
    // 是否是第一次进入，刷新督学人
    BOOL isFirst;
    
    UIView *nodataView;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
//    UIButton *button_addFriend;
//    UIButton *button_setAdmin;
    
    UIImageView *imgView_line; // 督学人下面的线

}

@property (retain, nonatomic) NSString *titleName;

@end
