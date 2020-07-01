//
//  ReportDBDao.h
//  ShenMaPassenger
//
//  Created by Kate on 14-3-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@class FMResultSet;

@interface ReportDBDao : NSObject
{
    NSString *_dbFile;                                    //数据库文件
}

@property (nonatomic, retain) NSString *dbFile;           //数据库文件
@property (nonatomic, retain) FMDatabaseQueue *dbQueue;   //数据库操作类

#pragma mark -
#pragma mark 数据库实例
// 业务库实例
+ (ReportDBDao *)getDaoInstance;

// 释放DB资源
- (void)releaseDB;

// 创建数据库表结构
- (BOOL)CreateTable;

#pragma mark -
#pragma mark 数据库插入更新操作
// 操作一条SQL，并加事务处理
- (BOOL)executeSql:(NSString *)sql;

#pragma mark -
#pragma mark 数据库查询操作
// 取得查询结果，返回值为数据字典，key为字段名  数据结构：<row <columnName value>>
- (NSMutableDictionary *)getDictionaryResultsByColumnName:(NSString *)sql;

// 取得查询结果，返回值为数据字典，key为字段所在的列数  数据结构：<row <columnIndex value>>
- (NSMutableDictionary *)getDictionaryResultsByColumnIdx:(NSString *)sql;

// 从本地数据库加载用户列表数据
- (NSMutableArray *)getAllData;

// 删除所有数据
- (BOOL)deleteAllData;
- (BOOL)executeSqlNoPostNotification:(NSString *)sql;

@end
