//
//  DBTableCreate.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalSingletonUserInfo.h"

@interface DBTableCreate : NSObject
{
}


#pragma mark -
#pragma mark 表创建SQL文

// User表创建SQL文
+ (NSString *)getCreateUserSql;

// MsgList表创建SQL文
+ (NSString *)getCreateMsgListSql;

// MsgInfo表创建SQL文
+ (NSString *)getCreateMsgInfoSql:(long long)user_id;

// Report表创建SQL文
+ (NSString *)getReportSql;

// 新闻列表模块创建
+ (NSString *)getNewsListSql;

// 新闻详细模块创建
+ (NSString *)getNewsDetailSql;

// MomentsList表创建SQL文
+ (NSString *)getMomentsListSql;

//MomentsDetail表创建SQL文
+ (NSString *)getMomentsDetailSql;

// MsgListForGroup表创建SQL文
+ (NSString *)getCreateMsgListForGroupSql:(long long)cid;

// MsgInfoForGroup表创建SQL文
+ (NSString *)getCreateMsgInfoForGroupSql:(long long)groupId;

// MsgInfoForGroup表创建SQL文为兼容老版本
+ (NSString *)getCreateMsgInfoForGroupForOldVSql:(long long)groupId;

// MsgGroupListForHeadImgSql 群聊头像 SQL文
+ (NSString *)getCreateMsgGroupListForHeadImgSql;

// 阅读状态 SQL文
+ (NSString *)getReadStatusSql;

+(NSString*)dropTable:(NSString*)tableName;

//MsgListMix表 创建SQL文 2016.01.18
+ (NSString *)getCreateMsgListMixSql;
//MsgInfoMix表 创建SQL文 2016.01.18
+ (NSString *)getCreateMsgInfoMixSql:(long long)groupId userId:(long long)userId;

@end
