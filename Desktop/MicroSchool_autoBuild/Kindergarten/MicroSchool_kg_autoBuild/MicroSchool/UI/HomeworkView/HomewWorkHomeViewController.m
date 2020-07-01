//
//  HomewWorkHomeViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/23.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HomewWorkHomeViewController.h"
#import "DiscussDetailViewController.h"

@interface HomewWorkHomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomewWorkHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MyTabBarController setTabBarHidden:YES];
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    //[self setCustomizeRightButton:@"icon_edit_forums.png"];老师可以发表作业
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeList:) name:@"reloadHomeList" object:nil];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [_tableView addSubview:_refreshHeaderView];
    
    tidList =[[NSMutableArray alloc] init];
    homeworkArray = [[NSMutableArray alloc] init];
    homworkTimeList = [[NSMutableArray alloc] init];
    heightArray = [[NSMutableArray alloc]init];
    finishTimesArray = [[NSMutableArray alloc] init];
    
    [self getData:@"0"];
    startNum = @"0";
    endNum = @"20";
    reflashFlag = 1;
    isReflashViewType = 1;
    
    [ReportObject event:ID_OPEN_TODAY_HOMEWORK];//2016.02.26

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 刷新列表状态 未完成 未批改 已完成 等
-(void)reloadHomeList:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    NSString *index = [dic objectForKey:@"index"];
    NSString *state = [dic objectForKey:@"state"];
    NSString *finished = [dic objectForKey:@"finished"];
    
    NSMutableDictionary *homeDic = [[NSMutableDictionary alloc] initWithDictionary:[homeworkArray objectAtIndex:[index integerValue]]];
    [homeDic setObject:state forKey:@"state"];
    [homeDic setObject:finished forKey:@"finished"];
    
    [homeworkArray replaceObjectAtIndex:[index integerValue] withObject:homeDic];
    [_tableView reloadData];
    
}

-(void)getData:(NSString*)index{
    
    [Utilities showProcessingHud:self.view];
    [self loadData:index];
}

/* 新版作业列表接口
* @author luke
* @date 2015.12.09
* @args
*  v=1, ac=Homework, op=homeworks, sid=, uid=, cid=, page=, size=, subview=
* 返回结构体：采用新版分页方式（count=0)
*/

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          REQ_URL, @"url",
//                          @"1",@"v",
//                          @"Homework",@"ac",
//                          @"homeworks",@"op",
//                          _cid,@"cid",
//                          @"all",@"subview",
//                          index,@"page",
//                          @"20",@"size",
//                          nil];
    /**
     * 学生作业列表
     * @author luke
     * @date 2016.01.28
     * @args
     *  v=3 ac=Homework op=items sid=5303 cid=6735 uid=6939 page=0 size=10
     */
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"3",@"v",
                          @"Homework",@"ac",
                          @"items",@"op",
                          _cid,@"cid",
                          index,@"page",
                          @"20",@"size",
                          nil];
    
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        _tableView.hidden = NO;
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
    
        NSLog(@"respDic:%@",respDic);
        
        //state: 0:未批改 1:我发的 2:已完成 3:未作答
        
        if(true == [result intValue])
        {
            NSDictionary *message_info = [respDic objectForKey:@"message"];

            NSArray *temp = [message_info objectForKey:@"list"];
            
            if (isReflashViewType == 1) {
                
                [homeworkArray removeAllObjects];
                [tidList removeAllObjects];
                [homworkTimeList removeAllObjects];
                
            }
            
            [heightArray removeAllObjects];
            [finishTimesArray removeAllObjects];
            
            for (NSObject *object in temp)
            {
                [homeworkArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [tidList addObject:[aaa objectForKey:@"tid"]];
                
                NSString *datelineStr = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"dateline"]];
                
                NSString *dateline = [[[Utilities alloc] init] linuxDateToString:datelineStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
                
                [homworkTimeList addObject:dateline];
                
//                NSString *times = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"times"]];
//                [finishTimesArray addObject:times];
                
            }
            
            for (int i=0; i<[homeworkArray count]; i++) {
                
                NSDictionary *aaa = [homeworkArray objectAtIndex:i];
                NSString *times = [NSString stringWithFormat:@"%@",[aaa objectForKey:@"times"]];
                [finishTimesArray addObject:times];

            }
            
            hasNext = [[message_info objectForKey:@"hasNext"] boolValue];
            
            NSInteger finishTime = 0;
            
            for (int i = 0; i<[homworkTimeList count]; i++) {
                
                NSString *height = @"60";
                NSString *dateline = [homworkTimeList objectAtIndex:i];
                NSInteger time = [[finishTimesArray objectAtIndex:i] integerValue];
                
                if (i+1 < [homworkTimeList count]) {
                    
                    finishTime = finishTime+time;
                    
                    NSString *tempDateline = [homworkTimeList objectAtIndex:i+1];
                    
                    if (![dateline isEqualToString:tempDateline]) {
                     
                        //height = @"75";
                        height = @"115";
                        [finishTimesArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)finishTime]];
                        finishTime = 0;
                    }
                }else if (i == [homworkTimeList count] - 1){//heightArray_left的最后一条并且不是只有一条
                    
                    if ([homeworkArray count] > 1) {
                        
                        NSString *tempDateline = [homworkTimeList objectAtIndex:i-1];//前一条的日期
                        if (![dateline isEqualToString:tempDateline]){
                            
                            if (!hasNext) {//没有下一页 此条就是所有数据中最后一条
                                
                                height = @"115";
                                
                                [finishTimesArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)finishTime]];
                                finishTime = 0;
                                
                                
                            }else{
                                
                                //height = @"";
                                
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
                
                [heightArray addObject:height];
                
            }
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];
            
            
            if ([homeworkArray count]>0) {
                
                [noDataView removeFromSuperview];
                
                if ([[NSString stringWithFormat:@"%@",[message_info objectForKey:@"last"]] isEqualToString:@""] || [message_info objectForKey:@"last"] == nil) {
                    
                }else{
                    
                    NSString *idStr = [message_info objectForKey:@"last"];
                    [Utilities updateClassRedPoints:_cid last:idStr mid:_mid];
                }
                
            }else{
                
                if ([_tableView viewWithTag:123]) {
                    
                }else{
                    
                    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44.0);
                    noDataView = [Utilities showNodataView:@"暂无作业" msg2:@"" andRect:rect imgName:@"nodata_home.png"];
                    noDataView.tag = 123;
                    [_tableView addSubview:noDataView];
  
                }
                
            }
        }
        else
        {
            NSString *message_info = [respDic objectForKey:@"message"];

            [Utilities showFailedHud:message_info descView:self.view];
        }
        
        //刷新表格内容
        [_tableView reloadData];
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
         [Utilities dismissProcessingHud:self.view];
        
    }];
    

}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [homeworkArray count];// update by kate 2014.12.08
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return [[heightArray objectAtIndex:indexPath.row] floatValue];
    
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
    
    cell.delegte = self;
    cell.index = indexPath.row;

    NSDictionary *list_dic = [homeworkArray objectAtIndex:indexPath.row];
    //NSString *subject = [list_dic objectForKey:@"subject"];
    NSString *subject = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"title"]]];
    NSString *dateline = [list_dic objectForKey:@"dateline"];
    //NSString *username = [list_dic objectForKey:@"username"];
    NSString *username = [list_dic objectForKey:@"name"];
//    NSString *replynum = [list_dic objectForKey:@"replynum"];
//    NSString *viewnum = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[list_dic objectForKey:@"people"]]];
    
    //state: 0:未批改 1:我发的 2:已完成 3:未作答
    NSString *state = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"state"]];
    NSString *finishNum = [list_dic objectForKey:@"finished"];
    NSString *answer = [list_dic objectForKey:@"answer"];
    NSString *time = [finishTimesArray objectAtIndex:indexPath.row];
    
    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
    NSMutableAttributedString *totalTime;
    
    if ([time length] > 0) {
        
       totalTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总预计完成时间 %@ 分钟",time]];
        
        [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] range:NSMakeRange(0,6)];//颜色
        
        [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:63.0/255.0 green:151.0/255.0 blue:238.0/255.0 alpha:1] range:NSMakeRange(8,[time length])];//颜色
        
        [totalTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] range:NSMakeRange([totalTime length]-2,2)];//颜色
        
    }
    
        if (indexPath.row+1 <= [homeworkArray count]) {
            
            if (indexPath.row+1 == [homeworkArray count]) {
                
                if ([homeworkArray count] > 1) {
                    
                    NSDictionary *list_dic;
                    list_dic = [homeworkArray objectAtIndex:indexPath.row-1];//最后一行的前一行
                    
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
                        cell.totalTimeLabel.attributedText = totalTime;
                        cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                        
                    }else{
                        
                        cell.totalTimeView.hidden = YES;
                    }
                    
                }else{
                    
                    cell.monthLabel.text = [tempDate substringToIndex:3];
                    cell.dayLabel.text = [tempDate substringFromIndex:3];
                    cell.totalTimeView.hidden = NO;
                    cell.totalTimeLabel.attributedText = totalTime;
                    cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                    
                }
                
                
            }else{
                
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
                
                NSDictionary *list_dic;
                list_dic = [homeworkArray objectAtIndex:indexPath.row+1];
                
                NSString *dateline = [list_dic objectForKey:@"dateline"];
                NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                
                if ([tempDate isEqualToString:tempDateB]) {
                    
                    if (indexPath.row-1 >= 0) {
                        
                        NSDictionary *list_dic;
                        list_dic = [homeworkArray objectAtIndex:indexPath.row-1];
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
                        list_dic = [homeworkArray objectAtIndex:indexPath.row-1];
                        NSString *dateline = [list_dic objectForKey:@"dateline"];
                        NSString *tempDateC = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                        
                        if ([tempDate isEqualToString:tempDateC]) {
                            
                            cell.monthLabel.text = @"";
                            cell.dayLabel.text = @"";
                            
                        }
                        
                    }
                    
                    cell.totalTimeView.hidden = NO;
                    cell.totalTimeLabel.attributedText = totalTime;
                    cell.bottomBarImgV.frame = CGRectMake(0, cell.totalTimeView.frame.origin.y, cell.bottomBarImgV.frame.size.width, cell.bottomBarImgV.frame.size.height);
                    
                }
            }
            
            
        }
        
    
    
    cell.homeNameLabel.text = subject;
    cell.publishNameLabel.text = username;
    cell.publishNameImgV.image = [UIImage imageNamed:@"publishName_home.png"];
    cell.icon_finishImgV.image = [UIImage imageNamed:@"icon_finishNum.png"];
    cell.finishNumLabel.text = finishNum;
    
    if ([answer integerValue] == 1) {
        
        cell.answerImgV.image = [UIImage imageNamed:@"icon_answer.png"];
        cell.icon_finishImgV.image = [UIImage imageNamed:@"icon_finishNum.png"];
        cell.finishNumLabel.hidden = NO;
        //state: 0:未批改 1:我发的 2:已完成 3:未作答 bert确认 有答案才显示state
        if ([state integerValue] == 0) {
            cell.finishImgV.image = [UIImage imageNamed:@"icon_unCorrect.png"];
        }else if ([state integerValue] == 2){
            cell.finishImgV.image = [UIImage imageNamed:@"icon_Done.png"];
        }else if ([state integerValue] == 3){
            cell.finishImgV.image = [UIImage imageNamed:@"icon_unAnswer.png"];
            
        }
    }else{
        cell.answerImgV.image = nil;
        cell.finishImgV.image = nil;
        cell.icon_finishImgV.image = nil;
        cell.finishNumLabel.hidden = YES;
    }
    
//    cell.commentNumLabel.text = replynum;
//    cell.label_viewnum.text = viewnum;
    
    //cell.commentNumImgV.image = [UIImage imageNamed:@"commentNumber_home.png"];
    
    //CGSize strSize = [Utilities getStringHeight:replynum andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];
    
    CGSize strSizeB = [Utilities getStringHeight:username andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];
    
    //CGSize strSizeC = [Utilities getStringHeight:viewnum andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(269.0, 21.0)];
    
    //cell.commentNumLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-strSize.width, 38.0, strSize.width, 21.0);
    
    //cell.commentNumImgV.frame = CGRectMake(cell.commentNumLabel.frame.origin.x-3-14.0, 38.0+3, 14.0, 14.0);
    
    //cell.label_viewnum.frame = CGRectMake(cell.commentNumImgV.frame.origin.x - 10-strSizeC.width, 38.0, strSizeC.width, 21.0);
    
    //cell.imgView_viewnum.frame = CGRectMake(cell.label_viewnum.frame.origin.x-3-14.0, 38.0+3, 14.0, 14.0);

    
//    cell.publishNameLabel.frame = CGRectMake(cell.imgView_viewnum.frame.origin.x - 10-strSizeB.width, 38.0, strSizeB.width, 21.0);
//    cell.publishNameImgV.frame = CGRectMake(cell.publishNameLabel.frame.origin.x-3-14.0, 38.0+3, 14.0, 14.0);
    
    cell.publishNameLabel.frame = CGRectMake(cell.publishNameLabel.frame.origin.x, cell.publishNameLabel.frame.origin.y, strSizeB.width, 21.0);
    cell.icon_finishImgV.frame = CGRectMake(cell.publishNameLabel.frame.origin.x+cell.publishNameLabel.frame.size.width+10,cell.icon_finishImgV.frame.origin.y,14.0 ,14.0 );
    cell.finishNumLabel.frame = CGRectMake(cell.icon_finishImgV.frame.origin.x+14.0+5,cell.finishNumLabel.frame.origin.y,cell.finishNumLabel.frame.size.width ,cell.finishNumLabel.frame.size.height);
    
    return cell;
}

/*//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];//update by kate 2014.12.08
    
    // 去班级详情页
    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid =  [dic objectForKey:@"tid"];
    [disscussDetailViewCtrl setFlag:3];
    disscussDetailViewCtrl.disTitle = _titleName;
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];

}*/

// cell的delegate回调
-(void)gotoHomeDetail:(NSInteger)index type:(NSString*)type{
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:index] forKey:@"tid"];//update by kate 2014.12.08
    NSDictionary *dic = [homeworkArray objectAtIndex:index];//update by kate 2014.12.08

    // 1 或 5 1是旧版作业 5是新版作业
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]] integerValue] == 5) {
        //新版本作业详情
        HomeworkDetailViewController *vc = [[HomeworkDetailViewController alloc] init];
        vc.viewType = @"student";
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

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        [self loadData:startNum];
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[homeworkArray count]];
        [self loadData:startNum];
        
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
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
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
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
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



@end
