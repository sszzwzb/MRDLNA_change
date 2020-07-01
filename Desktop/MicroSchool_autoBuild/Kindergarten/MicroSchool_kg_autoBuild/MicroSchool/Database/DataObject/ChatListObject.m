//
//  ChatListObject.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "ChatListObject.h"
#import "DBDao.h"
#import "Utilities.h"
#import <Foundation/Foundation.h>

@interface ChatListObject (PRIVATE)

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


@implementation ChatListObject

// 聊天ID
@synthesize msglist_id;
// 聊天表名
@synthesize msg_table_name;
// 消息的发送(0)接收(1)区分
@synthesize is_recieved;
//最后一条消息ID
@synthesize last_msg_id;
// 聊天的最后一条消息的类型
@synthesize last_msg_type;
// 聊天的最后一条消息内容
@synthesize last_msg;
//该条消息是否已经读取
@synthesize msg_state;
// 对方的user_id
@synthesize user_id;
// 聊天标题
@synthesize title;
//聊天的最后一条消息的时间戳
@synthesize timestamp;


#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (ChatListObject *)init
{
    if (self = [super init]) {
        // 聊天表名
        msg_table_name = @"";
        // 最后一条消息ID
        last_msg_id = 0;
        // 消息的发送(0)接收(1)区分
        is_recieved = 0;
        // 聊天的最后一条消息的类型
        last_msg_type = 0;
        // 聊天的最后一条消息内容
        last_msg = @"";
        // 聊天的最后一条消息是否已读
        msg_state = 0;
        // 对方的user_id
        user_id = 0;
        // 聊天标题,对方的昵称
        title = @"";
        // 聊天的最后一条消息的时间戳
        timestamp = 0;
    }
    return self;
}

/*
 * 析构
 */
- (void)dealloc
{
    self.msg_table_name = nil;
    self.last_msg = nil;
    self.title = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark DB相关方法

/// <summary>
/// 更新变更到数据库
/// </summary>
- (BOOL)updateToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (user_id == 0) {
        return NO;
    }
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateData];
    } else {
        ret = [self insertData];
    }
    
    [self updateLastMsg];
    //返回
    return ret;
}

/// <summary>
/// 判断是否有该条记录
/// </summary>
- (BOOL)isExistInDB
{
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgList where user_id = %lli",
                     self.user_id];
    
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

/// <summary>
/// 插入数据到DB
/// </summary>
- (BOOL)insertData
{
    self.last_msg = [self sqliteEscape:self.last_msg];
    
    NSString *sql = [NSString stringWithFormat:@"insert into msgList (msg_table_name, is_recieved, last_msg_id, last_msg_type, last_msg, msg_state, user_id, title, timestamp) values ('%@', %d, %lli, %d, '%@', %d, %lli, '%@', %lli)",
                     self.msg_table_name,
                     self.is_recieved,
                     self.last_msg_id,
                     self.last_msg_type,
                     self.last_msg,
                     self.msg_state,
                     self.user_id,
                     self.title,
                     self.timestamp];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/// <summary>
/// 更新数据到DB
/// </summary>
- (BOOL)updateData
{
    
    NSString *sql = [NSString stringWithFormat:@"update msgList set is_recieved = %d, last_msg_id = %lli, last_msg_type = %d, last_msg = '%@', msg_state = %d, title = '%@', timestamp = %lli where user_id = %lli",
                     self.is_recieved,
                     self.last_msg_id,
                     self.last_msg_type,
                     self.last_msg,
                     self.msg_state,
                     self.title,
                     self.timestamp,
                     self.user_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

-(void)updateLastMsg{
    
    //NSString *sqlLast = [NSString stringWithFormat:@"select a.last_msg from msgInfoMix_%lli_%lli a inner join (select max(last_msg_id) as lid from msgInfoMix_%lli_%lli) b on a.last_msg_id = b.lid",self.gid,self.user_id,self.gid,self.user_id];
    NSString *sqlLast = [NSString stringWithFormat:@"select msg_content from msgInfo_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d",self.user_id, 0, 1];
    NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sqlLast];
    NSMutableDictionary *chatObjectDict = [retDictionary objectForKey:[NSNumber numberWithInt:0]];
    NSLog(@"chatObjectDict:%@",chatObjectDict);
    NSString *last = [chatObjectDict objectForKey:@"msg_content"];
    
    NSString *sql = [NSString stringWithFormat:@"update msgList set last_msg = '%@' where user_id = %lli",
                     last,
                     self.user_id
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    NSLog(@"ret:%d",ret);
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
