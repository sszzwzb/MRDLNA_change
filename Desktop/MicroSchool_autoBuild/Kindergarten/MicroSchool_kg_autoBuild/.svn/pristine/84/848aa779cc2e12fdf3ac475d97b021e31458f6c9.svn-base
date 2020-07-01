//
//  ChatListObject.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListObject : NSObject
{
    // DB表中的行
    NSInteger msglist_id;
    // 聊天表名
    NSString *msg_table_name;
    // 消息的发送(0)接收(1)区分
    NSInteger is_recieved;
    // 最后一条消息ID
    long long last_msg_id;
    // 聊天的最后一条消息的类型
    NSInteger last_msg_type;
    // 聊天的最后一条消息内容
    NSString *last_msg;
    // 聊天的最后一条消息是否已读
    NSInteger msg_state;
    // 对方的user_id
    long long user_id;
    // 聊天标题,对方的昵称
    NSString *title;
    // 聊天的最后一条消息的时间戳
    long long timestamp;
    
    NSString *mid;//后台返回的消息最后一条消息id //add 2015.01.26
}

#pragma mark -
#pragma mark 属性

// DB表中的行
@property (nonatomic, assign) NSInteger msglist_id;
// 聊天表名
@property (nonatomic, retain) NSString *msg_table_name;
// 消息的发送(0)接收(1)区分
@property (nonatomic, assign) NSInteger is_recieved;
// 最后一条消息ID
@property (nonatomic, assign) long long last_msg_id;
// 聊天的最后一条消息的类型
@property (nonatomic, assign) NSInteger last_msg_type;
// 聊天的最后一条消息内容
@property (nonatomic, retain) NSString *last_msg;
// 该条消息是否已读
@property (nonatomic, assign) NSInteger msg_state;
// 对方的user_id
@property (nonatomic, assign) long long user_id;
// 聊天标题,对方的昵称
@property (nonatomic, retain) NSString *title;
// 聊天的最后一条消息的时间戳
@property (nonatomic, assign) long long timestamp;
//后台返回的消息最后一条消息id
@property (nonatomic, retain) NSString *mid;//add 2015.01.26


#pragma mark -
#pragma mark DB相关方法

- (BOOL)updateToDB;

@end
