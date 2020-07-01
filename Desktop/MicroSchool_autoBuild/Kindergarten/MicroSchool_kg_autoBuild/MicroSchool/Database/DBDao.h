//
//  DBDao.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@class FMDatabaseQueue;
@class FMResultSet;


@interface DBDao : NSObject
{
    NSString *_dbFile;                                    //数据库文件
    BOOL _isPostNotification;                             //控制是否发回调消息
    long long _user_id;
}

@property (nonatomic, retain) NSString *dbFile;           //数据库文件
@property (nonatomic, retain) FMDatabaseQueue *dbQueue;   //数据库操作类
@property (nonatomic, assign) BOOL isPostNotification;    //控制是否发回调消息
@property (nonatomic, retain) FMDatabase *db;

#pragma mark -
#pragma mark 数据库实例
//业务库实例
+ (DBDao *)getDaoInstance;

#pragma mark -
#pragma mark 数据库初始化
//通过user_id初始化数据库
- (void)initDB:(long long)user_id;

//释放DB资源
- (void)releaseDB;

#pragma mark -
#pragma mark 数据库插入更新操作
//执行多条SQL，并加事务处理
- (BOOL)executeSqls:(NSMutableArray *)sqls;

//操作一条SQL，并加事务处理
- (BOOL)executeSql:(NSString *)sql;

//执行多条SQL，并加事务处理,不发送消息给画面
- (BOOL)executeSqlsNoPostNotification:(NSMutableArray *)sqls;

//操作一条SQL，并加事务处理,不发送消息给画面
- (BOOL)executeSqlNoPostNotification:(NSString *)sql;

//更新数据用？传值方法
- (BOOL)executeUpdate:(NSString *)sql indata:(NSMutableArray *)data;
- (BOOL)executeUpdateSqls:(NSMutableArray *)sqls indata:(NSMutableArray *)data;

//更新数据用？传值方法
- (BOOL)executeUpdateNoPostNotification:(NSString *)sql indata:(NSMutableArray *)data;

#pragma mark -
#pragma mark 数据库查询操作
//取得查询结果，返回值为数据字典，key为字段名  数据结构：<row <columnName value>>
- (NSMutableDictionary *)getDictionaryResultsByColumnName:(NSString *)sql;

//取得查询结果，返回值为数据字典，key为字段所在的列数  数据结构：<row <columnIndex value>>
- (NSMutableDictionary *)getDictionaryResultsByColumnIdx:(NSString *)sql;

//取得查询结果，返回值为string类型，保证一条数据的情况下使用该方法
- (NSString *)getResultsToString:(NSString *)sql;

//取得查询结果，返回值为NSDate类型，保证一条数据的情况下使用该方法
- (NSDate *)getResultsToDate:(NSString *)sql;

//取得查询结果，返回值为NSData类型，保证一条数据的情况下使用该方法
- (NSData *)getResultsToData:(NSString *)sql;

//取得查询结果，返回值为longLong类型，保证一条数据的情况下使用该方法
- (long long)getResultsTolongLongInt:(NSString *)sql;

//取得查询结果，返回值为int类型，保证一条数据的情况下使用该方法
- (int)getResultsToInt:(NSString *)sql;

//取得查询结果，返回值为long类型，保证一条数据的情况下使用该方法
- (int)getResultsTolong:(NSString *)sql;

#pragma mark -
#pragma mark 创建表操作

//创建数据库表结构
- (BOOL)CreateTable;

//创建msgInfo表,需要传uuid作为表名的一部分
- (BOOL)createmsgInfoTable:(long long)user_id;

//---add by kate 2015.05.26----------------------------
// 创建MsgListForGroup表 群聊聊天记录表
- (BOOL)createMsgListForGroupTable:(long long)cid;

// 创建MsgInfoForGroup表 群聊详情表
- (BOOL)createMsgInfoForGroupTable:(long long)groupId;
//-----------------------------------------------------
- (BOOL)createMsgInfoMixTable:(long long)groupId userId:(long long)userId;
// 聊天记录表
- (BOOL)CreateMixListTable;

// 字段是否存在
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName;
@end
