//
//  GroupChatDetail.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatDetailObject.h"
#import "DBDao.h"
#import "Utilities.h"
#import "PublicConstant.h"

@interface GroupChatDetailObject (PRIVATE)

/*
 * 判断是否有该条记录
 */
- (BOOL)isExistInDB;

/*
 * DB中插入数据
 */
- (BOOL)insertData;

/*
 * DB中更新数据
 */
- (BOOL)updateData;

@end

@implementation GroupChatDetailObject

// BD表中的行
@synthesize msginfo_id;
// 消息ID
@synthesize msg_id;
// user_id
@synthesize user_id;
// 消息的发送(0)接收(1)区分
@synthesize is_recieved;
// 消息类型 1:文本消息(UTF-8)（文字） 2:图片消息 3:系统消息，邀请，创建, 4:移除 5:解散
@synthesize msg_type;
// 消息状态：发送，已读，未读，失败等
@synthesize msg_state;
// 消息内容
@synthesize msg_content;
// 图片文件名
@synthesize msg_file;
// 原始图片文件的HTTP-URL地址，获取缩略图片时使用
@synthesize pic_url_thumb;
// 原始图片文件的HTTP-URL地址，获取原始大图片时使用
@synthesize pic_url_original;
// 时间戳
@synthesize timestamp;
//是否需要在time label标签里显示时间
@synthesize showTimeLabel;

@synthesize audio_url;// 语音的url

// 班级id
@synthesize cid;

// 群id
@synthesize groupid;

// 他人头像url
@synthesize headimgurl;

@synthesize audioSecond;

@synthesize userName;

@synthesize reflashFlag;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (GroupChatDetailObject *)init
{
    if (self = [super init]) {
        // 消息ID
        msg_id = 0;
        // user_id
        user_id = 0;
        // 消息的发送(0)接收(1)区分
        is_recieved = MSG_IO_FLG_SEND;
        // 消息类型 1:文本消息(UTF-8)（文字） 2:图片消息 3:系统消息，邀请，创建, 4:移除 5:解散
        msg_type = 1;
        // 消息状态：发送，已读，未读，失败等
        msg_state = 0;
        // 消息内容
        msg_content = @"";
        // 图片文件名
        msg_file = @"";
        // 原始图片文件的HTTP-URL地址，获取原始大图片时使用
        pic_url_thumb = @"";
        // 原始图片文件的HTTP-URL地址，获取原始大图片时使用
        pic_url_original = @"";
        // 时间戳
        timestamp = 0;
        //是否需要在time label标签里显示时间
        showTimeLabel = YES;
        
        // 语音的url
        audio_url = @"";
        
        audioSecond = 0;
        
        userName = @"";
    }
    return self;
}


#pragma mark -
#pragma mark DB相关方法

/*
 * 更新到数据库
 */
- (BOOL)updateToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (user_id == 0) {
        return NO;
    }
    
    BOOL ret = YES;
    // 判断服务器是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateData];
    }else {
        ret = [self insertData];
    }
    
    return ret;
}

/*
 * 判断是否有该条记录
 */
- (BOOL)isExistInDB
{
    //目前判断表有问题，暂时每次进来都模拟创建表，然后再进行检索
    //    if (![[DBDao getDaoInstance] isTableExist:[NSString stringWithFormat:@"msgInfo_%lli", user_id]]) {
    //        [[DBDao getDaoInstance] createmsgInfoTable:user_id];
    //        return NO;
    //    }
    [[DBDao getDaoInstance] createMsgInfoForGroupTable:groupid];
    
//    NSLog(@"groupid:%lli",self.groupid);
//    NSLog(@"msg_id:%lli",self.msg_id);
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli where msg_id = %lli", self.groupid, self.msg_id];
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    self.msg_content = [self sqliteEscape:self.msg_content];
    //insert语句以后要像下边那么些insert or ignore 过滤重复数据 意思是如果遇见重复的就ignore 或者 insert or replace 如果重复就更新 前提是建表时要有UNIQUE
    NSString *sql = [NSString stringWithFormat:@"insert or ignore into msgInfoForGroup_%lli (msg_id, user_id, is_recieved, msg_type, msg_state, msg_content, msg_file, pic_url_thumb, pic_url_original, timestamp, audio_url, headimgurl, userName, audioSecond ) values (%lli, %lli, %ld, %ld, %ld, '%@', '%@', '%@', '%@', %lli, '%@', '%@', '%@' , %li)",
                     self.groupid,
                     self.msg_id,
                     self.user_id,
                     (long)self.is_recieved,
                     (long)self.msg_type,
                     (long)self.msg_state,
                     self.msg_content,
                     self.msg_file,
                     self.pic_url_thumb,
                     self.pic_url_original,
                     self.timestamp,
                     self.audio_url,
                     self.headimgurl,
                     self.userName,
                     self.audioSecond
                     ];
    
    NSLog(@"sql:%@",sql);
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    NSString *sql = [NSString stringWithFormat:@"update msgInfoForGroup_%lli set msg_state = %ld, timestamp = %lli where msg_id = %lli",
                     self.groupid,
                     (long)self.msg_state,
                     self.timestamp,
                     self.msg_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    
    return ret;
}

/// 更新语音未读已读状态
- (BOOL)updateAudioState
{
    NSString *sql = [NSString stringWithFormat:@"update msgInfoForGroup_%lli set msg_state_audio = %ld, timestamp = %lli where msg_id = %lli",
                     self.groupid,
                     (long)self.msg_state_audio,
                     self.timestamp,
                     self.msg_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/// 更新语音时长
-(BOOL)updateAudio{
    
    NSString *sql = [NSString stringWithFormat:@"update msgInfoForGroup_%lli set audioSecond = %li where msg_id = %lli",
                     self.groupid,
                     (long)self.audioSecond,
                     self.msg_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
//    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    return keyWord;
}

@end
