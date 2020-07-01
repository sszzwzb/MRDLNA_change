//
//  PhotoCollectionDetailViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "CollectionHeaderReusableView.h"

@interface PhotoCollectionDetailViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate,UIAlertViewDelegate>{
    
    CGFloat maxHeight;
    CGFloat maxWidth;
    
    NSMutableArray *tagArray;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    BOOL isRightButtonClicked;
    NSMutableArray *dataArray;
    UIView *noDataView;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    //EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIImageView *imagev;//封面
    UILabel *titleLab;//封面名字
    
    UIActivityIndicatorView *activityView;

    NSInteger loading;
    
    BOOL hasNext;//是否有下一页
    
    UIImageView *maskImgV;
    
    NSDictionary *albumDic;
    CollectionHeaderReusableView *hheaderView;
    UIButton *leftButton1;
    UIButton *rightButton1;
    
    UIButton *uploadImgBtn;
    
    
//    //系统自带的下拉刷新
//    UIRefreshControl *_refreshControl;
//    BOOL _isPullRefresh;///判断是否是下拉
//    BOOL scrolling;///是否正在上拉刷新
//    UIActivityIndicatorView *activity;
    
}

@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *aid;
@property(nonatomic,strong)NSString *photoAlbumTitle;
// 渐进的navigation
@property(nonatomic, retain) UIView *alphaView;

@end
