//
//  SelectPhotoFromAlbumViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"


@interface SelectPhotoFromAlbumViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,EGORefreshTableDelegate>{
    
    NSMutableArray *dataArray;
    UIView *noDataView;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    NSString *startNum;
}

@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *aid;
@end
