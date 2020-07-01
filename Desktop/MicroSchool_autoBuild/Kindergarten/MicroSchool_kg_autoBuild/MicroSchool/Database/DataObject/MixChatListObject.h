//
//  MixChatListObject.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/19.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixChatListObject : NSObject{
    
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
    // 是否有人@我
    NSInteger at_state;
    // 自己的user_id
    long long user_id;//接收消息的userid
    // 聊天标题,群聊名称
    NSString *title;
    // 聊天的最后一条消息的时间戳
    long long timestamp;
    
    //cid
    long long cid;
    
    NSString *mid;//后台返回的消息最后一条消息id
    
    long long gid;
    
    long long uid;//自己的uid
    
    NSInteger bother;//是否设置免打扰
   
    
    NSDictionary *userInfo;

    long long stick;//置顶时间戳 2017.01.18 教育局
   
    
   
    
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
// 聊天的最后一条消息的类型 0:文本消息(UTF-8)（文字） 1:图片消息 2：语音 3:系统消息，邀请，创建, 4:移除 5:解散
@property (nonatomic, assign) NSInteger last_msg_type;
// 聊天的最后一条消息内容
@property (nonatomic, retain) NSString *last_msg;
// 是否有人@我
@property (nonatomic, assign) NSInteger at_state;
// 该条消息是否已读
@property (nonatomic, assign) NSInteger msg_state;
// 自己的user_id
@property (nonatomic, assign) long long user_id;//群聊列表里这个值貌似木有用，可以变成自己的userid 2015.05.26
// 聊天标题,对方的昵称
@property (nonatomic, retain) NSString *title;
// 聊天的最后一条消息的时间戳
@property (nonatomic, assign) long long timestamp;
//后台返回的消息最后一条消息id
@property (nonatomic, retain) NSString *mid;
// 班级id
@property(nonatomic,assign) long long cid;

// gid
@property(nonatomic,assign) long long gid;

@property(nonatomic,assign) NSInteger bother;//消息免打扰

@property(nonatomic,assign) long long stick;//置顶时间戳 2017.01.18 教育局



/// 学校名称
@property (nonatomic,strong) NSString *schoolName;
/// 学校id
@property (nonatomic,assign) long long schoolID;

#pragma mark -
#pragma mark DB相关方法

- (BOOL)updateToDB;
// 群聊名字
- (BOOL)updateGroupName;
// 消息免打扰
-(BOOL)noBother;
// 更新列表at显示
- (BOOL)updateAtState;
// 是否存在
- (BOOL)isExistInDB;

// 是否置顶
-(BOOL)isStick;
// 置顶/取消置顶
- (BOOL)updateStick;

@end
