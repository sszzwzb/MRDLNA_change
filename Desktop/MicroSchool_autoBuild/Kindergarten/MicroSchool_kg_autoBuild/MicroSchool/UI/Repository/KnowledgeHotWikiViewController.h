//
//  KnowledgeHotWikiViewController.h
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

#import "KnowlegeHomeTableViewCell.h"
#import "KnowledgeHotWikiModel.h"
#import "KnowledgePayItemViewController.h"

#import "MicroSchoolViewController.h"
#import "MicroSchoolAppDelegate.h"

#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"

@interface KnowledgeHotWikiViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate, DropDownChooseDelegate, DropDownChooseDataSource>
{
    MBProgressHUD *progressHud;
    
    NSString *startNum;
    NSString *endNum;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSInteger reflashFlag;
    
    NSMutableDictionary *dataDic;
    NSMutableArray *dataArr;
    
    NSMutableArray *chooseArray;
    
    DropDownListView * dropDownView;

}

@property (nonatomic, retain) UITableView *tableView;

// 数据model
@property (nonatomic,retain) KnowledgeHotWikiModel *model;

// 类型
@property (nonatomic,retain) UIButton *btn_categories;
@property (nonatomic,retain) NSString *filter_categorise;

// 科目
@property (nonatomic,retain) UIButton *btn_courses;
@property (nonatomic,retain) NSString *filter_courses;

// 年级
@property (nonatomic,retain) UIButton *btn_grades;
@property (nonatomic,retain) NSString *filter_grades;

@end
