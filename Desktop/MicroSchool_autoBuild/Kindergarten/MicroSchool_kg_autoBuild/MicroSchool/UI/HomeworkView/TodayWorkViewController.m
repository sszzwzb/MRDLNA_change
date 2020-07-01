//
//  TodayWorkViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "TodayWorkViewController.h"


@interface TodayWorkViewController ()

@end

@implementation TodayWorkViewController

#define TIPS_Y 14

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tidList =[[NSMutableArray alloc] init];
        homeworkArray =[[NSMutableArray alloc] init];
        homworkTimeList =[[NSMutableArray alloc] init];
        homworkTimeArray =[[NSMutableArray alloc] init];

        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"10";
        
        tips = [[UILabel alloc] init];
        label_time = [[UILabel alloc] init];
        imgView_clock = [[UIImageView alloc] init];
        
        // 获取当前用户的uid
        GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        
        // 获取当前用户的cid
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];

        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype] || [@"2"  isEqual: usertype])
        {
            cid = [g_userInfo getUserCid];
        }
        else
        {
            cid = [userDetailInfo objectForKey:@"role_cid"];
        }
        
        isReflashViewType = 1;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utilities showProcessingHud:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashHomeworkView:) name:@"Weixiao_reflashHomeworkView" object:nil];

    GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSString *isHomeworkSubmit = [g_userInfo getIsHomeworkSubmit];
    
    if ([@"1"  isEqual: isHomeworkSubmit]) {
        [imgView_message removeFromSuperview];
        [tips removeFromSuperview];
        [Utilities showProcessingHud:self.view];
        [self refreshView];
        
        [g_userInfo setIsHomeworkSubmit:@"0"];
    }
    else {
        // nothing
        [self refreshView];//2015.11.02 解决tabBar下数据不刷新问题
    }
    
    [ReportObject event:ID_OPEN_TODAY_HOMEWORK];//2015.06.24
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_reflashHomeworkView" object:nil];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    //    {
    //        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, 320, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStyleGrouped];
    //
    //        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, 320, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStyleGrouped];
    //    }
    //    else
    //    {
    //        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, 320, [UIScreen mainScreen].applicationFrame.size.height-44-57) style:UITableViewStyleGrouped];
    //    }
    
//----update by kate -----------------------------------------------------------------------
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49 + TIPS_Y*2 + 25, 320, [UIScreen mainScreen].applicationFrame.size.height-44-49 - TIPS_Y*2 - 25) style:UITableViewStyleGrouped];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49 , WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStylePlain];
//-------------------------------------------------------------------------
    UIImageView *imgView_table_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_table_bg setBackgroundColor:[UIColor whiteColor]];
    
    _tableView.backgroundView = imgView_table_bg;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //-----update by kate 2014.12.08--------------------------------------
    // 隐藏tableview分割线
   // [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,49,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    //--------------------------------------------------------------------
    

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self.view addSubview:_tableView];
    
    
    
    [self createHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //----update by kate 2014.12.08--------------------------------------
    //return 1;
    return [homeworkArray count];
    //-------------------------------------------------------------------
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //----update by kate 2014.12.08--------------------------------------
    //return [homeworkArray count];
    return 1;
    //------------------------------------
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//---update by kate 2014.12.10--------
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 10;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//----------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    HomeworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[HomeworkTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
 
    //------update by kate 2014.12.08----------------------------------------
//    NSUInteger section = [indexPath section];
//    NSDictionary* list_dic = [homeworkArray objectAtIndex:section];
    
    NSDictionary *list_dic = [homeworkArray objectAtIndex:indexPath.row];
    //--------------------------------------------------------------------
    
    NSString* subject= [list_dic objectForKey:@"subject"];
    NSString* dateline= [list_dic objectForKey:@"dateline"];
    NSString* viewnum= [list_dic objectForKey:@"viewnum"];
    NSString* username= [list_dic objectForKey:@"username"];
    NSString* sbj_uid= [list_dic objectForKey:@"uid"];
    NSString* replynum= [list_dic objectForKey:@"replynum"];
    //NSString* stick= [list_dic objectForKey:@"stick"];
    NSString* expectedtime= [list_dic objectForKey:@"expectedtime"];
    NSString* tid = [list_dic objectForKey:@"tid"];

    NSString* displayorder= [list_dic objectForKey:@"displayorder"];
    NSString* digest= [list_dic objectForKey:@"digest"];
    
    // 是否置顶
    if([@"1"  isEqual: displayorder])
    {
        cell.imgView_displayorder.hidden = NO;
        [cell.imgView_displayorder setImage:[UIImage imageNamed:@"icon_top.png"]];
    }
    else
    {
        cell.imgView_displayorder.hidden = YES;
    }
    
    // 是否置顶
    if([@"1"  isEqual: digest])
    {
        cell.imgView_digest.hidden = NO;
        [cell.imgView_digest setImage:[UIImage imageNamed:@"icon_jing.png"]];
    }
    else
    {
        cell.imgView_digest.hidden = YES;
    }

    //---update by kate 2014.11.14-------------------------------------
    Utilities *util = [Utilities alloc];
    NSString *head_url = [list_dic objectForKey:@"avatar"];
    //NSString* head_url = [util getAvatarFromUid:sbj_uid andType:@"1"];
    //------------------------------------------------------------------
    
    [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    
    cell.dateline = [util linuxDateToString:dateline andFormat:@"%@:%@" andType:DateFormat_MS];
    
    cell.subject = subject;
    //NSString *viewNumSrt = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];
    cell.viewnum = viewnum;
    cell.username = username;
    cell.replynum = replynum;
//    cell.button_delete.tag = section;
    cell.button_delete.tag = indexPath.row;
    cell.tid = tid;
    cell.expectedtime = [NSString stringWithFormat:@"%@分钟", expectedtime];
    cell.button_delete.hidden = YES;

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//----update by kate 2014.12.08--------------------------------------
//       NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.section] forKey:@"tid"];
     NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];
    //-----------------------------------------------------------------
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Weixiao_changeToHomeworkDetailView" object:self userInfo:dic];

    
    
}

-(void)reflashHomeworkView:(NSNotification *)notification
{
    NSLog(@"reflashHomeworkView");
    //NSDictionary *dic = [notification userInfo];
    //NSString *tidStr = [dic objectForKey:@"tid"];
    
    //    _tabBarHomework.selectedViewController.
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Homework",@"ac",
                          @"threads",@"op",
                          cid, @"cid",
                          @"today", @"subview",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_Homework andData:data];
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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.2];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.2];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    //if (_reloading) return;
    
    isReflashViewType = 1;

	NSLog(@"刷新完成");
    
    startNum = @"0";
    endNum = @"10";
//    [homeworkArray removeAllObjects];
//    [tidList removeAllObjects];
//    [homworkTimeList removeAllObjects];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Homework",@"ac",
                          @"threads",@"op",
                          cid, @"cid",
                          @"today", @"subview",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_Homework andData:data];
}
//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Homework",@"ac",
                          @"threads",@"op",
                          cid, @"cid",
                          @"today", @"subview",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_Homework andData:data];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self beginToReloadData:aRefreshPos];
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
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        NSArray *temp = [message_info objectForKey:@"list"];
       // NSDictionary *temp1 = [message_info objectForKey:@"list"];

        if (isReflashViewType == 1) {
            [homeworkArray removeAllObjects];
            [tidList removeAllObjects];
            [homworkTimeList removeAllObjects];
        }

        for (NSObject *object in temp)
        {
            [homeworkArray addObject:object];
            
            NSDictionary *aaa = (NSDictionary *)object;
            [tidList addObject:[aaa objectForKey:@"tid"]];
            [homworkTimeList addObject:[aaa objectForKey:@"expectedtime"]];
            [homworkTimeArray addObject:[aaa objectForKey:@"dateline"]];
        }
        
        //NSLog(@"tidList:%@",tidList);
        
        NSString *idStr = @"0";
        if([homeworkArray count] > 0){
        
        [homworkTimeArray sortUsingSelector:@selector(compare:)];
        
//            [[NSUserDefaults standardUserDefaults]setObject:[[homeworkArray objectAtIndex:0]objectForKey:@"id"] forKey:@"lastId_classHomework"];
            //idStr = [tidList objectAtIndex:0];
           
        }
        
        if ([[message_info objectForKey:@"last"] isEqualToString:@""] || [message_info objectForKey:@"last"] == nil) {
            
        }else{
            idStr = [message_info objectForKey:@"last"];
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary: [userDefaults objectForKey:@"lastHomeIdDic"]];
        cid = [NSString stringWithFormat:@"%@",cid];
        [tempDic setObject:idStr forKey:cid];
        [userDefaults setObject:tempDic forKey:@"lastHomeIdDic"];
        [userDefaults synchronize];
        
        //NSArray *array = [[temp1 allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 今日作业上方提示条
        if ([@"0"  isEqual: startNum]) {
            //[self doShowTips:[temp count]];
        }

        startNum = [NSString stringWithFormat:@"%d",((int)startNum.integerValue + 10)];
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];
        
        //刷新表格内容
        if([homeworkArray count] > 0){
            
//             _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
             [_tableView reloadData];
            [noDataView removeFromSuperview];
            
        }else{
            
            if ([_tableView viewWithTag:123]) {
                
            }else{
                noDataView = [Utilities showNodataView:@"没作业啊没作业" msg2:@"可以先做别的了"];
                noDataView.tag = 123;
                [_tableView addSubview:noDataView];
            }
            
           
        }
       
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取作业错误，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)doShowTips:(NSInteger)count
{
    if (0 == count) {
        imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(0,49 + TIPS_Y,262,25)];
        imgView_message.image=[UIImage imageNamed:@"bg_use_time.9.png"];
        [self.view addSubview:imgView_message];
        
        tips.frame = CGRectMake(imgView_message.frame.origin.x +3,
                                                                  imgView_message.frame.origin.y + 2,
                                                                  imgView_message.frame.size.width,
                                                                  25);
        tips.lineBreakMode = NSLineBreakByWordWrapping;
        tips.text = @"虽然今天没有作业，但也不要忘记了学习哦!";
        tips.font = [UIFont systemFontOfSize:12.0f];
        tips.numberOfLines = 0;
        tips.textColor = [UIColor whiteColor];
        tips.backgroundColor = [UIColor clearColor];
        tips.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.view addSubview:tips];

    }
    else {
        imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(0,49 + TIPS_Y,175,25)];
        imgView_message.image=[UIImage imageNamed:@"bg_use_time.9.png"];
        [self.view addSubview:imgView_message];
        
        imgView_clock.frame = CGRectMake(
                                                                        imgView_message.frame.origin.x +3,
                                                                        imgView_message.frame.origin.y + (imgView_message.frame.size.height - 15)/2,
                                                                        15,
                                                                        15);
        
        imgView_clock.image=[UIImage imageNamed:@"icon_clock_top.png"];
        [self.view addSubview:imgView_clock];

        tips.frame = CGRectMake(
                                                                  imgView_clock.frame.origin.x + imgView_clock.frame.size.width + 3,
                                                                  imgView_message.frame.origin.y,
                                                                  100,
                                                                  25);
        tips.lineBreakMode = NSLineBreakByWordWrapping;
        tips.text = @"今日预计完成时间:";
        tips.font = [UIFont systemFontOfSize:11.0f];
        tips.numberOfLines = 0;
        tips.textColor = [UIColor whiteColor];
        tips.backgroundColor = [UIColor clearColor];
        tips.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.view addSubview:tips];
        
        label_time.frame = CGRectMake(95,
                                                                  tips.frame.origin.y,
                                                                  90,
                                                                  25);
        label_time.lineBreakMode = NSLineBreakByWordWrapping;
        label_time.font = [UIFont systemFontOfSize:11.0f];
        label_time.numberOfLines = 0;
        label_time.textColor = [UIColor redColor];
        label_time.backgroundColor = [UIColor clearColor];
        label_time.lineBreakMode = NSLineBreakByTruncatingTail;
        label_time.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label_time];
        
        NSInteger totalTime = 0;
        for (NSObject *object in homworkTimeList)
        {
            NSString *time = (NSString *)object;
            totalTime = time.integerValue + totalTime;
        }

        label_time.text = [NSString stringWithFormat: @"%d分钟", (int)totalTime];
    }
}

@end
