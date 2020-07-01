//
//  DBTableCreate.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "DBTableCreate.h"

@implementation DBTableCreate

#pragma mark -
#pragma mark 基本表创建SQL文


/*
 * User表创建SQL文
 */
+ (NSString *)getCreateUserSql {
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     @" create table if not exists user (",
                     @" userinfo_id	        integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" user_id             integer,",
                     @" user_type           integer,",
                     @" name                nvarchar(100) COLLATE NOCASE,",
                     @" nickname            nvarchar(100) COLLATE NOCASE,",
                     @" introduction        nvarchar(500) COLLATE NOCASE,",
                     @" phone               nvarchar(100) COLLATE NOCASE,",
                     @" headimgurl          nvarchar(200) COLLATE NOCASE,",
                     @" houses_id           integer,",
                     @" houses_name         nvarchar(100) COLLATE NOCASE,",
                     @" customer_quantity   integer,",
                     @" star                integer,",
                     @" star1               nvarchar(20) COLLATE NOCASE,",
                     @" star2               nvarchar(20) COLLATE NOCASE,",
                     @" star3               nvarchar(20) COLLATE NOCASE,",
                     @" my_mark_star1       integer,",
                     @" my_mark_star2       integer,",
                     @" my_mark_star3       integer,",
                     @" markStarStatus      integer,",
                     @" status              integer,",
                     @" register_date       integer,",
                     @" serviceType         integer",
                     @")"];
    return sql;
}

/*
 * MsgList表创建SQL文
 */
+ (NSString *)getCreateMsgListSql {
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",
                     @" create table if not exists msgList (",
                     @" msglist_id		    integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_table_name		nvarchar(50) COLLATE NOCASE,",
                     @" is_recieved		    integer,",
                     @" last_msg_id		    integer,",
                     @" last_msg_type		integer,",
                     @" last_msg		    nvarchar(2000) COLLATE NOCASE,",
                     @" msg_state		    integer,",
                     @" user_id		        integer,",
                     @" title		        nvarchar(100) COLLATE NOCASE,",
                     @" timestamp		    integer",
                     @")"];
    
    return sql;
}

/*
 * MsgInfo表创建SQL文
 */
+ (NSString *)getCreateMsgInfoSql:(long long)user_id {
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists msgInfo_%lli (",user_id],
                     @" msginfo_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_id              integer,",
                     @" user_id             integer,",
                     @" is_recieved         integer,",
                     @" msg_type            integer,",
                     @" msg_state           integer,",
                     @" msg_content         nvarchar(2000) COLLATE NOCASE,",
                     @" msg_file            nvarchar(100) COLLATE NOCASE,",
                     @" pic_url_thumb       nvarchar(200) COLLATE NOCASE,",
                     @" pic_url_original    nvarchar(200) COLLATE NOCASE,",
                     @" timestamp           integer,",
                     @" audioSecond         integer,",
                     @" audio_url           nvarchar(200) COLLATE NOCASE,",
                     @" msg_state_audio     integer",
                     @")"];

    return sql;
}

//---add by kate 2015.05.26-------------------------------------------------------------------------------------
/*
 * MsgListForGroup表 For 群聊 创建SQL文
 */
+ (NSString *)getCreateMsgListForGroupSql:(long long)cid {
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists msgListForGroup_%lli (",cid],
                     @" msglist_id		    integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_table_name		nvarchar(50) COLLATE NOCASE,",
                     @" is_recieved		    integer,",
                     @" last_msg_id		    integer,",
                     @" last_msg_type		integer,",
                     @" last_msg		    nvarchar(2000) COLLATE NOCASE,",
                     @" msg_state		    integer,",
                     @" user_id		        integer,",
                     @" title		        nvarchar(500) COLLATE NOCASE,",
                     @" timestamp		    integer,",
                     @" gid		            integer,",
                     @" uid                 integer,",
                     @" cid                 integer,",
                     @" bother              integer",
                     @")"];
    
    return sql;
}

/*
 * MsgInfoForGroup表 For 群聊 创建SQL文
 */
+ (NSString *)getCreateMsgInfoForGroupSql:(long long)groupId {
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists msgInfoForGroup_%lli (",groupId],
                     @" msginfo_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_id              integer,",
                     @" user_id             integer,",
                     @" is_recieved         integer,",
                     @" msg_type            integer,",
                     @" msg_state           integer,",
                     @" msg_content         nvarchar(2000) COLLATE NOCASE,",
                     @" msg_file            nvarchar(100) COLLATE NOCASE,",
                     @" pic_url_thumb       nvarchar(200) COLLATE NOCASE,",
                     @" pic_url_original    nvarchar(200) COLLATE NOCASE,",
                     @" timestamp           integer,",
                     @" audio_url           nvarchar(200) COLLATE NOCASE,",
                     @" audioSecond         integer,",
                     @" userName            nvarchar(200) COLLATE NOCASE,",
                     @" headimgurl          nvarchar(200) COLLATE NOCASE,",
                     @" msg_state_audio     integer,",
                     @" UNIQUE(msg_id)"
                     @")"];
    NSLog(@"sql:%@",sql);
    return sql;
}

/*
 * MsgInfoForGroup表 For 群聊 创建SQL文 //2015.07.21
 */
+ (NSString *)getCreateMsgInfoForGroupForOldVSql:(long long)groupId {
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table msgInfoForGroup_%lli (",groupId],
                     @" msginfo_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_id              integer,",
                     @" user_id             integer,",
                     @" is_recieved         integer,",
                     @" msg_type            integer,",
                     @" msg_state           integer,",
                     @" msg_content         nvarchar(2000) COLLATE NOCASE,",
                     @" msg_file            nvarchar(100) COLLATE NOCASE,",
                     @" pic_url_thumb       nvarchar(200) COLLATE NOCASE,",
                     @" pic_url_original    nvarchar(200) COLLATE NOCASE,",
                     @" timestamp           integer,",
                     @" audio_url           nvarchar(200) COLLATE NOCASE,",
                     @" audioSecond         interger,",
                     @" userName            nvarchar(200) COLLATE NOCASE,",
                     @" headimgurl          nvarchar(200) COLLATE NOCASE",
                     @")"];
    
    return sql;
}


+(NSString*)dropTable:(NSString*)tableName{
    
    NSString *sql = [NSString stringWithFormat:@"%@",
                     [NSString stringWithFormat:@"drop table %@",tableName]];
    
    return sql;

}
/*
 * MsgGroupListForHeadImgSql 群聊头像 SQL文
 */
+ (NSString *)getCreateMsgGroupListForHeadImgSql{
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                     @" create table if not exists msgGroupListForHeadImg (",
                     @" msgGrouplist_id		integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" name		        nvarchar(200) COLLATE NOCASE,",
                     @" headUrl		        nvarchar(2000) COLLATE NOCASE,",
                     @" user_id		        integer,",
                     @" gid		            integer,",
                     @" uid                 integer"
                     @")"];
    
    return sql;
}
//-----------------------------------------------------------------------------------------------------------------

//---add by kate 2016.01.18-----------------------------------------------------------------------------------------
/*
 * MsgListMix表 创建SQL文 2016.01.18
 */
+ (NSString *)getCreateMsgListMixSql{
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     @" create table if not exists msgListMix (",
                     @" msglist_id		    integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_table_name		nvarchar(50) COLLATE NOCASE,",
                     @" is_recieved		    integer,",
                     @" last_msg_id		    integer,",
                     @" last_msg_type		integer,",
                     @" last_msg		    nvarchar(2000) COLLATE NOCASE,",
                     @" msg_state		    integer,",
                     @" at_state            integer,",
                     @" user_id		        integer,",
                     @" title		        nvarchar(500) COLLATE NOCASE,",
                     @" timestamp		    integer,",
                     @" gid		            integer,",
                     @" uid                 integer,",
                     @" cid                 integer,",
                     @" bother              integer",
                     @")"];
    
    return sql;
}

/*
 * MsgInfoMix表 创建SQL文 2016.01.18
 */
+ (NSString *)getCreateMsgInfoMixSql:(long long)groupId userId:(long long)userId {
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists msgInfoMix_%lli_%lli (",groupId,userId],
                     @" msginfo_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" msg_id              integer,",
                     @" user_id             integer,",
                     @" is_recieved         integer,",
                     @" msg_type            integer,",
                     @" msg_state           integer,",
                     @" at_state            integer,",
                     @" msg_content         nvarchar(2000) COLLATE NOCASE,",
                     @" msg_file            nvarchar(100) COLLATE NOCASE,",
                     @" pic_url_thumb       nvarchar(200) COLLATE NOCASE,",
                     @" pic_url_original    nvarchar(200) COLLATE NOCASE,",
                     @" timestamp           integer,",
                     @" audio_url           nvarchar(200) COLLATE NOCASE,",
                     @" audioSecond         integer,",
                     @" userName            nvarchar(200) COLLATE NOCASE,",
                     @" headimgurl          nvarchar(200) COLLATE NOCASE,",
                     @" msg_state_audio     integer,",
                     @" audio_r_status      INT DEFAULT(0),",
                     @" UNIQUE(msg_id)"
                     @")"];
    
    return sql;
}
//-------------------------------------------------------------------------------------------------------------------

/*
 * Report表创建SQL文
 */
+ (NSString *)getReportSql
{
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                     @" create table if not exists report (",
                     @" report_rowid        integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" newsModuleName      nvarchar(200) COLLATE NOCASE,",
                     @" timestamp           nvarchar(30) COLLATE NOCASE,",
                     @" eventNo             nvarchar(10) COLLATE NOCASE,",
                     @" longitude           nvarchar(30) COLLATE NOCASE,",
                     @" latitude            nvarchar(30) COLLATE NOCASE",
                     @")"];
    
    return sql;
}

/*
 * NewsList表创建SQL文
 */
+ (NSString *)getNewsListSql
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists newsList_table_%@ (",[userInfo objectForKey:@"uid"]],
                     @" news_rowid          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" newsid              nvarchar(200) COLLATE NOCASE,",
                     @" newsType            nvarchar(200) COLLATE NOCASE,",
                     @" title               nvarchar(200) COLLATE NOCASE,",
                     @" dateline            nvarchar(200) COLLATE NOCASE,",
                     @" pic                 nvarchar(200) COLLATE NOCASE,",
                     @" updatetime          nvarchar(200) COLLATE NOCASE,",
                     @" stick               nvarchar(200) COLLATE NOCASE,",
                     @" digest              nvarchar(200) COLLATE NOCASE,",
                     @" smessage            nvarchar(200) COLLATE NOCASE,",
                     @" viewnum             nvarchar(200) COLLATE NOCASE,",
                     @" iscomment           nvarchar(200) COLLATE NOCASE",
                     @")"];
    
    return sql;
}



/*
 * NewsDetail表创建SQL文
 */
+ (NSString *)getNewsDetailSql
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists newsDetail_table_%@ (",[userInfo objectForKey:@"uid"]],
                     @" news_rowid          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" newsid              nvarchar(200) COLLATE NOCASE,",
                     @" title               nvarchar(200) COLLATE NOCASE,",
                     @" updatetime          nvarchar(200) COLLATE NOCASE,",
                     @" message             nvarchar(20000) COLLATE NOCASE,",
                     @" pics                nvarchar(20000) COLLATE NOCASE,",
                     @" iscomment           nvarchar(20000) COLLATE NOCASE,",
                     @" name                nvarchar(200) COLLATE NOCASE,",
                     @" viewnum             nvarchar(200) COLLATE NOCASE",
                     @")"];
    
    return sql;
}


/*
 * MomentsList表创建SQL文
 */
+ (NSString *)getMomentsListSql
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists momentsList_table_%@ (",[userInfo objectForKey:@"uid"]],
                     @" moments_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" momentId            nvarchar(200) COLLATE NOCASE,",
                     @" momentType          nvarchar(200) COLLATE NOCASE,",
                     @" page                nvarchar(200) COLLATE NOCASE,",
                     @" jsonStr             TEXT COLLATE NOCASE",
                     @")"];
    
    NSLog(@"sql:%@",sql);
    
    return sql;
}

/*
 * MomentsDetail表创建SQL文
 */
+ (NSString *)getMomentsDetailSql
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists momentsDetail_table_%@ (",[userInfo objectForKey:@"uid"]],
                     @" moments_id          integer PRIMARY KEY AUTOINCREMENT NOT NULL,",
                     @" momentId            nvarchar(200) COLLATE NOCASE,",
                     @" momentType          nvarchar(200) COLLATE NOCASE,",
                     @" page                nvarchar(200) COLLATE NOCASE,",
                     @" jsonStr             TEXT COLLATE NOCASE",
                     @")"];
    
    NSLog(@"sql:%@",sql);
    
    return sql;
}

+ (NSString *)getReadStatusSql {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@%@",
                     [NSString stringWithFormat:@" create table if not exists readStatus_table_%@ (",[userInfo objectForKey:@"uid"]],
                     @" readId          nvarchar(200) COLLATE NOCASE,",
                     @" status          nvarchar(200) COLLATE NOCASE",
                     @")"];
    
    NSLog(@"sql:%@",sql);
    
    return sql;
}

@end
