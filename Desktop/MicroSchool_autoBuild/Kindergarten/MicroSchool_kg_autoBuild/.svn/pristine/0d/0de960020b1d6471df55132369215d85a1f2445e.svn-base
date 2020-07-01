//
//  MomentsEntranceForTeacherController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/26.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SchoolExhibitionViewController.h"
#import "ScanViewController.h"
#import "networkBar.h"
#import "NetworkGuideViewController.h"
#import "FileManager.h"
#import "EGORefreshTableHeaderView.h"
#import "GroupChatList.h"

@interface MomentsEntranceForTeacherController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,EGORefreshTableDelegate>{
    
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
    
    NSMutableArray *chatListArray;
    GroupChatList *groupChatList;
    CGSize winSize;
    UIView *noDataView;
    NSMutableArray *headArray;//放组合完头像的群聊头像
    
    UIView *viewMasking;//蒙版

    
}

@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,retain)NSString *foundModuleName;
@property(nonatomic,strong)NSString *cid;// 班级id
@property (nonatomic, retain) NSMutableArray *chatListArray;

@end
