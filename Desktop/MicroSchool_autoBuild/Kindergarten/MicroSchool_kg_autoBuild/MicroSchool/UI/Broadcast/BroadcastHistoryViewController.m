//
//  BroadcastHistoryViewController.m
//  MicroSchool
//
//  Created by jojo on 15/1/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BroadcastHistoryViewController.h"

@interface BroadcastHistoryViewController ()

@end

@implementation BroadcastHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"历史广播"];
    [super setCustomizeLeftButton];

    dataDic = [[NSMutableDictionary alloc] init];
    dataArr = [[NSMutableArray alloc] init];

    startNum = @"0";
    endNum = @"10";

    reflashFlag = 1;

    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [ReportObject event:ID_SCHOOL_RADIO_LIST];//2015.06.25

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

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
    //    [self createHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];// update frame by kate
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    
//    TradeDetailView *histViewCtrl = [[TradeDetailView alloc] init];

//    [self.view addSubview:histViewCtrl];


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
    
    // 因为在viewwillappare里面调用了 所以这里不调用
    // 发出两次请求会有问题
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"SchoolRadio",@"ac",
                          @"2",@"v",
                          @"history", @"op",
                          _otherSid, @"sid",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_BroadcastHistory andData:data];
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
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"SchoolRadio",@"ac",
                              @"2",@"v",
                              @"history", @"op",
                              _otherSid, @"sid",
                              startNum, @"page",
                              endNum, @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_BroadcastHistory andData:data];
    }
}
//加载调用的方法
-(void)getNextPageView
{
    if (reflashFlag == 1) {
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"SchoolRadio",@"ac",
                              @"2",@"v",
                              @"history", @"op",
                              _otherSid, @"sid",
                              startNum, @"page",
                              endNum, @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_BroadcastHistory andData:data];
    }
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
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    NSDictionary *dic = [dataArr objectAtIndex:row];
    BroadcastHistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[BroadcastHistTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.label_message.text = [dic objectForKey:@"title"];
    cell.label_viewNum.text = [Utilities replaceNull:[dic objectForKey:@"viewnum"]];
    
    Utilities *util = [Utilities alloc];
    cell.label_dateline.text = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@" andType:DateFormat_YMDHM];//时间精确到天，不要小时分钟 update by kate 2015.01.29
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          _otherSid,@"otherSid",
                          [[dataArr objectAtIndex:[indexPath row]] objectForKey:@"nid"],@"nid",
                          nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:@"broadcastDic"];
    [userDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    

    
#if 0
    BroadcastViewController *broadcastViewCtrl = [[BroadcastViewController alloc] init];
    broadcastViewCtrl.nid = [[dataArr objectAtIndex:[indexPath row]] objectForKey:@"nid"];
    broadcastViewCtrl.otherSid = _otherSid;
    broadcastViewCtrl.moduleName = _moduleName;
    [self.navigationController pushViewController:broadcastViewCtrl animated:YES];
#endif
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"SchoolRadioAction.history"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        
        //[progressHud hide:YES];
        [Utilities dismissProcessingHud:self.view];// 2015.05.12
        if(true == [result intValue]) {
            if ([@"0"  isEqual: startNum]) {
                [dataArr removeAllObjects];
            }

            NSDictionary *dic = [resultJSON objectForKey:@"message"];
            NSArray *arr = [dic objectForKey:@"list"];
            
            for (NSObject *object in arr)
            {
                [dataArr addObject:object];
            }

            dataDic = [resultJSON objectForKey:@"message"];

            startNum = [NSString stringWithFormat:@"%d",(startNum.intValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            [_tableView reloadData];

        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取历史广播错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }else if ([@"OtherSchoolAction.favorites"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    //[progressHud hide:YES];
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
