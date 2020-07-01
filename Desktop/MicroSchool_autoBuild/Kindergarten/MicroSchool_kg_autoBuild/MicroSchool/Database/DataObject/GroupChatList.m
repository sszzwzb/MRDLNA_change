//
//  GroupChatList.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatList.h"
#import "DBDao.h"
#import "Utilities.h"
#import <Foundation/Foundation.h>

@interface GroupChatList (PRIVATE)

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

@implementation GroupChatList

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
//班级id
@synthesize cid;
// 最后一条消息id 
@synthesize mid;
//群id
@synthesize gid;
//免打扰标实
@synthesize bother;


#pragma mark -
#pragma mark 构造方法

/*
 * 构造
 */
- (GroupChatList *)init
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
        // 消息免打扰
        bother = 0;
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        uid = [[userInfo objectForKey:@"uid"] longLongValue];
    }
    return self;
}


#pragma mark -
#pragma mark DB相关方法

/// <summary>
/// 更新变更到数据库
/// </summary>
- (BOOL)updateToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (uid == 0) {
        return NO;
    }
    
    [[DBDao getDaoInstance] createMsgListForGroupTable:cid];
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    ret = [self isExistInDB];
    if (ret) {
        [self updateData];
    } else {
        [self insertData];
    }
    
    //返回
    return ret;
}

/// <summary>
/// 判断是否有该条记录
/// </summary>
- (BOOL)isExistInDB
{
    [[DBDao getDaoInstance] createmsgInfoTable:cid];
    
    NSLog(@"self.gid:%lli",self.gid);
    NSLog(@"uid:%lli",uid);
    NSLog(@"self.cid:%lli",self.cid);
    
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgListForGroup_%lli where uid = %lli and gid = %lli",self.cid,uid,self.gid];
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
    //NSLog(@"uid:%lld",uid);
    self.last_msg = [self sqliteEscape:self.last_msg];

    NSString *sql = [NSString stringWithFormat:@"insert into msgListForGroup_%lli (msg_table_name, is_recieved, last_msg_id, last_msg_type, last_msg, msg_state, uid, title, timestamp, gid, user_id, cid, bother) values ('%@', %ld, %lli, %ld, '%@', %ld, %lli, '%@', %lli, %lli, %lli, %lli, %ld)",
                     self.cid,
                     self.msg_table_name,
                     (long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     uid,
                     self.title,
                     self.timestamp,
                     self.gid,
                     self.user_id,
                     self.cid,
                     (long)self.bother
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/// <summary>
/// 更新数据到DB
/// </summary>
- (BOOL)updateData
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    NSLog(@"self.cid:%lli",self.cid);
    
    NSString *sql = [NSString stringWithFormat:@"update msgListForGroup_%lli set is_recieved = %ld, last_msg_id = %lli, last_msg_type = %ld, last_msg = '%@', msg_state = %ld, timestamp = %lli where uid = %lli and gid = %lli",
                     self.cid,
                     (long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     self.timestamp,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

// 更新群名字
- (BOOL)updateGroupName
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    NSLog(@"uid:%lld",uid);
    NSLog(@"title:%@",self.title);
    
    NSString *sql = [NSString stringWithFormat:@"update msgListForGroup_%lli set title = '%@' where uid = %lli and gid = %lli",
                     self.cid,
                     self.title,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

// 消息免打扰
-(BOOL)noBother{
    
    NSString *sql = [NSString stringWithFormat:@"update msgListForGroup_%lli set bother = %ld where uid = %lli and gid = %lli",
                     self.cid,
                     (long)self.bother,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
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
