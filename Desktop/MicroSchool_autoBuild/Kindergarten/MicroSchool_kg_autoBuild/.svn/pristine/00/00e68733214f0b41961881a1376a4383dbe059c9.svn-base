//
//  HomeworkForTeacherViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HomeworkForTeacherViewController.h"
#import "HomeworkSubmitViewController.h"
#import "DiscussDetailViewController.h"
#import "SubmitHWViewController.h"


@interface HomeworkForTeacherViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation HomeworkForTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MyTabBarController setTabBarHidden:YES];
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_titleName];
    [self setCustomizeRightButton:@"icon_edit_forums.png"];//老师可以发表作业
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    _rightTableView.hidden = YES;
    _leftTableView.hidden = YES;
    _segmentControl.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyHomework) name:@"refreshMyHomework" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeworkAnswer:) name:@"refreshHomeworkAnswer" object:nil];
    
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    if (_refreshHeaderViewL && [_refreshHeaderViewL superview]) {
        [_refreshHeaderViewL removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    _refreshHeaderViewL = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderViewL.delegate = self;
    
    _leftTableView.tableFooterView = [[UIView alloc]init];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView addSubview:_refreshHeaderViewL];
    
    _rightTableView.tableFooterView = [[UIView alloc]init];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_rightTableView.delaysContentTouches = NO;
    [_rightTableView addSubview:_refreshHeaderView];
    
    tidList =[[NSMutableArray alloc] init];
    homeworkArray = [[NSMutableArray alloc] init];
    homworkTimeList = [[NSMutableArray alloc] init];
    heightArray = [[NSMutableArray alloc]init];
    
    tidList_left =[[NSMutableArray alloc] init];
    homeworkArray_left = [[NSMutableArray alloc] init];
    homworkTimeList_left = [[NSMutableArray alloc] init];
    heightArray_left = [[NSMutableArray alloc]init];
    finishTimesArray = [[NSMutableArray alloc] init];
    
    isGo = YES;
    
    [self getData:@"0" type:@"left"];
    startNum = @"0";
    startNumLeft = @"0";
    endNum = @"20";
    reflashFlag = 1;
    isReflashViewType = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
  
    if ([_spaceForClass integerValue] == 1) {
        
        SubmitHWViewController *submitViewC = [[SubmitHWViewController alloc]init];
        submitViewC.cid = _cid;
        submitViewC.titleName = _titleName;
        submitViewC.spaceForClass = _spaceForClass;
        [self.navigationController pushViewController:submitViewC animated:YES];
        
    }else{//班级未绑定学籍去老版作业
#if 1
        HomeworkSubmitViewController *submitViewCtrl = [[HomeworkSubmitViewController alloc] init];
        [self.navigationController pushViewController:submitViewCtrl animated:YES];
#endif
        
    }
  
}

-(void)segmentAction:(UISegmentedControl *)Seg{

    NSInteger index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li", (long)index);
    
    [self showView:index];
}

// 切换tab不重新刷新数据 2015.11.24 志伟确认
-(void)showView:(NSInteger)index{
    
    if (index == 0) {
        
        _rightTableView.hidden = YES;
        
        if (isPublishRefresh == 1) {
            [self loadData:@"0" type:@"left"];
        }else{
            if ([homeworkArray_left count] > 0) {
                _leftTableView.hidden = NO;
            }else{
                startNumLeft = @"0";
                [self loadData:@"0" type:@"left"];
            }
        }
        
        [ReportObject event:ID_OPEN_TODAY_HOMEWORK];//2016.02.26
        
    }else{
        
        _leftTableView.hidden = YES;
        
        if (isPublishRefresh == 1){
            [self loadData:@"0" type:@"right"];
        }else{
            if ([homeworkArray count] > 0) {
                _rightTableView.hidden = NO;
            }else{
                startNum = @"0";
                [self loadData:@"0" type:@"right"];
            }
        }
        
    
    }
    
}


-(void)getData:(NSString*)index type:(NSString*)type{
    
    [Utilities showProcessingHud:self.view];
    [self loadData:index type:type];
}

/* 新版作业列表接口
 * @author luke
 * @date 2015.12.09
 * @args
 *  v=1, ac=Homework, op=homeworks, sid=, uid=, cid=, page=, size=, subview=
 * 返回结构体：采用新版分页方式（count=0)
 */
-(void)loadData:(NSString*)index type:(NSString*)type{
    
    
    if ([type isEqualToString:@"right"]) {
        
        [_refreshHeaderView refreshLastUpdatedDate];
        

        
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              REQ_URL, @"url",
//                              @"1",@"v",
//                              @"Homework",@"ac",
//                              @"homeworks",@"op",
//                              _cid,@"cid",
//                              @"me",@"subview",
//                              index,@"page",
//                              @"20",@"size",
//                              nil];
        /**
         * 我发布的作业 2.9.4
         * @author luke
         * @date 2016.01.28
         * @args
         *  v=3 ac=HomeworkTeacher op=mine sid=5303 cid=6735 uid=6939 page=0 size=10
         */
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"3",@"v",
                              @"HomeworkTeacher",@"ac",
                              @"mine",@"op",
                              _cid,@"cid",
                              index,@"page",
                              @"20",@"size",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            
            _rightTableView.hidden = NO;
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            NSLog(@"respDic:%@",respDic);
            
            if(true == [result intValue])
            {
                isPublishRefresh = 0;
                
                NSDictionary *message_info = [respDic objectForKey:@"message"];
                
                NSArray *temp = [message_info objectForKey:@"list"];
                
                if ([startNum integerValue] == 0) {
                    
                    [homeworkArray removeAllObjects];
                    [tidList removeAllObjects];
                    [homworkTimeList removeAllObjects];
                    //[];
                }
               
                for (NSObject *object in temp)
                {
                    [homeworkArray addObject:object];
                    
                    NSDictionary *aaa = (NSDictionary *)object;
                    [tidList addObject:[aaa objectForKey:@"tid"]];
                    
                    NSString *datelineStr = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"dateline"]];
                    
                    NSString *dateline = [[[Utilities alloc] init] linuxDateToString:datelineStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
                    
                    [homworkTimeList addObject:dateline];
                    
                }
                
                [heightArray removeAllObjects];
                
                for (int i = 0; i<[homworkTimeList count]; i++) {
                    
                    NSString *height = @"60";
                    
                    NSString *dateline = [homworkTimeList objectAtIndex:i];
                    
                    if (i+1 < [homworkTimeList count]) {
                        
                        NSString *tempDateline = [homworkTimeList objectAtIndex:i+1];
                        
                        if (![dateline isEqualToString:tempDateline]) {
                            
                            height = @"75";
                        }
                    }
                    
                    [heightArray addObject:height];
                    
                }
                
                startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];
                
                if ([homeworkArray count]>0) {
                     [[_rightTableView viewWithTag:124] removeFromSuperview];
                    
                    if ([[NSString stringWithFormat:@"%@",[message_info objectForKey:@"last"]] isEqualToString:@""] || [message_info objectForKey:@"last"] == nil) {
                        
                    }else{
                        
                        NSString *idStr = [message_info objectForKey:@"last"];
                        [Utilities updateClassRedPoints:_cid last:idStr mid:_mid];
                    }
                    
                }else{
                    
                    if ([_rightTableView viewWithTag:124]) {
                        
                    }else{
                        
                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44.0 - 47.0);
                        noDataView = [Utilities showNodataView:@"暂无作业" msg2:@"" andRect:rect imgName:@"nodata_home.png"];
                        noDataView.tag = 124;
                        [_rightTableView addSubview:noDataView];
 
                        
                        
                    }
                    
                }
            }
            else
            {
                NSString *message_info = [respDic objectForKey:@"message"];
                
                [Utilities showFailedHud:message_info descView:self.view];
            }
            
            //刷新表格内容
            [_rightTableView reloadData];
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            
        }];
    }else{
        
        _rightTableView.hidden = YES;
        
        [_refreshHeaderViewL refreshLastUpdatedDate];
        
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              REQ_URL, @"url",
//                              @"1",@"v",
//                              @"Homework",@"ac",
//                              @"homeworks",@"op",
//                              _cid,@"cid",
//                              @"all",@"subview",
//                              index,@"page",
//                              @"20",@"size",
//                              nil];
        
        /**
         * 全部作业列表 2.9.4
         * @author luke
         * @date 2016.01.28
         * @args
         *  v=3 ac=HomeworkTeacher op=items sid=5303 cid=6735 uid=6939 page=0 size=10
         */
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"3",@"v",
                                      @"HomeworkTeacher",@"ac",
                                      @"items",@"op",
                                      _cid,@"cid",
                                      index,@"page",
                                      @"20",@"size",
                                      nil];
        
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            
            _segmentControl.hidden = NO;
            _leftTableView.hidden = NO;
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            NSLog(@"respDic:%@",respDic);
            
            if(true == [result intValue])
            {
                NSDictionary *message_info = [respDic objectForKey:@"message"];
                
                NSArray *temp = [message_info objectForKey:@"list"];
                
                if ([startNumLeft integerValue] == 0) {
                    
                    [homeworkArray_left removeAllObjects];
                    [tidList_left removeAllObjects];
                    [homworkTimeList_left removeAllObjects];
//                    [finishTimesArray removeAllObjects];
                }
                [finishTimesArray removeAllObjects];
                
                for (NSObject *object in temp)
                {
                    [homeworkArray_left addObject:object];
                    
                    NSDictionary *aaa = (NSDictionary *)object;
                    [tidList_left addObject:[aaa objectForKey:@"tid"]];
                    
                    NSString *datelineStr = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"dateline"]];
                    
                    NSString *dateline = [[[Utilities alloc] init] linuxDateToString:datelineStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
                    
                    [homworkTimeList_left addObject:dateline];
                    
//                    NSString *times = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"times"]];
//                    [finishTimesArray addObject:times];
                    
                }
                
                [heightArray_left removeAllObjects];
                
                for (int i=0; i<[homeworkArray_left count]; i++) {
                    
                    NSDictionary *aaa = [homeworkArray_left objectAtIndex:i];
                    NSString *times = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"times"]];
                    [finishTimesArray addObject:times];
                    
                }
               
                
                hasNext = [[message_info objectForKey:@"hasNext"] boolValue];

                NSInteger finishTime = 0;
                for (int i = 0; i<[homworkTimeList_left count]; i++) {
                    
                    NSString *height = @"60";
                    NSString *dateline = [homworkTimeList_left objectAtIndex:i];
                    NSInteger time = [[finishTimesArray objectAtIndex:i] integerValue];
                   
                    if (i+1 < [homworkTimeList_left count]) {
                        
                        finishTime = finishTime+time;
                        
                        NSString *tempDateline = [homworkTimeList_left objectAtIndex:i+1];
                        
                        if (![dateline isEqualToString:tempDateline]) {
                            
                            //height = @"75";
                            height = @"115";
                            [finishTimesArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)finishTime]];
                            finishTime = 0;
                            
                        }
                    }else if (i == [homworkTimeList_left count] - 1){//heightArray_left的最后一条并且不是只有一条
                        
                        if ([homeworkArray_left count] > 1) {
                            
                            NSString *tempDateline = [homworkTimeList_left objectAtIndex:i-1];//前一条的日期
                            if (![dateline isEqualToString:tempDateline]){
                                
                                if (!hasNext) {//没有下一页 此条就是所有数据中最后一条
                                    
                                    height = @"115";
                                    
                                    [finishTimesArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)finishTime]];
                                    finishTime = 0;

                                    
                                }else{
                                    
                                }
                                
                                
                            }else{
                               
                                finishTime = finishTime+time;
                                
                                if (!hasNext) {//没有下一页 此条就是所有数据中最后一条
                                    
                                    height = @"115";
                                    
                                    [finishTimesArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)finishTime]];
                                    
                                    
                                }else{
                                    
                                }
                                
                            }

                        }else{
                            
                            height = @"115";
                            finishTime = time;
                        }
                        
                    }
                    
                    [heightArray_left addObject:height];
                    
                }
                
                startNumLeft = [NSString stringWithFormat:@"%ld",(startNumLeft.integerValue + 10)];
                
                if ([homeworkArray_left count]>0) {
                    
                    [[_leftTableView viewWithTag:123] removeFromSuperview];
                  
                    if ([[NSString stringWithFormat:@"%@",[message_info objectForKey:@"last"]] isEqualToString:@""] || [message_info objectForKey:@"last"] == nil) {
                        
                    }else{
                        
                        NSString *idStr = [message_info objectForKey:@"last"];
                        [Utilities updateClassRedPoints:_cid last:idStr mid:_mid];
                    }
                    
                }else{
                    
                    if ([_leftTableView viewWithTag:123]) {
                        
                    }else{
                       
                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44.0 - 47.0);
                        noDataView = [Utilities showNodataView:@"暂未发布作业" msg2:@"" andRect:rect imgName:@"nodata_home.png"];
                        noDataView.tag = 123;
                        [_leftTableView addSubview:noDataView];
                        
                        
                        
                    }
                    
                }
            }
            else
            {
                NSString *message_info = [respDic objectForKey:@"message"];
                
                [Utilities showFailedHud:message_info descView:self.view];
            }
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];
            //刷新表格内容
            [_leftTableView reloadData];
            

            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            
        }];
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTableView) {
        return YES;
 
    }else{
        return NO;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED{
    
    NSLog(@"willBeginEditingRowAtIndexPath");
    isGo = NO;
    
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED{
    
    NSLog(@"didEndEditingRowAtIndexPath");
    isGo = YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete");
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList_left objectAtIndex:indexPath.row] forKey:@"tid"];
//    NSDictionary* list_dic = [homeworkArray_left objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];
    NSDictionary* list_dic = [homeworkArray objectAtIndex:indexPath.row];
    NSString *uid_table= [list_dic objectForKey:@"uid"];
    if ([[Utilities getUniqueUid] isEqualToString:uid_table]) {
        [self reflashHomeworkView:dic];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"非本人发布的内容，您无权删除"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        [_leftTableView reloadData];
    }
    
}

// 删除作业
-(void)reflashHomeworkView:(NSDictionary *)dic
{
    /**
     * 删除本人发布的内容(thread)
     * @author luke
     * @date 2014.12.29
     * @args
     *  ac=Homework, v=1, op=delete, sid=, uid=, tid=
     * @example:
     *
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSLog(@"reflashHomeworkView");
    //    NSDictionary *dic = [notification userInfo];
    NSString *tidStr = [dic objectForKey:@"tid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Homework",@"ac",
                          @"1",@"v",
                          @"delete",@"op",
                          _cid,@"cid",
                          tidStr,@"tid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            //[self refreshView];
            
            isReflashViewType = 1;
            
            if (reflashFlag == 1) {
                NSLog(@"刷新完成");
                startNum = @"0";
                startNumLeft = @"0";
                
                if (_segmentControl.selectedSegmentIndex == 0) {
                    [self loadData:startNumLeft type:@"left"];
                     [self loadData:startNum type:@"right"];
                }else{
                    [self loadData:startNum type:@"right"];
                    [self loadData:startNumLeft type:@"left"];
                    
                }
                
            }
            
            [ReportObject event:ID_DELETE_HOMEWORK];//2016.02.26
        }else{
            
            NSString *msg = [respDic objectForKey:@"message"];
            
            [Utilities showFailedHud:msg descView:self.view];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        
        [Utilities showFailedHud:@"删除失败，请重试" descView:self.view];

        
    }];
    
    
}


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        return [homeworkArray count];// update by kate 2014.12.08
    }else{
        return [homeworkArray_left count];// update by kate 2014.12.08
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _rightTableView) {
        return [[heightArray objectAtIndex:indexPath.row] floatValue];
    }else{
        return [[heightArray_left objectAtIndex:indexPath.row] floatValue];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"HomeworkHomeTableViewCell";
    
    HomeworkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"HomeworkHomeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *list_dic = nil;
    
    if (tableView == _rightTableView) {
        cell.type = @"right";
        list_dic = [homeworkArray objectAtIndex:indexPath.row];
    }else{
        cell.type = @"left";
        list_dic = [homeworkArray_left objectAtIndex:indexPath.row];
    }
    
    cell.delegte = self;
    cell.index = indexPath.row;
    
    //NSString *subject = [list_dic objectForKey:@"subject"];
    NSString *subject = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"title"]]];
    NSString *dateline = [list_dic objectForKey:@"dateline"];
    //NSString *username = [list_dic objectForKey:@"username"];
    NSString *username = [list_dic objectForKey:@"name"];
//    NSString *replynum = [list_dic objectForKey:@"replynum"];
//    NSString *viewnum = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"people"]]];
    NSString *finishNum = [list_dic objectForKey:@"finished"];
    NSString *answer = [list_dic objectForKey:@"answer"];
    //NSString *time = [list_dic objectForKey:@"times"];
//    NSString *time = [finishTimesArray objectAtIndex:indexPath.row];
    
    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];

#if 0
    if (indexPath.row == 0) {
        
        cell.monthLabel.text = [tempDate substringToIndex:3];
        cell.dayLabel.text = [tempDate substringFromIndex:3];
        
    }
    
    if (indexPath.row-1 >= 0) {
        
        cell.monthLabel.text = [tempDate substringToIndex:3];
        cell.dayLabel.text = [tempDate substringFromIndex:3];
        
        NSDictionary *list_dic;
        if (tableView == _rightTableView) {
            list_dic = [homeworkArray objectAtIndex:indexPath.row-1];

        }else {
            list_dic = [homeworkArray_left objectAtIndex:indexPath.row-1];

        }
        NSString *dateline = [list_dic objectForKey:@"dateline"];
        NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        
        if (![tempDate isEqualToString:tempDateB]) {
            
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
           
        }else{
            cell.monthLabel.text = @"";
            cell.dayLabel.text = @"";
            
        }
        
    }
#endif
    
    if (tableView == _leftTableView) {
        
        NSMutableAttributedString *totalTime;
        
        NSString *time = [finishTimesArray objectAtIndex:indexPath.row];
        
        if ([time length] > 0) {
            
            totalTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总预计完成时间 %@ 分钟",time]];
            
            [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] range:NSMakeRange(0,6)];//颜色
            
            [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:63.0/255.0 green:151.0/255.0 blue:238.0/255.0 alpha:1] range:NSMakeRange(8,[time length])];//颜色
            
            [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] range:NSMakeRange([totalTime length]-2,2)];//颜色
            
        }
        
        if (indexPath.row+1 <= [homeworkArray_left count]) {
            
            if (indexPath.row+1 == [homeworkArray_left count]) {
                
                if ([homeworkArray_left count] > 1) {
                
                    NSDictionary *list_dic;
                    list_dic = [homeworkArray_left objectAtIndex:indexPath.row-1];//最后一行的前一行
                    
                    NSString *dateline = [list_dic objectForKey:@"dateline"];
                    NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                    if (![tempDate isEqualToString:tempDateB]) {//最后一行不等于前一行的日期的话
                        
                        cell.monthLabel.text = [tempDate substringToIndex:3];
                        cell.dayLabel.text = [tempDate substringFromIndex:3];
                        
                    }else{
                        
                        cell.monthLabel.text = @"";
                        cell.dayLabel.text = @"";
                        
                    }
                    //没有下一页 此条就是所有数据中最后一条
                    if (!hasNext) {
                        
                        cell.totalTimeView.hidden = NO;
                        //cell.totalTimeLabel.text = [NSString stringWithFormat:@"总预计完成时间 %@ 分钟",time];
                        cell.totalTimeLabel.attributedText = totalTime;
                        cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                        
                    }else{
                        
                        cell.totalTimeView.hidden = YES;
                    }
                    
                }else{
                    
                    cell.monthLabel.text = [tempDate substringToIndex:3];
                    cell.dayLabel.text = [tempDate substringFromIndex:3];
                    cell.totalTimeView.hidden = NO;
                    //cell.totalTimeLabel.text = [NSString stringWithFormat:@"总预计完成时间 %@ 分钟",time];
                    cell.totalTimeLabel.attributedText = totalTime;
                    cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                    
                }
                
                
            }else{
                
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
                
                NSDictionary *list_dic;
                list_dic = [homeworkArray_left objectAtIndex:indexPath.row+1];
                
                NSString *dateline = [list_dic objectForKey:@"dateline"];
                NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                
                if ([tempDate isEqualToString:tempDateB]) {
                    
                    if (indexPath.row-1 >= 0) {
                        
                        NSDictionary *list_dic;
                        list_dic = [homeworkArray_left objectAtIndex:indexPath.row-1];
                        NSString *dateline = [list_dic objectForKey:@"dateline"];
                        NSString *tempDateC = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                        
                        if ([tempDate isEqualToString:tempDateC]) {
                            
                            cell.monthLabel.text = @"";
                            cell.dayLabel.text = @"";
                            
                        }
                        
                    }
                   
                    cell.totalTimeView.hidden = YES;
                    
                }else{//不相等就是这个分组的最后一行
                    
                    if (indexPath.row-1 >= 0) {
                        
                        NSDictionary *list_dic;
                        list_dic = [homeworkArray_left objectAtIndex:indexPath.row-1];
                        NSString *dateline = [list_dic objectForKey:@"dateline"];
                        NSString *tempDateC = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                        
                        if ([tempDate isEqualToString:tempDateC]) {
                            
                            cell.monthLabel.text = @"";
                            cell.dayLabel.text = @"";
                            
                        }
                        
                    }
                    
                    cell.totalTimeView.hidden = NO;
                    //cell.totalTimeLabel.text = [NSString stringWithFormat:@"总预计完成时间 %@ 分钟",time];
                    cell.totalTimeLabel.attributedText = totalTime;
                    cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                    
                }
            }
            

        }
        
    }else{//我发布的
        
        cell.totalTimeView.hidden = YES;
        
        if (indexPath.row == 0) {
            
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
            
        }
        
        if (indexPath.row-1 >= 0) {
            
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
            
            NSDictionary *list_dic;
            if (tableView == _rightTableView) {
                list_dic = [homeworkArray objectAtIndex:indexPath.row-1];
                
            }else {
                list_dic = [homeworkArray_left objectAtIndex:indexPath.row-1];
                
            }
            NSString *dateline = [list_dic objectForKey:@"dateline"];
            NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
            
            if (![tempDate isEqualToString:tempDateB]) {
                
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
                
            }else{
                cell.monthLabel.text = @"";
                cell.dayLabel.text = @"";
                
            }
            
        }
        
    }
    
    cell.homeNameLabel.text = subject;
//    cell.commentNumLabel.text = replynum;
//    cell.commentNumImgV.image = [UIImage imageNamed:@"commentNumber_home.png"];
#if 0
    if (tableView == _leftTableView){
        cell.publishNameImgV.image = [UIImage imageNamed:@"publishName_home.png"];
        cell.publishNameLabel.text = username;
    }else{
        cell.publishNameImgV.image = nil;
        cell.publishNameLabel.text = @"";
    }
#endif
    
    cell.publishNameImgV.image = [UIImage imageNamed:@"publishName_home.png"];
    cell.publishNameLabel.text = username;
    
    cell.icon_finishImgV.image = [UIImage imageNamed:@"icon_finishNum.png"];
    cell.finishNumLabel.text = finishNum;
    
    if ([answer integerValue] == 1) {
        cell.answerImgV.image = [UIImage imageNamed:@"icon_answer.png"];
        cell.icon_finishImgV.image = [UIImage imageNamed:@"icon_finishNum.png"];
        cell.finishNumLabel.hidden = NO;
    }else{
        cell.answerImgV.image = nil;
        cell.icon_finishImgV.image = nil;
        cell.finishNumLabel.hidden = YES;
    }
    
    //cell.label_viewnum.text = viewnum;
    
//    CGSize strSize = [Utilities getStringHeight:replynum andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];
    
    CGSize strSizeB = [Utilities getStringHeight:username andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];
    
//    CGSize strSizeC = [Utilities getStringHeight:viewnum andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];

    
    //cell.commentNumLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-strSize.width, 38.0, strSize.width, 21.0);
    
    //cell.commentNumImgV.frame = CGRectMake(cell.commentNumLabel.frame.origin.x-3-14.0, 38.0+3, 14.0, 14.0);
    
    //cell.label_viewnum.frame = CGRectMake(cell.commentNumImgV.frame.origin.x - 10-strSizeC.width, 38.0, strSizeC.width, 21.0);
    
    //cell.imgView_viewnum.frame = CGRectMake(cell.label_viewnum.frame.origin.x-3-14.0, 38.0+3, 14.0, 14.0);

    
    //cell.publishNameLabel.frame = CGRectMake(cell.imgView_viewnum.frame.origin.x - 10-strSizeB.width, 38.0, strSizeB.width, 21.0);
    
    cell.publishNameLabel.frame = CGRectMake(cell.publishNameLabel.frame.origin.x, cell.publishNameLabel.frame.origin.y, strSizeB.width, 21.0);
    cell.icon_finishImgV.frame = CGRectMake(cell.publishNameLabel.frame.origin.x+cell.publishNameLabel.frame.size.width+10,cell.icon_finishImgV.frame.origin.y,14.0 ,14.0 );
    cell.finishNumLabel.frame = CGRectMake(cell.icon_finishImgV.frame.origin.x+14.0+5,cell.finishNumLabel.frame.origin.y,cell.finishNumLabel.frame.size.width ,cell.finishNumLabel.frame.size.height);

   
    return cell;
}

/*
 //选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = nil;
    
    if (tableView == _rightTableView || _segmentControl.selectedSegmentIndex == 1){
    
        dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];//update by kate 2014.12.08
    
    }else{
        dic = [NSDictionary dictionaryWithObject:[tidList_left objectAtIndex:indexPath.row] forKey:@"tid"];//update by kate 2014.12.08
    }
    
    // 去班级详情页
    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid =  [dic objectForKey:@"tid"];
    [disscussDetailViewCtrl setFlag:3];
    disscussDetailViewCtrl.disTitle = _titleName;
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
    
}*/

// cell的delegate回调
-(void)gotoHomeDetail:(NSInteger)index type:(NSString*)type{
    
    // isGo用于解决button点击事件与左划事件冲突
    if (isGo) {
        
        NSDictionary *dic = nil;
       
        if ([type isEqualToString:@"right"]){
            
            dic = [homeworkArray objectAtIndex:index];//update by kate 2014.12.08
            
        }else{
            dic = [homeworkArray_left objectAtIndex:index];//update by kate 2014.12.08
        }
        
        // 1 或 5 1是旧版作业 5是新版作业
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]] integerValue] == 5) {
            //新版本作业详情
            HomeworkDetailViewController *vc = [[HomeworkDetailViewController alloc] init];
            vc.viewType = @"teacher";
            vc.spaceForClass = _spaceForClass;
            vc.tid = [dic objectForKey:@"tid"];
            vc.cid = self.cid;
            vc.homeworkListIndex = [NSString stringWithFormat:@"%ld",(long)index];
            vc.disTitle = _titleName;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//旧版本作业详情
            // 去班级详情页
            DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
            disscussDetailViewCtrl.tid =  [dic objectForKey:@"tid"];
            [disscussDetailViewCtrl setFlag:3];
            disscussDetailViewCtrl.disTitle = _titleName;
            [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
        }
        
       
    }
    
}

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        startNumLeft = @"0";
        
        if (_segmentControl.selectedSegmentIndex == 0) {
            [self loadData:startNumLeft type:@"left"];
        }else{
            [self loadData:startNum type:@"right"];
        }
        
        
    }
}

-(void)refreshMyHomework{
    
    isReflashViewType = 1;
    _segmentControl.selectedSegmentIndex = 0;
    isPublishRefresh = 1;
    startNum = @"0";
    startNumLeft = @"0";
    [self showView:0];
    
}

//refresh有没有答案的状态
-(void)refreshHomeworkAnswer:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    NSString *index = [dic objectForKey:@"index"];
    NSString *state = [dic objectForKey:@"answer"];
    NSString *title = [dic objectForKey:@"title"];
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        //left
        // 百度的crash日志：NSRangeException fix by beck
        if ((0 != [homeworkArray_left count]) && nil != homeworkArray_left) {
            NSMutableDictionary *homeDic = [[NSMutableDictionary alloc] initWithDictionary:[homeworkArray_left objectAtIndex:[index integerValue]]];
            [homeDic setObject:state forKey:@"answer"];
            [homeDic setObject:title forKey:@"title"];
            
            [homeworkArray_left replaceObjectAtIndex:[index integerValue] withObject:homeDic];
            [_leftTableView reloadData];
        }
    }else{
        //right
        // 百度的crash日志：NSRangeException fix by beck
        if ((0 != [homeworkArray count]) && nil != homeworkArray) {
            NSMutableDictionary *homeDic = [[NSMutableDictionary alloc] initWithDictionary:[homeworkArray objectAtIndex:[index integerValue]]];
            [homeDic setObject:state forKey:@"answer"];
            [homeDic setObject:title forKey:@"title"];
            
            [homeworkArray replaceObjectAtIndex:[index integerValue] withObject:homeDic];
            [_rightTableView reloadData];
        }


    }
    
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        if (_segmentControl.selectedSegmentIndex == 1) {
            
           startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[homeworkArray count]];
           [self loadData:startNum type:@"right"];
        
        }else{
            startNumLeft = [NSString stringWithFormat:@"%lu",(unsigned long)[homeworkArray_left count]];
            [self loadData:startNumLeft type:@"left"];
        }
        
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    if (_segmentControl.selectedSegmentIndex == 1){
        
        //  model should call this when its done loading
        _reloading = NO;
        
        if (_refreshHeaderView) {
            
           [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_rightTableView];
            
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_rightTableView];
            
            [self setFooterView];
        }

        
    }else{
        
        _reloading = NO;
        
        if (_refreshHeaderViewL) {
            [_refreshHeaderViewL egoRefreshScrollViewDataSourceDidFinishedLoading:self->_leftTableView];//3
        }
        
        if (_refreshFooterViewL) {
            
            [_refreshFooterViewL egoRefreshScrollViewDataSourceDidFinishedLoading:self->_leftTableView];

            [self setFooterView];
        }

        
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    if (_segmentControl.selectedSegmentIndex == 1){
        
        CGFloat height = MAX(self->_rightTableView.bounds.size.height, self->_rightTableView.contentSize.height);
        //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
        if (_refreshFooterView && [_refreshFooterView superview])
        {
            // reset position
            _refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self->_rightTableView.frame.size.width,
                                                  self.view.bounds.size.height);
        }else
        {
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.view.frame.size.width, self->_rightTableView.bounds.size.height)];
            //self->_tableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView.delegate = self;
            [self->_rightTableView addSubview:_refreshFooterView];
        }
    }else{
        CGFloat height = MAX(self->_leftTableView.bounds.size.height, self->_leftTableView.contentSize.height);
        //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
        if (_refreshFooterViewL && [_refreshFooterViewL superview])
        {
            // reset position
            _refreshFooterViewL.frame = CGRectMake(0.0f,
                                                  height,
                                                  self->_leftTableView.frame.size.width,
                                                  self.view.bounds.size.height);
        }else
        {
            // create the footerView
            _refreshFooterViewL = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.view.frame.size.width, self->_leftTableView.bounds.size.height)];
            //self->_tableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterViewL.delegate = self;
            [self->_leftTableView addSubview:_refreshFooterViewL];
        }
    }
    
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
    
    if (_refreshFooterViewL)
    {
        [_refreshFooterViewL refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_segmentControl.selectedSegmentIndex == 1){
        
        if (_refreshFooterView && [_refreshFooterView superview])
        {
            [_refreshFooterView removeFromSuperview];
        }
        _refreshFooterView = nil;
        
    }else{
        
        if (_refreshFooterViewL && [_refreshFooterViewL superview])
        {
            [_refreshFooterViewL removeFromSuperview];
        }
        _refreshFooterViewL = nil;
        
    }
    
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
            //[self refreshView];
            [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
        }else if(aRefreshPos == EGORefreshFooter)
        {
            // pull up to load more data
            [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
        }
        
        // overide, the actual loading data operation is done in the subclass
        
        
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_segmentControl.selectedSegmentIndex == 1){
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
        
    }else{
        if (_reloading == NO) {
            if (_refreshHeaderViewL)
            {
                 NSLog(@"did y:%f",scrollView.contentOffset.y);
                [_refreshHeaderViewL egoRefreshScrollViewDidScroll:scrollView];//1
            }
            
            if (_refreshFooterViewL)
            {
                [_refreshFooterViewL egoRefreshScrollViewDidScroll:scrollView];
            }
        }
        
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_segmentControl.selectedSegmentIndex == 1){
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
    }else{
        NSLog(@"y:%f",scrollView.contentOffset.y);
        if (_reloading == NO) {
            if (_refreshHeaderViewL)
            {
                [_refreshHeaderViewL egoRefreshScrollViewDidEndDragging:scrollView];//2
            }
            
            if (_refreshFooterViewL)
            {
                [_refreshFooterViewL egoRefreshScrollViewDidEndDragging:scrollView];
            }
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

@end
