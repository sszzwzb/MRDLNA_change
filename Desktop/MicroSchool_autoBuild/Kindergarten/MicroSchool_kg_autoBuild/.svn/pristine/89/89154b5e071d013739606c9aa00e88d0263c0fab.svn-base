//
//  HealthHistoryViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 15/12/2.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HealthHistoryViewController.h"

@interface HealthHistoryViewController ()

@end

@implementation HealthHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];
    
    if (![Utilities isConnected]) {//2015.12.07
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLoadData)
                                                 name:@"reloadHealthHistoryView"
                                               object:nil];

    _dataArr = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    [self createHeaderView];
    [self doGetHealthHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reLoadData {
    _page = @"0";
    
    [self doGetHealthHistory];
}


- (void)doGetHealthHistory {
    //  *  v=2, ac=Physical, op=conditions, sid=, uid=, cid=, page=, size=
    
    NSString *op = @"";
    NSString *number = @"";

    if ([@"conditions"  isEqual: _viewType]) {
//        [ReportObject event:ID_OPEN_BODY_LIST];

        op = @"conditions";
        number = @"0";
    }else if ([@"scores"  isEqual: _viewType]) {
        [ReportObject event:ID_OPEN_SCORE_HISTORY];

        op = @"scores";
        number = @"0";
    }else if ([@"studentConditions"  isEqual: _viewType]) {
        [ReportObject event:ID_OPEN_BODY_LIST];

        op = @"conditions";
        number = _number;
    }else if ([@"studentScores"  isEqual: _viewType]) {
        [ReportObject event:ID_OPEN_PHYSICAL_LIST];

        op = @"scores";
        number = _number;
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Physical",@"ac",
                          @"2",@"v",
                          op, @"op",
                          _cid, @"cid",
                          _page, @"page",
                          _size, @"size",
                          number, @"number",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            NSArray *list = [message objectForKey:@"list"];
            
            if (0 != [list count]) {
                
                if ([@"scores" isEqualToString:op]) {
                    
                    if ([@"0"  isEqual: _page]) {
                        [_dataArr removeAllObjects];
                        //_dataArr = [NSMutableArray arrayWithArray:list];
                    }else {
                        //[_dataArr addObjectsFromArray:list];
                    }
                    
                    // 已读未读
                    for (NSObject *object in list) {
                        
                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                        NSDictionary *dic = (NSDictionary *)object;
                        
                        [dic1 addEntriesFromDictionary:dic];
                        
                        // 去db里查找是否有该条记录。
                        NSString *readId = @"";
                        if ([_viewType isEqualToString:@"studentScores"]) {
                            readId = [NSString stringWithFormat:@"%@_%@", @"testReportForTeacher", [dic objectForKey:@"pid"]];
                        }else{
                             readId = [NSString stringWithFormat:@"%@_%@", @"testReport", [dic objectForKey:@"pid"]];
                        }
                       
                        NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                        
                        if (nil == dicFromDb) {
                            // db里没有，存入db。
                            ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                            rsObj.readId = readId;
                            rsObj.status = @"0";
                            [rsObj updateToDB];
                            
                            [dic1 setObject:@"0" forKey:@"readStatus"];
                        }else {
                            // db里面有，直接取出来。
                            NSString *status = [dicFromDb objectForKey:@"status"];
                            [dic1 setObject:status forKey:@"readStatus"];
                        }
                        // 与基本信息一起设置到需要显示的数组里面
                        [_dataArr addObject:dic1];
                    }
                    
                }else{
                   
                    if ([@"0"  isEqual: _page]) {
                        [_dataArr removeAllObjects];
                        _dataArr = [NSMutableArray arrayWithArray:list];
                    }else {
                        [_dataArr addObjectsFromArray:list];
                    }
                    
                }
                
                
                _page = [NSString stringWithFormat:@"%d", [_page intValue] + (int)[list count]];
            }
            
            [self performSelector:@selector(finishedLoadData) withObject:nil afterDelay:0.1];
            [_tableView reloadData];
            
            if (0 == [_dataArr count]) {
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                [_noDataView removeFromSuperview];
                _noDataView = [Utilities showNodataView:@"没记录？宝宝不开心了" msg2:@"" andRect:rect imgName:@"noHealthList.png"];
                [_tableView addSubview:_noDataView];
            }else {
                [_noDataView removeFromSuperview];
            }
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        [self performSelector:@selector(finishedLoadData) withObject:nil afterDelay:0.1];
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *GroupedTableIdentifier1 = @"PhysicalRecordTableViewCell";
    static NSString *GroupedTableIdentifier2 = @"TestReportTableViewCell";
    
    NSUInteger section = [indexPath section];
    NSDictionary* list_dic = [_dataArr objectAtIndex:section];
    
    if (([@"conditions"  isEqual: _viewType]) || ([@"studentConditions"  isEqual: _viewType])) {
        PhysicalRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        if(cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"PhysicalRecordTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier1];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.dateLabel.hidden = NO;
        cell.heightTitleLabel.hidden = NO;
        cell.weightTitleLabel.hidden = NO;
        cell.visionTitleLabel.hidden = NO;
        cell.leftEyeTitleLabel.hidden = NO;
        cell.rightEyeTitleLabel.hidden = NO;
        cell.noDataLabel.text = @"";
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
        NSString *height = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"height"]]];
        NSString *weight = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"weight"]]];
        NSDictionary *visionDic =  [list_dic objectForKey:@"vision"];
        
        if (visionDic) {
            NSString *left = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[visionDic objectForKey:@"left"]]];
            NSString *right = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[visionDic objectForKey:@"right"]]];
            cell.leftEyeLabel.text = left;
            cell.rightEyeLabel.text = right;
        }
        
        cell.dateLabel.text = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        cell.heightLabel.text = height;
        cell.weightLabel.text = weight;
        
        
        return cell;
    }else if (([@"scores"  isEqual: _viewType]) || ([@"studentScores"  isEqual: _viewType])) {
        TestReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier2];
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"TestReportTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier2];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier2];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.rankTitleLabel.hidden = NO;
        cell.noDataLabel.hidden = YES;
        
        NSString *title = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"title"]];
        NSString *dateStr = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
        NSDictionary *rankDic = [list_dic objectForKey:@"rank"];
        
        if (rankDic) {
            
            NSString *grade = [NSString stringWithFormat:@"%@",[rankDic objectForKey:@"grade"]];
            
            if ([grade integerValue] == 0) {
                
                cell.RankLabel.text = @"--";
                cell.RankLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
                
            }else{
                NSString *tempStr = [NSString stringWithFormat:@"第%@名",grade];
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tempStr];
                [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(1,[grade length])];//颜色
                cell.RankLabel.attributedText = title;
                
            }
            
        }

        NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"score"]]];
        cell.dateLabel.text = title;
        NSString *updateDate = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
        cell.updateDateLabel.text = [NSString stringWithFormat:@"更新时间：%@",updateDate];
        cell.scoreLabel.text = score;
        
        if ([@"0"  isEqual: [list_dic objectForKey:@"readStatus"]]) {
            // 未读过的
            cell.dateLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
            cell.updateDateLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
            cell.rankTitleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
            
        }else {
            // 读过的
            cell.dateLabel.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
            cell.updateDateLabel.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
            cell.rankTitleLabel.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
        }
        
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        return cell;
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary* list_dic = [_dataArr objectAtIndex:[indexPath section]];
    
    if (([@"conditions"  isEqual: _viewType]) || ([@"studentConditions"  isEqual: _viewType])) {
        HealthDetailViewController *healthDetailV = [[HealthDetailViewController alloc] init];
        healthDetailV.cid = _cid;
        healthDetailV.pid = [list_dic objectForKey:@"pid"];
        healthDetailV.nunmber = _number;
        [self.navigationController pushViewController:healthDetailV animated:YES];
    }else if (([@"scores"  isEqual: _viewType]) || ([@"studentScores"  isEqual: _viewType])) {
        
        // 设置db中的该条数据变为已读
        NSString *readId = @"";
        if ([_viewType isEqualToString:@"studentScores"]) {
            readId = [NSString stringWithFormat:@"%@_%@", @"testReportForTeacher", [list_dic objectForKey:@"pid"]];
        }else{
             readId = [NSString stringWithFormat:@"%@_%@", @"testReport", [list_dic objectForKey:@"pid"]];
        }
       
        ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
        rsObj.readId = readId;
        rsObj.status = @"1";
        [rsObj updateToDB];
        
        // 设置内存中的该条数据变为已读
        NSMutableDictionary* list_dic1 = [_dataArr objectAtIndex:[indexPath section]];
        [list_dic1 setObject:@"1" forKey:@"readStatus"];
        [_dataArr replaceObjectAtIndex:[indexPath section] withObject:list_dic1];
        
        TestReportDetailViewController *testReportDeV = [[TestReportDetailViewController alloc] init];
        testReportDeV.cid = _cid;
        testReportDeV.pid = [list_dic objectForKey:@"pid"];
        testReportDeV.nunmber = _number;
        [self.navigationController pushViewController:testReportDeV animated:YES];
    }
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    [Utilities showProcessingHud:self.view];
    
    _page = @"0";
    _size = @"20";
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)finishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_reloading == NO) {
        [self beginToReloadData:aRefreshPos];
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self->_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    _page = @"0";
    _size = @"20";
    
    [self doGetHealthHistory];
}
//加载调用的方法
-(void)getNextPageView
{
    [self doGetHealthHistory];
}

@end
