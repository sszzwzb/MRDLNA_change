//
//  MyCheckinHome.m
//  MicroSchool
//
//  Created by CheungStephen on 9/13/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "MyCheckinHome.h"

#import "MyTabBarController.h"
#import "SignManageViewController.h"
#import "MyCheckinHomeTableViewCell.h"

@interface MyCheckinHome ()
{
    NSMutableArray *thumbArray;  //  选择 的 图片
}

@end

@implementation MyCheckinHome

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    thumbArray = [NSMutableArray array];
    
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBackwardJTCalendar)
                                                 name:@"goBackwardJTCalendar"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goForwardJTCalendar)
                                                 name:@"goForwardJTCalendar"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preLoadCheckinData)
                                                 name:@"preLoadCheckinData"
                                               object:nil];
    
    _dayRecordArray = [[NSMutableArray alloc] init];
    _recordsArray = [[NSMutableArray alloc] init];
    
    [self checkinDate:[NSDate date]];
    _todayDate = [NSDate date];
    _dateSelected = [NSDate date];
    
    if (_showRightItem) {
        [super setCustomizeRightButtonWithName:@"管理"];
    }
    
    if (nil == _teacherUid) {
        _teacherUid = [Utilities getUniqueUid];
    }
    
    if (_isStudent) {
        _summaryCheckin = @"本月已签到";
    }else {
        _summaryCheckin = @"本月迟到/早退";
    }
    
    [self checkinRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBackwardJTCalendar{
    NSLog(@"goBackwardJTCalendar called");
    
    //    NSDate *a = _calendarManager.date;
    //
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //    [comps setMonth:-1];
    //    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *mDate = [calender dateByAddingComponents:comps toDate:a options:0];
    
    //    [_calendarManager setDate:mDate];
    
    [_dayRecordArray removeAllObjects];
    [_tableView reloadData];
    
    [_calendarContentView loadPreviousPageWithAnimation];
}

-(void)goForwardJTCalendar {
    NSLog(@"goForwardJTCalendar called");
    
    //    NSDate *a = _calendarManager.date;
    //
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //    [comps setMonth:-1];
    //    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *mDate = [calender dateByAddingComponents:comps toDate:a options:0];
    
    //    [_calendarManager setDate:mDate];
    
    [_dayRecordArray removeAllObjects];
    [_tableView reloadData];
    
    [_calendarContentView loadNextPageWithAnimation];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bgImage.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

-(void)selectLeftAction:(id)sender {
    // 退回到上个画面
    if ([@"firstBind" isEqualToString:_fromName]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3]animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
- (BOOL)gestureRecognizerShouldBegin{
    // 退回到上个画面
    if ([@"firstBind" isEqualToString:_fromName]) {
        //        NSArray *arr = self.navigationController.viewControllers;
        //        NSInteger b = [self.navigationController.viewControllers count];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3]animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return NO;
}

-(void)selectRightAction:(id)sender {
    SignManageViewController *vc = [[SignManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)preLoadCheckinData {
    
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:_checkinDate];
    NSLog(@"date = %@", inputDate);
    
    
    NSDate *a = [_calendarManager.dateHelper addToDate:inputDate months:-1];
    
    
    
    
    [self checkinDate:a];
    
    
    
    
    
    
    
    NSMutableDictionary *userDetailInfo = [[GlobalSingletonUserInfo sharedGlobalSingleton] getUserDetailInfo];
    NSString *cid = [NSString stringWithFormat:@"%@", [userDetailInfo objectForKey:@"role_cid"]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Checkin",@"ac",
                          @"3",@"v",
                          @"teacherRecords", @"op",
                          cid, @"cid",
                          _teacherUid, @"teacher",
                          _checkinDate, @"month",
                          nil];
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            NSArray *list = [message objectForKey:@"records"];
            
            // flag 0 进校，1 出校
            // status 0 正常 1 迟到或早退
            
            //            {
            //                date = "2016-09-13";
            //                list =     (
            //                            {
            //                                ccid = 11;
            //                                date = "2016-09-13";
            //                                dateline = 1473741421;
            //                                flag = 1;
            //                                id = 10;
            //                                sid = 5303;
            //                                status = 0;
            //                            },
            //                            {
            //                                ccid = 11;
            //                                date = "2016-09-13";
            //                                dateline = 1473741421;
            //                                flag = 1;
            //                                id = 12;
            //                                sid = 5303;
            //                                status = 0;
            //                            }
            //                            );
            //                status = 0;
            //            },
            
            if (0 == [list count]) {
                //                [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }else {
                [Utilities dismissNodataView:_tableView];
                
                _recordsArray = [NSMutableArray arrayWithArray:list];
                
                
            }
            
            if (nil == _calendarMenuView) {
                // 获取当天的数据
                NSString *dateSrt = [self checkinDateWhole:[NSDate date]];
                
                if (0 == [_recordsArray count]) {
                    [_dayRecordArray removeAllObjects];
                }else {
                    for (id dayRecord in _recordsArray) {
                        NSDictionary *dayRecordDic = [NSDictionary dictionaryWithDictionary:dayRecord];
                        NSString *day = [dayRecordDic objectForKey:@"date"];
                        
                        if ([dateSrt isEqualToString:day]) {
                            _dayRecordArray = [NSMutableArray arrayWithArray:[dayRecordDic objectForKey:@"list"]];
                        }else {
                            [_dayRecordArray removeAllObjects];
                        }
                    }
                }
                
                [_tableView reloadData];
                
                [self showContent];
            }else {
                //                [_calendarManager setDate:_dateSelected];
                
                [self performSelector:@selector(ppp) withObject:nil afterDelay:0.05];
            }
            
            if (0 == [_dayRecordArray count]) {
                _noCheckinDataView.hidden = NO;
            }else {
                _noCheckinDataView.hidden = YES;
            }
            
            if (0 != ((NSString *)[message objectForKey:@"count"]).integerValue) {
                if (_isStudent) {
                    NSString *lateCnt = [NSString stringWithFormat:@"%@%@天", _summaryCheckin, [message objectForKey:@"count"]];
                    NSString *cnt = [NSString stringWithFormat:@"%@", [message objectForKey:@"count"]];
                    
                    NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:lateCnt];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0,4)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(5,cnt.length)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(5+cnt.length,1)];
                    
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 6)];
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(7,1)];
                    
                    [_briefLabel setAttributedText:pstr];
                    
                }else {
                    NSString *lateCnt = [NSString stringWithFormat:@"%@%@天", _summaryCheckin, [message objectForKey:@"count"]];
                    NSString *cnt = [NSString stringWithFormat:@"%@", [message objectForKey:@"count"]];
                    
                    NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:lateCnt];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0,6)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(7,cnt.length)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(7+cnt.length,1)];
                    
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 6)];
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(7,1)];
                    
                    [_briefLabel setAttributedText:pstr];
                }
            }else {
                _briefLabel.text = [NSString stringWithFormat:@"%@0天", _summaryCheckin];
            }
        } else {
            [Utilities showTextHud:@"获取信息错误，请稍候再试。" descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        if (nil == _calendarMenuView) {
            [self showContent];
        }
        
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)checkinRecords {
    [Utilities showProcessingHud:self.view];
    
    NSMutableDictionary *userDetailInfo = [[GlobalSingletonUserInfo sharedGlobalSingleton] getUserDetailInfo];
    NSString *cid = [NSString stringWithFormat:@"%@", [userDetailInfo objectForKey:@"role_cid"]];
    
    /**
     * 学生打卡记录
     * v=3 ac=Checkin op=studentRecords sid= cid= uid= student=学生ID month=201609
     */
    
    NSDictionary *data;
    if (_isStudent) {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                @"Checkin",@"ac",
                @"3",@"v",
                @"studentRecords", @"op",
                cid, @"cid",
                _checkinDate, @"month",
                _teacherUid, @"student",
                nil];
    }else {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                @"Checkin",@"ac",
                @"3",@"v",
                @"teacherRecords", @"op",
                cid, @"cid",
                _teacherUid, @"teacher",
                _checkinDate, @"month",
                nil];
    }
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"MyCheckinHome  cid = %@ month = %@  student = %@",cid,_checkinDate,_teacherUid);
        NSLog(@"MyCheckinHome  Data = %@",respDic);
        
        if(true == [result intValue]) {
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            NSArray *list = [message objectForKey:@"records"];
            
            // flag 0 进校，1 出校
            // status 0 正常 1 迟到或早退
            
            //            {
            //                date = "2016-09-13";
            //                list =     (
            //                            {
            //                                ccid = 11;
            //                                date = "2016-09-13";
            //                                dateline = 1473741421;
            //                                flag = 1;
            //                                id = 10;
            //                                sid = 5303;
            //                                status = 0;
            //                            },
            //                            {
            //                                ccid = 11;
            //                                date = "2016-09-13";
            //                                dateline = 1473741421;
            //                                flag = 1;
            //                                id = 12;
            //                                sid = 5303;
            //                                status = 0;
            //                            }
            //                            );
            //                status = 0;
            //            },
            
            if (0 == [list count]) {
                //                [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }else {
                [Utilities dismissNodataView:_tableView];
                
                _recordsArray = [NSMutableArray arrayWithArray:list];
                
            }
            
            if (nil == _calendarMenuView) {
                // 获取当天的数据
                NSString *dateSrt = [self checkinDateWhole:[NSDate date]];
                
                if (0 == [_recordsArray count]) {
                    [_dayRecordArray removeAllObjects];
                    [thumbArray removeAllObjects];
                }else {
                    for (id dayRecord in _recordsArray) {
                        NSDictionary *dayRecordDic = [NSDictionary dictionaryWithDictionary:dayRecord];
                        NSString *day = [dayRecordDic objectForKey:@"date"];
                        
                        if ([dateSrt isEqualToString:day]) {
                            _dayRecordArray = [NSMutableArray arrayWithArray:[dayRecordDic objectForKey:@"list"]];
                            thumbArray = [NSMutableArray arrayWithArray:[dayRecordDic objectForKey:@"list"]];
                        }else {
                            [_dayRecordArray removeAllObjects];
                            [thumbArray removeAllObjects];
                        }
                    }
                }
                
                [_tableView reloadData];
                
                [self showContent];
            }else {
                //                [_calendarManager setDate:_dateSelected];
                
                [self performSelector:@selector(ppp) withObject:nil afterDelay:0.05];
            }
            
            if (0 == [_dayRecordArray count]) {
                _noCheckinDataView.hidden = NO;
            }else {
                _noCheckinDataView.hidden = YES;
            }
            
            if (0 != ((NSString *)[message objectForKey:@"count"]).integerValue) {
                if (_isStudent) {
                    NSString *lateCnt = [NSString stringWithFormat:@"%@%@天", _summaryCheckin, [message objectForKey:@"count"]];
                    NSString *cnt = [NSString stringWithFormat:@"%@", [message objectForKey:@"count"]];
                    
                    NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:lateCnt];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0,4)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(5,cnt.length)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(5+cnt.length,1)];
                    
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 6)];
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(5,1)];
                    
                    [_briefLabel setAttributedText:pstr];
                    
                }else {
                    NSString *lateCnt = [NSString stringWithFormat:@"%@%@天", _summaryCheckin, [message objectForKey:@"count"]];
                    NSString *cnt = [NSString stringWithFormat:@"%@", [message objectForKey:@"count"]];
                    
                    NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:lateCnt];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0,6)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(7,cnt.length)];
                    [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(7+cnt.length,1)];
                    
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 6)];
                    [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(7,1)];
                    
                    [_briefLabel setAttributedText:pstr];
                }
            }else {
                _briefLabel.text = [NSString stringWithFormat:@"%@0天", _summaryCheckin];
            }
        } else {
            [Utilities showTextHud:@"获取信息错误，请稍候再试。" descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        if (nil == _calendarMenuView) {
            [self showContent];
        }
        
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)ppp {
    //    [_calendarManager reload];
    [_calendarContentView setDate:_calendarContentView.date];
}

- (void)showContent {
    _calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 40)];
    [self.view addSubview:_calendarMenuView];
    
    _calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].applicationFrame.size.width, 280)];
    [self.view addSubview:_calendarContentView];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    UIImageView *briefImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _calendarContentView.frame.origin.y+ _calendarContentView.frame.size.height-20, [UIScreen mainScreen].applicationFrame.size.width, 90)];
    briefImageView.image = [UIImage imageNamed:@"Attendance/checkin_briefBG@2x"];
    [self.view addSubview:briefImageView];
    
    _briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, briefImageView.frame.origin.y + (briefImageView.frame.size.height-30)/2, [UIScreen mainScreen].applicationFrame.size.width, 30)];
    _briefLabel.textAlignment = NSTextAlignmentCenter;
    _briefLabel.font = [UIFont systemFontOfSize:15.0f];
    _briefLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _briefLabel.text = [NSString stringWithFormat:@"%@0天", _summaryCheckin];
    [self.view addSubview:_briefLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              briefImageView.frame.origin.y + briefImageView.frame.size.height - 15,
                                                              [UIScreen mainScreen].applicationFrame.size.width,
                                                              [UIScreen mainScreen].applicationFrame.size.height - _briefLabel.frame.origin.y - _briefLabel.frame.size.height-73 + 15) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _noCheckinDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 60)];
    _noCheckinDataView.hidden = YES;
    [_tableView addSubview:_noCheckinDataView];
    
    _noCheckinLabel = [UILabel new];
    _noCheckinLabel.font = [UIFont systemFontOfSize:15];
    _noCheckinLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _noCheckinLabel.textAlignment = NSTextAlignmentCenter;
    _noCheckinLabel.textColor = TS_COLOR_FONT_DETAIL_RGB153;
    _noCheckinLabel.text = @"当前日期无签到记录";
    
    [_noCheckinDataView addSubview:_noCheckinLabel];
    
    [_noCheckinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_top).with.offset(0);
        make.left.equalTo(_tableView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 51));
    }];
    
    _bottomLineImageView = [UIImageView new];
    _bottomLineImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bottomLineImageView.backgroundColor = TS_COLOR_TABLEVIEW_SEPARATOR_RGB;
    [_noCheckinDataView addSubview:_bottomLineImageView];
    
    [_bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noCheckinLabel.mas_bottom).with.offset(-0.5);
        make.left.equalTo(_noCheckinLabel.mas_left).with.offset(18);
        make.right.equalTo(_noCheckinDataView.mas_right).with.offset(-18);
        
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    
    
}

#pragma mark - Buttons callback
- (IBAction)didGoTodayTouch {
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch {
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate
// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    NSString *hasRecord = [self haveEarlyLeaveEventForDay:dayView.date];
    if(nil != hasRecord){
        if (_isStudent) {
            // 学生身份只要是有记录就显示对号
            dayView.dotView.hidden = NO;
        }else {
            if (hasRecord.integerValue) {
                NSLog(@"%@", dayView.date);
                
                dayView.earlyLeaveView.hidden = NO;
                dayView.dotView.hidden = YES;
            }else {
                dayView.earlyLeaveView.hidden = YES;
                dayView.dotView.hidden = NO;
            }
        }
    }
    else{
        dayView.earlyLeaveView.hidden = YES;
        dayView.dotView.hidden = YES;
    }
    
    // 如果是今天则把数字标蓝色
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        
        if (!_isStudent) {
            dayView.dotView.hidden = YES;
        }
        dayView.earlyLeaveView.hidden = YES;
    }else {
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    // 如果是学生的考勤的话，不显示迟到或者早退
    if (_isStudent) {
        dayView.earlyLeaveView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
#if 0
    NSLog(@"%@", _dateSelected);
    
    // 获取时间戳并且转化成字符串
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
    NSDate *myDate = [NSDate date];
    // 打印出来的时间是格林威治时间,想差8个小时,但是把这个时间转成字符串就是正确的北京时间
    NSLog(@"currentTime is ---- %@", _dateSelected); // 格林威治时间
    [myFormatter setDateFormat:@"年月日是:yyyy-MM-dd 时分秒是:HH:mm:ss"];
    // 把时间戳转成字符串
    NSString *currentTimeStr = [myFormatter stringFromDate:_dateSelected];
    
    NSLog(@"curremtTimeStr is ------%@", currentTimeStr); // 按字符串打印不会有时差
#endif
    
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    NSString *dateSrt = [self checkinDateWhole:dayView.date];
    
    if (0 == [_recordsArray count]) {
        [_dayRecordArray removeAllObjects];
        [thumbArray removeAllObjects];
    }else {
        for (id dayRecord in _recordsArray) {
            NSDictionary *dayRecordDic = [NSDictionary dictionaryWithDictionary:dayRecord];
            NSString *day = [dayRecordDic objectForKey:@"date"];
            
            if ([dateSrt isEqualToString:day]) {
                _dayRecordArray = [NSMutableArray arrayWithArray:[dayRecordDic objectForKey:@"list"]];
                thumbArray = [NSMutableArray arrayWithArray:[dayRecordDic objectForKey:@"list"]];
                break;
            }else {
                [_dayRecordArray removeAllObjects];
                [thumbArray removeAllObjects];
            }
        }
    }
    
    if (0 == [_dayRecordArray count]) {
        _noCheckinDataView.hidden = NO;
    }else {
        _noCheckinDataView.hidden = YES;
    }
    
    [_tableView reloadData];
}

- (void)createMinAndMaxDate {
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-60];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:1];
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    NSLog(@"Next page loaded");
    
    //    [_dayRecordArray removeAllObjects];
    //    [_tableView reloadData];
    //
    //    [_calendarContentView loadNextPageWithAnimation];
    
    
    _dateSelected = nil;
    
    [_dayRecordArray removeAllObjects];
    [thumbArray removeAllObjects];
    [_tableView reloadData];
    
    [self checkinDate:calendar.date];
    [self checkinRecords];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    NSLog(@"Previous page loaded");
    
    //    [_dayRecordArray removeAllObjects];
    //    [_tableView reloadData];
    //
    //    [_calendarContentView loadPreviousPageWithAnimation];
    
    _dateSelected = nil;
    
    [_dayRecordArray removeAllObjects];
    [thumbArray removeAllObjects];
    [_tableView reloadData];
    
    [self checkinDate:calendar.date];
    [self checkinRecords];
    
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (NSString *)haveEarlyLeaveEventForDay:(NSDate *)date {
    NSString *dateSrt = [self checkinDateWhole:date];
    
    //    [dateSrt isEqualToString:@"2016-09-10"]
    
    for (id dayRecord in _recordsArray) {
        NSDictionary *dayRecordDic = [NSDictionary dictionaryWithDictionary:dayRecord];
        NSString *day = [dayRecordDic objectForKey:@"date"];
        
        if ([dateSrt isEqualToString:day]) {
            NSString *status = [NSString stringWithFormat:@"%@", [dayRecordDic objectForKey:@"status"]];
            
            return status;
        }
        //        else {
        //            return nil;
        //        }
    }
    
    return nil;
    
    
#if 0
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [(NSArray *)_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
#endif
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dayRecordArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dic = [_dayRecordArray objectAtIndex:indexPath.row];
    if ( ![[Utilities replaceNull:[dic objectForKey:@"img_url"]]isEqualToString:@""]) {
        return 44 + 80;
    }else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [Utilities transformationHeight:15/2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    
    NSDictionary* dic = [_dayRecordArray objectAtIndex:row];
    
    MyCheckinHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[MyCheckinHomeTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    Utilities *util = [Utilities alloc];
    cell.checkinTimeLabel.text = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@:%@" andType:DateFormat_HM];
    
    if (0 == ((NSString *)[dic objectForKey:@"flag"]).integerValue) {
        cell.checkinContentLabel.text = @"入园";
        
        if (0 == ((NSString *)[dic objectForKey:@"status"]).integerValue) {
            cell.checkinStatusImageView.hidden = YES;
        }else {
            cell.checkinStatusImageView.hidden = NO;
            cell.checkinStatusImageView.image = [UIImage imageNamed:@"Attendance/checkin_icon_late@2x"];
        }
    }else {
        cell.checkinContentLabel.text = @"离园";
        
        if (0 == ((NSString *)[dic objectForKey:@"status"]).integerValue) {
            cell.checkinStatusImageView.hidden = YES;
        }else {
            cell.checkinStatusImageView.hidden = NO;
            cell.checkinStatusImageView.image = [UIImage imageNamed:@"Attendance/checkin_icon_early@2x"];
        }
    }
    
    
    if ( ![[Utilities replaceNull:[dic objectForKey:@"img_url"]]isEqualToString:@""]) {
        [cell.imgLogo sd_setImageWithURL:[dic objectForKey:@"img_url"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:cell.imgLogo];
        [thumbArray setObject:arr atIndexedSubscript:row];
        
        
        cell.imgLogoBut.tag = indexPath.row;
        [cell.imgLogoBut addTarget:self action:@selector(photoSelect:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.imgLogoBut.hidden = NO;
        cell.imgLogo.hidden = NO;
    } else {
        cell.imgLogoBut.hidden = YES;
        cell.imgLogo.hidden = YES;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:[dic objectForKey:@"date"]];
    
    // 如果是今天则不显示迟到或者早退
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:date]){
        cell.checkinStatusImageView.hidden = YES;
    }
    
    // 如果是学生的考勤的话，不显示迟到或者早退
    if (_isStudent) {
        cell.checkinStatusImageView.hidden = YES;
    }
    
    return  cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
}

- (NSString *)checkinDate:(NSDate *)date {
    NSDateComponents *componentsCurrentDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSInteger month = componentsCurrentDate.month;
    NSString *monthStr = [NSString stringWithFormat:@"%ld", (long)month];
    if (1 == monthStr.length) {
        monthStr = [NSString stringWithFormat:@"0%ld", (long)month];
    }
    
    NSInteger year = componentsCurrentDate.year;
    
    _checkinDate = [NSString stringWithFormat:@"%ld%@", (long)year, monthStr];
    
    return _checkinDate;
}

- (NSString *)checkinDateWhole:(NSDate *)date {
    NSDateComponents *componentsCurrentDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSInteger month = componentsCurrentDate.month;
    NSString *monthStr = [NSString stringWithFormat:@"%ld", (long)month];
    if (1 == monthStr.length) {
        monthStr = [NSString stringWithFormat:@"0%ld", (long)month];
    }
    
    NSInteger year = componentsCurrentDate.year;
    
    NSInteger day = componentsCurrentDate.day;
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)day];
    if (1 == dayStr.length) {
        dayStr = [NSString stringWithFormat:@"0%ld", (long)day];
    }
    
    _checkinDate = [NSString stringWithFormat:@"%ld-%@-%@", (long)year, monthStr, dayStr];
    
    return _checkinDate;
}

-(void)photoSelect:(UIButton *)button{
    
    NSDictionary* dic = [_dayRecordArray objectAtIndex:button.tag];
    
    NSMutableArray *picAry = @[[dic objectForKey:@"img_url"]].copy;
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = 0;
    // 设置所有的图片。photos是一个包含所有图片的数组。
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[picAry count]];
    
    for (int i = 0; i<[picAry count]; i++) {
        
        NSString *pic_url = [picAry objectAtIndex:i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        photo.save = NO;
        photo.url = [NSURL URLWithString:pic_url]; // 图片路径
        photo.srcImageView = [thumbArray[button.tag] objectAtIndex:i]; // 来源于哪个UIImageView
        
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    [browser show];
    
}

@end
