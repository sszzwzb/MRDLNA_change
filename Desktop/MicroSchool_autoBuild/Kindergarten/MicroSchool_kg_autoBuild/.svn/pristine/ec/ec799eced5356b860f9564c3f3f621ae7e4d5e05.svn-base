//
//  PhotoCollectionViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/5.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface PhotoCollectionViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,EGORefreshTableDelegate>{
    
    CGFloat maxHeight;
    CGFloat maxWidth;
    
    NSMutableArray *dataArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
    
    
    
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong ,nonatomic)NSString *cid;
@end
