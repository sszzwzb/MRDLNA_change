//
//  SetAdminMemberListViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetAdminMemberCellTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "BaseViewController.h"

@interface SetAdminMemberListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,setAdminMemberDelegate>{
    
    NSMutableArray *listArray;
    NSString *userIndex;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    NSMutableArray *tagArray;
    
}

@property(nonatomic,strong) NSString *cId;

// 从消息中心来的mid
@property(nonatomic,strong)NSString *msgCenterMid;

@end
