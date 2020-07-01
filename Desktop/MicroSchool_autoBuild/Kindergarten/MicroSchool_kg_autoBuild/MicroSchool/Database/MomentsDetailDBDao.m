//
//  MomentsDetailDBDao.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MomentsDetailDBDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "DBTableCreate.h"
#import "PublicConstant.h"
#import "Utilities.h"
#import "ReportObject.h"


#pragma mark -
#pragma mark NewsListDBDao实例变量
//业务库实例
static MomentsDetailDBDao *gDaoInstance = nil;
@implementation MomentsDetailDBDao

#pragma mark -
#pragma mark 属性
@synthesize dbFile = _dbFile;                               //数据库文件
@synthesize dbQueue;

#pragma mark -
#pragma mark 数据库实例
+ (MomentsDetailDBDao *)getDaoInstance
{
    @synchronized(self)
    {
        if (gDaoInstance == nil) {
            gDaoInstance = [[MomentsDetailDBDao alloc] init];
            //初始化数据库名字
            [gDaoInstance genDBPath:[NSString stringWithFormat:@"MomentsList.db"]];
        }
        //创建所有基本表
        [gDaoInstance CreateTable];
    }
    return gDaoInstance;
}

/*
 * 释放当前DB
 */
- (void)releaseDB
{
    //    [gDaoInstance release];
    gDaoInstance = nil;
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
    NSString *reportSql = [DBTableCreate getMomentsDetailSql];
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
 * 操作一条SQL，并加事务处理
 */
- (BOOL)executeSql:(NSString *)sql mId:(NSString*)momentId momentType:(NSString*)momentType jsonStr:(NSString*)jsonStr page:(NSString*)page
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         ret = [db executeUpdate:sql,momentId,momentType,jsonStr,page];
         if (!ret) {
             //操作失败，回滚所有操作
             *rollback = YES;
         }
     }];
    
    return ret;
}

//更新数据用？传值方法
- (BOOL)executeUpdate:(NSString *)sql indata:(NSMutableArray *)data
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         ret = [db executeUpdate:sql withArgumentsInArray:data];
         if (!ret) {
             //操作失败，回滚所有操作
             *rollback = YES;
         } else {
             //如果操作成功，返回消息给主画面，通知画面更新数据
             if (_isPostNotification) {
                 NSMutableArray *arrSql = [NSMutableArray arrayWithObjects:sql, nil];
                 [self performSelectorOnMainThread:@selector(postNotification:) withObject:arrSql waitUntilDone:NO];
             }
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

-(NSDictionary*)getData:(NSString*)type page:(NSString*)page momentID:(NSString*)momentID{
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"select * from momentsDetail_table_%@ where momentType = '%@' and page = '%@' and momentId = '%@'", [userInfo objectForKey:@"uid"],type, page,momentID];
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    NSMutableDictionary *retDic = [dict objectForKey:[NSNumber numberWithInt:0]];
    NSString *jsonStr = [retDic objectForKey:@"jsonStr"];
    
    NSDictionary *dic = nil;
    if ([jsonStr length] > 0) {
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
    }
    
    return dic;
}

/*
 * 删除所有数据
 */
- (BOOL)deleteAllData:(NSString*)type momentID:(NSString*)momentID
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *reportSql = [NSString stringWithFormat:@"delete from momentsDetail_table_%@ where momentType = '%@' and momentId = '%@'", [userInfo objectForKey:@"uid"],type,momentID];
    return [self executeSql:reportSql];
}

- (int)getResultsToInt:(NSString *)sql
{
    __block int ret = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = ([retArrData objectForColumnIndex:0]== [NSNull null])?0:[retArrData intForColumnIndex:0];
        }
    }];
    return ret;
}

- (BOOL)deleteDBFile
{
    NSString *dbFilePath = [[Utilities SystemDir] stringByAppendingPathComponent:@"MomentsList.db"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = dbFilePath;
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        bRet = [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    return bRet;
}


@end
