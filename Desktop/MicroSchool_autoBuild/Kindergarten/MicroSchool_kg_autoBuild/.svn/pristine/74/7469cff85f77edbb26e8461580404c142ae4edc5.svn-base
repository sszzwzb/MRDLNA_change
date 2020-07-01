//
//  NewsDBDao.m
//  MicroSchool
//
//  Created by jojo on 14-9-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "NewsListDBDao.h"
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
static NewsListDBDao *gDaoInstance = nil;

@implementation NewsListDBDao

#pragma mark -
#pragma mark 属性
@synthesize dbFile = _dbFile;                               //数据库文件
@synthesize dbQueue;                                        //数据dbQueue，多线程用

#pragma mark -
#pragma mark 数据库实例
+ (NewsListDBDao *)getDaoInstance
{
    @synchronized(self)
    {
        if (gDaoInstance == nil) {
			gDaoInstance = [[NewsListDBDao alloc] init];
            //初始化数据库名字
            [gDaoInstance genDBPath:[NSString stringWithFormat:@"NewsList.db"]];
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

- (void)dealloc
{
    if (_dbFile) {
//        [_dbFile release];
    }
    
    self.dbQueue = nil;
    
//    [super dealloc];
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
    NSString *reportSql = [DBTableCreate getNewsListSql];
    BOOL ret = [self executeSql:reportSql];
    return ret;
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
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

    NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ n ORDER BY n.stick DESC,  n.dateline DESC, n.updatetime DESC LIMIT 0,2", [userInfo objectForKey:@"uid"]];
    
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    int cnt = [dict.allKeys count];
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        NSMutableDictionary *dic = [dict objectForKey:[NSNumber numberWithInt:listCnt]];
        
        [dataArr addObject:dic];
    }
    
    return dataArr;
//    return [reportArr autorelease];
}



/*
 * 从本地数据库按服务器顺序加载用户列表数据
 */
- (NSMutableArray *)getDataType:(NSString *)type andPage:(NSString *)page andSize:(NSString *)size
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ n WHERE newsType = '%@' ORDER BY n.stick DESC, n.dateline DESC, n.updatetime DESC LIMIT %@,%@", [userInfo objectForKey:@"uid"], type, page, size];
    
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    int cnt = [dict.allKeys count];
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        NSMutableDictionary *dic = [dict objectForKey:[NSNumber numberWithInt:listCnt]];
        
        [dataArr addObject:dic];
    }
    
    return dataArr;
}


/*
 * 从本地数据库加载用户列表数据 add by kate
 */
- (NSString *)getAllDataNOOrder:(NSString*)type
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    //NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ where newsType = '%@' order by dateline DESC LIMIT 1", [userInfo objectForKey:@"uid"],type];
    NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ where newsType = '%@' order by newsid DESC LIMIT 1", [userInfo objectForKey:@"uid"],type];
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    NSMutableDictionary *retDic = [dict objectForKey:[NSNumber numberWithInt:0]];
    NSString *newsid =  [retDic objectForKey:@"newsid"];
    return newsid;
    
}

- (NSMutableDictionary *)getDataFromNewsId:(NSString *)newsid
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ where newsid = %@", [userInfo objectForKey:@"uid"], newsid];
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    
    NSMutableDictionary *retDic = [dict objectForKey:[NSNumber numberWithInt:0]];
    //    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    //    int cnt = [dict.allKeys count];
    //    for (int listCnt = 0; listCnt < cnt; listCnt++) {
    //        NSMutableDictionary *dic = [dict objectForKey:[NSNumber numberWithInt:listCnt]];
    //
    //        [dataArr addObject:dic];
    //    }
    
    return retDic;
    //    return [reportArr autorelease];
}

- (NSString *)getLastTimeFromNews:(NSString *)type
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    NSString *sql = [NSString stringWithFormat:@"select * from newsList_table_%@ n WHERE newsType = '%@' order by updatetime DESC limit 1", [userInfo objectForKey:@"uid"], type];
    
    NSMutableDictionary *dict = [self getDictionaryResultsByColumnName:sql];
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    int cnt = [dict.allKeys count];
    
    NSString *lastTime;
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        NSMutableDictionary *dic = [dict objectForKey:[NSNumber numberWithInt:listCnt]];
        
        lastTime = [dic objectForKey:@"updatetime"];
        
        [dataArr addObject:dic];
    }
    
    return lastTime;
}

/*
 * 删除所有数据
 */
- (BOOL)deleteAllData
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

    NSString *reportSql = [NSString stringWithFormat:@"delete from newsList_table_%@", [userInfo objectForKey:@"uid"]];
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
    NSString *dbFilePath = [[Utilities SystemDir] stringByAppendingPathComponent:@"NewsList.db"];
    
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
