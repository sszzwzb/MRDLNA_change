//
//  KnowledgeSearchViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeSearchViewController.h"

@interface KnowledgeSearchViewController ()

@end

@implementation KnowledgeSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        eidList =[[NSMutableArray alloc] init];
        joinedList =[[NSMutableArray alloc] init];
        listDataArray =[[NSMutableArray alloc] init];
        subuidList =[[NSMutableArray alloc] init];

        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"5";
        
        searchText = @"";
        
        // 获取当前用户的uid
        NSDictionary *user1 = [g_userInfo getUserDetailInfo];
        cid = [user1 objectForKey:@"cid"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"知识库"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];

    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
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
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    
    // search图片
    UIImageView *imgView_searchIcom =[[UIImageView alloc]initWithFrame:CGRectMake(5,5,25,30)];
    //[imgView_searchIcom setImage:[UIImage imageNamed:@"icon_liulan.png"]];
    [self.view addSubview:imgView_searchIcom];

    
    if (isOSVersionLowwerThan(@"7.0")){
    
        textField_search = [[UITextField alloc] initWithFrame: CGRectMake(
                                                                          imgView_searchIcom.frame.origin.x + imgView_searchIcom.frame.size.width,
                                                                          imgView_searchIcom.frame.origin.y+13,
                                                                          WIDTH - imgView_searchIcom.frame.origin.x - imgView_searchIcom.frame.size.width-20 - 60,
                                                                          50)];

    }else{
        textField_search = [[UITextField alloc] initWithFrame: CGRectMake(
                                                                          imgView_searchIcom.frame.origin.x + imgView_searchIcom.frame.size.width,
                                                                          imgView_searchIcom.frame.origin.y-3,
                                                                          WIDTH - imgView_searchIcom.frame.origin.x - imgView_searchIcom.frame.size.width-20 - 60,
                                                                          50)];
 
        
    }
    // search输入框
    
    textField_search.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    textField_search.borderStyle = UITextBorderStyleNone;
    textField_search.backgroundColor = [UIColor clearColor];
    textField_search.placeholder = @"搜索问题...";
    textField_search.font = [UIFont systemFontOfSize:14.0f];
    textField_search.textColor = [UIColor blackColor];
    textField_search.textAlignment = NSTextAlignmentLeft;
    textField_search.keyboardType=UIKeyboardTypeDefault;
    textField_search.returnKeyType =UIReturnKeySearch;
    
    [textField_search setDelegate: self];
    [textField_search addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

    [textField_search performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [self.view addSubview: textField_search];

    // 订阅button
    UIButton *button_search = [UIButton buttonWithType:UIButtonTypeCustom];
    button_search.frame = CGRectMake(
                                     250,
                                     imgView_searchIcom.frame.origin.y,
                                     58, 44);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_search.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [button_search setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_wiki_search_d.png"] forState:UIControlStateNormal] ;
    [button_search setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_wiki_search_p.png"] forState:UIControlStateHighlighted] ;
    
    button_search.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    
    [button_search addTarget:self action:@selector(search_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview:button_search];
    
    // search输入下方的横线
    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(0,50,WIDTH,2)];
    [imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [self.view addSubview:imgView_line];

    // 列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+2, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-35) style:UITableViewStylePlain];
    
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

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"textField text : %@", [textField text]);
    searchText = [textField text];
}

- (IBAction)search_btnclick:(id)sender
{
    [textField_search resignFirstResponder];

    startNum = @"0";
    endNum = @"5";
    
    [eidList removeAllObjects];
    [listDataArray removeAllObjects];
    [_tableView reloadData];
    

     [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"search", @"op",
                          cid, @"cid",
                          searchText, @"keyword",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiSearch andData:data];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if ([@""  isEqual: string]) {
//        
//    }
//    
//    searchText = textField.text;
//    return YES;
    
//    NSString *newString = nil;
//	if (range.length == 0) {
//		newString = [textField_search.text stringByAppendingString:string];
//	} else {
//		NSString *headPart = [textField_search.text substringToIndex:range.location];
//		NSString *tailPart = [textField_search.text substringFromIndex:range.location+range.length];
//		newString = [NSString stringWithFormat:@"%@%@",headPart,tailPart];
//	}
//    searchText = newString;
//    return YES;

    // 获取更改后的uitextField
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    searchText = toBeString;
    return YES;
}
// 当用户按下return键或者按回车键，开始搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"slkjfalskdjf %@", textField.text);
    
    searchText = textField.text;
    
    [textField resignFirstResponder];
    
    return YES;
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
    
    KnowledgeSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[KnowledgeSearchTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUInteger row = [indexPath row];
    
    NSDictionary* list_dic = [listDataArray objectAtIndex:row];
    
    NSString* subject= [list_dic objectForKey:@"subject"];
    NSString* dateline= [list_dic objectForKey:@"dateline"];
    NSString* name= [list_dic objectForKey:@"name"];
    NSString* likes= [list_dic objectForKey:@"likes"];

    Utilities *util = [Utilities alloc];
    
    NSString *timeStr = [NSString stringWithFormat: @"%@",
                         [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];
    
    cell.title = subject;
    cell.time = timeStr;
    cell.name = name;
    cell.topNum = likes;

    //[cell.imgView_head setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@@"loading_gray.png"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.row] forKey:@"tid"];
    
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
//    if (_refreshHeaderView && [_refreshHeaderView superview]) {
//        [_refreshHeaderView removeFromSuperview];
//    }
//    
//	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
//                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
//                                     self.view.frame.size.width, self.view.bounds.size.height)];
//    _refreshHeaderView.delegate = self;
//    
//	[self->_tableView addSubview:_refreshHeaderView];
//    
//    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    //[self setFooterView];
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
        //[self performSelector:@selector(refreshView) withObject:nil afterDelay:0.5];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        //[self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
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
                          @"search", @"op",
                          cid, @"cid",
                          searchText, @"keyword",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiSearch andData:data];
}

//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"search", @"op",
                          cid, @"cid",
                          searchText, @"keyword",
                          nil];
    
    [network sendHttpReq:HttpReq_WikiSearch andData:data];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	if (_refreshHeaderView)
//	{
//        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    }
	
//	if (_refreshFooterView)
//	{
//        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//	if (_refreshHeaderView)
//	{
//        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
	
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
 
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        NSArray *temp = [resultJSON objectForKey:@"message"];
        
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
        
        startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 5)];
        //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:1.0];
        
        //刷新表格内容
        [_tableView reloadData];
    }
    else
    {
        
        [Utilities dismissProcessingHud:self.view];//2015.05.12
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"搜索错误，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
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
