//
//  TotalSubjectsViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

// 用于已读未读
#import "ReadStatusObject.h"
#import "ReadStatusDBDao.h"

@interface TotalSubjectsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    NSMutableArray *listArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
}

@property(nonatomic,strong)NSString *cId;

// studentGrowthSpace 老师身份查看学生的成长空间的成绩
@property(nonatomic,strong)NSString *viewType;

// 学生空间id
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *name;

@end
