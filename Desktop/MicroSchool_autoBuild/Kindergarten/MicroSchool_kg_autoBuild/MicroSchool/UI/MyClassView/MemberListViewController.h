//
//  MemberListViewController.h
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MemberTableViewCell.h"

@interface MemberListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,memberListDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *listArray;
    NSString *userIndex;
    UIView *noDataView;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    NSMutableArray *tagArray;
}

@property(nonatomic,strong) NSString *cId;
@property(nonatomic,strong) NSString *fromName;
@property(nonatomic,strong) NSString *titleName;
@end
