//
//  EnterMultiMsgViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-11.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "EnterMultiMsgViewController.h"
#import "ChatListObject.h"
#import "ChatDetailObject.h"
#import "PublicConstant.h"
#import "FRNetPoolUtils.h"
#import "Toast+UIView.h"

@interface EnterMultiMsgViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textV;

@end

@implementation EnterMultiMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"输入消息内容"];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"发送"];
    [_textV becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    [_textV resignFirstResponder];
    
    if ([_textV.text length] == 0) {
        
        [Utilities showAlert:@"提示" message:@"请输入消息内容" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }else{
        
        [ReportObject event:ID_SEND_LIST_MESSAGE];//2015.06.25
        
        NSString *text = _textV.text;
        
        // 多人发送，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportGPStype:DataReport_Act_PhoneBook_MultiSendMsg];
        
        for (int i=0; i<[_sendMsgUids count]; i++) {
            
            ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
            // 消息的msgID
            chatDetail.msg_id = [Utilities GetMsgId];
            chatDetail.user_id = [[_sendMsgUids objectAtIndex:i] longLongValue];
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
            
            ChatListObject *chatList = [self saveMsgToChatList:chatDetail userName:[_sendMsgUserName objectAtIndex:i]];
            if (HUD == nil) {
//                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                HUD.labelText = @"发送中...";
                [Utilities showProcessingHud:self.view];//2015.05.12
                
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                NSString *sendFlag = [FRNetPoolUtils sendMsg:chatDetail];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[HUD hide:YES];
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
                        
                        /*if (![sendFlag isEqualToString:@"NO"]) { // 发送失败
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
                    
                    if (i == ([_sendMsgUids count]-1)) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
 
                    }
                    
                    
                });
            });
        }
       

        
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



@end
