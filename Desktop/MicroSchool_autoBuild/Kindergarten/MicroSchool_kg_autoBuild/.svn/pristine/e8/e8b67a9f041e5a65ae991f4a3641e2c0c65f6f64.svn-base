//
//  MyEventViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-25.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MyEventViewController.h"

@interface MyEventViewController ()

@end

@implementation MyEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        eidList =[[NSMutableArray alloc] init];
        eventArray =[[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"5";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 查看我的活动列表
    [ReportObject event:ID_OPEN_MY_EVENT];// 2015.06.13
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//    {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, 320, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStyleGrouped];
//    }
//    else
//    {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, 320, [UIScreen mainScreen].applicationFrame.size.height-44-57) style:UITableViewStyleGrouped];
//    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStyleGrouped];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    _tableView.backgroundView = imgView_bg;
    
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
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [eventArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[EventTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUInteger section = [indexPath section];
    
    NSDictionary* list_dic = [eventArray objectAtIndex:section];
    
    NSString* title= [list_dic objectForKey:@"title"];
    NSString* starttime= [list_dic objectForKey:@"starttime"];
    NSString* endtime= [list_dic objectForKey:@"endtime"];
    NSString* pic= [list_dic objectForKey:@"poster"];
    NSString* location= [list_dic objectForKey:@"location"];
    NSString* membernum= [list_dic objectForKey:@"membernum"];
    NSString* status= [list_dic objectForKey:@"status"];
    NSString* mtagtype= [list_dic objectForKey:@"mtagtype"];
    
    Utilities *util = [Utilities alloc];
    
    NSString *startStr = [NSString stringWithFormat: @"%@",
                          [util linuxDateToString:starttime andFormat:@"%@/%@ %@:%@" andType:DateFormat_MDHM]];
    
    NSString *endStr = [NSString stringWithFormat: @"%@",
                        [util linuxDateToString:endtime andFormat:@"%@/%@ %@:%@" andType:DateFormat_MDHM]];
    
    NSString *timeStr = [[startStr stringByAppendingString:@"-"] stringByAppendingString:endStr];
    
    cell.title = title;
    cell.time = timeStr;
    cell.start = startStr;
    cell.end = endStr;
    cell.location = location;
    cell.member = membernum;
    
    // 活动种类图片
    if ([@"class"  isEqual: mtagtype]) {
        [cell.imgView_mtagtype setImage:[UIImage imageNamed:@"icon_event_list_type_class.png"]];
    }
    else if ([@"league"  isEqual: mtagtype]) {
        [cell.imgView_mtagtype setImage:[UIImage imageNamed:@"icon_event_list_type_school.png"]];
    }
    else {
        [cell.imgView_mtagtype setImage:[UIImage imageNamed:@"icon_event_list_type_school.png"]];
    }
    
    // 活动是否结束图片
    if (1 == status.integerValue)
    {
        [cell.imgView_status setImage:[UIImage imageNamed:@"icon_event_list_event_over.png"]];
    }
    else if (0 == status.integerValue)
    {
        [cell.imgView_status setImage:[UIImage imageNamed:@"icon_event_list_event_going.png"]];
    }
    
    [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.section] forKey:@"eventid"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToEventDetailView" object:self userInfo:dic];
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
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"events", @"op",
                          @"mine", @"type",
                          startNum,  @"page",
                          endNum, @"size",
                          nil];

    [network sendHttpReq:HttpReq_SchoolEvent andData:data];
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
    
	NSLog(@"刷新完成");
    
    startNum = @"0";
    endNum = @"5";
//    [eventArray removeAllObjects];
//    [eidList removeAllObjects];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"events", @"op",
                          @"mine", @"type",
                          startNum,  @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_SchoolEvent andData:data];
}
//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"events", @"op",
                          @"mine", @"type",
                          startNum,  @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_SchoolEvent andData:data];
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
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        if ([@"0"  isEqual: startNum]) {
            [eventArray removeAllObjects];
            [eidList removeAllObjects];
        }

        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        NSArray *temp = [message_info objectForKey:@"list"];
        
        for (NSObject *object in temp)
        {
            [eventArray addObject:object];
            
            NSDictionary *aaa = (NSDictionary *)object;
            [eidList addObject:[aaa objectForKey:@"eventid"]];
        }
        
        //        eventArray = [message_info objectForKey:@"list"];
        //        eventType = [message_info objectForKey:@"type"];
        
        startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 5)];
        //endNum = [NSString stringWithFormat:@"%ld",(endNum.integerValue + 5)];
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
        
        //刷新表格内容
        [_tableView reloadData];
        
        if ([eventArray count] > 0) {
            [noDataView removeFromSuperview];
        }else{
            
            CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
            noDataView = [Utilities showNodataView:@"空空如也" msg2:@"去其他地方看看吧" andRect:rect];
            [self.view addSubview:noDataView];
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取校园事件错误，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];

//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
    
    if ([eventArray count] == 0) {
        if (![Utilities isConnected]) {//2015.06.30
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            
            
        }
    }
}

@end
