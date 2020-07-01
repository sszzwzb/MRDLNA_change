//
//  MyCheckinHome.h
//  MicroSchool
//
//  Created by CheungStephen on 9/13/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import <JTCalendar/JTCalendar.h>

@interface MyCheckinHome : BaseViewController<JTCalendarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (retain, nonatomic) JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@property (retain, nonatomic) NSMutableDictionary *eventsByDate;

@property (strong, nonatomic) NSDate *todayDate;
@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;

@property (strong, nonatomic) NSDate *dateSelected;

@property (strong, nonatomic) UIView *noCheckinDataView;
@property (retain, nonatomic) UILabel *noCheckinLabel;
@property (retain, nonatomic) UIImageView *bottomLineImageView;

@property (retain, nonatomic) NSString *summaryCheckin;

@property(nonatomic,assign) BOOL showRightItem;
@property (retain, nonatomic) NSString *studentId;

// 打卡简要
@property (strong, nonatomic) UILabel *briefLabel;

@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray* dayRecordArray;
@property(nonatomic,retain) NSMutableArray* recordsArray;


@property(nonatomic,strong)NSString *teacherUid;
@property(nonatomic,strong)NSString *checkinDate;

//for beck: 从第三个tab直接来("tab") 从首次绑定页来("firstBind") 从有查看统计权限的页来("secondEnter") 用于判断popViewController的层级关系 有些分支不直接返回上一级，比如从绑定页来
@property(nonatomic,strong)NSString *fromName;

@property(nonatomic,strong)NSString *card;//for beck:考勤卡ID
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,assign)NSUInteger isStudent;//for beck:学生家长 1 其他身份 不为1

@end
