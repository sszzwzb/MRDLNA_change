//
//  NewsListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "NewsTableViewCell.h"
#import "NewsImgTableViewCell.h"
#import "NewsDetailOtherViewController.h"

@interface NewsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HttpReqCallbackDelegate, EGORefreshTableDelegate>{
    
    // 新闻条目信息
    NSMutableArray* newsArray;
    NSMutableArray* newsidList;
    NSMutableArray* newsDateList;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;
    
    NSString *_titleName;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    UIView *noDataView;

}
- (id)initWithVar:(NSString *)newsName;
@property(nonatomic,strong)NSString *otherSid;//其他学校学校id
@end
