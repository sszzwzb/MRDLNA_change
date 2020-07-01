//
//  NewsViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "NewsTableViewCell2.h"
#import "NewsImgTableViewCell2.h"
#import "NewsDetailViewController.h"
#import "SchoolListForBureauViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "NewsListObject.h"
#import "NewsListDBDao.h"

#import "ReadStatusObject.h"
#import "ReadStatusDBDao.h"

@interface NewsViewController2 : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate>
{
    // 新闻条目信息
    NSMutableArray* newsDBArray;
    NSMutableArray* newsArray;
    
    NSMutableArray* newsidList;
    NSMutableArray* newsDateList;
    
    UITableView *_tableView;
    
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

@property(nonatomic,strong)NSString *mid;//模块id 用于存贮lastid 2015.11.12
@property(nonatomic,strong)NSDictionary *newsDic;//2015.11.12


- (id)initWithVar:(NSString *)newsName;

// http请求返回结果
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type;

//@property (copy, nonatomic) NSString *type;

//-(void) doGetNewsPage:(NSString*)page andSize:(NSString*)size;
//-(void) callFooWithArray: (NSArray *) inputArray;

// eduinspectorNews 督学模块的通知信息
@property(nonatomic,strong) NSString *fromName;
@property(nonatomic,strong) NSString *last;//督学last

#if BUREAU_OF_EDUCATION

// 教育局版本新闻的类型
// headLineNews 校园头条
// headLineNewsSid 校园头条学校筛选
// schoolNews 公告发布

@property(nonatomic,strong) NSString *newsType;

@property(nonatomic,strong) NSString *headLineNewsSid;



#endif

@end
