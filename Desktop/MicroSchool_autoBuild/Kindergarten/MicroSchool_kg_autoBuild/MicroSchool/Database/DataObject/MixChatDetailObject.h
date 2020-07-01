//
//  MixChatDetailObject.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/18.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixChatDetailObject : NSObject{
    
    long long uid;//自己的uid 2017.02.28
    
    // DB表中的行
    NSInteger msginfo_id;
    // 消息ID
    long long msg_id;
    // user_id
    long long user_id;
    // 消息的发送(0)接收(1)区分
    NSInteger is_recieved;
    // 消息类型 0:文本消息(UTF-8)（文字） 1:图片消息 2：语音 3:系统消息，邀请，创建, 4:移除 5:解散
    NSInteger msg_type;
    // 消息状态：发送，已读，未读，失败等
    NSInteger msg_state;
    // 消息内容
    NSString *msg_content;
    // 图片文件名
    NSString *msg_file;
    // 原始图片文件的HTTP-URL地址，获取缩略图片时使用
    NSString *pic_url_thumb;
    // 原始图片文件的HTTP-URL地址，获取原始大图片时使用
    NSString *pic_url_original;
    // 时间戳
    long long timestamp;
    
    //是否需要在time label标签里显示时间
    BOOL showTimeLabel;
    
    NSString *audio_url;// 语音的url
    
    long long cid;//班级id
    
    long long groupid;// 群id
    
    NSString *headimgurl;// 他人头像url
    
    /// 语音时长
    NSInteger audioSecond;
    
    ///发送者名字
    NSString *userName;
    
    /// 学校名称
    NSString *schoolName;
    /// 学校id
    long long schoolID;

}

#pragma mark -
#pragma mark 属性
// DB表中的行
@property (nonatomic, assign) NSInteger msginfo_id;
// 消息ID
@property (nonatomic, assign) long long msg_id;
// user_id
@property (nonatomic, assign) long long user_id;
// 消息的发送(0)接收(1)区分
@property (nonatomic, assign) NSInteger is_recieved;
// 消息类型 1:文本消息(UTF-8)（文字） 2:图片消息 3:系统消息，邀请，创建, 4:移除 5:解散
@property (nonatomic, assign) NSInteger msg_type;
// 消息状态：发送1，已读2，未读3，失败4等
@property (nonatomic, assign) NSInteger msg_state;
// 是否有人@我
@property (nonatomic, assign) NSInteger at_state;
// 消息内容
@property (nonatomic, retain) NSString *msg_content;
// 图片文件名
@property (nonatomic, retain) NSString *msg_file;
// 原始图片文件的HTTP-URL地址，获取缩略图片时使用
@property (nonatomic, retain) NSString *pic_url_thumb;
// 原始图片文件的HTTP-URL地址，获取原始大图片时使用
@property (nonatomic, retain) NSString *pic_url_original;
// 时间戳
@property (nonatomic, assign) long long timestamp;

//是否需要在time label标签里显示时间
@property (nonatomic, assign) BOOL showTimeLabel;

@property (nonatomic, retain) NSString *audio_url;// 语音的url

@property (nonatomic,assign) long long cid;// 班级id

@property (nonatomic,assign) long long groupid;// 群id

@property (nonatomic,strong) NSString *headimgurl;//他人头像url

///语音时长
@property (nonatomic, assign) NSInteger audioSecond;

/// 接收语音状态 0 未接收 1 已接收 2 失败
@property (nonatomic, assign) NSInteger audio_r_status;

///发送者名字
@property (nonatomic, strong) NSString *userName;

@property (nonatomic,assign) float labelHeight;//add 2015.08.01
@property (nonatomic,assign) CGSize size;//add 2015.08.01

@property (nonatomic, assign) NSInteger msg_state_audio;//语音红点显示

// cell是否需要刷新的标志位
@property (nonatomic,strong) NSString *reflashFlag;

/// 学校名称
@property (nonatomic,strong) NSString *schoolName;

/// 学校id
@property (nonatomic,assign) long long schoolID;

/// 自己的uid
@property (nonatomic,assign) long long uid;

#pragma mark -
#pragma mark DB相关方法

-(BOOL)updateToDB;

///更新语音时长
-(BOOL)updateAudio;

- (BOOL)insertData;
///更新语音已读未读状态
-(BOOL)updateAudioState;
//更新接收语音状态
-(BOOL)updateRAudioState;
@end
