//
//  CollectionViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        eidList =[[NSMutableArray alloc] init];
        joinedList =[[NSMutableArray alloc] init];
        listDataArray =[[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"5";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,49+40,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];

    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    _tableView.backgroundView = imgView_bg;
    
    [self.view addSubview:_tableView];
    
    [self createHeaderView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCancelCollection:) name:@"Weixiao_knowledgeCancelCollection" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_knowledgeCancelCollection" object:nil];
}

-(void)doCancelCollection:(NSNotification *)notification
{
    NSLog(@"doCancelCollection");
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *dic = [notification userInfo];
    NSString *tid = [dic objectForKey:@"tid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"favoriteCancel", @"op",
                          tid, @"tid",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiFavoriteCancel andData:data];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listDataArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [listDataArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[CollectionTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    cell.backgroundView = imgView_bg;

//    NSUInteger section = [indexPath section];
    NSUInteger section = [indexPath row];

    NSDictionary* list_dic = [listDataArray objectAtIndex:section];
    
    NSString* subject= [list_dic objectForKey:@"subject"];
    NSString* time= [list_dic objectForKey:@"dateline"];
    NSString* tuid= [list_dic objectForKey:@"uid"];
    NSString* name= [list_dic objectForKey:@"name"];
    NSString* tid= [list_dic objectForKey:@"tid"];
    NSString* likes= [list_dic objectForKey:@"likes"];
    NSString* school= [list_dic objectForKey:@"school"];

    Utilities *util = [Utilities alloc];
    
    //---update by kate 2014.11.14----------------------------------
    NSString *head_url = [list_dic objectForKey:@"avatar"];
    //NSString* head_url = [util getAvatarFromUid:tuid andType:@"1"];
    //----------------------------------------------------------------

    NSString *timeStr = [NSString stringWithFormat: @"%@",
                          [util linuxDateToString:time andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];

    cell.title = subject;
    cell.time = timeStr;
    
    NSString *nameStr = [[name stringByAppendingString:@"|"] stringByAppendingString:school];
    cell.name = nameStr;
    cell.tid = tid;
    cell.topNum = likes;

    [cell.imgView_head sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.row] forKey:@"tid"];
    //NSDictionary *dic = [NSDictionary dictionaryWithObject:@"collectionView" forKey:@"tid"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToKnowledgeDetailView" object:self userInfo:dic];
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
    
   
     [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"favorites", @"op",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];

    [network sendHttpReq:HttpReq_WikiCollection andData:data];
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
    [listDataArray removeAllObjects];
    [eidList removeAllObjects];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"favorites", @"op",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiCollection andData:data];
}

//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"favorites", @"op",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiCollection andData:data];
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
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(HttpReq_WikiCollection == type)
    {
        if(true == [result intValue])
        {
            NSArray *temp = [resultJSON objectForKey:@"message"];
            
            for (NSObject *object in temp)
            {
                [listDataArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [eidList addObject:[aaa objectForKey:@"tid"]];
                //[joinedList addObject:[aaa objectForKey:@"joined"]];
            }
            
            //        eventArray = [message_info objectForKey:@"list"];
            //        eventType = [message_info objectForKey:@"type"];
            
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 5)];
            //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
            
            //刷新表格内容
            [_tableView reloadData];
            
            if ([listDataArray count] > 0) {
                [noDataView removeFromSuperview];
            }else{
                CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"您还未收藏任何知识点" msg2:@"  " andRect:rect];
                [self.view addSubview:noDataView];
            }
        }
        else
        {
            
            [Utilities dismissProcessingHud:self.view];//2015.05.12

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取知识库错误，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([@"do_wiki_favoriteCancel"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
