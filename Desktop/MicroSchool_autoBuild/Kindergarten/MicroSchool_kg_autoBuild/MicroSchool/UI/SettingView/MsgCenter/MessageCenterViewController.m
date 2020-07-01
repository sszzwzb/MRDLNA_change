//
//  MessageCenterViewController.m
//  MicroSchool
//
//  Created by jojo on 14/11/10.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "TeacherApplyViewController.h"
@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isFirstShow = false;
    
    [super setCustomizeTitle:@"我的消息"];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"清空"];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    dataArr =[[NSMutableArray alloc] init];

    [self createHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(test111:)
                                                 name:@"test111"
                                               object:nil];

    startNum = @"0";
    endNum = @"10";
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"MessageCenter",@"ac",
                          @"2",@"v",
                          @"inbox", @"op",
                          [Utilities getAppVersion], @"app",
                          self->startNum, @"page",
                          self->endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_MessageCenter andData:data];
    
    [ReportObject event:ID_OPEN_SYSTEM_MESSAGE];//2015.06.25
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 全部删除
-(void)selectRightAction:(id)sender{
    TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"是否清空所有消息"];
    
    [alert addBtnTitle:@"取消" action:^{
        // nothing to do
    }];
    [alert addBtnTitle:@"确定" action:^{
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"MessageCenter",@"ac",
                              @"2",@"v",
                              @"clear", @"op",
                              _lastId, @"last",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                // 删除成功
                [Utilities showTextHud:@"清空成功" descView:self.view];
                
                [dataArr removeAllObjects];
                [_tableView reloadData];
            } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取信息错误，请稍候再试"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }];
    
    [alert showAlertWithSender:self];
}

-(void)test111:(NSNotification *)notification
{
    NSDictionary *dicInfo = [notification userInfo];
    NSLog(@"dicInfo:%@",dicInfo);
    int pos = 0;
    
    for (int i=0; i<[dataArr count]; i++) {
        NSDictionary *dic = [dataArr objectAtIndex:i];
        if ([dicInfo objectForKey:@"mid"] == [dic objectForKey:@"mid"]) {
            pos = i;
        }
    }

    //Chenth 12.22注释掉这行  为了解决5049 这里吧 action_command 至空之后导致点击无反应
//    [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];

    if ([@"FriendAction.accept" isEqual: [dicInfo objectForKey:@"msg"]]) {
        [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];
        [[dataArr objectAtIndex:pos] setObject:@"通过" forKey:@"action_result"];
    }else if([@"FriendAction.reject" isEqual: [dicInfo objectForKey:@"msg"]]) {
        [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];
        [[dataArr objectAtIndex:pos] setObject:@"拒绝" forKey:@"action_result"];
    }else if([@"ClassAction.audit" isEqual: [dicInfo objectForKey:@"msg"]]) {
        [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];
        if ([@"0"  isEqual: [dicInfo objectForKey:@"yn"]]) {
            [[dataArr objectAtIndex:pos] setObject:@"通过" forKey:@"action_result"];
        }else {
            [[dataArr objectAtIndex:pos] setObject:@"拒绝" forKey:@"action_result"];
        }
    }else if([@"inspector_question" isEqual: [dicInfo objectForKey:@"msg"]]) {
        [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];
        [[dataArr objectAtIndex:pos] setObject:@"已回答" forKey:@"action_result"];
    }else if([@"admin_class_charge" isEqual: [dicInfo objectForKey:@"msg"]]) {
        [[dataArr objectAtIndex:pos] setObject:@"" forKey:@"action_command"];
        [[dataArr objectAtIndex:pos] setObject:@"已处理" forKey:@"action_result"];
    }else if([@"apply_teacher" isEqual: [dicInfo objectForKey:@"msg"]]) {
        if ([@"0"  isEqual: [dicInfo objectForKey:@"yn"]]) {
            [[dataArr objectAtIndex:pos] setObject:@"通过" forKey:@"action_result"];
        }else {
            [[dataArr objectAtIndex:pos] setObject:@"拒绝" forKey:@"action_result"];
        }
        NSMutableDictionary *oldDic = [dataArr objectAtIndex:pos];
        NSDictionary *message_info;
        message_info = [g_userInfo getUserDetailInfo];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        if ([[dicInfo objectForKey:@"yn"] integerValue] == 0) {
            [tempDic setObject:@"通过" forKey:@"result"];
        }else{
            [tempDic setObject:@"拒绝" forKey:@"result"];
        }
        
        [tempDic setObject:[dicInfo objectForKey:@"reason"] forKey:@"reason"];
        [tempDic setObject:[[oldDic objectForKey:@"action_message"] objectForKey:@"username"] forKey:@"applicant"];
        [tempDic setObject:[message_info objectForKey:@"name"] forKey:@"auditor"];
        [tempDic setObject:[[oldDic objectForKey:@"action_message"] objectForKey:@"message"] forKey:@"message"];
        [tempDic setObject:[[oldDic objectForKey:@"action_message"] objectForKey:@"title"] forKey:@"subject"];
        [oldDic setObject:tempDic forKey:@"action_message"];
        [dataArr replaceObjectAtIndex:pos withObject:oldDic];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadView
{
    startNum = @"0";
    endNum = @"10";

    reflashFlag = 1;
    isReflashViewType = 1;

    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
//    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
//    // 背景图片
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
   
//    _tableView.backgroundColor = [[UIColor alloc] initWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0];
    _tableView.backgroundColor = [UIColor whiteColor];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:_tableView];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 指定行的高度
//    return 70;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* list_dic = [dataArr objectAtIndex:[indexPath row]];

    if ([@"0"  isEqual: [list_dic objectForKey:@"uid"]]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteIndexPath = indexPath;

    [Utilities showProcessingHud:self.view];

    NSDictionary *list_dic = [dataArr objectAtIndex:[indexPath row]];
   
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"MessageCenter",@"ac",
                              @"2",@"v",
                              @"delete", @"op",
                              [list_dic objectForKey:@"mid"], @"mid",
                              nil];
        
        [network sendHttpReq:HttpReq_MessageCenterClear andData:data];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";

    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [dataArr objectAtIndex:row];

    MsgCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MsgCenterTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.imageView_img.frame = CGRectMake(10,10,50,50);
    cell.imageView_img.layer.cornerRadius = 50/2;
    [cell.imageView_img sd_setImageWithURL:[NSURL URLWithString:[list_dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    cell.label_subject.frame =  CGRectMake(70,
                                           14,
                                           200,
                                           20);
    
    cell.label_subject.text = [list_dic objectForKey:@"subject"];
    
    if ([@"0"  isEqual: [list_dic objectForKey:@"readStatus"]]) {
        // 未读过的
        cell.label_subject.textColor = [UIColor blackColor];
    }else {
        // 读过的
        cell.label_subject.textColor = [UIColor grayColor];
    }
    
    cell.label_message.frame =  CGRectMake(cell.label_subject.frame.origin.x,
                                           cell.label_subject.frame.origin.y + cell.label_subject.frame.size.height + 2,
                                           200,
                                           20);
    cell.label_message.text = [list_dic objectForKey:@"message"];
    
    Utilities *util = [Utilities alloc];
    cell.label_dateline.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 55,
                                           cell.label_subject.frame.origin.y+2,
                                           45,
                                           15);
    
    NSString *md = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@%@" andType:DateFormat_MD];

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *mdNow = [util linuxDateToString:[NSString stringWithFormat:@"%lld", date] andFormat:@"%@%@" andType:DateFormat_MD];

    if ([md isEqualToString:mdNow]) {
        cell.label_dateline.text = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@:%@" andType:DateFormat_HM];
    }else {
        cell.label_dateline.text = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@-%@" andType:DateFormat_MD];
    }
    
    if ((([@"open"  isEqual: [list_dic objectForKey:@"action_command"]]) &&
         ([@""  isEqual: [list_dic objectForKey:@"action_result"]])) ||
        ([@"webview"  isEqual: [list_dic objectForKey:@"action_command"]]) ||
        (([@"forward"  isEqual: [list_dic objectForKey:@"action_command"]]) &&
         ([@""  isEqual: [list_dic objectForKey:@"action_result"]]))) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.label_result.text = @"";
        }else {
            // 只显示结果的cell
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.label_result.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 55,
                                                 cell.label_message.frame.origin.y,45,20);
            
            NSString *result = [list_dic objectForKey:@"action_result"];
            if ([@"通过"  isEqual: result]) {
                cell.label_result.textColor = [[UIColor alloc] initWithRed:21/255.0f green:141/255.0f blue:138/255.0f alpha:1.0];
            }else {
                cell.label_result.textColor = [[UIColor alloc] initWithRed:255/255.0f green:96/255.0f blue:131/255.0f alpha:1.0];
            }
            
            cell.label_result.text = [list_dic objectForKey:@"action_result"];
            
            if ([@"系统消息"  isEqual: [list_dic objectForKey:@"subject"]]) {
                CGSize strSize = [Utilities getStringHeight:[list_dic objectForKey:@"message"] andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(200, 0)];
                
                cell.label_message.lineBreakMode = NSLineBreakByWordWrapping;
                cell.label_message.numberOfLines = 0;

                cell.label_message.frame =  CGRectMake(cell.label_subject.frame.origin.x,
                                                       cell.label_subject.frame.origin.y + cell.label_subject.frame.size.height + 2,
                                                       200,
                                                       strSize.height);
            }else {
                cell.label_message.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.label_message.numberOfLines = 1;
            }
        }

    CGRect rect = cell.frame;
    
    // 重新设置cell得高度
    rect.size.height = (cell.label_message.frame.origin.y + cell.label_message.frame.size.height + 15);
    cell.frame = rect;
    
    return cell;
}

- (void)reloadTableViewData {
    [_tableView reloadData];
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    [ReportObject event:ID_CHECK_SYSTEM_MESSAGE];//2015.06.25
    
    NSDictionary* list_dic = [dataArr objectAtIndex:[indexPath row]];

//    MsgCenterTableViewCell *cell = (MsgCenterTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *action_source = [list_dic objectForKey:@"action_source"];
    NSString *action_result = [list_dic objectForKey:@"action_result"];
    NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
    // 设置db中的该条数据变为已读
    NSString *readId = [NSString stringWithFormat:@"%@_%@", @"myMsg", [list_dic objectForKey:@"mid"]];
    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
    rsObj.readId = readId;
    rsObj.status = @"1";
    [rsObj updateToDB];
    
    // 设置内存中的该条数据变为已读
    NSMutableDictionary* list_dic1 = [dataArr objectAtIndex:[indexPath row]];
    [list_dic1 setObject:@"1" forKey:@"readStatus"];
    [dataArr replaceObjectAtIndex:[indexPath row] withObject:list_dic1];
    
    [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.2];

    // todo 2.9.1
    //班级论坛回复
    //const CLASS_FORUM_REPLY = 'class_forum_reply';
    //新闻（自定义公告)回复： 由于自定义公告模块很多种，消息体中我会添加模块ID，便于客户端跳转
    //const SCHOOL_NEWS_REPLY = 'school_news_reply';
    //知识库回复
    //const SCHOOL_WIKI_REPLY = 'school_wiki_reply';
    
    
    if (([@"forward"  isEqual: [list_dic objectForKey:@"action_command"]]) &&
        ([@""  isEqual: [list_dic objectForKey:@"action_result"]])) {
        if (([@"inspector_question"  isEqual: action_source]) && (![@"已回答"  isEqual: action_result])) {
            // 督学人回答问题
            AnswerQuestionViewController *answerQuV = [[AnswerQuestionViewController alloc]init];
            answerQuV.qustionText = [list_dic objectForKey:@"message"];
            NSString *dateline =  [Utilities timeIntervalToDate:[[list_dic objectForKey:@"dateline"] longLongValue] timeType:10 compareWithToday:NO];
            answerQuV.date = dateline;
            answerQuV.aid = [list_dic objectForKey:@"from_uid"];
            answerQuV.msgCenterMid = [list_dic objectForKey:@"mid"];

            NSDictionary *ridDic = [list_dic objectForKey:@"action_message"];
            answerQuV.rid = [ridDic objectForKey:@"rid"];
            [self.navigationController pushViewController:answerQuV animated:YES];
        }else if ([@"inspector_answer"  isEqual: action_source]) {
            // 督学回答内容
            [Utilities showProcessingHud:self.view];

            NSDictionary *ridDic = [list_dic objectForKey:@"action_message"];

            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Eduinspector",@"ac",
                                  @"view", @"op",
                                  [ridDic objectForKey:@"rid"], @"rid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MessageCenterGetEduAns andData:data];
        }else if ([@"admin_class_charge"  isEqual: action_source]) {
            // 班级无管理员消息
            SetAdminMemberListViewController *setAdminLV = [[SetAdminMemberListViewController alloc]init];
            NSDictionary *msg = [list_dic objectForKey:@"action_message"];
            NSString *cid = [msg objectForKey:@"cid"];
            setAdminLV.cId= cid;
            setAdminLV.msgCenterMid= [list_dic objectForKey:@"mid"];
            [self.navigationController pushViewController:setAdminLV animated:YES];
        }else if (([@"school_thread_reply"  isEqual: action_source]) ||
                  ([@"class_forum_reply"  isEqual: action_source])) {
            // 讨论区回复 去讨论区详情
            // 班级讨论区与校园讨论区都是进详情
            DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            NSString *tid = [actDic objectForKey:@"tid"];
            disscussDetailViewCtrl.tid = tid;
            if ([@"class_forum_reply"  isEqual: action_source]) {//班级讨论区
                disscussDetailViewCtrl.cid = [NSString stringWithFormat:@"%@",[actDic objectForKey:@"cid"]];
                [disscussDetailViewCtrl setFlag:4];
            }else{
              [disscussDetailViewCtrl setFlag:1];
            }
            
            disscussDetailViewCtrl.disTitle = [actDic objectForKey:@"title"];
            [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
            
        }else if (([@"class_thread_reply"  isEqual: action_source])){//班级公告
         
            DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            NSString *tid = [actDic objectForKey:@"tid"];
            disscussDetailViewCtrl.tid = tid;
            [disscussDetailViewCtrl setFlag:2];
            disscussDetailViewCtrl.disTitle = [actDic objectForKey:@"title"];
            disscussDetailViewCtrl.cid = [actDic objectForKey:@"cid"];
            [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
            
        }else if ([@"class_homework_reply"  isEqual: action_source]) {
            // 班级作业回复 去班级详情页
            DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            disscussDetailViewCtrl.tid =  [actDic objectForKey:@"tid"];
            [disscussDetailViewCtrl setFlag:3];
            disscussDetailViewCtrl.disTitle = [actDic objectForKey:@"title"];
            [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
        }else if ([@"ss_phy_con_msg"  isEqual: action_source]) {
            // @"身体记录详情"
            HealthDetailViewController *healthDetailV = [[HealthDetailViewController alloc] init];
            healthDetailV.fromName = @"msgCenter";
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            healthDetailV.cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"cid"]]];
            healthDetailV.pid = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"tid"]]];
            
            NSString *a = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            if (![@""  isEqual: a]) {
                healthDetailV.nunmber = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            }else {
                healthDetailV.nunmber = @"0";
            }
            
            [self.navigationController pushViewController:healthDetailV animated:YES];

        }else if ([@"ss_phy_rep_msg"  isEqual: action_source]) {
            // @"体测报告详情"
            TestReportDetailViewController *testReportDeV = [[TestReportDetailViewController alloc] init];
            testReportDeV.fromName = @"msgCenter";
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            testReportDeV.cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"cid"]]];
            testReportDeV.pid = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"tid"]]];
            NSString *a = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            if (![@""  isEqual: a]) {
                testReportDeV.nunmber = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            }else {
                testReportDeV.nunmber = @"0";
            }
            
            [self.navigationController pushViewController:testReportDeV animated:YES];
        }else if ([@"ss_exm_sco_msg"  isEqual: action_source]) {
            // 成绩详情
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];

            ScoreDetailViewController *scoreDVC = [[ScoreDetailViewController alloc] init];
            scoreDVC.fromName = @"msgCenter";
            scoreDVC.cId = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"cid"]]];
            scoreDVC.examId = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"tid"]]];
            NSString *a = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            if (![@""  isEqual: a]) {
                scoreDVC.nunmber = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"number"]]];
            }else {
                scoreDVC.nunmber = @"0";
            }
            
            [self.navigationController pushViewController:scoreDVC animated:YES];
        }else if ([@"school_news_reply"  isEqual: action_source]) {
            // 公告回复
            NSDictionary *actDic = [list_dic objectForKey:@"action_message"];
            
            NewsCommentViewController *newsCommentViewCtrl = [[NewsCommentViewController alloc] init];
            newsCommentViewCtrl.newsId = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [actDic objectForKey:@"tid"]]];
            newsCommentViewCtrl.cmtSid = G_SCHOOL_ID;
            
            [self.navigationController pushViewController:newsCommentViewCtrl animated:YES];
        }
    }else if(([@"open"  isEqual: [list_dic objectForKey:@"action_command"]]) &&
             ([@""  isEqual: [list_dic objectForKey:@"action_result"]])) {
        // 类似好友请求画面
        if ([@"friend"  isEqual: action_source]) {
            if (![@""  isEqual: [Utilities replaceNull:[list_dic objectForKey:@"action_message"]]]) {
                ActCmdOpenViewController *actCmdVC = [[ActCmdOpenViewController alloc] init];
                actCmdVC.action_msg = [list_dic objectForKey:@"action_message"];
                actCmdVC.actType = action_source;
                actCmdVC.mid = [list_dic objectForKey:@"mid"];
                [self.navigationController pushViewController:actCmdVC animated:YES];
            }
        }else if ([@"apply_class"  isEqual: action_source]) {
            if (![@""  isEqual: [Utilities replaceNull:[list_dic objectForKey:@"action_message"]]]) {
                ActCmdOpenViewController *actCmdVC = [[ActCmdOpenViewController alloc] init];
                actCmdVC.action_msg = [list_dic objectForKey:@"action_message"];
                NSLog(@"action_msg:%@",actCmdVC.action_msg);
                actCmdVC.actType = action_source;
                actCmdVC.mid = [list_dic objectForKey:@"mid"];
                [self.navigationController pushViewController:actCmdVC animated:YES];
            }
        }else if ([@"apply_teacher"  isEqual: action_source]) {
            if ([@""  isEqual: [list_dic objectForKey:@"action_result"]]) {
                ActCmdOpenViewController *actCmdVC = [[ActCmdOpenViewController alloc] init];
                actCmdVC.action_msg = [list_dic objectForKey:@"action_message"];
                NSLog(@"action_msg:%@",actCmdVC.action_msg);
                actCmdVC.actType = action_source;
                actCmdVC.mid = [list_dic objectForKey:@"mid"];
                [self.navigationController pushViewController:actCmdVC animated:YES];
            }
        }else if (([@"apply_teacher_result"  isEqual: action_source]) ||
                  ([@"apply_class_result"  isEqual: action_source])) {
            if((nil != [list_dic objectForKey:@"action_message"]) && (![[list_dic objectForKey:@"action_message"] isKindOfClass:[NSNull class]])) {
                // 当教师申请或者班级加入申请通过或拒绝之后是可以进入详情的
                TeacherApplyViewController *vc = [[TeacherApplyViewController alloc]init];
                vc.action_msg = [list_dic objectForKey:@"action_message"];
                
                Utilities *util = [Utilities alloc];
                NSString *md = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      md, @"dateline",
                                      [list_dic objectForKey:@"avatar"], @"avatar",
                                      nil];
                
                vc.action_info = data;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if([@"webview"  isEqual: [list_dic objectForKey:@"action_command"]]) {
#if 0
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        NSDictionary *aaa = [list_dic objectForKey:@"action_message"];
        NSString *b = [aaa objectForKey:@"url"];
        fileViewer.requestURL = b;
        fileViewer.titleName = [list_dic objectForKey:@"subject"];
#endif
        //2015.09.23
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        NSDictionary *aaa = [list_dic objectForKey:@"action_message"];
        NSString *b = [aaa objectForKey:@"url"];
        fileViewer.requestURL = b;
        fileViewer.webType = SWLoadRequest;
        fileViewer.titleName = [list_dic objectForKey:@"subject"];
        [self.navigationController pushViewController:fileViewer animated:YES];
        
    }else if ([@"html5" isEqualToString:[list_dic objectForKey:@"action_command"]]) {
        
        if ([@"school_spec_act" isEqualToString:action_source]) {
            
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            //            NSDictionary *message_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
            //            //    NSMutableDictionary *message_info = [g_userInfo getUserDetailInfo];
            //            NSString *uid = [NSString stringWithFormat:@"%@" ,[message_info objectForKey:@"uid"]];
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setObject:@"1" forKey:uid];
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            NSDictionary *aaa = [list_dic objectForKey:@"action_message"];
            NSString *b = [aaa objectForKey:@"url"];//url需要拼接
            NSString *newUrl = [Utilities appendUrlParamsV2:b];
            newUrl = [NSString stringWithFormat:@"%@&grade=%@",newUrl,usertype];
            fileViewer.url = [NSURL URLWithString:newUrl];
            fileViewer.webType = SWLoadURl;
            fileViewer.isShowSubmenu = @"0";
            fileViewer.closeVoice = 1;
            //fileViewer.hideBar = YES;
            fileViewer.isFromEvent = YES;
            [self.navigationController pushViewController:fileViewer animated:YES];
        }
        
    }else if(([@"open"  isEqual: [list_dic objectForKey:@"action_command"]]) &&
             (([@"apply_class"  isEqual: action_source]) ||
              ([@"apply_teacher"  isEqual: action_source]) ||
              ([@"apply_teacher_result"  isEqual: action_source]))) {
                if((nil != [list_dic objectForKey:@"action_message"]) && (![[list_dic objectForKey:@"action_message"] isKindOfClass:[NSNull class]])) {
                    // 当教师申请或者班级加入申请通过或拒绝之后是可以进入详情的
                    TeacherApplyViewController *vc = [[TeacherApplyViewController alloc]init];
                    vc.action_msg = [list_dic objectForKey:@"action_message"];
                    
                    Utilities *util = [Utilities alloc];
                    NSString *md = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          md, @"dateline",
                                          [list_dic objectForKey:@"avatar"], @"avatar",
                                          nil];
                    
                    vc.action_info = data;
                    [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    [Utilities showProcessingHud:self.view];

    startNum = @"0";
    endNum = @"10";

    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
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
        NSString *app = [Utilities getAppVersion];

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"MessageCenter",@"ac",
                              @"2",@"v",
                              @"inbox", @"op",
                              app, @"app",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_MessageCenter andData:data];
    }
}
//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        NSString *app = [Utilities getAppVersion];

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"MessageCenter",@"ac",
                              @"2",@"v",
                              @"inbox", @"op",
                              app, @"app",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_MessageCenter andData:data];
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    NSLog(@"resultJSON:%@",resultJSON);
    
    if ([@"MessageCenterAction.inbox"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            [self removeFooterView];
            
            if ([@"0"  isEqual: startNum]) {
                [dataArr removeAllObjects];
            }
            
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSArray *arr = [message_info objectForKey:@"list"];
            _lastId = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"last"]];
            
            for (NSObject *object in arr) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                NSDictionary *dic = (NSDictionary *)object;
                
                [dic1 addEntriesFromDictionary:dic];
                
                // 去db里查找是否有该条记录。
                NSString *readId = [NSString stringWithFormat:@"%@_%@", @"myMsg", [dic objectForKey:@"mid"]];
                NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];

                if (nil == dicFromDb) {
                    // db里没有，存入db。
                    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                    rsObj.readId = readId;
                    rsObj.status = @"0";
                    [rsObj updateToDB];
                    
                    [dic1 setObject:@"0" forKey:@"readStatus"];
                }else {
                    // db里面有，直接取出来。
                    NSString *status = [dicFromDb objectForKey:@"status"];
                    [dic1 setObject:status forKey:@"readStatus"];
                }
                
                // 与基本信息一起设置到需要显示的数组里面
                [dataArr addObject:dic1];
            }
            
            //---add by kate 2015.01.27------------------------
            if ([@"0"  isEqual: startNum]) {

             if([dataArr count] == 0){
                
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                noDataView = [Utilities showNodataView:@"还木有消息" msg2:@"过会再来看看吧" andRect:rect imgName:@"消息列表_03.png"];
                [self.view addSubview:noDataView];
              }else{
                [noDataView removeFromSuperview];
              }
            }
            
            //------------------------------------------
            
            
            if ([startNum integerValue] == 0) {
                
                NSString *lastId = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"last"]];
                //NSLog(@"last:%@",lastId);
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:lastId forKey:@"MyMsgLastId"];
                [userDefaults synchronize];
            }
           
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            
//           NSDictionary *dic = [dataArr firstObject];
//            NSString *lastId = [dic objectForKey:@"mid"];
            
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1];
            [_tableView reloadData];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取数据错误，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if([@"EduinspectorAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            NSDictionary *dic = [resultJSON objectForKey:@"message"];
            
            EduQuesDetailViewController *eduDetailViewCtrl = [[EduQuesDetailViewController alloc] init];
            eduDetailViewCtrl.quesDic = dic;
            [self.navigationController pushViewController:eduDetailViewCtrl animated:YES];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取数据错误，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if([@"MessageCenterAction.delete"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            [dataArr removeObjectAtIndex:deleteIndexPath.row];
            
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            [_tableView endUpdates];

        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"删除失败，请重试"
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
    
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
}

@end
