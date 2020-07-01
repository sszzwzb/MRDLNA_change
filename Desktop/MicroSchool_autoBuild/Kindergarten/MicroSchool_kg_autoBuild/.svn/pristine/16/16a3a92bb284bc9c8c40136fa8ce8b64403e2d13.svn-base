//
//  ManagePhotoViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "BaseViewController.h"
#import "ManageHeaderReusableView.h"

@interface ManagePhotoViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,EGORefreshTableDelegate,ManageHeaderDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *dataArray;
    UIView *noDataView;
    NSMutableArray *pidArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    NSString *startNum;
    
    UIButton *deleteBtn;
    UIButton *moveBtn;
   
    NSMutableArray *checkListArray;// 选择array 存row的选中情况
    
    NSMutableArray *checkSectionArray;// 存section的选中情况
    
    //ManageHeaderReusableView *headerView;
    NSString *moveAid;//移动到的相册
    
    //NSString *postPids;
    UIView *bottomV;
    
    
}

@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *aid;

@end
