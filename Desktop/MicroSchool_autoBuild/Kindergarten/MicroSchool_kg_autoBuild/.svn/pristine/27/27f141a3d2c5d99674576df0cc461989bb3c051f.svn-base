//
//  MsgListViewController.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgListViewController.h"
#import "MsgZoomImageViewController.h"
#import "ChatListObject.h"
#import "PublicConstant.h"
#import "DBDao.h"
#import "Utilities.h"
#import "ImageResourceLoader.h"
//#import "MobClick.h"
#import "FRNetPoolUtils.h"
//#import "MyTabBarController.h"

@interface MsgListViewController ()

- (void)createChatsListTableView;

// 加载聊天列表数据
- (void)loadChatListData:(NSNotification *)notification;

// 接收到离线消息
//- (void)didReceiveMsg:(NSNotification *)notification;

@end


@implementation MsgListViewController

@synthesize chatListArray, chatsListTableView;
//@synthesize chatDeatilController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tag = 211;
    
    //获取窗口大小
    winSize = [[UIScreen mainScreen] bounds].size;
    self.view.backgroundColor = COMMON_BACKGROUND_COLOR;
    self.title = @"消息";
    //self.navigationItem.backBarButtonItem = [CommonUtil customerBackItem:@"消息"];
    
    //UIBarButtonItem *left = [CommonUtil customerLeftItem:@"主页" target:self action:@selector(back:)];
    //if (left) {
    //    self.navigationItem.leftBarButtonItem = left;
    //}
    
    [super setCustomizeLeftButton];
    [super setCustomizeTitle:@"消息"];
    
    //-----2015.11.19----------------------------------------------------
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"MsgListView" forKey:@"viewName"];
    [userDefaults synchronize];
    //--------------------------------------------------------------------
    
    chatListArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatListData)
                                                 name:NOTIFICATION_DB_GET_CHAT_LIST_DATA
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(clickDeleteMsg)
//                                                 name:@"clickDeleteMsg"
//                                               object:nil];
    
    [self createChatsListTableView];
    
    [self createNoDataView];
    
    //---kate 测试代码 2016.01.14------------------------------------------------------------------------------------------
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, winSize.height- 64.0 - 40.0, self.view.frame.size.width, 40.0)];
    
    _baseView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_baseView];
    _baseView.hidden = YES;
    
    deleteArr = [[NSMutableArray alloc] init];
    
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.backgroundColor = [UIColor clearColor];
    //[_deleteBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.frame = CGRectMake(winSize.width - 60.0, 0, 60.0, 40.0);
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.userInteractionEnabled = NO;
    
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.backgroundColor = [UIColor clearColor];
    [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.frame = CGRectMake(0, 0, 60.0, 40.0);
    [selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseView addSubview:selectAllBtn];
    [_baseView addSubview:_deleteBtn];
    //-----------------------------------------------------------------------------------------------------------------
    
}

//// 2016.01.15
//- (void)clickDeleteMsg{
//    
//    self.chatsListTableView.allowsMultipleSelectionDuringEditing = YES;
//    
//    self.chatsListTableView.editing = !self.chatsListTableView.editing;
//    
//    if (self.chatsListTableView.editing) {
//        
//        self.chatsListTableView.frame = CGRectMake(0, 0, winSize.width, self.chatsListTableView.frame.size.height - _baseView.frame.size.height);
//        
//       _baseView.hidden = NO;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setRightBarItem" object:@"1"];
//
//    }else{
//        
//        CGRect tableFrame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
//
//        self.chatsListTableView.frame = tableFrame;
//        _baseView.hidden = YES;
//        
//        //[button setTitle:@"删除" forState:UIControlStateNormal];
//        self.navigationItem.rightBarButtonItems = nil;
//        self.navigationItem.rightBarButtonItem = nil;
//        
//    }
//    
//}

// 全选
-(void)selectAll:(id)sender{
    
    for (int i = 0; i < chatListArray.count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [self.chatsListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [deleteArr addObjectsFromArray:self.chatListArray];
        
    }
    
}

// 删除
-(void)deleteClick:(id)sender{
    
    if (self.chatsListTableView.editing) {
        
        //删除

        //1.将数组中数据删除
        [self.chatListArray removeObjectsInArray:self->deleteArr];
        
        //2.将数据库中的数据删除
        // to do:
        
        //3. refresh
        [self.chatsListTableView reloadData];
        
    }
    
    else return;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  //  [MyTabBarController setTabBarHidden:YES];
    
    //[self getChatListData];
    
   // [MobClick beginLogPageView:@"消息中心"];
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
   // NSLog(@"viewName:%@",viewName);
    //点击聊天列表页单行发送通知之后做完聊天详情页的viewWillAppear之后又走了一遍聊天记录列表页的viewWillAppear，将defaults中存的viewName的值覆盖了,所以加入此判断
    if ([viewName isEqualToString:@"MsgDetailsView"]) {//update by kate 2015.03.02
        
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"MsgListView" forKey:@"viewName"];
        [userDefaults synchronize];
    }
    
    [self getChatListData];// 2015.11.19 换下顺序
    
    
#if 0 // 2015.11.18
    //------add 2015.01.25--------------------------------
    
    NSString *sql = [NSString stringWithFormat:@"select * from msgList"];
    
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    int userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
        NSLog(@"objectDict:%@",objectDict);
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
    }
    
    if(count == 0){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNew" object:nil];
    }
    //----------------------------------------------------
#endif
    
    //[self addNewCount];// 未读数量接口 2015.11.18

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//update by kate 2015.02.28
    //[MobClick endLogPageView:@"消息中心"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    
    self.chatsListTableView = nil;
    self.chatListArray = nil;
//    self.chatDeatilController = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.chatsListTableView = nil;
    self.chatListArray = nil;
//    self.chatDeatilController = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.chatListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgListCell";
    
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MsgListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    ChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    cell.chatListObject = chatListObject;
    cell.nameLabel.text = chatListObject.title;
    //cell.detailLabel.text = chatListObject.last_msg;
    
    if (chatListObject.msg_state == MSG_SEND_FAIL) {
        cell.sendFailed.hidden = NO;
        cell.detailLabel.frame = CGRectMake(80, 34, 237, 26);
    } else {
        cell.sendFailed.hidden = YES;
        cell.detailLabel.frame = CGRectMake(67+8, 34, [[UIScreen mainScreen] bounds].size.width - 67 - 8, 26);
    }
    
    [cell setDetail:chatListObject.last_msg];//update 2015.07.17
    
    UserObject *localUser = [UserObject getUserInfoWithID:chatListObject.user_id];
    if (localUser && [localUser.headimgurl length] > 0) {
        // 从服务器拉取头像
        NSString *imageName = [localUser.headimgurl lastPathComponent];
        NSString *imagePath = [Utilities getHeadImagePath:chatListObject.user_id imageName:imageName];
        if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                cell.headImageView.image = image;
            }
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserObject *serverUser = [FRNetPoolUtils getSalesmenWithID:chatListObject.user_id];
        if (serverUser && serverUser.user_id > 0) {
            if ([serverUser.headimgurl length] > 0) {
                // 从服务器拉取头像
                NSString *imageName = [serverUser.headimgurl lastPathComponent];
                NSString *imagePath = [Utilities getHeadImagePath:chatListObject.user_id imageName:imageName];
                if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                    NSString *userHeadUrl = [[NSString alloc] initWithFormat:@"%@", serverUser.headimgurl];
                    [FRNetPoolUtils getPicWithUrl:userHeadUrl picType:PIC_TYPE_HEAD userid:chatListObject.user_id msgid:0];
                    [userHeadUrl release];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 从服务器拉取头像
                    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                        if (image) {
                            cell.headImageView.image = image;
                        }
                    }
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([serverUser.name length] > 0) {
                    cell.nameLabel.text = serverUser.name;
                }
            });
        }
    });
    
    // 时间标签,转换时间形式
    long long timestamp = chatListObject.timestamp;
    timestamp = timestamp/1000.0;
    
    NSString *dateString = [Utilities timeIntervalToDate:timestamp timeType:0 compareWithToday:YES];
    [cell setTime:dateString];
    
    if (tableView.editing == YES) {
        cell.timeLabel.hidden = YES;
//        cell.unReadBadgeView.hidden = YES;
//        cell.unReadLabel.hidden = YES;
    } else {
        cell.timeLabel.hidden = NO;
        cell.unReadBadgeView.hidden = YES;
        cell.unReadLabel.hidden = YES;
        cell.unReadLabel.text = @"";
        
        // Done:消息未读数量要做漫游，所以以下从数据库取出的未读数量逻辑要修改，改成从server拉取未读数量
        // 将从server获取到的未读数量添加到一个字典里，key是cell.chatListObject.user_id，value是未读数量
        // unReadMsgDic存储未读数量的字典
#if 0
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", cell.chatListObject.user_id, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
#endif
        
        if (unReadMsgDic) {//update 2015.11.18
            
            if ([unReadMsgDic count] > 0) {
                int cnt = [[unReadMsgDic objectForKey:[NSString stringWithFormat:@"%lld",cell.chatListObject.user_id]] intValue];
                
                if (cnt > 0) {
                    cell.unReadBadgeView.hidden = NO;
                    cell.unReadLabel.hidden = NO;
                    cell.unReadBadgeView.frame = CGRectMake(cell.headImageView.frame.origin.x + WIDTH_HEAD_CELL_IMAGE - 10, cell.headImageView.frame.origin.y - 2, 19, 19);
                    cell.unReadLabel.frame = cell.unReadBadgeView.frame;
                    if (cnt < 10) {
                        cell.unReadLabel.text = [NSString stringWithFormat:@"%d", cnt];
                    } else {
                        CGRect frame = cell.unReadBadgeView.frame;
                        frame.origin.x -= 5;
                        frame.size.width += 10;
                        cell.unReadBadgeView.frame = frame;
                        cell.unReadLabel.frame = frame;
                        
                        if (cnt < 100) {
                            cell.unReadLabel.text = [NSString stringWithFormat:@"%d", cnt];
                        } else {
                            cell.unReadLabel.text = @"...";
                        }
                    }
                }else{
                    
                    cell.unReadBadgeView.hidden = YES;
                    cell.unReadLabel.hidden = YES;
                }
            }
        }
        
        
    }
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = COMMON_TABLEVIEWCELL_SELECTED_COLOR;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 进入编辑状态后不显示时间和未读消息数
    MsgListCell *cell =  (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
        if (tableView.editing == YES) {
            cell.timeLabel.hidden = YES;
            //        cell.unReadBadgeView.hidden = YES;
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
            
        } else {
            cell.timeLabel.hidden = NO;
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
            //        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
            //            cell.unReadBadgeView.hidden = NO;
            //        } else {
            //            cell.unReadBadgeView.hidden = YES;
            //        }
            
        }

    
    return YES;
}

// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.user_id];
        if (bDeleteMsg) {
            //[self performSelectorInBackground:@selector(deleteChatResourceWithWithUserID:) withObject:[NSString stringWithFormat:@"%lli", chatListObject.user_id]];
            [self.chatListArray removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
#if 0 //2015.11.18
            //------add 2015.07.08-----------------------------------------------------------------
                // 左划直接删除聊天消息，不查看 使聊天tab的未读消息动态变化
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:nil];
            
            //-----------------------------------------------------------------------------------------
#endif
            [self addNewCount];//2015.11.18
            
            
        } else {
            // 删除失败提示
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Failed to delete chat!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
            [alert show];
            [alert release];
        }
    }
}*/

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//删除
        
        NSLog(@"delete");
        
        //真正项目中做删除
        
        //1.将表中的cell删除
        
        //2.将本地的数组中数据删除
        
        //3.最后将服务器端的数据删除
        
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleRows = [tableView visibleCells];
    if([visibleRows count] > 0){
        for (MsgListCell *cell in visibleRows) {
            cell.timeLabel.hidden = NO;
            //        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
            //            cell.unReadBadgeView.hidden = NO;
            //        } else {
            //            cell.unReadBadgeView.hidden = YES;
            //        }
        }
    }
    
    [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
       
        [_deleteBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = YES;
       
        //选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
        [deleteArr addObject:[self.self.chatListArray objectAtIndex:indexPath.row]];
        
    }else{
        
        MsgListCell *cell = (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
            cell.chatListObject.msg_state = MSG_READ_FLG_READ;
            [cell.chatListObject updateToDB];
        }
        cell.unReadBadgeView.hidden = YES;
        cell.botherImgV.image = nil;
        cell.botherImgV.hidden = YES;
        UserObject *chatUser = [UserObject getUserInfoWithID:cell.chatListObject.user_id];
        if (chatUser == nil) {
            chatUser = [FRNetPoolUtils getSalesmenWithID:cell.chatListObject.user_id];
            if (chatUser == nil) {
                chatUser = [[[UserObject alloc] init] autorelease];
                chatUser.user_id = cell.chatListObject.user_id;
                [chatUser updateToDB];
                
                if ([chatUser.name length] > 0) {
                    cell.chatListObject.title = chatUser.name;
                } else {
                    cell.chatListObject.title = NO_NAME_USER;
                }
                [cell.chatListObject updateToDB];
            } else {
                if (chatUser.user_id == 0) {
                    chatUser = [[[UserObject alloc] init] autorelease];
                    chatUser.user_id = cell.chatListObject.user_id;
                    [chatUser updateToDB];
                }
            }
        }
        
        //[MobClick event:Report_ShowMessageDetailsFromList];
        //[ReportObject event:Report_Event_NO_ShowMessageDetailsFromList];
        
        ////    if (!chatDeatilController) {
        //        MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
        ////    }
        //    chatDeatilController.user = chatUser;
        //    chatDeatilController.frontName = @"list";
        //    [chatDeatilController getChatDetailData];
        //    [self.navigationController pushViewController:chatDeatilController animated:YES];
        //    [chatDeatilController release];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             chatUser, @"user",
                             @"list",@"frontName",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailView" object:self userInfo:dic];
    }
    
    
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [deleteArr removeObject:[self.chatListArray objectAtIndex:indexPath.row]];
    
    if ([deleteArr count] == 0) {
        
        [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = NO;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return HEIGHT_CHATLIST_CELL;
}


#pragma mark - Private function

//- (void)editList
//{
//    self.chatsListTableView.editing = YES;
//    UIBarButtonItem *rightDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone)];
//    self.navigationItem.rightBarButtonItem = rightDone;
//    [rightDone release];
//    rightDone = nil;
//}
//
//- (void)editDone
//{
//    self.chatsListTableView.editing = NO;
//    UIBarButtonItem *rightEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editList)];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = rightEdit;
//    [rightEdit release];
//    rightEdit = nil;
//}

- (void)createChatsListTableView
{
    // 初始化tableview
#if 0 // 2015.01.15
    CGRect tableFrame = CGRectMake(0, 49.0, winSize.width, winSize.height - 20 - 44 - 49);
#endif
    
    CGRect tableFrame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
    
    self.chatsListTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    //self.chatsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatsListTableView.scrollsToTop = YES;
    self.chatsListTableView.delegate = self;
    self.chatsListTableView.dataSource = self;
    self.chatsListTableView.tableFooterView = [[UIView alloc] init];
  
    [self.view addSubview:self.chatsListTableView];
}

// 获取Chat list
- (void)getChatListData
{
    [NSThread detachNewThreadSelector:@selector(getChatListDataNewThread) toTarget:self withObject:nil];
}

- (void)getChatListDataNewThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *sql = @"select * from msgList ORDER BY timestamp DESC";
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[[NSMutableArray alloc] init] autorelease];
    int cnt = [chatsListDict.allKeys count];
    //int count = 0;//add 2015.01.25
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        
        ChatListObject *chatList = [[ChatListObject alloc] init];
        chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
        chatList.msg_table_name = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_table_name"]];
        chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
        chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
        chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
        chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
        chatList.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        
        //NSLog(@"last_msg:%@",chatList.last_msg);
        
        chatList.last_msg = [self sqliteEscape:chatList.last_msg];
        
        [chatListArr addObject:chatList];
        [chatList release];
        
        }
//    
//    if (count >0) {
//        
//        NSString *c = [NSString stringWithFormat:@"%d",count];
//        // 红点推送
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:c];
//    }

#if 0 //2015.11.18
    //------add 2015.01.25--------------------------------
    
    NSString *sql2 = [NSString stringWithFormat:@"select * from msgList"];
    
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql2];
    int userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
        NSLog(@"objectDict:%@",objectDict);
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
    }
    
    if(count > 0){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:nil];
    }
    //----------------------------------------------------
#endif

    
    //--add 2015.01.25----------------------------------------------
    NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
    NSString *moudleName = @"";
    for (int i=0; i<[dynamicArr count]; i++) {
        
        NSDictionary *dic = [dynamicArr objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        
        if ([type intValue] == 10) {
            
            moudleName = name;
        }
    }
    
    if (cnt > 0) {
        
         NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:0]];
        
        long long timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue]/1000;
        
        NSString *newsId = [NSString stringWithFormat:@"%lli",timestamp];
        
        if ([moudleName length]>0) {
            
            if (newsId!=nil) {
                [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:moudleName];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }
        
    }
    
    //-----------------------------------------------------------------
    
    [self performSelectorOnMainThread:@selector(loadChatListData:) withObject:chatListArr waitUntilDone:YES];
    
    [pool release];
    pool = nil;
    
    [NSThread exit];
}

// 加载聊天列表数据
- (void)loadChatListData:(NSMutableArray *)chatListData
{
    [self.chatListArray removeAllObjects];
    self.chatListArray = [chatListData retain];
    
    //NSLog(@"chatListArray:%@",self.chatListArray);
    
    if ([self.chatListArray count] > 0) {
        
        noDataView.hidden = YES;
        self.chatsListTableView.hidden = NO;
        [self.chatsListTableView reloadData];
        
        NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
        if ([viewName isEqualToString:@"MsgListView"]) {
           [self addNewCount];// 未读数量接口 2015.11.18
        }
        
    }else {
        noDataView.hidden = NO;
        self.chatsListTableView.hidden = YES;
    }
    
}

- (BOOL)deleteChatsListDataWithUserID:(long long)user_id
{
    BOOL deleteResult = NO;
    
    NSString *deleteChatListSql = [[NSString alloc] initWithFormat:@"delete from msgList where user_id = %lli", user_id];
    deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatListSql];
    [deleteChatListSql release];
    
//    NSString *dropTableSql = [[NSString alloc] initWithFormat:@"drop table msgInfo_%lli", user_id];
//    [[DBDao getDaoInstance] executeSql:dropTableSql];
//    [dropTableSql release];
    
    return deleteResult;
}

- (void)deleteChatResourceWithWithUserID:(NSString *)user_id
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // 取得聊天的资源路径名
    NSString *userDir = [Utilities getUserInfoDir:[user_id longLongValue]];
    NSString *chatDir = [userDir stringByAppendingFormat:@"/%@", DIR_NAME_CHAT];
    
    // 删除聊天资源文件夹
    NSFileManager *manager =[NSFileManager defaultManager];
    [manager removeItemAtPath:chatDir error:nil];
    
    [pool release];
    pool = nil;
    
    [NSThread exit];
}

- (void)back:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNoDataView
{
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49)];
    noDataView.backgroundColor = [UIColor clearColor];
    noDataView.hidden = YES;
    
    UIImageView *noDataLogo = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 124, 174)];
    noDataLogo.image = [UIImage imageNamed:@"icon_jxw.png"];
    
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width/2.0))/2.0, noDataLogo.frame.origin.y+noDataLogo.frame.size.height+10, [UIScreen mainScreen].bounds.size.width/2.0, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"新来的吧";
    
    
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width/2.0))/2.0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width/2.0, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"快找同学老师聊聊看";
    //label2.backgroundColor = [UIColor grayColor];
    
    //---update 2015.05.06----------------------
    if ([@"bureau" isEqualToString:schoolType]) {//教育局

        noDataLogo.hidden = YES;
        label.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 20.0 -49.0)/2.0, [UIScreen mainScreen].bounds.size.width, 20.0);
        label.text = @"暂无聊天信息";
        label.textColor = [UIColor grayColor];
        [noDataView addSubview:label];
       
    }else{
        
        [noDataView addSubview:noDataLogo];
        [noDataLogo release];
        [noDataView addSubview:label];
        [noDataView addSubview:label2];
    }
    //--------------------------------------------
   
    
    [self.view addSubview:noDataView];
    [noDataView release];
}

-(void)showNoDataView{
    
    if ([self.chatListArray count] == 0) {
        noDataView.hidden = NO;
    }
    
}

/**
 * 获取与朋友聊天的未读消息数量
 * v=1, ac=Message, op=count, sid=, uid=
 * 2015.11.18
 */
-(void)addNewCount{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Message",@"ac",
                          @"1",@"v",
                          @"count", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSArray *messageArray = [respDic objectForKey:@"message"];
            //NSLog(@"messageArray:%@",messageArray);
            
            if (!unReadMsgDic) {
                unReadMsgDic = [[NSMutableDictionary alloc]init];
            }else{
                [unReadMsgDic removeAllObjects];
            }
            
            
            NSInteger totalMsgCount = 0;
            
            for (int i =0; i<[messageArray count]; i++) {
                
                long long fuid = [[NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:i]objectForKey:@"friend"]] longLongValue];
                NSInteger count =  [[NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:i]objectForKey:@"count"]] intValue];;
                
                NSString *sql = [NSString stringWithFormat:@"select count(*) from msgList where user_id = %lli",
                                 fuid];
                NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
                
                NSString *sql2 = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", fuid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
                int cnt = [[DBDao getDaoInstance] getResultsToInt:sql2];

                
                if (iCnt > 0) {
                    
                    if (cnt < count) {
                        count = cnt;
                    }
                    
                    if (count < cnt) {
                        count = count;
                    }
                    
                    totalMsgCount+=count;
                    [unReadMsgDic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:[NSString stringWithFormat:@"%lld",fuid]];
                    
                }
                
            }
            
            //totalMsgCount = 25;//测试代码
            
            if(totalMsgCount > 0){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:[NSString stringWithFormat:@"%ld",(long)totalMsgCount]];
                [chatsListTableView reloadData];
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNew" object:nil];
                [chatsListTableView reloadData];
                
            }
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/%" withString:@"%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/&" withString:@"&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/_" withString:@"_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/(" withString:@"("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/)" withString:@")"];
    
    return keyWord;
}
@end
