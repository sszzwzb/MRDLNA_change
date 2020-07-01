//
//  TranspondViewController.m
//  MicroSchool
//
//  Created by Kate on 15-3-24.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TranspondViewController.h"
#import "FriendTableViewCell.h"
#import "UIButton+WebCache.h"
#import "ChatListObject.h"
#import "UserObject.h"
#import "FRNetPoolUtils.h"
#import "PublicConstant.h"
#import "MyClassViewController.h"
#import "Toast+UIView.h"
#import "FriendMultiSelectViewController.h"
#import "DepartmentListViewController.h"

@interface TranspondViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerViewForDep;
@property (strong, nonatomic) IBOutlet UIView *headerView;
- (IBAction)gotoClassmate:(id)sender;
- (IBAction)gotoTeachers:(id)sender;
- (IBAction)gotoParents:(id)sender;
- (IBAction)gotoFriends:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *classmateBtn;
@property (strong, nonatomic) IBOutlet UIButton *teacherBtn;
@property (strong, nonatomic) IBOutlet UIButton *parentsBtn;
@property (strong, nonatomic) IBOutlet UIButton *friendBtn;
- (IBAction)gotoDepartmentList:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *departmentBtn;
@property (strong, nonatomic) IBOutlet UIButton *subDepartmentBtn;
@property (strong, nonatomic) IBOutlet UIButton *friendbBtn;

@end

@implementation TranspondViewController
@synthesize chatListArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self setCustomizeTitle:@""];
    
    [_classmateBtn setBackgroundImage:[UIImage imageNamed:@"icon_tx_d.png"] forState:UIControlStateNormal];
    [_classmateBtn setBackgroundImage:[UIImage imageNamed:@"icon_tx_p.png"] forState:UIControlStateHighlighted];
    
    [_teacherBtn setBackgroundImage:[UIImage imageNamed:@"icon_ls_d.png"] forState:UIControlStateNormal];
    [_teacherBtn setBackgroundImage:[UIImage imageNamed:@"icon_ls_p.png"] forState:UIControlStateHighlighted];
    
    [_parentsBtn setBackgroundImage:[UIImage imageNamed:@"icon_jz_d.png"] forState:UIControlStateNormal];
    [_parentsBtn setBackgroundImage:[UIImage imageNamed:@"icon_jz_p.png"] forState:UIControlStateHighlighted];
    
    [_friendBtn setBackgroundImage:[UIImage imageNamed:@"icon_hy_d.png"] forState:UIControlStateNormal];
    [_friendBtn setBackgroundImage:[UIImage imageNamed:@"icon_hy_p.png"] forState:UIControlStateHighlighted];
    
    //---add 2015.05.06------------------------------------------------------------------------------------
    [_departmentBtn setBackgroundImage:[UIImage imageNamed:@"btn_bdw_d.png"] forState:UIControlStateNormal];
    [_departmentBtn setBackgroundImage:[UIImage imageNamed:@"btn_bdw_p.png"] forState:UIControlStateHighlighted];
    
    [_subDepartmentBtn setBackgroundImage:[UIImage imageNamed:@"btn_xsdw_d.png"] forState:UIControlStateNormal];
    [_subDepartmentBtn setBackgroundImage:[UIImage imageNamed:@"btn_xsdw_p.png"] forState:UIControlStateHighlighted];
    
    [_friendbBtn setBackgroundImage:[UIImage imageNamed:@"btn_hy_d_b.png"] forState:UIControlStateNormal];
    [_friendbBtn setBackgroundImage:[UIImage imageNamed:@"btn_hy_p_b.png"] forState:UIControlStateHighlighted];
    //-----------------------------------------------------------------------------------------------------
    // update 2015.05.06
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    if ([@"bureau" isEqualToString:schoolType]) {
        _tableView.tableHeaderView = _headerViewForDep;
    }else{
       _tableView.tableHeaderView = _headerView;
    }
    //---------------------------------------------------------------------------------------
    
    _tableView.tableFooterView = [[UIView alloc] init];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getChatListData];
    
}

// 获取Chat list
- (void)getChatListData
{
    [NSThread detachNewThreadSelector:@selector(getChatListDataNewThread) toTarget:self withObject:nil];
}

- (void)getChatListDataNewThread
{
    
    NSString *sql = @"select * from msgList ORDER BY timestamp DESC";
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[NSMutableArray alloc] init] ;
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
        
        //NSLog(@"title:%@",chatList.title);
        
        [chatListArr addObject:chatList];
        
        
    }
   
    
    [self performSelectorOnMainThread:@selector(loadChatListData:) withObject:chatListArr waitUntilDone:YES];
    
    
    [NSThread exit];
}

// 加载聊天列表数据
- (void)loadChatListData:(NSMutableArray *)chatListData
{
    [self.chatListArray removeAllObjects];
    self.chatListArray = chatListData;
    
    //NSLog(@"chatListArray:%@",self.chatListArray);
    
    if ([self.chatListArray count] > 0) {
        
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
    
}

-(void)cancel:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoClassmate:(id)sender {

    [self gotoActorView:@"classmate"];
}

- (IBAction)gotoTeachers:(id)sender {

    [self gotoActorView:@"teacher"];
}


- (IBAction)gotoParents:(id)sender {

    [self gotoActorView:@"parent"];
}


- (IBAction)gotoFriends:(id)sender {
    
    [self gotoActorView:@"friend"];
    
}

-(void)gotoActorView:(NSString*)friendType{
    
    
     MyClassViewController *myClassViewCtrl = [[MyClassViewController alloc] init];
     myClassViewCtrl.toViewName = @"Transpond";
     myClassViewCtrl.title = @"我的班级";
     myClassViewCtrl.friendType = friendType;
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *checked = [user objectForKey:@"role_checked"];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    if([@"7"  isEqual: usertype])
    {
        // update by kate 2015.06.18 好友不管认证是否都可以进入
        if ([@"friend" isEqualToString:friendType]){
            
            FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
            friendSelectViewCtrl.classid = cid;
            friendSelectViewCtrl.friendType = friendType;
            friendSelectViewCtrl.fromName = @"Transpond";
            friendSelectViewCtrl.entity = _entity;
            [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
            
        }else{
            
            if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
            {
//                [self.view makeToast:@"您还未获得教师身份，请递交申请."
//                            duration:0.5
//                            position:@"center"
//                               title:nil];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"只有认证教师可以使用."
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
            {
//                [self.view makeToast:@"请耐心等待审批."
//                            duration:0.5
//                            position:@"center"
//                               title:nil];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"只有认证教师可以使用."
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                /*if ([@"friend" isEqualToString:friendType]) {
                    
                    FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
                    friendSelectViewCtrl.classid = cid;
                    friendSelectViewCtrl.friendType = friendType;
                    friendSelectViewCtrl.fromName = @"Transpond";
                    friendSelectViewCtrl.entity = _entity;
                    [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
                    
                }else{*/
                    myClassViewCtrl.entity = _entity;
                    [self.navigationController pushViewController:myClassViewCtrl animated:YES];
                //}
                
                
            }
        }
        
 
    }else if ([@"2"  isEqual: usertype] || [@"9"  isEqual: usertype]){
        

        if ([@"friend" isEqualToString:friendType]) {
            
            FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
            friendSelectViewCtrl.classid = cid;
            friendSelectViewCtrl.friendType = friendType;
            friendSelectViewCtrl.fromName = @"Transpond";
            friendSelectViewCtrl.entity = _entity;
            [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
            
        }else{
            myClassViewCtrl.entity = _entity;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        }
        
    }
    else{
        // update by kate 2015.06.18 好友不管认证是否都可以进入
        if ([@"friend" isEqualToString:friendType]){
            
            FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
            friendSelectViewCtrl.classid = cid;
            friendSelectViewCtrl.friendType = friendType;
            friendSelectViewCtrl.fromName = @"Transpond";
            friendSelectViewCtrl.entity = _entity;
            [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
            
        }else{
            if ([@""  isEqual: cid] || [cid integerValue] == 0) {
                
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"请通过主页的“我的班级”右上角加入班级"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"知道了"
//                                                     otherButtonTitles:nil];
//                [alert show];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"您还未加入任何班级，无法使用此功能。"
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
                
            } else {
                
                
                FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
                friendSelectViewCtrl.classid = cid;
                friendSelectViewCtrl.friendType = friendType;
                friendSelectViewCtrl.fromName = @"Transpond";
                friendSelectViewCtrl.entity = _entity;
                [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
                
            }

        }
        
    }
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
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[FriendTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.btn_thumb.layer.masksToBounds = YES;
    cell.btn_thumb.layer.cornerRadius = 40/2;
    cell.btn_thumb.contentMode = UIViewContentModeScaleToFill;
    //[cell.btn_thumb setEnabled:true];
    
    ChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    cell.name = chatListObject.title;
    
    
    UserObject *localUser = [UserObject getUserInfoWithID:chatListObject.user_id];
    if (localUser && [localUser.headimgurl length] > 0) {
        // 从服务器拉取头像
        NSString *imageName = [localUser.headimgurl lastPathComponent];
        NSString *imagePath = [Utilities getHeadImagePath:chatListObject.user_id imageName:imageName];
        if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                 [cell.btn_thumb setBackgroundImage:image forState:UIControlStateNormal];
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
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 从服务器拉取头像
                    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                        if (image) {
                            
                            [cell.btn_thumb setBackgroundImage:image forState:UIControlStateNormal];
                        }
                    }
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([serverUser.name length] > 0) {
                    cell.name = serverUser.name;
                }
            });
        }
    });
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"最近联系人";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //弹出提示框，将消息发送给某某
    ChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    userID = [NSString stringWithFormat:@"%lld",chatListObject.user_id];
    userName = chatListObject.title;
    UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"确定发送给：" message:chatListObject.title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerV show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //调用转发接口，更新数据库，转发成功后页面消失
//        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.labelText = @"发送中...";
         [Utilities showProcessingHud:self.view];// 2015.05.12
       
        long long msgID = [Utilities GetMsgId];
        NSString *otherMsgId = [NSString stringWithFormat:@"%lld",msgID];
        NSString *receivers = [NSString stringWithFormat:@"%@:%@",userID,otherMsgId];
        //NSLog(@"recivers:%@",receivers);
        
        //NSLog(@"entity.msgId:%@",);
        
        
        ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
        // 消息的msgID
        chatDetail.msg_id = msgID;
        chatDetail.user_id = [userID longLongValue];
        //NSLog(@"uid:%lld",chatDetail.user_id);
        // 消息的发送(0)接收(1)区分
        chatDetail.is_recieved = MSG_IO_FLG_SEND;
       
        // 消息状态：发送，已读，未读，失败等
        chatDetail.msg_state = MSG_SENDING;
        if (_entity.msg_type == MSG_TYPE_TEXT) {
            // 消息内容
            chatDetail.msg_content = _entity.msg_content;//文本
            //消息类型-文本
            chatDetail.msg_type = MSG_TYPE_TEXT;
        }else if(_entity.msg_type == MSG_TYPE_PIC){
            // 文件名（语音，图片，涂鸦）
            chatDetail.msg_content = @"[图片]";//图片
            NSString *thumbImageDir = [Utilities getChatPicThumbDir:_entity.user_id];// update by kate 2015.03.27
            NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, _entity.msg_id,FILE_JPG_EXTENSION];
            //UIImage *pic = [UIImage imageWithContentsOfFile:thumbImagePath];
            NSData *fileData =[NSData dataWithContentsOfFile:thumbImagePath];
            
            NSString *originalImageDir = [Utilities getChatPicOriginalDir:_entity.user_id];
            NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, _entity.msg_id, FILE_JPG_EXTENSION];
            NSData *fileData2 =[NSData dataWithContentsOfFile:originalImagePath];
            
            if ([_entity.pic_url_original length]>0) {
                if (fileData2) {
                    chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData2];
                }else if (fileData){
                    chatDetail.msg_file = [self saveThumbPicToLocal:chatDetail.msg_id imageData:fileData];
                }
            }else{
                if (fileData2) {
                    chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData2];
                }else if (fileData){
                    chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData];
                }
 
            }
            
            //消息类型-图片
            chatDetail.msg_type = MSG_TYPE_PIC;
        }
       
        // 原始图片文件的HTTP-URL地址
        chatDetail.pic_url_thumb = @"";
        if ([_entity.pic_url_original length]>0) {
            chatDetail.pic_url_original = _entity.pic_url_original;
            
        }else{
            chatDetail.pic_url_original = @"";
            
        }
        chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
        
        [chatDetail updateToDB];
        
        ChatListObject *chatList = [self saveMsgToChatList:chatDetail userName:userName];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *sendFlag = [FRNetPoolUtils transpondMsg:_entity receivers:receivers];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[HUD hide:YES];
                [Utilities dismissProcessingHud:self.view];//2015.05.12

                //NSLog(@"sendFlag:%@",sendFlag);
                
                if ([sendFlag isEqualToString:@"NO"]) {
                    
                    // 发送失败
                    chatDetail.msg_state = MSG_SEND_FAIL;
                    chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                    [chatDetail updateToDB];
                    //[(ChatDetailObject *)[chatDetailArray lastObject] setMsg_state:MSG_SEND_FAIL];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                        message:@"转发消息失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil,nil];
                    [alertView show];
                    
                }else{
                    // 发送成功
                    chatDetail.msg_state = MSG_SEND_SUCCESS;
                    chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                    [chatDetail updateToDB];
                    
                    //[MobClick event:Report_SendTextMessage];
                    //[ReportObject event:Report_Event_NO_SendTextMessage];
                }
                
                chatList.msg_state = chatDetail.msg_state;
                chatList.timestamp = chatDetail.timestamp;
                [chatList updateToDB];
                
            
//                // 更新聊天列表画面
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];
                
                // 更新聊天详情画面
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
                
                if (![sendFlag isEqualToString:@"NO"]){
                    [self dismissViewControllerAnimated:YES completion:^{
                        //[MBProgressHUD showSuccess:@"已发送" toView:nil];
                        [Utilities showSuccessedHud:@"已发送" descView:nil];//2015.05.12
                    }];
                }
                
            });
        
        });
        
    }
    
}

-(ChatListObject *)saveMsgToChatList:(ChatDetailObject *)chatDetail userName:(NSString *)sendUserName
{
    ChatListObject *chatList = [[ChatListObject alloc] init];
    chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", chatDetail.user_id];
    chatList.is_recieved = MSG_IO_FLG_SEND;
    //最后一条消息ID
    chatList.last_msg_id= chatDetail.msg_id;
    // 聊天的最后一条消息的类型
    chatList.last_msg_type= chatDetail.msg_type;
    // 聊天的最后一条消息内容
    chatList.last_msg = chatDetail.msg_content;
    //该条消息是否已经读取
    //    if (chatDetail.is_recieved == MSG_IO_FLG_SEND) {
    //        chatList.msg_state = MSG_SEND_SUCCESS;
    //    } else {
    //        chatList.msg_state = MSG_RECEIVED_SUCCESS;
    //    }
    chatList.msg_state = chatDetail.msg_state;
    chatList.user_id = chatDetail.user_id;
    if ([sendUserName length] > 0) {
        chatList.title = sendUserName;
    } else {
        chatList.title = NO_NAME_USER;
    }
    //时间戳
    chatList.timestamp = chatDetail.timestamp;
    [chatList updateToDB];
    
    return chatList;
}

- (NSString *)saveThumbPicToLocal:(long long)msgid imageData:(NSData*)fileData
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:[userID longLongValue]];
    NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
    NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
   
    
    // 创建聊天缩略图片，并写入本地
    if ([fileData writeToFile:thumbImagePath atomically:YES]) {
        //NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
    }
    
    return thumbImagePath;//update by kate 2015.03.27
}

// 发送图片存储大图 2015.07.09
- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:[userID longLongValue]];
    NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
    NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
    
    //UIImage *originalImage = [UIImage imageWithData:fileData];
    
    //创建源图片，并写入本地成功
    if ([fileData writeToFile:originalImagePath atomically:YES]) {
        NSLog(@"writeToFile:%@", originalImagePath);
    }
    
    return originalImagePath;
    
}

- (IBAction)gotoDepartmentList:(id)sender {
    
     UIButton *btn = (UIButton*)sender;
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *checked = [user objectForKey:@"role_checked"];
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    // 教师未认证点击分组时，提示：只有认证教师可以使用 2015.06.18
    if([@"7"  isEqual: usertype])
    {
        if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
          
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"只有认证教师可以使用."
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
           
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"只有认证教师可以使用."
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (btn.tag == 111) {
                
//                FriendCommonViewController *friendCommonViewCtrl = [[FriendCommonViewController alloc] init];
//                friendCommonViewCtrl.titleName = @"本单位";
//                friendCommonViewCtrl.fromTitle = @"本单位";
//                friendCommonViewCtrl.classid = @"0";
//                [self.navigationController pushViewController:friendCommonViewCtrl animated:YES];
                
                
                
                
                DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
                
                departV.fromName = @"department";
                departV.toViewName = @"Transpond";
                departV.entity = _entity;

                //        if ([[dic objectForKey:@"row"] integerValue] == 0) {
                //            departV.fromName = @"subdepart";
                //        }
                [self.navigationController pushViewController:departV animated:YES];

                
#if 0
                FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
                friendSelectViewCtrl.classid = @"0";
                friendSelectViewCtrl.friendType = @"friend";
                friendSelectViewCtrl.fromName = @"Transpond";
                friendSelectViewCtrl.flag = @"本单位";
                friendSelectViewCtrl.entity = _entity;
                [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
#endif
                
            }else{
                DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
                departV.toViewName = @"Transpond";
                departV.entity = _entity;
                if (btn.tag == 111) {
                    departV.fromName = @"department";
                }else{
                    departV.fromName = @"subdepart";
                }
                [self.navigationController pushViewController:departV animated:YES];
            }
            
            
        }
    }else if ([@"2"  isEqual: usertype] || [@"9"  isEqual: usertype]){
       
        if (btn.tag == 111) {
            
//            FriendCommonViewController *friendCommonViewCtrl = [[FriendCommonViewController alloc] init];
//            friendCommonViewCtrl.titleName = @"本单位";
//            friendCommonViewCtrl.fromTitle = @"本单位";
//            friendCommonViewCtrl.classid = @"0";
//            [self.navigationController pushViewController:friendCommonViewCtrl animated:YES];
            
            DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
            
            departV.fromName = @"department";
            departV.toViewName = @"Transpond";
            departV.entity = _entity;
            
            //        if ([[dic objectForKey:@"row"] integerValue] == 0) {
            //            departV.fromName = @"subdepart";
            //        }
            [self.navigationController pushViewController:departV animated:YES];

            
#if 0
            FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
            friendSelectViewCtrl.classid = @"0";
            friendSelectViewCtrl.friendType = @"friend";
            friendSelectViewCtrl.fromName = @"Transpond";
            friendSelectViewCtrl.flag = @"本单位";
            friendSelectViewCtrl.entity = _entity;
            [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
#endif
            
        }else{
            
            DepartmentListViewController *departV = [[DepartmentListViewController alloc]init];
            departV.toViewName = @"Transpond";
            departV.entity = _entity;
            if (btn.tag == 111) {
                departV.fromName = @"department";
            }else{
                departV.fromName = @"subdepart";
            }
            [self.navigationController pushViewController:departV animated:YES];
        }
       
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"只有认证教师可以使用."
                                                      delegate:nil
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
        [alert show];
        /*对于教育局版本（分组：本单位、下属单位）：
         教师未认证点击分组时，提示：只有认证教师可以使用
         家长学生无论是否加入班级，均有如上提示。*/
        
        
    }
    
}
@end
