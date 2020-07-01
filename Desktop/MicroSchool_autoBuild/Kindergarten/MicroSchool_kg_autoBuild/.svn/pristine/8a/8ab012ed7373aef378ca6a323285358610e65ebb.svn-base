//
//  KnowledgeLibViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeLibViewController.h"

@interface KnowledgeLibViewController ()

@end

@implementation KnowledgeLibViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        eidList =[[NSMutableArray alloc] init];
        subuidList =[[NSMutableArray alloc] init];
        joinedList =[[NSMutableArray alloc] init];
        listDataArray =[[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"10";
        
        buttonState = HomeTouched;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,49+40,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    // 本校知识库
    button_home = [UIButton buttonWithType:UIButtonTypeCustom];
    button_home.frame = CGRectMake(0, 49, 160, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_home.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_home.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_home setTitleColor:[[UIColor alloc] initWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button_home setTitleColor:[[UIColor alloc] initWithRed:129/255.0f green:175/255.0f blue:216/255.0f alpha:1.0] forState:UIControlStateSelected];
    button_home.titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    [button_home setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    CGSize buttonSize;
    buttonSize.width = 160;
    buttonSize.height = 40;
    UIImage *newimage_home_d;
    UIImage *newimage_home_p;

    UIImage *image_home_d = [UIImage imageNamed:@"knowledge/icon_bxzsk_d.png"];
    UIImage *image_home_p = [UIImage imageNamed:@"knowledge/icon_bxzsk_p.png"];

    UIGraphicsBeginImageContext(buttonSize);
    [image_home_d drawInRect:CGRectMake((buttonSize.width-25)/2 - 40,7,25,25)];
    
    newimage_home_d = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContext(buttonSize);
    [image_home_p drawInRect:CGRectMake((buttonSize.width-25)/2 - 40,7,25,25)];
    
    newimage_home_p = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    UIImage *newImage_home_d1 = [self resizeImage:newimage_home_d andSize:buttonSize];
//    UIImage *newImage_home_p1 = [self resizeImage:newimage_home_p andSize:buttonSize];
    
    [button_home setBackgroundImage:newimage_home_d forState:UIControlStateNormal] ;
    [button_home setBackgroundImage:newimage_home_p forState:UIControlStateSelected] ;
    // 添加 action
    [button_home addTarget:self action:@selector(home_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_home setTitle:@"本校知识库" forState:UIControlStateNormal];
    [button_home setTitle:@"本校知识库" forState:UIControlStateSelected];
    button_home.adjustsImageWhenHighlighted = NO;
    button_home.selected = YES;
    [self.view addSubview:button_home];
    
    // 共享知识库
    button_share = [UIButton buttonWithType:UIButtonTypeCustom];
    button_share.frame = CGRectMake(160, 49, 160, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_share.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_share.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_share setTitleColor:[[UIColor alloc] initWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button_share setTitleColor:[[UIColor alloc] initWithRed:129/255.0f green:175/255.0f blue:216/255.0f alpha:1.0] forState:UIControlStateSelected];
    button_share.titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    [button_share setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIImage *image_share_d = [UIImage imageNamed:@"knowledge/icon_fxzsk_d.png"];
    UIImage *image_share_p = [UIImage imageNamed:@"knowledge/icon_fxzsk_p.png"];
    
    UIImage *newimage_share_d;
    UIImage *newimage_share_p;

    UIGraphicsBeginImageContext(buttonSize);
    [image_share_d drawInRect:CGRectMake((buttonSize.width-25)/2 - 40,7,25,25)];
    
    newimage_share_d = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_share_p drawInRect:CGRectMake((buttonSize.width-25)/2 - 40,7,25,25)];
    
    newimage_share_p = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    UIImage *newImage_share_d = [self resizeImage:image_share_d andSize:buttonSize];
//    UIImage *newImage_share_p = [self resizeImage:image_share_p andSize:buttonSize];

    [button_share setBackgroundImage:newimage_share_d forState:UIControlStateNormal];
    [button_share setBackgroundImage:newimage_share_p forState:UIControlStateSelected];
    
    // 添加 action
    [button_share addTarget:self action:@selector(share_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_share setTitle:@"共享知识库" forState:UIControlStateNormal];
    [button_share setTitle:@"共享知识库" forState:UIControlStateSelected];
    button_share.adjustsImageWhenHighlighted = NO;
    
    [self.view addSubview:button_share];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49 + 40, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49-40) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
//    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    _tableView.backgroundView = imgView_bg;
    
    [self.view addSubview:_tableView];
    
    // button中间的线
    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(160,49 + 6,2,28)];
    [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [imgView_line1 setTag:999];
    [self.view addSubview:imgView_line1];

    [self createHeaderView];
}

- (IBAction)home_btnclick:(id)sender
{
    buttonState = HomeTouched;
    
    button_home.selected = YES;
    button_share.selected = NO;
    [listDataArray removeAllObjects];
    [_tableView reloadData];
    
    
     [Utilities showProcessingHud:self.view];// 2015.05.12
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.3];
}

- (IBAction)share_btnclick:(id)sender
{
    buttonState = ShareTouched;
    
    button_share.selected = YES;
    button_home.selected = NO;
    [listDataArray removeAllObjects];
    [_tableView reloadData];
    
    
     [Utilities showProcessingHud:self.view];// 2015.05.12
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.3];
}

-(UIImage*)resizeImage:(UIImage*)raw andSize:(CGSize)resize
{
    UIImage *sizedImage;
    
    UIGraphicsBeginImageContext(resize);
    [raw drawInRect:CGRectMake((resize.width-25)/2 - 40, (resize.height-25)/2,25,25)];
    
    sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return sizedImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSubscribe:) name:@"Weixiao_knowledgeSubscribe" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_knowledgeSubscribe" object:nil];
}

-(void)doSubscribe:(NSNotification *)notification
{
    NSLog(@"doSubscribe");
    
    NSDictionary *dic = [notification userInfo];
    NSString *subuid = [dic objectForKey:@"subuid"];
    
    
     [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"follow", @"op",
                          subuid, @"subuid",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiFollow andData:data];
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
    
    SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[SubscribeTableViewCell alloc]
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
    
    NSString* title= [list_dic objectForKey:@"subject"];
    NSString* time= [list_dic objectForKey:@"dateline"];
    NSString* pic= [list_dic objectForKey:@"avatar"];
    NSString* name= [list_dic objectForKey:@"name"];
    NSString* school= [list_dic objectForKey:@"school"];
    NSString* message= [list_dic objectForKey:@"message"];
    NSString* likes= [list_dic objectForKey:@"likes"];

    NSString* tid= [list_dic objectForKey:@"tid"];
    NSString* subuid= [list_dic objectForKey:@"uid"];

    NSString* isSubuid= [list_dic objectForKey:@"subuid"];

//    NSString* status= [list_dic objectForKey:@"status"];
//    NSString* mtagtype= [list_dic objectForKey:@"mtagtype"];
    
    NSString *username = [[name stringByAppendingString:@"|"] stringByAppendingString:school];
    
    Utilities *util = [Utilities alloc];
    
    NSString *timeStr = [NSString stringWithFormat: @"%@",
                         [util linuxDateToString:time andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];
    
    cell.title = title;
    cell.time = timeStr;
    cell.name = username;
    cell.content = message;
    cell.topNum = likes;
    cell.tid = tid;
    cell.subuid = subuid;

    if (![@"0"  isEqual: [NSString stringWithFormat:@"%@", isSubuid]]) {
        [cell.button_collect setTitle:@"已订阅" forState:(UIControlStateNormal)];
        cell.button_collect.alpha = 0.7;
        cell.button_collect.enabled = NO;
    } else {
        [cell.button_collect setTitle:@"订阅" forState:(UIControlStateNormal)];
        cell.button_collect.alpha = 1.0;
        cell.button_collect.enabled = YES;
    }
    
    [cell.imgView_head sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.row] forKey:@"tid"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [eidList objectAtIndex:indexPath.row], @"tid",
                         [subuidList objectAtIndex:indexPath.row], @"subuid", nil];

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
                          @"mySchoolWiki", @"op",
                          self->startNum,  @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiMySchool andData:data];
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
//    if (_reloading == YES) {
//        return;
//    }

	NSLog(@"刷新完成");
    
    startNum = @"0";
    endNum = @"10";
//    [listDataArray removeAllObjects];
//    [eidList removeAllObjects];
//    [subuidList removeAllObjects];

    NSDictionary *data;
    if (HomeTouched == buttonState) {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              AC_WIKI, @"url",
                              @"mySchoolWiki", @"op",
                              self->startNum,  @"page",
                              self->endNum, @"size",
                              nil];
    } else {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                AC_WIKI, @"url",
                @"otherSchoolWiki", @"op",
                self->startNum,  @"page",
                self->endNum, @"size",
                nil];
    }
    
    [network sendHttpReq:HttpReq_WikiMySchool andData:data];
}
//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data;

    if (HomeTouched == buttonState) {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                AC_WIKI, @"url",
                @"mySchoolWiki", @"op",
                self->startNum,  @"page",
                self->endNum, @"size",
                nil];
        
    } else {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                AC_WIKI, @"url",
                @"otherSchoolWiki", @"op",
                self->startNum,  @"page",
                self->endNum, @"size",
                nil];
    }

    [network sendHttpReq:HttpReq_WikiMySchool andData:data];
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
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(HttpReq_WikiFollow == type)
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(true == [result intValue])
        {
            //        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSArray *temp = [resultJSON objectForKey:@"message"];
            //        NSArray *temp = [message_info objectForKey:@"list"];
            
            
            if ([@"0"  isEqual: startNum]) {
                [listDataArray removeAllObjects];
                [eidList removeAllObjects];
                [subuidList removeAllObjects];
            }
            
            for (NSObject *object in temp)
            {
                [listDataArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [eidList addObject:[aaa objectForKey:@"tid"]];
                [subuidList addObject:[aaa objectForKey:@"uid"]];
                //[joinedList addObject:[aaa objectForKey:@"joined"]];
            }
            
            //        eventArray = [message_info objectForKey:@"list"];
            //        eventType = [message_info objectForKey:@"type"];
            
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
            //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
            
            //刷新表格内容
            [_tableView reloadData];
            
            if ([listDataArray count] > 0) {
                [noDataView removeFromSuperview];
            }else{
                CGRect rect = CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"老师们还未分享知识库" msg2:@"去共享知识库看看" andRect:rect];
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
