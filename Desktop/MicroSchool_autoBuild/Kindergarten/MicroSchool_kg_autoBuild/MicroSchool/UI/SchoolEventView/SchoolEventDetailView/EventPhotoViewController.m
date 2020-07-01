//
//  EventPhotoViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "EventPhotoViewController.h"

@interface EventPhotoViewController ()

@end

@implementation EventPhotoViewController

@synthesize eid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        networkDetail = [NetworkUtility alloc];
        networkDetail.delegate = self;
        
        photoArray =[[NSMutableArray alloc] init];

        [Utilities showProcessingHud:self.view];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 查看活动照片列表
    [ReportObject event:ID_OPEN_EVENT_PIC];//2015.06.23
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 179, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-179-44) style:UITableViewStyleGrouped];
    
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,179,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-179-44)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    _tableView.backgroundView = imgView_bgImg;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self->startNum = @"0";
    self->endNum = @"5";
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(240, 105, 70, 23);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
    [button setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [button addTarget:self action:@selector(buttonJoin:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button setTitle:@"退出" forState:UIControlStateHighlighted];
    
    [self.view addSubview:button];
    
    
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [photoArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
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
    
    EventPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[EventPhotoCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    
    NSUInteger section = [indexPath section];
    
    NSDictionary* list_dic = [photoArray objectAtIndex:section];
    NSString* pic= [list_dic objectForKey:@"pic"];
    
    [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
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
    
    /**
     * 活动相册列表
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=gallery, sid=, uid=, eid=, page=, size=
     */
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_SCHOOLEVENT, @"url",
//                          self.eid, @"eid",
//                          @"pic", @"view",
//                          self->startNum,  @"page",
//                          self->endNum, @"size",
//                          nil];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"gallery",@"op",
                          self->eid, @"eid",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [networkDetail sendHttpReq:HttpReq_SchoolEventPic andData:data];
    
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
    [photoArray removeAllObjects];
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_SCHOOLEVENT, @"url",
//                          self.eid, @"eid",
//                          @"pic", @"view",
//                          self->startNum,  @"page",
//                          self->endNum, @"size",
//                          nil];
    // 2015.06.23
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"gallery",@"op",
                          self->eid, @"eid",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [networkDetail sendHttpReq:HttpReq_SchoolEventPic andData:data];
    
}
//加载调用的方法
-(void)getNextPageView
{
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_SCHOOLEVENT, @"url",
//                          self.eid, @"eid",
//                          @"pic", @"view",
//                          self->startNum,  @"page",
//                          self->endNum, @"size",
//                          nil];
    
    // 2015.06.23
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          @"gallery",@"op",
                          self->eid, @"eid",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [networkDetail sendHttpReq:HttpReq_SchoolEventPic andData:data];
    
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
    
    NSLog(@"resultJSON:%@",resultJSON);
    
    if(true == [result intValue])
    {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        NSArray *temp = [message_info objectForKey:@"list"];

        for (NSObject *object in temp)
        {
            [photoArray addObject:object];
        }
        
        startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 5)];

        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
        
        //刷新表格内容
        [_tableView reloadData];
    }
    else
    {
        [Utilities dismissProcessingHud:self.view];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取信息失败，请稍候再试"
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

-(void) getPhoto:(NSString*) eidValue andJoined:(NSString *) jonied andStatus:(NSString*) status andNum:(NSString*) num
{
    self.eid = eidValue;
    
    if ([@"1"  isEqual: jonied]) {
        //设置title
        [button setTitle:@"退出" forState:UIControlStateNormal];
        [button setTitle:@"退出" forState:UIControlStateHighlighted];
    } else {
        //设置title
        NSString *buttonStr = [NSString stringWithFormat:@"参加 %@", num];
        [button setTitle:buttonStr forState:UIControlStateNormal];
        [button setTitle:buttonStr forState:UIControlStateHighlighted];
    }

    if (1 == status.integerValue)
    {
        button.alpha = 0.7;
        button.enabled = NO;
    }

    [self createHeaderView];
}

- (IBAction)buttonJoin:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_joinSchoolEvent" object:self userInfo:Nil];
}

@end
