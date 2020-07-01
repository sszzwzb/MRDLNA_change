//
//  ChoosePhotoAlbumViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface ChoosePhotoAlbumViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    NSMutableArray *listArray;
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
    
}
@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *aid;
@end
