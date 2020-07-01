//
//  MyInitiatorViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-13.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MyInitiatorViewController.h"

@interface MyInitiatorViewController ()

@end

@implementation MyInitiatorViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [super setCustomizeTitle:@"我发起的话题"];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        initiatorArray =[[NSMutableArray alloc] init];
        tidList =[[NSMutableArray alloc] init];

        isReflashViewType = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (![Utilities isConnected]){//2015.06.30
        return;
    }
    
    [Utilities showProcessingHud:self.view];
    
    [ReportObject event:ID_OPEN_MY_POST_THREAD_LIST];//2015.06.24
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    
    self->startNum = @"0";
    self->endNum = @"10";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
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
    return [initiatorArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [initiatorArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 指定行的高度
    return 80;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 10;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MyTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [initiatorArray objectAtIndex:row];
    
    NSString* subject= [list_dic objectForKey:@"subject"];
    NSString* dateline= [list_dic objectForKey:@"dateline"];
    //NSString* viewnum= [list_dic objectForKey:@"viewnum"];
//    NSString* username= [list_dic objectForKey:@"username"];
    //NSString* sbj_uid= [list_dic objectForKey:@"uid"];
    NSString* replynum= [list_dic objectForKey:@"replynum"];
    NSString* stick= [list_dic objectForKey:@"stick"];
    NSString* digest= [list_dic objectForKey:@"digest"];

    if([@"1"  isEqual: digest])
    {
    	cell.imgView_digest.hidden = NO;
        [cell.imgView_digest setImage:[UIImage imageNamed:@"icon_jing.png"]];
    }
    else
    {
    	cell.imgView_digest.hidden = YES;
    }
    
    // 是否置顶
    if([@"1"  isEqual: stick])
    {
        cell.imgView_stick.hidden = NO;
        [cell.imgView_stick setImage:[UIImage imageNamed:@"icon_top.png"]];
    }
    else
    {
        cell.imgView_stick.hidden = YES;
    }

    Utilities *util = [Utilities alloc];
    
//    NSString* head_url = [util getAvatarFromUid:sbj_uid andType:@"1"];
    
//    [cell.imgView_thumb setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"btn_title_d.png"]];
    
    cell.dateline = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    
    cell.subject = subject;
//    NSString *viewNumSrt = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];
//    cell.viewnum = viewNumSrt;
    //cell.username = username;
    cell.replynum = replynum;
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid = [tidList objectAtIndex:indexPath.row];
    disscussDetailViewCtrl.disTitle = _nextPageTitle;
    disscussDetailViewCtrl.flag = 1;
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete");
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];
    NSDictionary* list_dic = [initiatorArray objectAtIndex:indexPath.row];
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
        [_tableView reloadData];
    }
    
}

// 删除学校讨论区
-(void)reflashHomeworkView:(NSDictionary *)dic
{
    [Utilities showProcessingHud:self.view];
    
    NSLog(@"reflashHomeworkView");
    //    NSDictionary *dic = [notification userInfo];
    /*
     v=1, ac=SchoolThread|也支持其他讨论区
     调用参数：
     
     op=delete, sid=, uid=, tid=
     */
    
    NSString *tidStr = [dic objectForKey:@"tid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"1",@"v",
                          @"SchoolThread", @"ac",
                          tidStr, @"tid",
                          @"delete",@"op",
                          nil];
    
    
    
    [network sendHttpReq:Http_SchoolDiscussDelete andData:data];
    
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
                          @"SchoolThread",@"ac",
                          @"threads", @"op",
                          self->startNum, @"page",
                          self->endNum, @"size",
                          @"me",  @"subview",
                          nil];
    
    [network sendHttpReq:HttpReq_ThreadInitiator andData:data];
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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.5];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
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

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"SchoolThread",@"ac",
                          @"threads", @"op",
                          self->startNum, @"page",
                          self->endNum, @"size",
                          @"me",  @"subview",
                          nil];

    [network sendHttpReq:HttpReq_ThreadInitiator andData:data];
}
//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"SchoolThread",@"ac",
                          @"threads", @"op",
                          self->startNum, @"page",
                          self->endNum, @"size",
                          @"me",  @"subview",
                          nil];
    
    [network sendHttpReq:HttpReq_ThreadInitiator andData:data];
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
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"SchoolThreadAction.delete"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        [Utilities dismissProcessingHud:self.view];

        if(true == [result intValue])
        {
            [self refreshView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewForDiscussView" object:nil];//add by kate 2015.03.20
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else{
        
        [Utilities dismissProcessingHud:self.view];

        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSArray *temp = [message_info objectForKey:@"list"];
            
            if (isReflashViewType == 1) {
                [initiatorArray removeAllObjects];
                [tidList removeAllObjects];
            }
            
            for (NSObject *object in temp)
            {
                [initiatorArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [tidList addObject:[aaa objectForKey:@"tid"]];
            }
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
            
            //刷新表格内容
            [_tableView reloadData];
            
            if ([initiatorArray count] > 0) {
                [noDataView removeFromSuperview];
            }else{
                
                //noDataView = [Utilities showNodataView:@"空空如也" msg2:@"去其他地方看看吧"];
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                noDataView = [Utilities showNodataView:@"这里空空的，来点话题吧" msg2:nil andRect:rect imgName:@"BlankViewImage/讨论区空白页_03.png"];
                [self.view addSubview:noDataView];
            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取数据错误，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
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

@end
