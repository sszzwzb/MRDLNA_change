//
//  KnowledgeCommentViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeCommentViewController.h"

@interface KnowledgeCommentViewController ()

@end

@implementation KnowledgeCommentViewController

@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        startNum = @"0";
        endNum = @"10";

        detailInfo =[[NSMutableDictionary alloc] init];
        dataArray =[[NSMutableArray alloc] init];
        cellHeightArray =[[NSMutableArray alloc] init];

        network = [NetworkUtility alloc];
        network.delegate = self;
        
        likeFlag = 0;
        _isFirstClickReply = false;

        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
        _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"知识库"];
    [ReportObject event:ID_OPEN_WIKI_REPLY_LIST];//2015.06.24
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLikeOrNot:) name:@"Weixiao_knowledgeLikeOrNot" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromKnowledgeComment2ProfileView" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_knowledgeLikeOrNot" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromKnowledgeComment2ProfileView" object:nil];
}

-(void)doGoToProfileView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
//    CGRect rect;
//    // 设置背景scrollView
//    if (iPhone5)
//    {
//        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44);
//    }
//    else
//    {
//        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44);
//    }
//    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
//    
//    if (iPhone5)
//    {
//        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
//    }
//    else
//    {
//        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 20);
//    }
//    
//    _scrollerView.scrollEnabled = YES;
//    _scrollerView.delegate = self;
//    _scrollerView.bounces = YES;
//    _scrollerView.alwaysBounceHorizontal = NO;
//    _scrollerView.alwaysBounceVertical = YES;
//    _scrollerView.directionalLockEnabled = YES;
//    [self.view addSubview:_scrollerView];


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-44) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //    _tableView.backgroundView = imgView_bg;
    
    [self.view addSubview:_tableView];
    
//    inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, 320, 44)];
//    
//    inputBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    
//    inputBar.delegate = self;
//    inputBar.clearInputWhenSend = YES;
//    inputBar.resignFirstResponderWhenSend = YES;
//    
//    [self.view addSubview:inputBar];
    
    [self createHeaderView];
    
    //---add by kate------------------------------------
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [self showCustomKeyBoard];
    //---- add by kate 2015.02.27
    
//    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    singleTouch.delegate = self;
//    [self.view addGestureRecognizer:singleTouch];


    /*以下代码段移到reciveHttpData方法中 modify by kate 2015.02.27
     NSDictionary *user_info = [g_userInfo getUserDetailInfo];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];

    if([@"7"  isEqual: role_id]) {
        if ([@"1"  isEqual: role_checked]) {
        }else {
            //inputBar.hidden = YES;
            toolBar.hidden = YES;// add by kate
            _tableView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height - 44);        }
    }else if ([@"9"  isEqual: role_id] || [@"2"  isEqual: role_id]){
        
    }
    else {
        if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
            //inputBar.hidden = YES;
            toolBar.hidden = YES;// add by kate
            _tableView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height - 44);        }else {
            }
    }*/
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

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *aaasss = [data objectForKey:@"posts"];
    return [dataArray count]+1;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [listDataArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 136;
    }
    return [[cellHeightArray objectAtIndex:(indexPath.row - 1)] floatValue]+48;
//    return [[cellHeightArray objectAtIndex:(indexPath.row - 1)] integerValue]+68;

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

    NSUInteger row = [indexPath row];

    if(row == 0)
    {
        KnowledgeCommentTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];

        if (cell == nil) {
            cell = [[KnowledgeCommentTopTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier1];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString* time= _detail_model.dateline;

        Utilities *util = [Utilities alloc];
        
        //-----update by kate 2014.11.14---------------------------------------------------------------
        NSString *head_url = _detail_model.avatar;
        //NSString* head_url = [util getAvatarFromUid:[threadDic objectForKey:@"uid"] andType:@"1"];
        //------------------------------------------------------------------------------------------
        
        NSString *timeStr = [NSString stringWithFormat: @"%@",
                             [util linuxDateToString:time andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];
        

        cell.title = _detail_model.title;
        cell.time = timeStr;
        cell.message = [threadDic objectForKey:@"summary"];
        cell.name = _detail_model.name;
        cell.reply = totalComment;
        
        NSString *nohelp;
        if (nil == _detail_model.bad) {
            nohelp = @"没有帮助";
        }else {
            nohelp = [@"没有帮助 " stringByAppendingString:[NSString stringWithFormat: @"%@",_detail_model.bad]];
        }
        
        NSString *likes;
        if (nil == _detail_model.good) {
            likes = @"感谢";
        }else {
            likes = [@"感谢 " stringByAppendingString:[NSString stringWithFormat: @"%@",_detail_model.good]];
        }

        [cell.button_noHelp setTitle:nohelp forState:UIControlStateNormal];
        [cell.button_thanks setTitle:likes forState:UIControlStateNormal];

        [cell.imgView_head sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];

        return cell;
    }
    else
    {
        KnowledgeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[KnowledgeCommentTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
        [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
        cell.backgroundView = imgView_bg;
        
        //    NSUInteger section = [indexPath section];
        NSUInteger section = [indexPath row]-1;
        
//        NSArray *aaasss = [data objectForKey:@"posts"];
        
        NSDictionary* list_dic = [dataArray objectAtIndex:section];
        
        NSString* time= [list_dic objectForKey:@"dateline"];
        NSString* name= [list_dic objectForKey:@"name"];
        NSString* message= [list_dic objectForKey:@"message"];
        NSString* subuid= [list_dic objectForKey:@"uid"];
        
        Utilities *util = [Utilities alloc];
        
        //---update by kate 2014.11.14-----------------------------------
        //NSString* head_url = [util getAvatarFromUid:subuid andType:@"1"];
        NSString *head_url = [list_dic objectForKey:@"avatar"];
        //---------------------------------------------------------------
        
        NSString *timeStr = [NSString stringWithFormat: @"%@",
                             [util linuxDateToString:time andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];
        
        // 以/div为标识，分割字符串
        NSArray * array = [message componentsSeparatedByString:@"</div>"];
        
        NSString *resultStr = @"";
        NSRange range;
        
        for(NSObject *temp in array)
        {
            NSString *str = (NSString *)temp;
            
            // 去掉html中的标识
            while ((range = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                str=[str stringByReplacingCharactersInRange:range withString:@""];
            }
            
            str = [str stringByAppendingString:@"\n"];
            resultStr = [resultStr stringByAppendingString:str];
        }
        
        /*---2015.09.18----------------------------------------------------------------------
         [cell.textParser.images removeAllObjects];
         
         NSString *displayStr = [self transformString:resultStr];
         NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
         
         attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
         [attString setFont:[UIFont systemFontOfSize:13]];
         
         [cell.label resetAttributedText];
         
         //NSLog(@"images:%@",textParser.images);
         //NSLog(@"attString:%@",attString);
         [cell.label setAttString:attString withImages:cell.textParser.images];
         */
        [cell setMLLabelText:resultStr];
        //----------------------------------------------------------------------------------------

        cell.name = name;
        cell.time = timeStr;
//        cell.comment = resultStr;
        cell.subuid = subuid;
        cell.pid = [list_dic objectForKey:@"pid"];

        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];

//        [cell.imgView_head sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        
        cell.imgView_line1.frame = CGRectMake(20,[[cellHeightArray objectAtIndex:(indexPath.row - 1)] floatValue] + 47,280,1);

#if 0
        cell.label_comment.frame = CGRectMake(
                                              cell.label_time.frame.origin.x,
                                              cell.label_time.frame.origin.y + cell.label_time.frame.size.height,
                                              WIDTH - 75 - 35 - 15,
                                              [[cellHeightArray objectAtIndex:(indexPath.row - 1)] integerValue]);
#endif
        cell.label.frame = CGRectMake(
                                              cell.label_time.frame.origin.x,
                                              cell.label_time.frame.origin.y + cell.label_time.frame.size.height,
                                              WIDTH - 75 - 35 - 15,
                                              [[cellHeightArray objectAtIndex:(indexPath.row - 1)] floatValue]);

        return cell;
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row!=0){
        KnowledgeCommentTableViewCell *detailCell = (KnowledgeCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        NSString* uid= [Utilities getUniqueUidWithoutQuit];
        
        if (![uid isEqual: detailCell.subuid]) {
            [textView becomeFirstResponder];
            
            textView.text = [NSString stringWithFormat:@"回复%@:", detailCell.name];
            _isFirstClickReply = true;

            isCommentComment = YES;
            _replyPid = detailCell.pid;
        }else {
            textView.text = @"";
            isCommentComment = NO;
            
            //-----add by kate 2015.03.23--------
            NSDictionary* list_dic = [dataArray objectAtIndex:indexPath.row-1];
            pid = [list_dic objectForKey:@"pid"];
            
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除这条评论？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alerV.tag = 305;
            [alerV show];
            //-----------------------------------
        }
    }else{
        //NSLog(@"000");
        
        [textView resignFirstResponder];
    }
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.row] forKey:@"tid"];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         [eidList objectAtIndex:indexPath.row], @"tid",
//                         [subuidList objectAtIndex:indexPath.row], @"subuid", nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToKnowledgeDetailView" object:self userInfo:dic];
    
    //add your code beck 回复评论
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
    
   
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Wiki",@"ac",
                          @"2",@"v",
                          @"wikiItemComments", @"op",
                          _kid, @"kid",
                          self->startNum, @"page",
                          self->endNum, @"size",
                          nil];

    [network sendHttpReq:HttpReq_KnowledgeWikiItemComment andData:data1];
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
    endNum = @"10";

    [dataArray removeAllObjects];

    NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           REQ_URL, @"url",
                           @"Wiki",@"ac",
                           @"2",@"v",
                           @"wikiItemComments", @"op",
                           _kid, @"kid",
                           self->startNum, @"page",
                           self->endNum, @"size",
                           nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiItemComment andData:data1];
}

//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           REQ_URL, @"url",
                           @"Wiki",@"ac",
                           @"2",@"v",
                           @"wikiItemComments", @"op",
                           _kid, @"kid",
                           self->startNum, @"page",
                           self->endNum, @"size",
                           nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiItemComment andData:data1];
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

-(void)doLikeOrNot:(NSNotification *)notification
{
    NSLog(@"doLikeOrNot");
    NSDictionary *dic = [notification userInfo];
    NSString *tag = [dic objectForKey:@"tag"];
    
    if([@"1"  isEqual: tag]) {
        if(0 == likeFlag)
        {
//            if(([[NSString stringWithFormat:@"%@",[data objectForKey:@"isLikeClicked"]] isEqual: @"1"]) ||
//               ([[NSString stringWithFormat:@"%@",[data objectForKey:@"isNoHelpClicked"]]  isEqual: @"1"]))
//            {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"已经评价过了，不要重复评价。"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
//
//            }
//            else
//            {
            
             [Utilities showProcessingHud:self.view];//2015.05.12
            
            _goodOrBadClicked = @"good";
            
            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"MyWiki",@"ac",
                                  @"2",@"v",
                                  @"reviewWiki", @"op",
                                  _detail_model.kid, @"kid",
                                  @"1", @"review",
                                  nil];
            
            [network sendHttpReq:HttpReq_WikiLikeOrNot andData:data1];

//            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"已经评价过了，不要重复评价。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"2"  isEqual: tag]) {
        if(0 == likeFlag)
        {
//            if(([[NSString stringWithFormat:@"%@",[data objectForKey:@"isLikeClicked"]] isEqual: @"1"]) ||
//               ([[NSString stringWithFormat:@"%@",[data objectForKey:@"isNoHelpClicked"]]  isEqual: @"1"]))
//            {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"已经评价过了，不要重复评价。"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
//
//            }
//            else
//            {
            
             [Utilities showProcessingHud:self.view];//2015.05.12
            
            _goodOrBadClicked = @"bad";

            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   REQ_URL, @"url",
                                   @"MyWiki",@"ac",
                                   @"2",@"v",
                                   @"reviewWiki", @"op",
                                   _detail_model.kid, @"kid",
                                   @"0", @"review",
                                   nil];
            
            [network sendHttpReq:HttpReq_WikiLikeOrNot andData:data1];

//            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"已经评价过了，不要重复评价。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSDictionary* message_info = [resultJSON objectForKey:@"message"];

    if ((HttpReq_WikiLikeOrNot == type) ||
        ((HttpReq_WikiComment == type)))
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        likeFlag = 1;
        
    } else if ([@"MyWikiAction.commentWiki"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue]) {
            //[MBProgressHUD showSuccess:message_info toView:nil];
             [Utilities showSuccessedHud:message_info descView:self.view];//2015.05.12
            
            self->startNum = @"0";
            
            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   REQ_URL, @"url",
                                   @"Wiki",@"ac",
                                   @"2",@"v",
                                   @"wikiItemComments", @"op",
                                   _kid, @"kid",
                                   self->startNum, @"page",
                                   self->endNum, @"size",
                                   nil];
            
            [network sendHttpReq:HttpReq_KnowledgeWikiItemComment andData:data1];
        }else {
            //[MBProgressHUD showError:message_info toView:nil];
            [Utilities showFailedHud:message_info descView:self.view];// 2015.05.12
            
        }
    }else if ([@"MyWikiAction.reviewWiki"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        // 赞或者不喜欢结果
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue]) {
            //[MBProgressHUD showSuccess:message_info toView:nil];
            [Utilities showSuccessedHud:message_info descView:self.view];// 2015.05.12 需要重写
            
            if ([@"good" isEqualToString:_goodOrBadClicked]) {
                [button_thanks setTitle:[NSString stringWithFormat:@"%ld", [button_thanks.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
            }else {
                [button_noHelp setTitle:[NSString stringWithFormat:@"%ld", [button_noHelp.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
            }
        }else {
            //[MBProgressHUD showError:message_info toView:nil];
            [Utilities showFailedHud:message_info descView:self.view];// 2015.05.12 需要重写
        }
    } else if ([@"WikiAction.wikiItemComments"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        //---add by kate--------------
        if(message_info!=nil){
            
            toolBar.hidden = NO;
            NSDictionary *user_info = [g_userInfo getUserDetailInfo];
            
            NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
            NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];
            
            NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
            // 2015.05.25 为教育局专版做特殊处理，没有身份的老师和学生可以发评论。
            // 持保留意见
            //if (![schoolType isEqualToString:@"bureau"]) {//教育局专版 2015.10.29 教育局改版
                if([@"7"  isEqual: role_id]) {
                    if ([@"1"  isEqual: role_checked]) {
                    }else {
                        //inputBar.hidden = YES;
                        toolBar.hidden = YES;// add by kate
                        _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);        }
                }else if ([@"9"  isEqual: role_id] || [@"2"  isEqual: role_id]){
                }
                else {
                    if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                        //inputBar.hidden = YES;
                        toolBar.hidden = YES;// add by kate
                        _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);        }else {
                        }
                }
            //}
        }
        //-----------------------------
        
        threadDic = [message_info objectForKey:@"thread"];
        NSDictionary *temp = [message_info objectForKey:@"posts"];
        totalComment = [message_info objectForKey:@"count"];

        NSArray *temp1 = [message_info objectForKey:@"list"];
        
        if ([@"0"  isEqual: startNum]) {
            [dataArray removeAllObjects];
        }
        
        for (NSObject *object in temp1)
        {
            [dataArray addObject:object];
            
//            NSDictionary *aaa = (NSDictionary *)object;
//            [tidList addObject:[aaa objectForKey:@"tid"]];
        }

        [self calcCellHeight ];
        
        //刷新表格内容
        [_tableView reloadData];
        
        if (0 !=[temp1 count]) {
            startNum = [NSString stringWithFormat:@"%u", [dataArray count] + 10];
        }
        
        //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];

//        NSString* message_info = [resultJSON objectForKey:@"message"];
//        
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                       message:message_info
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
    }else if ([@"MyWikiAction.deleteWikiComment" isEqual:[resultJSON objectForKey:@"protocol"]]){//add by kate 2015.03.23
        
        if (true == [result intValue]) {
            
            [self refreshView];
            
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"删除失败，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //-------
    if (alertView.tag == 305) {
        if (buttonIndex == 1) {
            NSDictionary *dicData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"MyWiki",@"ac",
                                  @"2",@"v",
                                  @"deleteWikiComment", @"op",
                                  pid, @"pid",
                                  nil];
            
            [network sendHttpReq:HttpReq_deleteWikiComment andData:dicData];
        }
    }else{
       
        [Utilities showProcessingHud:self.view];//2015.05.12
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
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

// cell高度
-(void)calcCellHeight
{
    [cellHeightArray removeAllObjects];
    
    for (int i=0; i<[dataArray count]; i++) {
        NSDictionary* list_dic = [dataArray objectAtIndex:i];
        
        NSString* message= [list_dic objectForKey:@"message"];
        
        // 以/div为标识，分割字符串
        NSArray * array = [message componentsSeparatedByString:@"</div>"];
        
        NSString *resultStr = @"";
        NSRange range;
        
        for(NSObject *temp in array)
        {
            NSString *str = (NSString *)temp;
            
            // 去掉html中的标识
            while ((range = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                str=[str stringByReplacingCharactersInRange:range withString:@""];
            }
            
            str = [str stringByAppendingString:@"\n"];
            resultStr = [resultStr stringByAppendingString:str];
        }

        /*----2015.09.18---------------------------------------------------------------------------------------
         NSString *newString = [self textFromEmoji:resultStr];
         //    CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont systemFontOfSize:16.0]  withWidth:[UIScreen mainScreen].bounds.size.width - 70.0];
         CGSize size = [Utilities getStringHeight:newString andFont:[UIFont systemFontOfSize:13.0] andSize:CGSizeMake(320 - 75 - 35 - 15, 0)];*/
        CGSize size = [KnowledgeCommentTableViewCell heightForEmojiText:resultStr];
        //----------------------------------------------------------------------------------------------------------------

        
        CGFloat contentHeight = size.height;
        
        [cellHeightArray addObject:[NSString stringWithFormat:@"%f",contentHeight]];

    }
}

- (NSString *)textFromEmoji:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"怒"];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

//-----add by kate--------------------------------------------------
-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolBar.hidden = YES;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    //textView.returnKeyType = UIReturnKeyDone;
    
    //---update 2015.07.23-----------------------------------------------
//    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
//    singleTouch.delegate = self;
//    [textView addGestureRecognizer:singleTouch];

    //---------------------------------------------------------------------
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    [toolBar addSubview:entryImageView];
    [toolBar addSubview:textView];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    clickFlag = 0;
    
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(284.0 - 9, 5.0, 40.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    
    [self.view addSubview:toolBar];
}

// 自定义输入框发表按钮,发送评论
-(void)AudioClick:(id)sender{
    if ([@""  isEqual: textView.text]) {
        [MBProgressHUD showError:@"请输入回复内容。" toView:textView.inputView];
    }else {
        if (isCommentComment) {
            
             [Utilities showProcessingHud:self.view];//2015.05.12
            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   REQ_URL, @"url",
                                   @"MyWiki",@"ac",
                                   @"2",@"v",
                                   @"commentWiki", @"op",
                                   _kid, @"kid",
                                   _replyPid, @"pid",
                                   textView.text, @"message",
                                   nil];
            
            [network sendHttpReq:HttpReq_WikiComment andData:data1];
            
            isCommentComment = NO;
        }else {
            
            [ReportObject event:ID_REPLY_WIKI];//2015.06.24
             [Utilities showProcessingHud:self.view];//2015.05.12
            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   REQ_URL, @"url",
                                   @"MyWiki",@"ac",
                                   @"2",@"v",
                                   @"commentWiki", @"op",
                                   _kid, @"kid",
                                   @"0", @"pid",
                                   textView.text, @"message",
                                   nil];
            
            [network sendHttpReq:HttpReq_WikiComment andData:data1];
        }
        
        //--------------------------------------------------
        //键盘下落
        isButtonClicked = NO;
        textView.inputView = nil;
        isSystemBoardShow = NO;
        textView.text = @"";
        textView.frame = CGRectMake(43.0, 5.0, 205-15+40.0, 33);
        clickFlag = 0;
        [textView resignFirstResponder];
        toolBar.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44);
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }
}

// 自定义输入框点击输入框事件
-(void)clickTextView:(id)sender{
    
    if (textView.inputView!=nil) {
        isButtonClicked = YES;
        textView.inputView = nil;
        isSystemBoardShow = YES;
        clickFlag = 0;
        [textView resignFirstResponder];
    }else{
        [textView becomeFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
//        if ( range.length > 1 ) {
//            
//            return YES;
//        }
//        else {
//            
//            [faceBoard backFace];
//            
//            return NO;
//        }
        return YES;
    }
    else {
        
        if (range.location >= 500) {//知识库回帖 500 2015.07.21
            return NO;
        }else {
            if (_isFirstClickReply) {
                self->textView.text = @"";
                _isFirstClickReply = false;
            }

            return YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    
   
    CGSize size = textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
    }
}

-(void)faceBoardClick:(id)sender{
    
    clickFlag = 1;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [textView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            textView.inputView = faceBoard;
        }
        
        [textView becomeFirstResponder];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // 键盘弹出时，清空输入框，之后可以优化为为每一条记录之前输入的内容，类似微信。
    //    textView.text = @"";
    
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         _tableView.frame = frame;
                         
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        switch (clickFlag) {
            case 1:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                
                break;
            default:
                break;
        }
        
    }
    else {
        
        switch (clickFlag) {
            case 1:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
            default:
                break;
        }
    }
    
    //    if ( discussArray.count ) {
    //
    //        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:discussArray.count - 1
    //                                                              inSection:0]
    //                          atScrollPosition:UITableViewScrollPositionBottom
    //                                  animated:NO];
    //    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         _tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
//    isCommentComment = NO;
    //textView.text = @"";
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [textView.inputView isEqual:faceBoard]) {
                    
                    isSystemBoardShow = YES;
                    textView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        textView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        textView.inputView = faceBoard;
                        
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    textView.inputView = faceBoard;
                    
                }
            }
                
                break;
            default:
                break;
        }
        
        [textView becomeFirstResponder];
    }
}

-(void)dismissKeyboard{
    
    [textView resignFirstResponder];
}

//--------------------------------------------------------------

/*Label过滤*/
- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    
    NSString *text = [self transformString:o_text];
    /*text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];*/
    MarkupParser* p = [[MarkupParser alloc] init] ;
    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
    
    //    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    label.backgroundColor = [UIColor clearColor];
    [label setAttString:attString withImages:p.images];
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    
    
    //    label.onlyCatchTouchesOnLinks = NO;
    //label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
    // 调用这个方法立即触发label的|drawTextInRect:|方法，
    // |setNeedsDisplay|方法有滞后，因为这个需要画面稳定后才调用|drawTextInRect:|方法
    // 这里我们创建的时候就需要调用|drawTextInRect:|方法，所以用|display|方法，这个我找了很久才发现的
}

/*画表情,将表情的imageview加到自定义label上*/
- (void)drawImage:(OHAttributedLabel *)label
{
    for (NSArray *info in label.imageInfoArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[info objectAtIndex:0] ofType:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            NSLog(@"存在");
        }else{
            NSLog(@"不存在");
        }
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
        //UIImage* image = [UIImage imageWithData:data];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectFromString([info objectAtIndex:2]);
        [label addSubview:imageView];//label内添加图片层
        [label bringSubviewToFront:imageView];
        
    }
}

- (NSString *)transformString:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='14' height='14'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

@end
