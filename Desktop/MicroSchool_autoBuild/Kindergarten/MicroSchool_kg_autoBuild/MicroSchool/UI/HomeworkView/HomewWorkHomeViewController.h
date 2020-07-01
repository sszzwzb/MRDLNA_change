//
//  HomewWorkHomeViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/23.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "HomeworkHomeTableViewCell.h"

#import "HomeworkDetail/HomeworkDetailViewController.h"

@interface HomewWorkHomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,HomeworkCellDelegate>{
    
    NSMutableArray *homeworkArray;
    NSMutableArray* tidList;
    NSMutableArray *homworkTimeList;
    NSMutableArray *heightArray;
    NSMutableArray *finishTimesArray;//总计完成时间数组
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    UIView *noDataView;
    UILabel *label;
    
    BOOL hasNext;
}

@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *titleName;
@property(nonatomic,strong) NSString *mid;
@property(nonatomic,strong) NSString *spaceForClass;//班级是否有学籍
@end
