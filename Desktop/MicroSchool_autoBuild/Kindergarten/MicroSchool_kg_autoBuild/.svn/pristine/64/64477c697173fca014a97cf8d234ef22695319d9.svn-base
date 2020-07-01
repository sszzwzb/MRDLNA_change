//
//  MyGroupMsgListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MyGroupMsgListViewController.h"
#import "LaunchGroupChatViewController.h"
#import "MsgListCell.h"
#import "GroupChatDetailObject.h"
#import "GroupChatList.h"
#import "GroupChatDetailViewController.h"
#import "SubUINavigationController.h"
#import "GroupChatList.h"
#import "GroupChatDetailObject.h"
#import "GroupChatDetailViewController.h"
#import "GroupChatListHeadObject.h"

@interface MyGroupMsgListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray *positionFor9ModeImage;
@end

@implementation MyGroupMsgListViewController
@synthesize chatListArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    headArray = [[NSMutableArray alloc]init];
    
    [self createNoDataView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoGroupChatDetail:)
                                                 name:@"gotoGroupChatDetail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatListData)
                                                 name:NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteGroupListCell:)
                                                 name:@"deleteGroupListCell"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeHeadArray)
                                                 name:@"removeHeadArray"
                                               object:nil];

    [ReportObject event:ID_GROUP_CHAT_OPEN_LIST_INFO];//2015.06.25
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"cid:%@",_cid);
    
    [self getChatListData];// 获取群聊列表数据
    
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    // NSLog(@"viewName:%@",viewName);
    //点击聊天列表页单行发送通知之后做完聊天详情页的viewWillAppear之后又走了一遍聊天记录列表页的viewWillAppear，将defaults中存的viewName的值覆盖了,所以加入此判断
    if ([viewName isEqualToString:@"GroupChatDetailView"]) {//update by kate 2015.03.02
        
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"GroupMsgListView" forKey:@"viewName"];
        [userDefaults synchronize];
    }
    
    [MyTabBarController setTabBarHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [Utilities dismissProcessingHud:self.view];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    LaunchGroupChatViewController *launchGroup = [[LaunchGroupChatViewController alloc] init];
    launchGroup.cid = _cid;
    
    SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:launchGroup];
    [self presentViewController:nav animated:YES completion:nil];

}

-(void)reload{
    
    [_tableView reloadData];
}

- (void)createNoDataView
{
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    noDataView.backgroundColor = [UIColor clearColor];
    noDataView.hidden = YES;
    
    UIImageView *noDataLogo = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 124, 174)];
    noDataLogo.image = [UIImage imageNamed:@"icon_jxw.png"];
    
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataLogo.frame.origin.y+noDataLogo.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您还没有加入任何群聊";
    
    
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"点击右上角创建一个试试吧";
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
        [noDataView addSubview:label];
        [noDataView addSubview:label2];
    }
    //--------------------------------------------
    
    
    [self.view addSubview:noDataView];
    
}

-(void)showNoDataView{
    
    if ([self.chatListArray count] == 0) {
        noDataView.hidden = NO;
    }
    
}

// 获取群聊列表数据
-(void)getChatListData{
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
        
    }
    
     [Utilities dismissProcessingHud:self.view];
     [Utilities showProcessingHud:self.view];
    
     [NSThread detachNewThreadSelector:@selector(getChatListDataNewThread) toTarget:self withObject:nil];
}

- (void)getChatListDataNewThread
{

    @autoreleasepool{
    
    NSLog(@"sql cid:%@",_cid);
    NSLog(@"uid:%@",[Utilities getUniqueUidWithoutQuit]);
        
    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[_cid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
    int cnt = [chatsListDict.allKeys count];
    
        if(cnt > 0){
            
            for (int listCnt = 0; listCnt < cnt; listCnt++) {
                
                NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
                
                GroupChatList *chatList = [[GroupChatList alloc] init];
                chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
                chatList.msg_table_name = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_table_name"]];
                chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
                chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
                chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
                chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
                chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
                chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
                chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
                chatList.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
                chatList.cid = [[chatObjectDict objectForKey:@"cid"] longLongValue];
                chatList.bother = [[chatObjectDict objectForKey:@"bother"] integerValue];
                
//                NSLog(@"gid:%@",[chatObjectDict objectForKey:@"gid"]);
//                NSLog(@"cid:%@",[chatObjectDict objectForKey:@"cid"]);
//                NSLog(@"last_msg:%@",[chatObjectDict objectForKey:@"last_msg"]);
                //       NSLog(@"title:%@",[chatObjectDict objectForKey:@"title"]);
                //---update 2015.09.08----------------------------------------------------------
                if(listCnt > 0){
                    
                   GroupChatList *chatListTemp = [chatListArr objectAtIndex:[chatListArr count]-1];
                    if (chatList.gid != chatListTemp.gid) {
                        [chatListArr addObject:chatList];
                    }
                }else{
                    [chatListArr addObject:chatList];
                }
                
                //[chatListArr addObject:chatList];
                //----------------------------------------------------------------------------------
                
            }
            
        }else{
            
           [Utilities dismissProcessingHud:self.view];
            [self showNoDataView];
            
        }
        
        
        
         [self performSelectorOnMainThread:@selector(loadChatListData:) withObject:chatListArr waitUntilDone:YES];
        
    }
    

    [NSThread exit];


}

// 加载聊天列表数据
- (void)loadChatListData:(NSMutableArray *)chatListData
{
    [self.chatListArray removeAllObjects];
    self.chatListArray = chatListData;
    
    //NSLog(@"chatListArray:%@",self.chatListArray);
    
    if ([self.chatListArray count] > 0) {
        
        noDataView.hidden = YES;
        _tableView.hidden = NO;
        
        [Utilities dismissProcessingHud:self.view];
        [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        
    } else {
        noDataView.hidden = NO;
        _tableView.hidden = YES;
        [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];
        
    }
    
}

- (BOOL)deleteChatsListDataWithUserID:(long long)gid
{
    BOOL deleteResult = NO;
    
    NSString *deleteChatListSql = [[NSString alloc] initWithFormat:@"delete from msgListForGroup_%lli where gid = %lli",[_cid longLongValue],gid];
    deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatListSql];
   
    return deleteResult;
}

-(NSMutableArray*)getGroupAvatar:(NSString*)gid{
    
    /**
     * 拉取群头像
     * @author luke
     * @date 2015.05.26
     * @args
     *  op=getGroupAvatar, sid=, uid=, gid=
     */
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          gid,@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        //NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            for (int i=0; i<[tempArray count]; i++) {
                [array addObject:[[tempArray objectAtIndex:i] objectForKey:@"avatar"]];
            }
            
            for (int i=0; i<[array count]; i++) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  
                    UIImage *itemImg = [FRNetPoolUtils getImage:[array objectAtIndex:i]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [returnArray addObject:itemImg];
                        
                    });
                    
                });

                
            }
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
    return returnArray;
    
}

// 获取头像数组
-(NSMutableArray*)getHeadArray:(long long)gid{
    
    NSLog(@"gid:%lli",gid);
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from msgGroupListForHeadImg where gid = %lli and uid = %lli",gid,[[Utilities getUniqueUidWithoutQuit] longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
    NSInteger cnt = [chatsListDict.allKeys count];
    for (int i = 0; i < cnt; i++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:i]];
        
        GroupChatListHeadObject *chatListHead = [[GroupChatListHeadObject alloc] init];
        chatListHead.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
        chatListHead.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        chatListHead.headUrl = [chatObjectDict objectForKey:@"headUrl"];
        chatListHead.name = [chatObjectDict objectForKey:@"name"];
        [chatListArr addObject:chatListHead];
        
    }
    
    return chatListArr;
    
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
        cell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GroupChatList *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    cell.groupChatListObject = chatListObject;
    cell.nameLabel.text = chatListObject.title;
    //cell.detailLabel.text = chatListObject.last_msg;
    cell.headImageViewForGroup.image = [UIImage imageNamed:@"loading_gray.png"];
    
    if (chatListObject.bother == 0) {
       
        cell.botherImgV.image = nil;
        cell.botherImgV.hidden = YES;

    }else{
        
        cell.botherImgV.image = [UIImage imageNamed:@"icon_mdr.png"];
        cell.botherImgV.hidden = NO;
    }
    
    //cell.botherImgV.image = [UIImage imageNamed:@"icon_mdr.png"];
    
    //NSLog(@"gid:%lli",chatListObject.gid);
    
    if (chatListObject.msg_state == MSG_SEND_FAIL) {
        cell.sendFailed.hidden = NO;
        cell.detailLabel.frame = CGRectMake(80, 34, 237, 26);
    } else {
        cell.sendFailed.hidden = YES;
        cell.detailLabel.frame = CGRectMake(67+8, 34, [[UIScreen mainScreen] bounds].size.width - 67 - 8, 26);
    }
    
    [cell setDetail:chatListObject.last_msg];//update 2015.07.17
    //---------------------------------------------------------
     /*Done:获取群头像数组，排列组合，设置cell.headImageView*/
   
    cell.headImageView.hidden = YES;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    
   //NSLog(@"gid:%lli",chatListObject.gid);
    
     NSMutableArray *tempArray = [self getHeadArray:chatListObject.gid];
    
    for (int i=0; i<[tempArray count]; i++) {
        
        GroupChatListHeadObject *headObj = [tempArray objectAtIndex:i];
        
        long long headUid = headObj.user_id;
        NSString *headUrl = headObj.headUrl;
        NSString *imageName = [headUrl lastPathComponent];
        NSString *imagePath = [Utilities getHeadImagePath:headUid imageName:imageName];
        if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                [returnArray addObject:image];
            }else{
                [array addObject:headObj];
                
            }
            
        }else{
            
            [array addObject:headObj];
            
        }
    }
    
    if (([tempArray count]>0) && ([returnArray count] == [tempArray count])) {
        
        if ([headArray count] == [self.chatListArray count]) {
            
            cell.headImageViewForGroup.image = [headArray objectAtIndex:indexPath.row];
            
        }else{
            
            [self initImageposition];
            NSLog(@"returnArrayCount:%d",[returnArray count]);
            UIImage *image = [self makeGroupAvatar:returnArray];
            if (image) {
                [headArray addObject:image];
            }else{
                NSLog(@"nil");
            }
            
            cell.headImageViewForGroup.image = image;
            
        }
        
        
    }else{
        for (int i=0; i<[array count]; i++) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                GroupChatListHeadObject *headObj = [array objectAtIndex:i];
                
                long long headUid = headObj.user_id;
                NSString *headUrl = headObj.headUrl;
                NSString *imageName = [headUrl lastPathComponent];
                NSString *imagePath = [Utilities getHeadImagePath:headUid imageName:imageName];
                
                // 拉取头像存储本地
                [FRNetPoolUtils getPicWithUrl:headUrl picType:PIC_TYPE_HEAD userid:headUid msgid:0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                        if (image) {
                            [returnArray addObject:image];
                        }
                    }
                    
                    if (i == [array count]-1) {
                        
                        [self initImageposition];
                        
                        //NSLog(@"returnArrayCount:%d",[returnArray count]);
                        
                        UIImage *image = [self makeGroupAvatar:returnArray];
                        
                        cell.headImageViewForGroup.image = image;
                        
                    }
                });
                
            });
            
        }
    
    }
    
    //---------------------------------------------------------------------------

    // 时间标签,转换时间形式
    long long timestamp = chatListObject.timestamp;
    timestamp = timestamp/1000.0;
    
    NSString *dateString = [Utilities timeIntervalToDate:timestamp timeType:0 compareWithToday:YES];
    [cell setTime:dateString];
    
    if (tableView.editing == YES) {
        cell.timeLabel.hidden = YES;
       
    } else {
        cell.timeLabel.hidden = NO;
        cell.unReadBadgeView.hidden = YES;
        cell.unReadLabel.hidden = YES;
        cell.unReadLabel.text = @"";
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", cell.groupChatListObject.gid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        if (cnt > 0) {
            
            cell.unReadBadgeView.hidden = NO;
            cell.unReadLabel.hidden = NO;
            cell.unReadBadgeView.frame = CGRectMake(cell.headImageViewForGroup.frame.origin.x + WIDTH_HEAD_CELL_IMAGE - 10, cell.headImageViewForGroup.frame.origin.y - 2, 19, 19);
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
        }
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = COMMON_TABLEVIEWCELL_SELECTED_COLOR;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 进入编辑状态后不显示时间和未读消息数
    MsgListCell *cell =  (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView.editing == YES) {
        cell.timeLabel.hidden = YES;
        
    } else {
        cell.timeLabel.hidden = NO;
        
    }
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        GroupChatList *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.gid];
        
        if (bDeleteMsg) {
            
            NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoForGroup_%lli",chatListObject.gid];
            [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
            
            [self.chatListArray removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
            
        } else {
            // 删除失败提示
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Failed to delete chat!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
            [alert show];
           
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleRows = [tableView visibleCells];
    if([visibleRows count] > 0){
        for (MsgListCell *cell in visibleRows) {
            cell.timeLabel.hidden = NO;
          
        }
    }
    
    [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupChatList *groupChatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    
//    MsgListCell *cell = (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (cell.groupChatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.groupChatListObject.msg_state != MSG_READ_FLG_READ) {
//        cell.groupChatListObject.msg_state = MSG_READ_FLG_READ;
//        [cell.groupChatListObject updateToDB];
//    }
    if (groupChatListObject.is_recieved == MSG_IO_FLG_RECEIVE && groupChatListObject.msg_state != MSG_READ_FLG_READ ) {
        groupChatListObject.msg_state = MSG_READ_FLG_READ;
        [groupChatListObject updateToDB];
    }
    //cell.unReadBadgeView.hidden = YES;
    
   //NSLog(@"cell.groupChatListObject.gid:%lld",cell.groupChatListObject.gid);
    
    NSString *title = [NSString stringWithFormat:@"%@",groupChatListObject.title];
    long long gid = groupChatListObject.gid;
    long long cid = groupChatListObject.cid;
    
    GroupChatDetailViewController *chatDeatilController = [[GroupChatDetailViewController alloc] init];
    chatDeatilController.gid = gid;
    chatDeatilController.titleName = title;
    chatDeatilController.cid = cid;
    chatDeatilController.groupChatList = groupChatListObject;
    if (groupChatListObject.last_msg_type == 4 || groupChatListObject.last_msg_type == 5) {
        
        if (groupChatListObject.user_id == [[Utilities getUniqueUidWithoutQuit] longLongValue]) {
            chatDeatilController.isViewGroupMember = 0;
        }else{
           chatDeatilController.isViewGroupMember = 1;
        }
        
    }else{
         chatDeatilController.isViewGroupMember = 1;
    }
   
    [self.navigationController pushViewController:chatDeatilController animated:YES];

    [self getGroupHead:groupChatListObject];
    
}

// 调用群头像接口
-(void)getGroupHead:(GroupChatList*)chatList{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          [NSString stringWithFormat:@"%lli",chatList.gid],@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            //群聊数量
             NSString *memberNum = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"member"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserNumer" object:memberNum];
            
            //name 群名字
            NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
            chatList.title = groupName;
            [chatList updateGroupName];//更新群名字
            
            GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
            headObject.gid = chatList.gid;
            [headObject deleteData];
            
            for (int i =0; i<[tempArray count]; i++) {
                
                long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                
                headObject.user_id = headUid;
                headObject.headUrl = headUrl;
                headObject.name = name;
                [headObject insertData];
                
            }
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

// 去群聊详细页
-(void)gotoGroupChatDetail:(NSNotification*)notification{
    
    // To do:生成群成功接收消息走此方法 刷新群聊列表 跳转至聊天详细页
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
    //[self getChatListData];// 获取最新群聊列表数据显示
    
    groupChatList = (GroupChatList*)[notification object];
    _cid = [NSString stringWithFormat:@"%lli",groupChatList.cid];
    
    GroupChatDetailViewController *groupDetailV = [[GroupChatDetailViewController alloc]init];
    groupDetailV.fromName = @"createGroup";
    groupDetailV.titleName = groupChatList.title;
    groupDetailV.gid = groupChatList.gid;
    groupDetailV.cid = groupChatList.cid;
    groupDetailV.isViewGroupMember = 1;
    groupDetailV.groupChatList = groupChatList;
    [self.navigationController pushViewController:groupDetailV animated:YES];
    
}

// 自己删除并推出群
-(void)deleteGroupListCell:(NSNotification*)notification{
    
    long long gid = [[notification object] longLongValue];
    
    BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:gid];
    
    BOOL deleteResult = NO;
    
    if (bDeleteMsg) {
        
        NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoForGroup_%lli",gid];
        deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
    
    }
    
    if (deleteResult) {
        [self getChatListData];// 重新获取最新群聊列表数据显示
    }
    
}

//---组合头像逻辑-----------------------------------------------------------------------
- (UIImage *)makeGroupAvatar: (NSMutableArray *)imageArray {
    //数组为空，退出函数
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,193,193)];
    groupAvatarView.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    
    for (int i = 0; i < [imageArray count]; i++){
        UIImageView *tempImageView;
        if ([imageArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor4ModeImage objectAtIndex:i]CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor9ModeImage objectAtIndex:i]CGRectValue]];
        }
        [tempImageView setImage:[imageArray objectAtIndex:i]];
        [groupAvatarView addSubview:tempImageView];
    }
    
    //把UIView设置为image并修改图片大小55*55，因为是Retina屏幕，要放大2倍
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(110.0, 110.0)];
    
    return reImage;
}

- (void)initImageposition{
    
    //初始化4图片模式和9图片模式
    for(int i = 0; i < 9; i++){
        CGRect tempMode4Rect;
        CGRect tempMode9Rect;
        float mode4PositionX = 0;
        float mode4PositionY = 0;
        float mode9PositionX = 0;
        float mode9PositionY = 0;
        
        switch (i) {
            case 0:
                mode4PositionX = 4;
                mode4PositionY = 4;
                mode9PositionX = 4;
                mode9PositionY = 4;
                break;
            case 1:
                mode4PositionX = 98.5;
                mode4PositionY = 4;
                mode9PositionX = 67;
                mode9PositionY = 4;
                break;
            case 2:
                mode4PositionX = 4;
                mode4PositionY = 98.5;
                mode9PositionX = 130;
                mode9PositionY = 4;
                break;
            case 3:
                mode4PositionX = 98.5;
                mode4PositionY = 98.5;
                mode9PositionX = 4;
                mode9PositionY = 67;
                break;
            case 4:
                mode9PositionX = 67;
                mode9PositionY = 67;
                break;
            case 5:
                mode9PositionX = 130;
                mode9PositionY = 67;
                break;
            case 6:
                mode9PositionX = 4;
                mode9PositionY = 130;
                break;
            case 7:
                mode9PositionX = 67;
                mode9PositionY = 130;
                break;
            case 8:
                mode9PositionX = 130;
                mode9PositionY = 130;
                break;
            default:
                break;
        }
        
        //添加4模式图片坐标到数组
        if (i < 4 ){
            tempMode4Rect = CGRectMake(mode4PositionX, mode4PositionY, 90.5, 90.5);
            [_positionFor4ModeImage addObject:[NSValue valueWithCGRect:tempMode4Rect]];
        }
        
        //添加4模式图片坐标到数组
        tempMode9Rect = CGRectMake(mode9PositionX, mode9PositionY, 59, 59);
        [_positionFor9ModeImage addObject:[NSValue valueWithCGRect:tempMode9Rect]];
    }
}

-(UIImage*)convertViewToImage:(UIView*)v{
    
    CGSize s = v.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)removeHeadArray{
    
    [headArray removeAllObjects];
}
//-----------------------------------------------------------------------------------------------------

@end
