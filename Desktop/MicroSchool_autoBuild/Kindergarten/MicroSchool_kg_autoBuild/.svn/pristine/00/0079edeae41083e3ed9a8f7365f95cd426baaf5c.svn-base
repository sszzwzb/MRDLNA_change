//
//  SingleSubjectListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface SingleSubjectListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    
    NSMutableArray *listArray;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSString *startNum;
    
    UIView *noDataView;
    
}
@property(nonatomic,strong)NSString *subjectId;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *cId;
@end
