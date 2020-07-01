//
//  ReportDBDao.m
//  MincroSchool
//
//  Created by Kate on 14-3-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ReportDBDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "DBTableCreate.h"
#import "PublicConstant.h"
#import "Utilities.h"
#import "ReportObject.h"

#pragma mark -
#pragma mark ReportDBDao实例变量
//业务库实例
static ReportDBDao *gDaoInstance = nil;

@implementation ReportDBDao

#pragma mark -
#pragma mark 属性
@synthesize dbFile = _dbFile;                               //数据库文件
@synthesize dbQueue;                                        //数据dbQueue，多线程用

#pragma mark -
#pragma mark 数据库实例
+ (ReportDBDao *)getDaoInstance
{
    @synchronized(self)
    {
        if (gDaoInstance == nil) {
			gDaoInstance = [[ReportDBDao alloc] init];
            //初始化数据库名字
            [gDaoInstance genDBPath:[NSString stringWithFormat:@"Report.db"]];
        }
        //创建所有基本表
        BOOL isSuccess = [gDaoInstance CreateTable];
    }
    return gDaoInstance;
}

/*
 * 释放当前DB
 */
- (void)releaseDB
{
    [gDaoInstance release];
    gDaoInstance = nil;
}

- (void)dealloc
{
    if (_dbFile) {
        [_dbFile release];
    }
    
    self.dbQueue = nil;

    [super dealloc];
}

/*
 * 拼接成数据库文件名
 */
- (void)genDBPath:(NSString *)DBName
{
    self.dbFile = [[Utilities SystemDir] stringByAppendingPathComponent:DBName];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbFile];
}

/*
 * 创建业务数据库表结构
 */
- (BOOL)CreateTable
{
    //创建上报表
    NSString *reportSql = [DBTableCreate getReportSql];
    return [self executeSql:reportSql];
}

#pragma mark -
#pragma mark 数据库插入更新操作

/*
 * 操作一条SQL，并加事务处理
 */
- (BOOL)executeSql:(NSString *)sql
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) 
     {
         ret = [db executeUpdate:sql];
         if (!ret) {
             //操作失败，回滚所有操作
             *rollback = YES;
         }
     }];  
    
    return ret;
}

/*
 * 操作一条SQL，并加事务处理,不发送消息给画面
 */
- (BOOL)executeSqlNoPostNotification:(NSString *)sql
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         ret = [db executeUpdate:sql];
         if (!ret) {
             //操作失败，回滚所有操作
             *rollback = YES;
         }
     }];
    
    return ret;
}


#pragma mark -
#pragma mark 数据库查询操作
/*
 * 取得查询结果，返回值为数据字典，key为字段名
 * 数据结构：<row <columnName value>>
 */
- (NSMutableDictionary *)getDictionaryResultsByColumnName:(NSString *)sql
{
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        
        int row = 0;
        while ([retArrData next]) 
        {
            NSMutableDictionary *dictrow = [NSMutableDictionary dictionaryWithCapacity:1];
            int columnCount = [retArrData columnCount];
            
            int columnIdx = 0;
            
            for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
                
                NSString *columnName = [retArrData columnNameForIndex:columnIdx];
                id objectValue = [retArrData objectForColumnIndex:columnIdx];
                [dictrow setObject:objectValue forKey:columnName];
            }
            [dict setObject:dictrow forKey:[NSNumber numberWithInt:row]];
            row = row +1;
        }
    }];
    
    return dict;
}

/*
 * 取得查询结果，返回值为数据字典，key为字段所在的列数
 * 数据结构：<row <columnIndex value>>
 */
- (NSMutableDictionary *)getDictionaryResultsByColumnIdx:(NSString *)sql
{
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
       
        int row = 0;
        while ([retArrData next]) 
        {
            NSMutableDictionary *dictrow = [NSMutableDictionary dictionaryWithCapacity:1];
            int columnCount = [retArrData columnCount];
            
            int columnIdx = 0;
            
            for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
                
                id objectValue = [retArrData objectForColumnIndex:columnIdx];
                [dictrow setObject:objectValue forKey:[NSNumber numberWithInt:columnIdx]];
            }
            [dict setObject:dictrow forKey:[NSNumber numberWithInt:row]];
            row = row +1;
        }
    }];
    
    return dict;
}

/*
 * 从本地数据库加载用户列表数据
 */
- (NSMutableArray *)getAllData
{
    NSString *sql = @"select * from report";
    NSMutableDictionary *reportDict = [self getDictionaryResultsByColumnName:sql];
    NSMutableArray *reportArr = [[NSMutableArray alloc] init];
    int cnt = [reportDict.allKeys count];
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        NSMutableDictionary *reportObjectDict = [reportDict objectForKey:[NSNumber numberWithInt:listCnt]];
        
        ReportObject *report = [[ReportObject alloc] init];
        report.timestamp = [Utilities replaceNull:[reportObjectDict objectForKey:@"timestamp"]];
        report.eventNo = [Utilities replaceNull:[reportObjectDict objectForKey:@"eventNo"]];
        report.newsModuleName = [Utilities replaceNull:[reportObjectDict objectForKey:@"newsModuleName"]];
        report.longitude = [Utilities replaceNull:[reportObjectDict objectForKey:@"longitude"]];
        report.latitude = [Utilities replaceNull:[reportObjectDict objectForKey:@"latitude"]];
        [reportArr addObject:report];
        [report release];
    }
    
    return [reportArr autorelease];
}

/*
 * 删除所有数据
 */
- (BOOL)deleteAllData
{
    NSString *reportSql = @"delete from report";
    return [self executeSql:reportSql];
}

@end
