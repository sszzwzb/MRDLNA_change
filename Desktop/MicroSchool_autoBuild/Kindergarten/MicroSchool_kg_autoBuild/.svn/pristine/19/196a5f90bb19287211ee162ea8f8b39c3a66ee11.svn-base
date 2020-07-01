//
//  NewsListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "NewsListViewController.h"



@interface NewsListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    newsArray =[[NSMutableArray alloc] init];
    newsidList =[[NSMutableArray alloc] init];
    newsDateList =[[NSMutableArray alloc] init];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    

    
    startNum = @"0";
    endNum = @"10";
    
    reflashFlag = 1;
    isReflashViewType = 1;
    
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    
    _tableView.backgroundView = imgView_bg;
    // 隐藏tableview分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    
    [self createHeaderView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    network.delegate = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    // 设置刷新标志位，在下拉或者上拉刷新的时候，先判断是否需要网络请求，
    // 如不需要，则不请求
    reflashFlag = 0;
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"News", @"ac",
                          @"2", @"v",
                          @"newsList", @"op",
                          _otherSid, @"sid",
                          _titleName, @"smid",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_News andData:data];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [newsArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";
    NSUInteger section = [indexPath row];
    
    NSDictionary* list_dic = [newsArray objectAtIndex:section];
    
    NSString* title= [list_dic objectForKey:@"title"];
    NSString* dateline= [list_dic objectForKey:@"updatetime"];
    NSString* pic= [list_dic objectForKey:@"pic"];
    NSString* smessage= [list_dic objectForKey:@"smessage"];
    NSString* stick= [list_dic objectForKey:@"stick"];
    NSString* iscomment= [list_dic objectForKey:@"iscomment"];

    NSString *viewnum = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"viewnum"]];//add by kate 2015.03.19
    
    if([@""  isEqual: pic])
    {
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[NewsTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //        cell.backgroundView.frame = CGRectMake(9, 0, 302, 100);
        //        cell.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 100);
        
        UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
        [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
        cell.backgroundView = imgView_bg;
        
        Utilities *util = [Utilities alloc];
        
        cell.label_content.text = title;
        cell.label_contentDetail.text = smessage;
        cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        
        if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
            // 置顶加编辑
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 225) {
                cell.label_content.frame = CGRectMake(20, 20, 215, 15);
            }
            
            cell.imgView_stick.hidden = NO;
            cell.imgView_edit.hidden = NO;
            
            cell.imgView_stick.frame = CGRectMake(240, 16, 21, 21);
            
        }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
            // 置顶
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 250) {
                cell.label_content.frame = CGRectMake(20, 20, 250, 15);
            }
            
            cell.imgView_stick.hidden = NO;
            cell.imgView_edit.hidden = YES;
            
        }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
            // 可编辑
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 250) {
                cell.label_content.frame = CGRectMake(20, 20, 250, 15);
            }
            
            cell.imgView_stick.hidden = YES;
            cell.imgView_edit.hidden = NO;
            
        }else {
            cell.imgView_stick.hidden = YES;
            cell.imgView_edit.hidden = YES;
        }
        
        cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
        
        
        return cell;
    }
    else
    {
        NewsImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
        if(cell == nil) {
            cell = [[NewsImgTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
        [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
        cell.backgroundView = imgView_bg;
        
        Utilities *util = [Utilities alloc];
        
        cell.label_content.text = title;
        cell.label_contentDetail.text = smessage;
        cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        
        if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
            // 置顶加编辑
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 150) {
                cell.label_content.frame = CGRectMake(98, 13, 140, 15);
            }
            
            cell.imgView_stick.hidden = NO;
            cell.imgView_edit.hidden = NO;
            
            cell.imgView_stick.frame = CGRectMake(240, 11, 21, 21);
            
        }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
            // 置顶
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 170) {
                cell.label_content.frame = CGRectMake(98, 11, 170, 15);
            }
            
            cell.imgView_stick.hidden = NO;
            cell.imgView_edit.hidden = YES;
            
        }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
            // 可编辑
            CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
            
            if (strSize.width > 170) {
                cell.label_content.frame = CGRectMake(98, 11, 170, 15);
            }
            
            cell.imgView_stick.hidden = YES;
            cell.imgView_edit.hidden = NO;
            
        }else {
            cell.imgView_stick.hidden = YES;
            cell.imgView_edit.hidden = YES;
        }
        
        cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
        return cell;
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NewsDetailOtherViewController *newsDetailViewCtrl = [[NewsDetailOtherViewController alloc] initWithVar:_titleName];
    
    newsDetailViewCtrl.newsid = [newsidList objectAtIndex:indexPath.row];
    newsDetailViewCtrl.newsDate = [newsDateList objectAtIndex:indexPath.row];
    newsDetailViewCtrl.otherSid = _otherSid;
    [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(_tableView.bounds.size.height, _tableView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, _tableView.bounds.size.height)];
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableView addSubview:_refreshFooterView];
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

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"News", @"ac",
                              @"2", @"v",
                              @"newsList", @"op",
                              _otherSid, @"sid",
                              _titleName, @"smid",
                              startNum, @"page",
                              endNum, @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_News andData:data];
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
       if (reflashFlag == 1) {
           NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
           
           NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 REQ_URL, @"url",
                                 @"News", @"ac",
                                 @"2", @"v",
                                 @"newsList", @"op",
                                 _otherSid, @"sid",
                                 _titleName, @"smid",
                                 startNum, @"page",
                                 endNum, @"size",
                                 nil];

            [network sendHttpReq:HttpReq_News andData:data];
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
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{

    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    [self enableLeftAndRightKey];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        NSArray *temp = [message_info objectForKey:@"list"];
        
        if (isReflashViewType == 1) {
            [newsArray removeAllObjects];
            [newsidList removeAllObjects];
            [newsDateList removeAllObjects];
        }
        
        for (NSObject *object in temp)
        {
            [newsArray addObject:object];
            
            NSDictionary *dic = (NSDictionary *)object;
            [newsidList addObject:[dic objectForKey:@"newsid"]];
            
            NSString* dateline= [dic objectForKey:@"updatetime"];
            [newsDateList addObject:dateline];
        }
        
       
        startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
        [self removeFooterView];
        
        //[self testFinishedLoadData];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        
        //刷新表格内容
        [_tableView reloadData];
        
       
        if ([newsArray count] > 0) {
            
            [noDataView removeFromSuperview];
            
        }else{
            
            CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
            noDataView = [Utilities showNodataView:@"一条信息也没有" msg2:@"管理员不勤快" andRect:rect];
            
            [self.view addSubview:noDataView];
            
        }
       
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取信息错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }

}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
     UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alert show];

}


- (id)initWithVar:(NSString *)newsName;
{
    if(self = [super init])
    {
        _titleName = newsName;
    }
    
    return self;
}

@end
