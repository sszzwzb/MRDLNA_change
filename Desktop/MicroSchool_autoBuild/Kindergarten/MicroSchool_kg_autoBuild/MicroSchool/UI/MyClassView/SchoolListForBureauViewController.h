//
//  SchoolListForBureauViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "networkBar.h"
#import "FileManager.h"
#import "NetworkGuideViewController.h"

@interface SchoolListForBureauViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIGestureRecognizerDelegate>{
    
    NSMutableArray *listArray;
    //----add by kate----------------------------
    NSInteger reflashFlag;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    //--------------------------------------------
    
     networkBar *networkVC;// 2015.06.25
    
  
}
@property(nonatomic,strong)NSString *titleName;//2015.10.29

@property(nonatomic,strong)NSString *viewType;

@end
