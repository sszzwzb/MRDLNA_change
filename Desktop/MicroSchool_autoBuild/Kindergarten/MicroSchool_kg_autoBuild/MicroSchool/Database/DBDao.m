//
//  DBDao.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "DBDao.h"

#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "DBTableCreate.h"
#import "PublicConstant.h"
#import "Utilities.h"
#import "GroupChatDetailObject.h"
#import "FMDatabaseAdditions.h"
#import "MixChatDetailObject.h"
#import "MixChatListObject.h"

#pragma mark -
#pragma mark DBDao实例变量
//业务库实例
static DBDao *gDaoInstance = nil;
extern NSInteger isNeedCompatible;//是否需要兼容2.8以前的版本
@implementation DBDao

#pragma mark -
#pragma mark 属性
@synthesize dbFile = _dbFile;                               //数据库文件，目前为每个登陆者有一个数据库
@synthesize dbQueue;                                        //数据dbQueue，多线程用
@synthesize isPostNotification = _isPostNotification;       //控制是否发回调消息



#pragma mark -
#pragma mark 数据库实例
+ (DBDao *)getDaoInstance
{
    @synchronized(self)
    {
        if (gDaoInstance == nil) {
			gDaoInstance = [[DBDao alloc] init];
            //初始化数据库名字
            [gDaoInstance genDBPath:[NSString stringWithFormat:@"WeixiaoChat.db"]];
        }
        //创建所有基本表
        [gDaoInstance CreateTable];
    }
    return gDaoInstance;
}

#pragma mark -
#pragma mark 数据库初始化
- (id)init
{
    self = [super init];
    if (self) {
        //设置初始值为true
        _isPostNotification = NO;
    }
    
    return  self;
}

/*
 * 通过user_id初始化数据库
 */
- (void)initDB:(long long)user_id
{
    _user_id = user_id;
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
    self.dbFile = [[Utilities getMyInfoDir] stringByAppendingPathComponent:DBName];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbFile];
}


#pragma mark -
#pragma mark 数据库插入更新操作
/*
 * 执行多条SQL，并加事务处理
 */
- (BOOL)executeSqls:(NSMutableArray *)sqls
{
    //是否回滚操作
    __block BOOL hasRollback = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) 
     {
         for (int i=0; i<[sqls count]; i++) {
             NSString * sql = [sqls objectAtIndex:i];
             BOOL ret = [db executeUpdate:sql];
             if (!ret) {
                 //操作失败，回滚所有操作
                 *rollback = YES;
                 hasRollback = YES;
                 return;
             } else {
                 
             }
         }
     }];  
    
    //判断是否进行过回滚操作，进行过回滚操作，代表操作失败，返回NO
    if (!hasRollback) {
        //如果操作成功，返回消息给主画面，通知画面更新数据
        if (_isPostNotification) {
            [self performSelectorOnMainThread:@selector(postNotification:) withObject:sqls waitUntilDone:NO];
        }
        return YES;
    } else {
        return NO;
    }
}

/*
 * 执行多条SQL，并加事务处理,不发送消息给画面
 */
- (BOOL)executeSqlsNoPostNotification:(NSMutableArray *)sqls
{
    //是否回滚操作
    __block BOOL hasRollback = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) 
     {
         for (int i=0; i<[sqls count]; i++) {
             NSString * sql = [sqls objectAtIndex:i];
             BOOL ret = [db executeUpdate:sql];
             if (!ret) {
                 //操作失败，回滚所有操作
                 *rollback = YES;
                 hasRollback = YES;
                 return;
             }
         }
         
     }];  
    
    //判断是否进行过回滚操作，进行过回滚操作，代表操作失败，返回NO
    if (!hasRollback) {
        return YES;
    } else {
        return NO;
    }
}

//更新数据用？传值方法
- (BOOL)executeUpdateSqls:(NSMutableArray *)sqls indata:(NSMutableArray *)data
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         for (int i=0; i<[sqls count]; i++) {
             NSString * sql = [sqls objectAtIndex:i];
             NSMutableArray *arr = [data objectAtIndex:i];
             ret = [db executeUpdate:sql withArgumentsInArray:arr];
             if (!ret) {
                 //操作失败，回滚所有操作
                 *rollback = YES;
             }
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

//更新数据用？传值方法
- (BOOL)executeUpdateNoPostNotification:(NSString *)sql indata:(NSMutableArray *)data
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) 
     {
         ret = [db executeUpdate:sql withArgumentsInArray:data];
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
- (BOOL)executeSql:(NSString *)sql
{
    __block BOOL ret;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) 
     {
         ret = [db executeUpdate:sql];
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

/*
 * 插入更新操作后，发送一个通知给画面
 */
- (void)postNotification:(NSString *)sql
{
    NSArray *retArr = [NSArray arrayWithObjects:sql, nil];
    dispatch_async(dispatch_get_main_queue(), ^{ @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCAL_DB_CHANGE object:retArr];
    }});
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
 * 取得查询结果，返回值为string类型，保证一条数据的情况下使用该方法
 */
- (NSString *)getResultsToString:(NSString *)sql
{  
    __block NSString  *ret = @"";
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = ([retArrData objectForColumnIndex:0]== [NSNull null])?nil:[retArrData stringForColumnIndex:0];
        }
    }];
    return ret;
}

/*
 * 取得查询结果，返回值为NSDate类型，保证一条数据的情况下使用该方法
 */
- (NSDate *)getResultsToDate:(NSString *)sql
{  
    __block NSDate  *ret;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = ([retArrData objectForColumnIndex:0]== [NSNull null])?nil:[retArrData dateForColumnIndex:0];
        }
    }];
    return ret;
}

/*
 * 取得查询结果，返回值为NSData类型，保证一条数据的情况下使用该方法
 */
- (NSData *)getResultsToData:(NSString *)sql
{  
    __block NSData  *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret =  ([retArrData objectForColumnIndex:0]== [NSNull null])?nil:[retArrData dataForColumnIndex:0];
        }
    }];
    return ret;
}

/*
 * 取得查询结果，返回值为longLong类型，保证一条数据的情况下使用该方法
 */
- (long long)getResultsTolongLongInt:(NSString *)sql
{  
    __block long long ret;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = ([retArrData objectForColumnIndex:0]== [NSNull null])?0:[retArrData longLongIntForColumnIndex:0];
        }
    }];
    return ret;
}

/*
 * 取得查询结果，返回值为int类型，保证一条数据的情况下使用该方法
 */
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

/*
 * 取得查询结果，返回值为long类型，保证一条数据的情况下使用该方法
 */
- (int)getResultsTolong:(NSString *)sql
{  
    __block long ret;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = [retArrData longForColumnIndex:0];
        }
    }];
    return ret;
}

/*
 * 创建业务数据库表结构
 */
- (BOOL)CreateTable
{
    BOOL ret = YES;

#if 0
    //创建消息列表,如果失败返回
    NSString *msgListSql = [DBTableCreate getCreateMsgListSql];
    ret = [self executeSql:msgListSql];
    if (!ret) {
        return ret;
    }
#endif
    
    //创建User表,如果失败返回
    NSString *userSql = [DBTableCreate getCreateUserSql];
    ret = [self executeSql:userSql];
    if (!ret) {
        return ret;
    }
    
    //创建newsList_table表,如果失败返回
    NSString *newsListSql = [DBTableCreate getNewsListSql];
    ret = [self executeSql:newsListSql];
    if (!ret) {
        return ret;
    }
    
    // 创建msgGroupListForHeadImg 2015.06.04
    NSString *MsgGroupListForHeadImgSql = [DBTableCreate getCreateMsgGroupListForHeadImgSql];
    ret = [self executeSql:MsgGroupListForHeadImgSql];
    if (!ret) {
        return ret;
    }
    
    ret = [self CreateMixListTable];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:ret forKey:@"DB_DONE"];
    [userDefaults synchronize];
    
    return ret;
}

// 创建聊天记录表
- (BOOL)CreateMixListTable{
    
    BOOL ret = NO;
    BOOL isTableExistMix = [self tableExists:@"msgListMix"];
    BOOL isTableExist = [self tableExists:@"msgList"];
    
    //msgListForGroup_
    
    if (isTableExistMix) {
        ret = YES;
    }else{
        
        if (!isTableExist) {
            
            // 创建msgListMix表 聊天记录 2016.01.18
            NSString *MsgListMixSql = [DBTableCreate getCreateMsgListMixSql];
            ret = [self executeSql:MsgListMixSql];
            
        }else{
            
            //拷贝单聊和群聊旧数据到新表中
            // done: 1. copy旧数据表里的数据 2. 删除旧表 3. 创建新表 4. 将旧数据表里的数据copy到新表
            NSString *sql = @"select count(*) from msgList";
            
            NSInteger iCnt = [self getResultsToInt:sql];
            if (iCnt > 0) {
                // 查询SQL文
                // 1
                NSString *getDataSql = @"select * from msgList ORDER BY timestamp DESC";
                
                //执行SQL
                NSMutableDictionary *retDictionary = [self getDictionaryResultsByColumnName:getDataSql];
                // 2
                NSString *dropSql = [DBTableCreate dropTable:[NSString stringWithFormat:@"msgList"]];
                if ([self executeSql:dropSql]) {
                    
                    //                // 3
                    NSString *MsgListMixSql = [DBTableCreate getCreateMsgListMixSql];
                    ret = [self executeSql:MsgListMixSql];
                    if (ret) {
                        // 4
                        [self updateChatList:retDictionary];
                        
                    }
                }
            }
            
            
            NSMutableArray *nameArr = [self getTableNames:@"msgListForGroup_"];
            if ([nameArr count] > 0) {
                
                NSString *MsgListMixSql = [DBTableCreate getCreateMsgListMixSql];
                ret = [self executeSql:MsgListMixSql];
                
                for (int i=0; i<[nameArr count]; i++) {
                    
                    NSString *name = [nameArr objectAtIndex:i];
                    
                    NSString *sql = [NSString stringWithFormat:@"select count(*) from '%@'",name];
                    
                    NSInteger iCnt = [self getResultsToInt:sql];
                    if (iCnt > 0) {
                        
                        NSString *getDataSql = [NSString stringWithFormat:@"select * from '%@' ORDER BY timestamp DESC",name];
                        //执行SQL
                        NSMutableDictionary *retDictionary = [self getDictionaryResultsByColumnName:getDataSql];
                        NSString *dropSql = [DBTableCreate dropTable:name];
                        if ([self executeSql:dropSql]) {
                            if (ret) {
                                
                                [self updateChatList:retDictionary];
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            
        }
    }
    
    BOOL isExist = [self columnExists:@"msgListMix" columnName:@"at_state"];
    
    if (!isExist) {
        NSString *alterSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ integer",@"msgListMix",@"at_state"];
        
        // 增加字段测试 Kate 2016.11.11
        BOOL isAlter1 = [self executeSql:alterSql];
    }
    
    NSString *alterStickSql = @"ALTER TABLE msgListMix ADD stick INTEGER DEFAULT 0";
    
    BOOL isAlter = [self executeSql:alterStickSql];
    NSLog(@"alter stick");
    
    NSString *alterSchoolID =  [NSString stringWithFormat:@"ALTER TABLE msgListMix ADD COLUMN schoolID INTEGER DEFAULT %lli",[G_SCHOOL_ID longLongValue]];
    BOOL isAlterSchoolID = [self executeSql:alterSchoolID];
    
    NSString *alterSchoolName = @"ALTER TABLE msgListMix ADD COLUMN schoolName nvarchar(2000)";
    BOOL isAlterSchoolName = [self executeSql:alterSchoolName];
   
    if (!ret) {
        return ret;
    }
    return ret;
}

/*
 * 创建msgInfo表,需要传user_id作为表名的一部分
 */
- (BOOL)createmsgInfoTable:(long long)user_id
{
    //创建sendingError表,如果失败返回
    NSString *MsgSql = [DBTableCreate getCreateMsgInfoSql:user_id];
    BOOL ret = [self executeSql:MsgSql];
    if (!ret) {
        return ret;
    }
    return ret;
}

//------add by kate 2015.05.26--------------------------------------
/*
 * 创建msgInfo表,需要传cid作为表名的一部分
 */
- (BOOL)createMsgListForGroupTable:(long long)cid
{
    //创建sendingError表,如果失败返回
    NSString *MsgSql = [DBTableCreate getCreateMsgListForGroupSql:cid];
    BOOL ret = [self executeSql:MsgSql];
    if (!ret) {
        return ret;
    }
    return ret;
}

/*
 * 创建msgInfo表,需要传user_id作为表名的一部分
 */
- (BOOL)createMsgInfoForGroupTable:(long long)groupId
{
    //创建sendingError表,如果失败返回
    NSString *MsgSql = @"";
    BOOL ret = NO;
    
    BOOL isTableExist = [self tableExists:[NSString stringWithFormat:@"msgInfoForGroup_%lli",groupId]];
    
    if (!isTableExist) {
        
        MsgSql = [DBTableCreate getCreateMsgInfoForGroupSql:groupId];
        ret = [self executeSql:MsgSql];
        
    }else{
        //NSString *sql = [NSString stringWithFormat:@"select userName from msgInfoForGroup_%lli", groupId];
        BOOL isExist = [self columnExists:[NSString stringWithFormat:@"msgInfoForGroup_%lli",groupId] columnName:@"userName"];
        
        if (isExist) {//新表 存在userName字段
            
            MsgSql = [DBTableCreate getCreateMsgInfoForGroupSql:groupId];
            ret = [self executeSql:MsgSql];
            
        }else{//旧表
            // done: 1. copy旧数据表里的数据 2. 删除旧表 3. 创建新表 4. 将旧数据表里的数据copy到新表
            NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli", groupId];
            
            NSInteger iCnt = [self getResultsToInt:sql];
            if (iCnt > 0) {
                // 查询SQL文
                
                // 1
                NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC", groupId];
                //执行SQL
                NSMutableDictionary *retDictionary = [self getDictionaryResultsByColumnName:getDataSql];
                // 2
                NSString *dropSql = [DBTableCreate dropTable:[NSString stringWithFormat:@"msgInfoForGroup_%lli", groupId]];
                if ([self executeSql:dropSql]) {
                    // 3
                    MsgSql = [DBTableCreate getCreateMsgInfoForGroupSql:groupId];
                    ret = [self executeSql:MsgSql];
                    if (ret) {
                        // 4
                        [self updataChatDetailArray:retDictionary gid:groupId];
                    }
                }
                
                
            }
            
        }
    }
  
    if (!ret) {
        return ret;
    }
    return ret;
}

// userId 别人的id groupId 群聊id
- (BOOL)createMsgInfoMixTable:(long long)groupId userId:(long long)userId{
    
    NSString *MsgSql = @"";
    BOOL ret = NO;
    BOOL isTableExistGroup = [self tableExists:[NSString stringWithFormat:@"msgInfoForGroup_%lli",groupId]];
    BOOL isTableExist = [self tableExists:[NSString stringWithFormat:@"msgInfo_%lli",userId]];
    BOOL isNewTableExist = [self tableExists:[NSString stringWithFormat:@"msgInfoMix_%lli_%lli",groupId,userId]];
    
    if (!isNewTableExist) {
        
        if (!isTableExist && !isTableExistGroup) {//都不存在 则建立新表
            
            MsgSql = [DBTableCreate getCreateMsgInfoMixSql:groupId userId:userId];
            ret = [self executeSql:MsgSql];
            
        }else{
            
            //存在旧表，那么把旧表的数据拷贝出来到新表中
            if (groupId == 0) {
                //拷贝单聊的数据到新表中
                // done: 1. copy旧数据表里的数据 2. 删除旧表 3. 创建新表 4. 将旧数据表里的数据copy到新表
                NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfo_%lli", userId];
                
                NSInteger iCnt = [self getResultsToInt:sql];
                if (iCnt > 0) {
                    // 查询SQL文
                    
                    // 1
                    NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfo_%lli ORDER BY timestamp DESC", userId];
                    //执行SQL
                    NSMutableDictionary *retDictionary = [self getDictionaryResultsByColumnName:getDataSql];
                    // 2
                    NSString *dropSql = [DBTableCreate dropTable:[NSString stringWithFormat:@"msgInfo_%lli", userId]];
                    if ([self executeSql:dropSql]) {
                        // 3
                        MsgSql =  [DBTableCreate getCreateMsgInfoMixSql:groupId userId:userId];
                        ret = [self executeSql:MsgSql];
                        if (ret) {
                            // 4
                            [self updataChatDetailArray:retDictionary gid:0 userId:userId];
                        }
                    }
                    
                    
                }
                
                
            }else{
                //拷贝群聊的数据到新表中
                // done: 1. copy旧数据表里的数据 2. 删除旧表 3. 创建新表 4. 将旧数据表里的数据copy到新表
                NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli", groupId];
                
                NSInteger iCnt = [self getResultsToInt:sql];
                if (iCnt > 0) {
                    // 查询SQL文
                    
                    // 1
                    NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC", groupId];
                    //执行SQL
                    NSMutableDictionary *retDictionary = [self getDictionaryResultsByColumnName:getDataSql];
                    // 2
                    NSString *dropSql = [DBTableCreate dropTable:[NSString stringWithFormat:@"msgInfoForGroup_%lli", groupId]];
                    if ([self executeSql:dropSql]) {
                        // 3
                        MsgSql =  [DBTableCreate getCreateMsgInfoMixSql:groupId userId:userId];
                        ret = [self executeSql:MsgSql];
                        if (ret) {
                            // 4
                            [self updataChatDetailArray:retDictionary gid:groupId userId:userId];
                        }
                    }
                    
                    
                }else{
                    
                    MsgSql = [DBTableCreate getCreateMsgInfoMixSql:groupId userId:userId];
                    ret = [self executeSql:MsgSql];
                }
                
            }
            
            
        }
    }
    
    NSString *tableName = [NSString stringWithFormat:@"msgInfoMix_%lli_%lli",groupId,userId];
    
    // 同时增加两个字段会有问题。。。得一个一个增加
    NSString *at_state = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INT DEFAULT(0)",tableName,@"at_state"];
    BOOL isAlter2 = [self executeSql:at_state];
    
    // 增加字段测试 Kate 2016.11.11
    
    NSString *audioRStatus = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INT DEFAULT(0)",tableName,@"audio_r_status"];
    
    // 增加字段测试 Kate 2016.11.11
    BOOL isAlter = [self executeSql:audioRStatus];
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    long long uid = [[userInfo objectForKey:@"uid"] longLongValue];
    
    NSString *addUidSql =  [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INT DEFAULT(%lli)",tableName,@"uid",uid];
    BOOL isAddUid = [self executeSql:addUidSql];
    
    
    NSString *alterSchoolName = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ nvarchar(2000)",tableName,@"schoolName"];
    BOOL isAlterSchoolName = [self executeSql:alterSchoolName];
    NSString *alterSchoolID = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INT DEFAULT(%lli)",tableName,@"schoolID",[G_SCHOOL_ID longLongValue]];
    BOOL isAlterSchoolID = [self executeSql:alterSchoolID];
    
    if (!ret) {
        return ret;
    }
    return ret;
    
}

#if 0
- (void)updataChatDetailArray:(NSDictionary*)dictionary gid:(long long)groupId
{
    for (int listCnt = [dictionary.allKeys count] - 1; listCnt >= 0; listCnt--) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        GroupChatDetailObject *ChatDetail = [[GroupChatDetailObject alloc] init];
        ChatDetail.groupid = groupId;
        ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"] intValue];
        ChatDetail.msg_id = [[chatObjectDict objectForKey:@"msg_id"] longLongValue];
        ChatDetail.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        ChatDetail.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        ChatDetail.msg_type = [[chatObjectDict objectForKey:@"msg_type"] intValue];
        ChatDetail.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        ChatDetail.msg_content = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]];
        ChatDetail.msg_file = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_file"]];
        ChatDetail.pic_url_thumb = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_thumb"]];
        ChatDetail.pic_url_original = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_original"]];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        ChatDetail.headimgurl = [Utilities replaceNull:[chatObjectDict objectForKey:@"headimgurl"]];
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];
        ChatDetail.userName = @"";
        
        [ChatDetail insertData];
        
    }
}
#endif

- (void)updataChatDetailArray:(NSDictionary*)dictionary gid:(long long)groupId userId:(long long)userId
{
    for (int listCnt = [dictionary.allKeys count] - 1; listCnt >= 0; listCnt--) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        MixChatDetailObject *ChatDetail = [[MixChatDetailObject alloc] init];
        ChatDetail.groupid = groupId;
        ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"] intValue];
        ChatDetail.msg_id = [[chatObjectDict objectForKey:@"msg_id"] longLongValue];
        if (userId == 0) {
            ChatDetail.user_id = [[chatObjectDict objectForKey:@"user_Id"] longLongValue];
        }else{
            ChatDetail.user_id = userId;
        }
        ChatDetail.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        ChatDetail.msg_type = [[chatObjectDict objectForKey:@"msg_type"] intValue];
        ChatDetail.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        ChatDetail.msg_content = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]];
        ChatDetail.msg_file = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_file"]];
        ChatDetail.pic_url_thumb = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_thumb"]];
        ChatDetail.pic_url_original = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_original"]];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        ChatDetail.headimgurl = [Utilities replaceNull:[chatObjectDict objectForKey:@"headimgurl"]];
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];
        ChatDetail.userName = [Utilities replaceNull:[chatObjectDict objectForKey:@"userName"]];
        
        [ChatDetail updateToDB];
        
        if ((ChatDetail.msg_type  == MSG_TYPE_Audio) && (ChatDetail.is_recieved == MSG_IO_FLG_RECEIVE)) {
            if ([chatObjectDict objectForKey:@"msg_state_audio"]) {
                
                ChatDetail.msg_state_audio = [[chatObjectDict objectForKey:@"msg_state_audio"] intValue];
                [ChatDetail updateAudioState];
                
            }
        }
        
    }
}

-(void)updateChatList:(NSDictionary*)dictionary{
    
    for (int listCnt = [dictionary.allKeys count] - 1; listCnt >= 0; listCnt--) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        MixChatListObject *chatList = [[MixChatListObject alloc] init];
        chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
        chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
        chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
        chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
        chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
        chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        
        NSString *gid = [Utilities replaceNull:[chatObjectDict objectForKey:@"gid"]];
        if ([gid length] == 0) {
            gid = @"0";
        }
        NSString *bother = [Utilities replaceNull:[chatObjectDict objectForKey:@"bother"]];
        if ([bother length] == 0) {
            bother = @"0";
        }
        NSString *user_id = [Utilities replaceNull:[chatObjectDict objectForKey:@"user_id"]];
        if ([gid longLongValue] != 0) {
            user_id = @"0";
        }
        chatList.gid = [gid longLongValue];
        chatList.bother = [bother longLongValue];
        chatList.user_id = [user_id longLongValue];
        
        [chatList updateToDB];
        
    }
    
}

-(NSMutableArray*)getTableNames:(NSString*)likeStr{
    
    __block FMResultSet *rs;
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        rs = [db getTableNames:likeStr];
        while ([rs next]) {
            [nameArr addObject:[[rs stringForColumn:@"name"] lowercaseString]];
            NSLog(@"1");
        }
    }];
    
    return nameArr;
    
}

// 字段是否存在
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName {

    __block BOOL ret = NO;;
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
      ret = [db columnExists:tableName columnName:columnName];
    }];
    
    return ret;
}

- (BOOL)tableExists:(NSString*)tableName{
    
    __block BOOL ret = NO;;
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        ret = [db tableExists:tableName];
    }];
    
    return ret;
}


//---------------------------------------------------------------------
@end
