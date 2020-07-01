//
//  DiscussViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "DiscussViewController.h"

@interface DiscussViewController ()

@end

@implementation DiscussViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [super setCustomizeTitle:@"讨论区"];
        [super setCustomizeLeftButton];

        network = [NetworkUtility alloc];
        network.delegate = self;

        tidList =[[NSMutableArray alloc] init];
        discussArray =[[NSMutableArray alloc] init];
        
        reflashFlag = 1;
        isReflashViewType = 1;
    }
    return self;
}

-(void)selectRightAction:(id)sender
{
    NSDictionary *user_info = [g_userInfo getUserDetailInfo];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];
    
    //---update by kate 2014.12.02 -------------------------------------------------------------------
    
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
        /*教育局版改版 2015.10.29
         if ([schoolType isEqualToString:@"bureau"]) {
            
            SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
            if ([_fromName isEqualToString:@"classDiscuss"]){
                [submitViewCtrl setFlag:3];
            }else{
                [submitViewCtrl setFlag:1];
            }
            
            [self.navigationController pushViewController:submitViewCtrl animated:YES];
        }else {*/
            if([@"7"  isEqual: role_id]) {
                if ([@"1"  isEqual: role_checked]) {
                    SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
                    if ([_fromName isEqualToString:@"classDiscuss"]){
                        [submitViewCtrl setFlag:3];
                    }else{
                        [submitViewCtrl setFlag:1];
                    }
                    
                    [self.navigationController pushViewController:submitViewCtrl animated:YES];
                }else if([@"2"  isEqual: role_checked]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"您还未获得教师身份，请递交申请."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else if([@"0"  isEqual: role_checked]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"请耐心等待审批."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }else if([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                
                SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
                if ([_fromName isEqualToString:@"classDiscuss"]){
                    [submitViewCtrl setFlag:3];
                }else{
                    [submitViewCtrl setFlag:1];
                }
                [self.navigationController pushViewController:submitViewCtrl animated:YES];
                
            }else {
                
                NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
                /*2015.10.29 教育局改版
                 if ([@"bureau" isEqualToString:schoolType]){
                    
                    SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
                    if ([_fromName isEqualToString:@"classDiscuss"]){
                        [submitViewCtrl setFlag:3];
                    }else{
                        [submitViewCtrl setFlag:1];
                    }
                    [self.navigationController pushViewController:submitViewCtrl animated:YES];
                    
                }else*/{
                    if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
#if BUREAU_OF_EDUCATION
             NSString *msg = @"请先加入一个部门";
#else
         NSString *msg = @"请先加入一个班级";
#endif
                        
                        
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                       message:msg
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                        [alert show];
                    }else {
                        SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
                        if ([_fromName isEqualToString:@"classDiscuss"]){
                            [submitViewCtrl setFlag:3];
                        }else{
                            [submitViewCtrl setFlag:1];
                        }
                        [self.navigationController pushViewController:submitViewCtrl animated:YES];
                    }
                }
                
                
            }
        //}
    
    
}

-(void)selectLeftAction:(id)sender
{
    // 设置刷新标志位，在下拉或者上拉刷新的时候，先判断是否需要网络请求，
    // 如不需要，则不请求
    reflashFlag = 0;
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)initiator_btnclick:(id)sender
{
    MyInitiatorViewController *initiatorViewCtrl = [[MyInitiatorViewController alloc] init];
    initiatorViewCtrl.nextPageTitle = _titleName;
    [self.navigationController pushViewController:initiatorViewCtrl animated:YES];
}

- (IBAction)response_btnclick:(id)sender
{
    MyResponseViewController *responseViewCtrl = [[MyResponseViewController alloc] init];
    responseViewCtrl.nextPageTitle = _titleName;
    [self.navigationController pushViewController:responseViewCtrl animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setCustomizeTitle:_titleName];//update by kate

	// Do any additional setup after loading the view.
    [Utilities showProcessingHud:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshViewForDiscussView"
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    // 教育局版本校校通
    if (![_fromName isEqualToString:@"schoolExhi"]) {
        [super setCustomizeRightButton:@"icon_edit_forums.png"];
    }

//    [tidList removeAllObjects];
//    [_tableView reloadData];
//
//    [self refreshView];

//    [self refreshView];
    //[_tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromDiscussView2ProfileView" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromDiscussView2ProfileView" object:nil];
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
    self->startNum = @"0";
    self->endNum = @"10";
    
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    UIImageView *imgView_table_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,130,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 130 - 44)];
    [imgView_table_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    
    _tableView.backgroundView = imgView_table_bg;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if ([_fromName isEqualToString:@"classDiscuss"]) {
        
    }else{
    
        [ReportObject event:ID_OPEN_THREAD_LIST];//2015.06.24
        //-----update by kate 2014.11.26--------------------------------
        
      
        if ([@"schoolExhi" isEqualToString:_fromName]) {
            _tableView.tableHeaderView = nil;
        }else{
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         [UIScreen mainScreen].applicationFrame.size.width,
                                                                         130)];
            
            // 上方背景图片
            UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,130)];
            imgView_bg.image=[UIImage imageNamed:@"bg_forums_list_top.png"];
            imgView_bg.contentMode = UIViewContentModeScaleToFill;
            [headerView addSubview:imgView_bg];//
            
            // 上方背景图片装饰条
            UIImageView *imgView_bg1 =[[UIImageView alloc]initWithFrame:CGRectMake(0,90,[UIScreen mainScreen].applicationFrame.size.width,40)];
            imgView_bg1.image=[UIImage imageNamed:@"bg_forums_black.png"];
            imgView_bg1.contentMode = UIViewContentModeScaleToFill;
            [headerView addSubview:imgView_bg1];//
            
            // 头像背景图片
            //    image_head_bg =[[UIImageView alloc]initWithFrame:CGRectMake(
            //                                                                10,50,70,70)];
            //    image_head_bg.image=[UIImage imageNamed:@"bg_photo.png"];
            //    image_head_bg.contentMode = UIViewContentModeScaleToFill;
            //    [self.view addSubview:image_head_bg];
            
            // 去单例中取得用户profile
            NSDictionary *user;
            user = [g_userInfo getUserDetailInfo];
            
            //    NSString *avatar = [user objectForKey:@"avatar"];
            // 头像
            image_head =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                     10,50,70,70)];
            //                                                             image_head_bg.frame.origin.x + 4,
            //                                                             image_head_bg.frame.origin.y + 4,
            //                                                             image_head_bg.frame.size.width - 8,
            //                                                             image_head_bg.frame.size.height - 8)];
            image_head.layer.masksToBounds = YES;
            image_head.layer.cornerRadius = 70/2;
            image_head.contentMode = UIViewContentModeScaleToFill;
            
            //Utilities *util = [Utilities alloc];
            //-----update by kate 2014.11.14---------------------------------------------------------------
            NSString *head_url = [user objectForKey:@"avatar"];
            //NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"1"];
            //----------------------------------------------------------------------------------------------
            [image_head sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            
            //    [image_head setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"cus_bgImg.png"]];
            [headerView addSubview:image_head];//
            
            // 名字
            label_name = [[UILabel alloc] initWithFrame:CGRectMake(85, 100, 130, 20)];
            //设置title自适应对齐
            
            NSString *title = [user objectForKey:@"role_name"];
            NSString *name = [user objectForKey:@"name"];
            NSString* duty = [user objectForKey:@"duty"];
            
            if ((nil != duty) && (![@""  isEqual: duty])) {
                name = [NSString stringWithFormat:@"%@|%@",name,duty];
            }else {
                name = [NSString stringWithFormat:@"%@|%@",name,title];
            }
            
            label_name.text = name;
            label_name.lineBreakMode = NSLineBreakByWordWrapping;
            
            //    label_name.text = [user objectForKey:@"name"];
            label_name.font = [UIFont systemFontOfSize:16.0f];
            label_name.numberOfLines = 0;
            label_name.lineBreakMode = NSLineBreakByTruncatingTail;
            label_name.textColor = [UIColor whiteColor];
            label_name.backgroundColor = [UIColor clearColor];
            [headerView addSubview:label_name];//
            
            // 我发起的主题
            button_initiator = [UIButton buttonWithType:UIButtonTypeCustom];
            button_initiator.frame = CGRectMake(230, 90, 40, 40);
            button_initiator.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            //设置title自适应对齐
            button_initiator.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            // 设置颜色和字体
            [button_initiator setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button_initiator setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            button_initiator.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            
            [button_initiator setBackgroundImage:[UIImage imageNamed:@"bg_forums_me_d.png"] forState:UIControlStateNormal] ;
            [button_initiator setBackgroundImage:[UIImage imageNamed:@"bg_forums_me_d.png"] forState:UIControlStateHighlighted] ;
            // 添加 action
            [button_initiator addTarget:self action:@selector(initiator_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            button_initiator.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//加了这个 回车符就能正常显示了
            
            //设置title
            //    [button_initiator setTitle:@"0\n发起" forState:UIControlStateNormal];
            //    [button_initiator setTitle:@"0\n发起" forState:UIControlStateHighlighted];
            [button_initiator setTitle:@"发起" forState:UIControlStateNormal];
            [button_initiator setTitle:@"发起" forState:UIControlStateHighlighted];
            
            [headerView addSubview:button_initiator];//
            
            // 我回复的主题
            button_response = [UIButton buttonWithType:UIButtonTypeCustom];
            button_response.frame = CGRectMake(275, 90, 40, 40);
            button_response.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            //设置title自适应对齐
            button_response.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            // 设置颜色和字体
            [button_response setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button_response setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            button_response.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            
            [button_response setBackgroundImage:[UIImage imageNamed:@"bg_forums_me_d.png"] forState:UIControlStateNormal] ;
            [button_response setBackgroundImage:[UIImage imageNamed:@"bg_forums_me_d.png"] forState:UIControlStateHighlighted] ;
            // 添加 action
            [button_response addTarget:self action:@selector(response_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            button_response.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//加了这个 回车符就能正常显示了
            
            //设置title
            [button_response setTitle:@"回应" forState:UIControlStateNormal];
            [button_response setTitle:@"回应" forState:UIControlStateHighlighted];
            
            [headerView addSubview:button_response];//
            _tableView.tableHeaderView = headerView;
        }
       
    
    //---------------------------------------------------------------------------------------------
    }

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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [discussArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 指定行的高度
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    DiscussTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[DiscussTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSUInteger section = [indexPath section];
    NSDictionary* list_dic = [discussArray objectAtIndex:section];
    
    NSString* subject= [list_dic objectForKey:@"subject"];
    NSString* dateline= [list_dic objectForKey:@"dateline"];
    NSString* viewnum= [list_dic objectForKey:@"viewnum"];
    NSString* username= [list_dic objectForKey:@"username"];
    NSString* sbj_uid= [list_dic objectForKey:@"uid"];
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

//    if([@"1"  isEqual: stick])
//    {
//        [cell.imgView_stick setImage:[UIImage imageNamed:@"icon_top.png"]];
//    }

    Utilities *util = [Utilities alloc];
    //-----update by kate 2014.11.14-----------------------------------
    NSString *head_url = [list_dic objectForKey:@"avatar"];
//    NSString* head_url = [util getAvatarFromUid:sbj_uid andType:@"1"];
    //-----------------------------------------------------------------
    
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];

    cell.dateline = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    
    cell.subject = subject;
    NSString *viewNumSrt = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];
    cell.viewnum = viewNumSrt;
    cell.username = username;
    cell.replynum = replynum;
    cell.uid = sbj_uid;
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid = [tidList objectAtIndex:indexPath.section];
    
    if ([_fromName isEqualToString:@"classDiscuss"]) {
        [disscussDetailViewCtrl setFlag:4];
    }else{
        [disscussDetailViewCtrl setFlag:1];
    }
    
    if ([_fromName isEqualToString:@"schoolExhi"]) {
        [ReportObject event:ID_OPEN_SUBORDINATE_FORUM_DETAIL];//2015.06.25
        
        disscussDetailViewCtrl.viewType = @"schoolExhi";
        disscussDetailViewCtrl.schoolExhiId = _schoolExhiId;
        [disscussDetailViewCtrl setFlag:5];
    }

    NSDictionary* list_dic = [discussArray objectAtIndex:indexPath.section];
    NSString* subject= [list_dic objectForKey:@"subject"];
    disscussDetailViewCtrl.disTitle = _titleName;
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
    
    if ([_fromName isEqualToString:@"schoolExhi"]) {
        [ReportObject event:ID_OPEN_SUBORDINATE_FORUM_DETAIL];//2015.06.25
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete");
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[tidList objectAtIndex:indexPath.row] forKey:@"tid"];
    NSDictionary* list_dic = [discussArray objectAtIndex:indexPath.section];
    NSString *uid_table= [list_dic objectForKey:@"uid"];
    if ([[Utilities getUniqueUid] isEqualToString:uid_table]) {
        [self reflashHomeworkView:list_dic];
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
    
    // 因为在viewwillappare里面调用了 所以这里不调用
    // 发出两次请求会有问题
    
    //---update by kate 2014.12.02----------------------------------------------
    if ([_fromName isEqualToString:@"classDiscuss"]) {
        // ac=ClassForumThread&v=1 op=threads&sid=&cid=&uid=&page=&size=
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"ClassForumThread",@"ac",
                              @"1",@"v",
                              @"threads", @"op",
                              _cId,@"cid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        [network sendHttpReq:HttpReq_ClassThread andData:data];
        
    }else if ([_fromName isEqualToString:@"schoolExhi"]) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"SchoolThread",@"ac",
                              @"threads", @"op",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              _schoolExhiId, @"sid",
                              nil];
        
        [network sendHttpReq:HttpReq_Thread andData:data];
    }else{
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"SchoolThread",@"ac",
                              @"threads", @"op",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        //-------------------------------------------------------------------
         [network sendHttpReq:HttpReq_Thread andData:data];
    }
    
   //-------------------------------------------------------------------------------
    
   
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
    isReflashViewType = 1;

    if (reflashFlag == 1) {
        NSLog(@"刷新完成");

        startNum = @"0";
        endNum = @"10";
        
        //---update by kate 2014.12.02----------------------------------------------
        if ([_fromName isEqualToString:@"classDiscuss"]) {
            // ac=ClassForumThread&v=1 op=threads&sid=&cid=&uid=&page=&size=
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"threads", @"op",
                                  _cId,@"cid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  nil];
            [network sendHttpReq:HttpReq_ClassThread andData:data];
            
        }else if ([_fromName isEqualToString:@"schoolExhi"]) {
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"SchoolThread",@"ac",
                                  @"threads", @"op",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  _schoolExhiId, @"sid",
                                  nil];
            
            [network sendHttpReq:HttpReq_Thread andData:data];
        }else{
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"SchoolThread",@"ac",
                              @"threads", @"op",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        //----------------------------------------------------------------

            [network sendHttpReq:HttpReq_Thread andData:data];
        }
        //-------------------------------------------------------------------------------
    }
}
//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        //---update by kate 2014.12.02----------------------------------------------
        if ([_fromName isEqualToString:@"classDiscuss"]) {
            // ac=ClassForumThread&v=1 op=threads&sid=&cid=&uid=&page=&size=
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"threads", @"op",
                                  _cId,@"cid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  nil];
            [network sendHttpReq:HttpReq_ClassThread andData:data];
            
        }else if ([_fromName isEqualToString:@"schoolExhi"]) {
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"SchoolThread",@"ac",
                                  @"threads", @"op",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  _schoolExhiId, @"sid",
                                  nil];
            
            [network sendHttpReq:HttpReq_Thread andData:data];
        }else{
\
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"SchoolThread",@"ac",
                                  @"threads", @"op",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  nil];
            //----------------------------------------------------------------
            
                [network sendHttpReq:HttpReq_Thread andData:data];
        }
        //--------------------------------------------------------------------------
    }
    
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
    
    /*if ([_fromName isEqualToString:@"classDiscuss"]) {
    
        if(true == [result intValue])
        {
     
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSLog(@"messge:%@",message_info);
            
            NSArray *temp = [message_info objectForKey:@"list"];
            
            if (isReflashViewType == 1) {
                [discussArray removeAllObjects];
                [tidList removeAllObjects];
            }
            
            for (NSObject *object in temp)
            {
                [discussArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [tidList addObject:[aaa objectForKey:@"tid"]];
            }
            
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            NSString *newsId = @"0";
            if([tidList count]>0){
                
                if ([_fromName isEqualToString:@"discuss"]) {
                
                    newsId = [message_info objectForKey:@"last"];
                    
                }else{
                    
                //刷新表格内容
                NSComparator cmptr = ^(id obj1, id obj2){
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1 integerValue] < [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                };
                
                NSArray *array = [tidList sortedArrayUsingComparator:cmptr];
                
                NSString *str = [array lastObject];
                //[[NSUserDefaults standardUserDefaults]setObject:str forKey:@"lastId_chat"];
                newsId = [NSString stringWithFormat:@"%@",str];
                
                if([array count] == 0){
                    newsId = @"0";
                }
                }
                
                /*if ([_fromName isEqualToString:@"classDiscuss"]) {
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastClassDisIdDic"]];
                    [tempDic setObject:newsId forKey:_cId];
                    [userDefaults setObject:tempDic forKey:@"lastClassDisIdDic"];
                    [userDefaults synchronize];
                    
                }else{
                     [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:_titleName];
                }
                
                [_tableView reloadData];
                
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
        
    }else{*/
    
    if ([@"SchoolThreadAction.delete"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        [Utilities dismissProcessingHud:self.view];
        if(true == [result intValue])
        {
           [self refreshView];
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
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            mythreads = [message_info objectForKey:@"mythreads"];
            myposts = [message_info objectForKey:@"myposts"];
            
            [button_initiator setTitle:[NSString stringWithFormat: @"%@\n发起", mythreads] forState:UIControlStateNormal];
            [button_initiator setTitle:[NSString stringWithFormat: @"%@\n发起", mythreads] forState:UIControlStateHighlighted];
            
            [button_response setTitle:[NSString stringWithFormat: @"%@\n回应", myposts] forState:UIControlStateNormal];
            [button_response setTitle:[NSString stringWithFormat: @"%@\n回应", myposts] forState:UIControlStateHighlighted];
            
            NSArray *temp = [message_info objectForKey:@"list"];
            
            if (isReflashViewType == 1) {
                [discussArray removeAllObjects];
                [tidList removeAllObjects];
            }
            
            for (NSObject *object in temp)
            {
                [discussArray addObject:object];
                
                NSDictionary *aaa = (NSDictionary *)object;
                [tidList addObject:[aaa objectForKey:@"tid"]];
            }
            
            //        DiscussListData *listData = DiscussListData.sharedDiscussListDataSingleton;
            //        [listData setDiscussArray:discussArray];
            
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            NSString *newsId = @"0";
            if([tidList count]>0){
                //刷新表格内容
                /*NSComparator cmptr = ^(id obj1, id obj2){
                 if ([obj1 integerValue] > [obj2 integerValue]) {
                 return (NSComparisonResult)NSOrderedDescending;
                 }
                 
                 if ([obj1 integerValue] < [obj2 integerValue]) {
                 return (NSComparisonResult)NSOrderedAscending;
                 }
                 return (NSComparisonResult)NSOrderedSame;
                 };
                 
                 NSArray *array = [tidList sortedArrayUsingComparator:cmptr];
                 
                 NSString *str = [array lastObject];
                 //[[NSUserDefaults standardUserDefaults]setObject:str forKey:@"lastId_chat"];*/
                
                newsId = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"last"]];
                [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:_titleName];
                [_tableView reloadData];
                
            }
            
            
            if([discussArray count]>0){
                [noDataView removeFromSuperview];
                
            }else{
                
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                noDataView = [Utilities showNodataView:@"这里空空的，来点话题吧" msg2:nil andRect:rect imgName:@"BlankViewImage/讨论区空白页_03.png"];
                [self.view addSubview:noDataView];
                
                _tableView.tableHeaderView = nil;

//                noDataView = [Utilities showNodataView:@f"此处空空如也" msg2:@"发布点信息活跃下"];
//                [self.view addSubview:noDataView];
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
    
    
    //}
    
   
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
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        
    }
}

@end
