//
//  FriendMultiSelectViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 6/6/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "FriendMultiSelectViewController.h"
#import "FRNetPoolUtils.h"
#import "PublicConstant.h"
#import "ChatListObject.h"
#import "EnterMultiMsgViewController.h"

@interface FriendMultiSelectViewController ()

@end

@implementation FriendMultiSelectViewController

@synthesize classid;
@synthesize friendType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        listDataArray =[[NSMutableArray alloc] init];
        sendMsgUids =[[NSMutableArray alloc] init];
        sendMsgUserName = [[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        searchText = @"";
        
        // 获取当前用户的cid
        NSDictionary *user1 = [g_userInfo getUserDetailInfo];
        cid = [user1 objectForKey:@"cid"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setCustomizeTitle:@"多人发送"];
    
    if ([@"Transpond" isEqualToString:_fromName]) {// 2015.03.25
        [self setCustomizeTitle:@"选择联系人"];
    }else{
        [ReportObject event:ID_OPEN_SEND_LIST];//2015.06.25
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    // 右菜单，发送
    [super setCustomizeRightButtonWithName:@"确定"];
}

-(void)viewWillDisappear:(BOOL)animated
{
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    [sendMsgUids removeAllObjects];
    [sendMsgUserName removeAllObjects];
    
    // 去多选数据里面寻找用户选中的uid，存储到array里面
    for (int i=0; i<[listDataArray count]; i++) {
        if (1 == ((NSString *)[[listDataArray objectAtIndex:i] objectForKey:@"isChecked"]).integerValue) {
            NSString *sendUid = [[listDataArray objectAtIndex:i] objectForKey:@"uid"];
            NSString *sendUserName = [[listDataArray objectAtIndex:i] objectForKey:@"name"];
            if (![@"0"  isEqual: sendUid]) {
                [sendMsgUids addObject:sendUid];
                [sendMsgUserName addObject:sendUserName];
            }
        }
    }
    
    if ([@"Transpond" isEqualToString:_fromName]){// 2015.03.25
        
        
        if ([sendMsgUserName count] == 0) {
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择联系人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertV.tag = 303;
            [alertV show];
            
        }else{
            //弹出提示框，“确定发送给：”，更新数据库，发送成功页面消失
            NSString *names = @"";
            if ([sendMsgUserName count] > 3) {
                names = [NSString stringWithFormat:@"%@、%@、%@等(%d人)",[sendMsgUserName objectAtIndex:0],[sendMsgUserName objectAtIndex:1],[sendMsgUserName objectAtIndex:2],[sendMsgUserName count]];
            }else{
                
                for (int i=0; i<[sendMsgUserName count]; i++) {
                    if ([names length] == 0) {
                        
                        names = [NSString stringWithFormat:@"%@",[sendMsgUserName objectAtIndex:i]];
                    }else{
                        names = [NSString stringWithFormat:@"%@、%@",names,[sendMsgUserName objectAtIndex:i]];
                    }
                    
                }
                
                names = [NSString stringWithFormat:@"%@(%d人)",names,[sendMsgUserName count]];
            }
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"确定发送给:" message:names delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 303;
            [alertV show];
        }
        
    
    }else{
        
        //---update by kate 2015.02.11--------------------------
        
        if ([sendMsgUserName count] == 0) {
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择联系人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertV.tag = 303;
            [alertV show];
            
        }else{
            EnterMultiMsgViewController *emmv = [[EnterMultiMsgViewController alloc]init];
            emmv.sendMsgUids = sendMsgUids;
            emmv.sendMsgUserName = sendMsgUserName;
            [self.navigationController pushViewController:emmv animated:YES];
        }
        
        /* if (0 != [sendMsgUids count]) {
         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
         message:@"请输入消息内容"
         delegate:self
         cancelButtonTitle:@"取消"
         otherButtonTitles:@"发送", nil];
         
         alert.alertViewStyle = UIAlertViewStylePlainTextInput;
         
         [alert show];
         }*/
        //--------------------------------------------------------
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    }
    else {
        
        if (alertView.tag == 303) {
            
            //调用转发接口，更新数据库，转发成功后页面消失
//            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            HUD.labelText = @"发送中...";
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            NSMutableArray *chatDetailArray = [[NSMutableArray alloc] init];
            NSMutableArray *chatListArray = [[NSMutableArray alloc]init];
            NSString *recivers = @"";
            
         for (int i=0; i<[sendMsgUids count]; i++) {
            
            ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
            // 消息的msgID
            chatDetail.msg_id = [Utilities GetMsgId];
            chatDetail.user_id = [[sendMsgUids objectAtIndex:i] longLongValue];
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
//                NSData *fileData =[NSData dataWithContentsOfFile:thumbImagePath];
//                chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData uid:[NSString stringWithFormat:@"%lld",chatDetail.user_id]];
                
                NSData *fileData =[NSData dataWithContentsOfFile:thumbImagePath];
                
                NSString *originalImageDir = [Utilities getChatPicOriginalDir:_entity.user_id];
                NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, _entity.msg_id, FILE_JPG_EXTENSION];
                NSData *fileData2 =[NSData dataWithContentsOfFile:originalImagePath];
                
                if ([_entity.pic_url_original length]>0) {
                    if (fileData2) {
                        chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData2 uid:[NSString stringWithFormat:@"%lld",chatDetail.user_id]];
                    }else if (fileData){
                        chatDetail.msg_file = [self saveThumbPicToLocal:chatDetail.msg_id imageData:fileData uid:[NSString stringWithFormat:@"%lld",chatDetail.user_id]];
                    }
                }else{
                    if (fileData2) {
                        chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData2 uid:[NSString stringWithFormat:@"%lld",chatDetail.user_id]];
                    }else if (fileData){
                        chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:fileData uid:[NSString stringWithFormat:@"%lld",chatDetail.user_id]];
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
            
            ChatListObject *chatList = [self saveMsgToChatList:chatDetail userName:[sendMsgUserName objectAtIndex:i]];
            
             [chatDetailArray addObject:chatDetail];
             [chatListArray addObject:chatList];
             
             NSString *itermMsgid = [NSString stringWithFormat:@"%lld",chatDetail.msg_id];
             NSString *iterm = [NSString stringWithFormat:@"%@:%@",[sendMsgUids objectAtIndex:i],itermMsgid];
            
             if ([recivers length] == 0) {
                 recivers = iterm;
             }else{
                  recivers = [NSString stringWithFormat:@"%@,%@",recivers,iterm];
             }
            
            
          }
            
            NSLog(@"recivers:%@",recivers);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *sendFlag = [FRNetPoolUtils transpondMsg:_entity receivers:recivers];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[HUD hide:YES];
                    [Utilities dismissProcessingHud:self.view];//2015.05.12
                    if ([[sendFlag substringToIndex:3] isEqualToString:@"YES"]) {
                        // 发送成功
                        
                        for (int i=0; i<[sendMsgUids count]; i++) {
                            
                            ChatDetailObject *chateD = [chatDetailArray objectAtIndex:i];
                            
                            chateD.msg_state = MSG_SEND_SUCCESS;
                            chateD.timestamp = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                            [chateD updateToDB];
                            
                        }
                        
//                        chatDetail.msg_state = MSG_SEND_SUCCESS;
//                        chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                        [chatDetail updateToDB];
                        
                        
                        //[MobClick event:Report_SendTextMessage];
                        //[ReportObject event:Report_Event_NO_SendTextMessage];
                    } else {
                        // 发送失败
//                        chatDetail.msg_state = MSG_SEND_FAIL;
//                        chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                        [chatDetail updateToDB];
                        //[(ChatDetailObject *)[chatDetailArray lastObject] setMsg_state:MSG_SEND_FAIL];
                        for (int i=0; i<[sendMsgUids count]; i++) {
                            
                            ChatDetailObject *chateD = [chatDetailArray objectAtIndex:i];
                            
                            chateD.msg_state = MSG_SEND_SUCCESS;
                            chateD.timestamp = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                            [chateD updateToDB];
                        }
                        
                    }
                    
//                    chatList.msg_state = chatDetail.msg_state;
//                    chatList.timestamp = chatDetail.timestamp;
//                    [chatList updateToDB];
                    for (int i=0; i<[sendMsgUids count]; i++) {
                        
                        ChatDetailObject *chateD = [chatDetailArray objectAtIndex:i];
                        ChatListObject *chatL = [chatListArray objectAtIndex:i];
                        
                        chatL.msg_state = chateD.msg_state;
                        chatL.timestamp = chateD.timestamp;
                        [chatL updateToDB];
                    }
                    
                    // 更新聊天详情画面
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        //[MBProgressHUD showSuccess:@"已发送" toView:nil];
                        [Utilities showSuccessedHud:@"已发送" descView:nil];//2015.05.12
                    }];
                    
                });
                
            });
            
        }else{
            UITextField *tf=[alertView textFieldAtIndex:0];
            NSString *text = tf.text;
            // to kate
            // 在这个地方直接发送即可，uid列表在sendMsgUids这个array里面
            
            // 多人发送，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:DataReport_Act_PhoneBook_MultiSendMsg];
            
            for (int i=0; i<[sendMsgUids count]; i++) {
                
                ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
                // 消息的msgID
                chatDetail.msg_id = [Utilities GetMsgId];
                chatDetail.user_id = [[sendMsgUids objectAtIndex:i] longLongValue];
                //NSLog(@"uid:%lld",chatDetail.user_id);
                // 消息的发送(0)接收(1)区分
                chatDetail.is_recieved = MSG_IO_FLG_SEND;
                //消息类型-文本
                chatDetail.msg_type = MSG_TYPE_TEXT;
                // 消息状态：发送，已读，未读，失败等
                chatDetail.msg_state = MSG_SENDING;
                // 消息内容
                chatDetail.msg_content = text;
                // 文件名（语音，图片，涂鸦）
                chatDetail.msg_file = @"";
                // 原始图片文件的HTTP-URL地址
                chatDetail.pic_url_thumb = @"";
                chatDetail.pic_url_original = @"";
                chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
                
                [chatDetail updateToDB];
                
                ChatListObject *chatList = [self saveMsgToChatList:chatDetail userName:[sendMsgUserName objectAtIndex:i]];
                
                [Utilities showProcessingHud:self.view];//2015.05.12
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 耗时的操作
                    NSString *sendFlag = [FRNetPoolUtils sendMsg:chatDetail];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [Utilities dismissProcessingHud:self.view];//2015.05.12
                        if ([[sendFlag substringToIndex:3] isEqualToString:@"YES"]) {
                            // 发送成功
                            chatDetail.msg_state = MSG_SEND_SUCCESS;
                            chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                            [chatDetail updateToDB];
                            
                            
                            //[MobClick event:Report_SendTextMessage];
                            //[ReportObject event:Report_Event_NO_SendTextMessage];
                        } else {
                            // 发送失败
                            chatDetail.msg_state = MSG_SEND_FAIL;
                            chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                            [chatDetail updateToDB];
                            //[(ChatDetailObject *)[chatDetailArray lastObject] setMsg_state:MSG_SEND_FAIL];
                            
                            /*if (![sendFlag isEqualToString:@"NO"]) { // 发送失败，被乘客端屏蔽
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                             message:sendFlag
                             delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil,nil];
                             [alertView show];
                             }*/
                        }
                        
                        chatList.msg_state = chatDetail.msg_state;
                        chatList.timestamp = chatDetail.timestamp;
                        [chatList updateToDB];
                    });
                });
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    }
}

- (ChatListObject *)saveMsgToChatList:(ChatDetailObject *)chatDetail userName:(NSString *)sendUserName
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    if ([@"firstPage" isEqualToString:_fromName]) {
        [self performSelector:@selector(doGetFriendAll) withObject:nil afterDelay:0.1];
    }else{
        NSString  *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
        if ([schoolType isEqualToString:@"bureau"]) {//教育局
            [self performSelector:@selector(doGetPeople) withObject:nil afterDelay:0.1];
        }else{
            [self performSelector:@selector(doGetFriendAll) withObject:nil afterDelay:0.1];
        }
    }
    
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	
	[super setEditing:!self.editing animated:YES];
    [self->_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

-(void)doGetFriendAll
{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"friend", @"ac",
                          friendType, @"op",
                          classid, @"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendGet andData:data];
}

//---add by kate 2015.05.05------------------------------------
-(void)doGetPeople
{
    
    if ([_flag isEqualToString:@"下属单位"] || [_flag isEqualToString:@"本单位"]){
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            /**
             * 教育局本单位成员列表
             * @author luke
             * @date 2015.05.05
             * @args
             *  ac=Friend, v=2, op=department, sid=, uid=, cid=
             */
            /**
             * 教育局下属单位成员列表
             * @author luke
             * @date 2015.05.05
             * @args
             *  ac=Friend,v=2, op=subordinate, sid=, uid=, cid=
             */
            
            NSString *op = @"department";
            if ([_flag isEqualToString:@"下属单位"]) {
                op = @"subordinate";
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Friend", @"ac",
                                      op, @"op",
                                      @"1",@"v",
                                      classid, @"cid",
                                      nil];
                
                NSLog(@"data:%@",data);
                [network sendHttpReq:HttpReq_PeopleGet andData:data];

            }else {
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Contact", @"ac",
                                      @"members", @"op",
                                      @"2",@"v",
                                      _gid, @"gid",
                                      nil];
                
                NSLog(@"data:%@",data);
                
                [network sendHttpReq:HttpReq_PeopleGet andData:data];

            }
            
        
        
    }else{
        
        if ([@"friend" isEqualToString:friendType]) {//add 2015.06.18
            
            [self doGetFriendAll];
            
        }
    }
    
    
}
//----------------------------------------------------------------

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listDataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((p1 == indexPath.row) || (p2 == indexPath.row) || (p3 == indexPath.row) || (p4 == indexPath.row)) {
        return 35;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";

//    FriendMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
//    if(cell == nil) {
//        cell = [[FriendMultiSelectTableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:CellTableIdentifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    
//    NSUInteger row = [indexPath row];
//    NSDictionary* list_dic = [listDataArray objectAtIndex:row];
//    
//    NSString* name= [list_dic objectForKey:@"name"];
//    //    NSString* pic= [list_dic objectForKey:@"avatar"];
//    
//    cell.name = name;
//    cell.uid = [list_dic objectForKey:@"uid"];
//    cell.spacenote = @"这家伙很懒，什么都没有留下。";
//    NSString *testrow =[NSString stringWithFormat:@"%d",row];
//    
//    cell.cellIndex = [NSString stringWithFormat:@"%d",row];
//    
//    return cell;

#if 1
    NSUInteger row1 = [indexPath row];
    if ((p1 == row1) || (p2 == row1) || (p3 == row1) || (p4 == row1)) {
        FriendMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
        if(cell == nil) {
            cell = [[FriendMultiSelectTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        NSUInteger row = [indexPath row];
        NSDictionary* list_dic = [listDataArray objectAtIndex:row];
        
        NSString* name= [list_dic objectForKey:@"name"];
        //    NSString* pic= [list_dic objectForKey:@"avatar"];
        
        cell.name = name;
        cell.uid = [list_dic objectForKey:@"uid"];
        //NSLog(@"uid:%@",uid);
        cell.cellIndex = [NSString stringWithFormat:@"%lu",(unsigned long)row];
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.imageView.hidden = YES;
        cell.m_checkImageView.frame = CGRectMake(251, (35-30)/2, 30, 30);
        cell.label_name.frame = CGRectMake(
                                           15,
                                           (35-20)/2,
                                           100,
                                           20);
        cell.label_name.font = [UIFont systemFontOfSize:13.0f];
        
        cell.label_comment.hidden = NO;

        NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
        BOOL isCheck;
        if (isSelect) {
            isCheck = YES;
        } else {
            isCheck = NO;
        }
        [cell setChecked:isCheck];

        return cell;

    } else {
        FriendMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[FriendMultiSelectTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        NSUInteger row = [indexPath row];
        NSDictionary* list_dic = [listDataArray objectAtIndex:row];
        
        NSString* name= [list_dic objectForKey:@"name"];
        NSString* pic= [list_dic objectForKey:@"avatar"];
        
        cell.name = name;
        cell.uid = [list_dic objectForKey:@"uid"];
        // NSLog(@"uid:%@",uid);
        cell.cellIndex = [NSString stringWithFormat:@"%lu",(unsigned long)row];
        [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

        NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
        BOOL isCheck;
        if (isSelect) {
            isCheck = YES;
        } else {
            isCheck = NO;
        }
        [cell setChecked:isCheck];

        return cell;
    }
#endif
    
//    FriendMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
//
//    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* list_dic = [listDataArray objectAtIndex:indexPath.row];
    
    NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
    BOOL isCheck;
    if (isSelect) {
        isCheck = YES;
    } else {
        isCheck = NO;
    }
    
    if ([friendType  isEqual: @"requests"]) {
        // nothing
    } else if ([friendType  isEqual: @"classmate"]) {
        if (p1 == indexPath.row) {
            for (int i=p1; i<p2; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [[listDataArray objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
            
            [cell setChecked:!isCheck];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        if ((indexPath.row > p1) &&(indexPath.row < p2)) {
            BOOL isAllSelect = YES;
            for (int i=p1+1; i<p2; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p1 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
        
    } else if ([friendType  isEqual: @"teacher"]) {
        if (p2 == indexPath.row) {
            for (int i=p2; i<p3; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [[listDataArray objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
            
            [cell setChecked:!isCheck];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        if ((indexPath.row > p2) &&(indexPath.row < p3)) {
            BOOL isAllSelect = YES;
            for (int i=p2+1; i<p3; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p2 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
    } else if ([friendType  isEqual: @"parent"]) {
        if (p3 == indexPath.row) {
            for (int i=p3; i<p4; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [[listDataArray objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
            
            [cell setChecked:!isCheck];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        if ((indexPath.row > p3) &&(indexPath.row < p4)) {
            BOOL isAllSelect = YES;
            for (int i=p3+1; i<p4; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p3 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
    }  else if ([friendType  isEqual: @"friend"]) {
        if (p4 == indexPath.row) {
            for (int i=p4; i<p5; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [[listDataArray objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
            
            [cell setChecked:!isCheck];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        if ((indexPath.row > p4) &&(indexPath.row < p5)) {
            BOOL isAllSelect = YES;
            for (int i=p4+1; i<p5; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p4 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
    } else if ([friendType  isEqual: @"all"]){
        // 当用户选择组名字进行全部选择的时候。
        if (p1 == indexPath.row) {
            for (int i=p1; i<p2; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else if (p2 == indexPath.row) {
            for (int i=p2; i<p3; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else if (p3 == indexPath.row) {
            for (int i=p3; i<p4; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else if (p4 == indexPath.row) {
            for (int i=p4; i<[listDataArray count]; i++) {
                [[listDataArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                
                FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
                [cell setChecked:!isCheck];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [[listDataArray objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"isChecked"];
            
            [cell setChecked:!isCheck];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        // 确保在组里面的每一项都选择的情况下，组名字需要被选上，
        // 或者当全选状态下，有某个组成员被取消选择，组名字也要取消选择。
        if ((indexPath.row > p1) &&(indexPath.row < p2)) {
            BOOL isAllSelect = YES;
            for (int i=p1+1; i<p2; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p1 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
        
        if ((indexPath.row > p2) &&(indexPath.row < p3)) {
            BOOL isAllSelect = YES;
            for (int i=p2+1; i<p3; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p2 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
        
        if ((indexPath.row > p3) &&(indexPath.row < p4)) {
            BOOL isAllSelect = YES;
            for (int i=p3+1; i<p4; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p3 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
        
        if ((indexPath.row > p4) && (indexPath.row < [listDataArray count])) {
            BOOL isAllSelect = YES;
            for (int i=p4+1; i<[listDataArray count]; i++) {
                NSMutableDictionary* list_dic = [listDataArray objectAtIndex:i];
                NSInteger isSelect = ((NSString *)[list_dic objectForKey:@"isChecked"]).integerValue;
                if (0 == isSelect) {
                    isAllSelect = NO;
                }
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:p4 inSection:0];
            FriendMultiSelectTableViewCell *cell = (FriendMultiSelectTableViewCell*)[tableView cellForRowAtIndexPath:index];
            
            if (isAllSelect) {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"isChecked"];
                [cell setChecked:1];
            } else {
                [[listDataArray objectAtIndex:p1] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"isChecked"];
                [cell setChecked:0];
            }
        }
    }
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
        NSDictionary *temp = [resultJSON objectForKey:@"message"];
        
        listDataArray = [self doListDataPrepare:temp];
        [self doShowTableview];
        
        
    }
    else
    {
       
        [Utilities dismissProcessingHud:self.view];//2015.05.12
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取信息错误，请重试"
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

-(void)doShowTableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (NSString *)replaceNull:(NSString *)source
{
    NSString *result = [NSString stringWithFormat:@"%@", source];
    if (result != nil && (NSNull *)result != [NSNull null]) {
        if ([result isEqualToString:@"<null>"]) {
            return @"";
        } else if ([result isEqualToString:@"(null)"]) {
            return @"";
        } else {
            return result;
        }
    } else {
        return @"";
    }
}

-(NSMutableArray*)doListDataPrepare:(NSDictionary *)data
{
    NSMutableArray* dataArray;
    dataArray =[[NSMutableArray alloc] init];
    
    NSArray *classmatesList;
    NSString *isNull;
    
    // 取出同学列表
    if ([friendType  isEqual: @"classmate"]) {
        classmatesList = (NSArray *)data;
    } else if ([friendType  isEqual: @"all"]){
        classmatesList = [data objectForKey:@"classmates"];
        isNull = [self replaceNull:[data objectForKey:@"classmates"]];
    }
    
    if (![@""  isEqual: isNull]) {
        if (0 != [classmatesList count]) {
            NSMutableDictionary *a1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"我的同学",@"name",
                                       @"0",@"uid",nil];;
            p1 = 0;
            
            [dataArray addObject:a1];
            
            for (NSObject *object in classmatesList)
            {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [(NSDictionary *)object objectForKey:@"name"],@"name",
                                             [(NSDictionary *)object objectForKey:@"uid"],@"uid",
                                             [(NSDictionary *)object objectForKey:@"avatar"],@"avatar",
                                             @"0",@"isChecked",nil];;
                
                [dataArray addObject:temp];
            }
            p2 = p1 + [dataArray count];
        }
    } else {
        p2 = p1 + 1;
    }
    
    // 取出老师列表
    NSArray *teachersList;
    
    if ([friendType  isEqual: @"teacher"]) {
        teachersList = (NSArray *)data;
    } else if ([friendType  isEqual: @"all"]){
        teachersList = [data objectForKey:@"teachers"];
        isNull = [self replaceNull:[data objectForKey:@"teachers"]];
    }

    if (![@""  isEqual: isNull]) {
        if (0 != [teachersList count]) {
            NSMutableDictionary *a2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"老师",@"name",
                                       @"0",@"uid",nil];;
            [dataArray addObject:a2];
            for (NSObject *object in teachersList)
            {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [(NSDictionary *)object objectForKey:@"name"],@"name",
                                             [(NSDictionary *)object objectForKey:@"uid"],@"uid",
                                             [(NSDictionary *)object objectForKey:@"avatar"],@"avatar",
                                             @"0",@"isChecked",nil];;
                
                [dataArray addObject:temp];
            }
            p3 = p2 + [teachersList count] + 1;
        }
    } else {
        p3 = p2 + 1;
    }

    // 取出家长列表
    NSArray *parentsList;
    
    if ([friendType  isEqual: @"parent"]) {
        parentsList = (NSArray *)data;
    } else if ([friendType  isEqual: @"all"]){
        parentsList = [data objectForKey:@"parents"];
        isNull = [self replaceNull:[data objectForKey:@"parents"]];
    }

    if (![@""  isEqual: isNull]) {
        if (0 != [parentsList count]) {
            NSMutableDictionary *a3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"家长",@"name",
                                       @"0",@"uid",nil];;
            [dataArray addObject:a3];
            for (NSObject *object in parentsList)
            {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [(NSDictionary *)object objectForKey:@"name"],@"name",
                                             [(NSDictionary *)object objectForKey:@"uid"],@"uid",
                                             [(NSDictionary *)object objectForKey:@"avatar"],@"avatar",
                                             @"0",@"isChecked",nil];;
                
                [dataArray addObject:temp];
            }
            p4 = p3 + [parentsList count] + 1;
        }
    } else {
        p4 = p3 + 1;
    }

    // 取出朋友列表
    NSArray *friendsList;
    
    if ([friendType  isEqual: @"friend"]) {
        friendsList = (NSArray *)data;
    } else if ([friendType  isEqual: @"all"]){
        friendsList = [data objectForKey:@"friends"];
        isNull = [self replaceNull:[data objectForKey:@"friends"]];
    }

    if (![@""  isEqual: isNull]) {
        if (0 != [friendsList count]) {
            //-----add by kate 2015.05.07----------------------------------------------------------
            NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
            NSString *headTitle = @"好友";
            
            if ([@"firstPage" isEqualToString:_fromName]) {
            
            }else{
                
                if ([@"bureau" isEqualToString:schoolType]) {
                    
                    if ([_flag isEqualToString:@"下属单位"] || [_flag isEqualToString:@"本单位"]){
                        
                        headTitle = _flag;
                        
                    }else{
                        if ([@"friend" isEqualToString:friendType]){
                            
                        }else{
                            headTitle = _flag;
                        }
                    }
                    
                   
                }
            }
            //---------------------------------------------------------------------------------------
            NSMutableDictionary *a4 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:headTitle,@"name",
                                       @"0",@"uid",nil];;
            [dataArray addObject:a4];
            for (NSObject *object in friendsList)
            {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [(NSDictionary *)object objectForKey:@"name"],@"name",
                                             [(NSDictionary *)object objectForKey:@"uid"],@"uid",
                                             [(NSDictionary *)object objectForKey:@"avatar"],@"avatar",
                                             @"0",@"isChecked",nil];;
                
                [dataArray addObject:temp];
            }
            p5 = p4 + [friendsList count] + 1;
        }
    } else {
        p5 = p4 + 1;
    }


//    for (int i=0; i<50; i++) {
//        Item *item = [[Item alloc] init];
//        item.title = [NSString stringWithFormat:@"%d",i];
//        item.isChecked = NO;
//        [_items addObject:item];
//        [item release];
//    }

    return dataArray;
}


//- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData uid:(NSString*)userID
//{
//    // 取得msgID
//    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
//    
//    NSString *thumbImageDir = [Utilities getChatPicThumbDir:[userID longLongValue]];
//    NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
//    NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
//    
//    
//    // 创建聊天缩略图片，并写入本地
//    if ([fileData writeToFile:thumbImagePath atomically:YES]) {
//        NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
//    }
//    
//    return thumbImagePath;//update by kate 2015.03.27
//}
- (NSString *)saveThumbPicToLocal:(long long)msgid imageData:(NSData*)fileData uid:(NSString*)userID
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
- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData uid:(NSString*)userID
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

@end
