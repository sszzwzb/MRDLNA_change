//
//  FootmarkListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "FootmarkLinkOrTxtTableViewCell.h"
#import "FootmarkPicTableViewCell.h"

@interface FootmarkListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,FootmarkLinkOrTxtCellDelegate,FootmarkPicCellDelegate>{
    
    NSMutableArray *tagArray;
    NSMutableArray *listArray;
    NSMutableArray *heightArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
    NSString *tag;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    
    
}


@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *fromName;//教师/家长学生
@end
