//
//  NewClassPhotoViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "NewClassPhotoTableViewCell.h"

@interface NewClassPhotoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NewClassPhotoTableViewCellDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>{
    
    NSMutableArray *listArray;
    NSMutableArray *heightArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
    

}

@property(nonatomic,strong)NSString *cId;
@end
