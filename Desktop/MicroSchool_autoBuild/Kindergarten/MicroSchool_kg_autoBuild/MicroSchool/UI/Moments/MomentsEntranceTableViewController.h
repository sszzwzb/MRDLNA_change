//
//  MomentsEntranceTableViewController.h
//  MicroSchool
//
//  Created by Kate on 15-2-3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "SchoolExhibitionViewController.h"
#import "ScanViewController.h"
#import "networkBar.h"
#import "NetworkGuideViewController.h"
#import "FileManager.h"
#import "EGORefreshTableHeaderView.h"

@interface MomentsEntranceTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,EGORefreshTableDelegate>{
    
    UIImageView *noticeImgVForMsg;
    BOOL isKnowledge;
    NSString *knowledgeName;
    NSMutableArray *listArray;
    
    UIImageView *isNewForScan;//new标记扫一扫
    
    networkBar *networkVC;
    UIView *topBar;
    NSInteger reflashFlag;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

    
}


@property(nonatomic,strong)NSString *titleName;

@property(nonatomic,retain)NSString *foundModuleName;

@end
