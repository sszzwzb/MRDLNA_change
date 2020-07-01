//
//  ChatDetailObject.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "ChatDetailObject.h"
#import "DBDao.h"
#import "Utilities.h"
#import "PublicConstant.h"

@interface ChatDetailObject (PRIVATE)

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

@implementation ChatDetailObject

// BD表中的行
@synthesize msginfo_id;
// 消息ID
@synthesize msg_id;
// user_id
@synthesize user_id;
// 消息的发送(0)接收(1)区分
@synthesize is_recieved;
// 消息类型 1:文本消息(UTF-8)（文字） 2:图片消息
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

@synthesize audioSecond;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (ChatDetailObject *)init
{
    if (self = [super init]) {
        // 消息ID
        msg_id = 0;
        // user_id
        user_id = 0;
        // 消息的发送(0)接收(1)区分
        is_recieved = MSG_IO_FLG_SEND;
        // 消息类型 1:文本消息(UTF-8)（文字） 2:图片消息
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
    }
    return self;
}

/*
 * 析构
 */
- (void)dealloc
{
    [msg_content release];
    [msg_file release];
    [pic_url_thumb release];
    [pic_url_original release];
    
    [super dealloc];
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
    
    //创建表，如果表存在就跳过不创建
    //[[DBDao getDaoInstance] createmsgInfoTable:user_id];
    
    BOOL ret = YES;
    // 判断服务器是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateData];
    } else {
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
    [[DBDao getDaoInstance] createmsgInfoTable:user_id];
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfo_%lli where msg_id = %lli", user_id, self.msg_id];
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    //NSLog(@"self.msg_content:%@",self.msg_content);
    
   self.msg_content = [self sqliteEscape:self.msg_content];
    
    // NSLog(@"sqliteEscapeStr:%@",self.msg_content);
    
    NSString *sql = [NSString stringWithFormat:@"insert into msgInfo_%lli (msg_id, user_id, is_recieved, msg_type, msg_state, msg_content, msg_file, pic_url_thumb, pic_url_original, timestamp, audio_url, audioSecond) values (%lli, %lli, %d, %d, %d, '%@', '%@', '%@', '%@', %lli, '%@', %li)",
                     self.user_id,
                     self.msg_id,
                     self.user_id,
                     self.is_recieved,
                     self.msg_type,
                     self.msg_state,
                     self.msg_content,
                     self.msg_file,
                     self.pic_url_thumb,
                     self.pic_url_original,
                     self.timestamp,
                     self.audio_url,
                     self.audioSecond
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    NSString *sql = [NSString stringWithFormat:@"update msgInfo_%lli set msg_state = %ld, timestamp = %lli where msg_id = %lli",
                     self.user_id,
                     (long)self.msg_state,
                     self.timestamp,
                     self.msg_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/// 更新语音未读已读状态
-(BOOL)updateAudioState{
    
    //msg_state_audio
    NSString *sql = [NSString stringWithFormat:@"update msgInfo_%lli set msg_state_audio = %ld, timestamp = %lli where msg_id = %lli",
                     self.user_id,
                     (long)self.msg_state_audio,
                     self.timestamp,
                     self.msg_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/// 更新语音时长
-(BOOL)updateAudio{
    
    NSString *sql = [NSString stringWithFormat:@"update msgInfo_%lli set audioSecond = %li where msg_id = %lli",
                     self.user_id,
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
