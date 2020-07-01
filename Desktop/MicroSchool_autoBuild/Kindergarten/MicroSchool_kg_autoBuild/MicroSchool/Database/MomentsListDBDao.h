//
//  MomentsListDBDao.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@class FMResultSet;

@interface MomentsListDBDao : NSObject{
     NSString *_dbFile;                                    //数据库文件
    BOOL _isPostNotification;                             //控制是否发回调消息

}


@property (nonatomic, retain) NSString *dbFile;           //数据库文件
@property (nonatomic, retain) FMDatabaseQueue *dbQueue;   //数据库操作类

#pragma mark -
#pragma mark 数据库实例
// 业务库实例
+ (MomentsListDBDao *)getDaoInstance;

// 释放DB资源
- (void)releaseDB;

// 创建数据库表结构
- (BOOL)CreateTable;

#pragma mark -
#pragma mark 数据库插入更新操作
// 操作一条SQL，并加事务处理
- (BOOL)executeSql:(NSString *)sql;

- (BOOL)executeUpdate:(NSString *)sql indata:(NSMutableArray *)data;

// 重载
- (BOOL)executeSql:(NSString *)sql mId:(NSString*)momentId momentType:(NSString*)momentType jsonStr:(NSString*)jsonStr page:(NSString*)page;

// 按页检索json串
-(NSDictionary*)getData:(NSString*)type page:(NSString*)page;

// 删除所有数据
- (BOOL)deleteAllData:(NSString*)type;

//取得查询结果，返回值为int类型，保证一条数据的情况下使用该方法
- (int)getResultsToInt:(NSString *)sql;

- (BOOL)deleteDBFile;
@end
