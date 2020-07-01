//
//  ReadStatusObject.m
//  MicroSchool
//
//  Created by CheungStephen on 2/20/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "ReadStatusObject.h"

@interface ReadStatusObject (PRIVATE)
/*
 * 判断是否有该条记录
 */
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

@implementation ReadStatusObject

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (ReadStatusObject *)init
{
    if (self = [super init]) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        self.uid = [userInfo objectForKey:@"uid"];
    }
    return self;
}

/*
 * 析构
 */
- (void)dealloc
{
    
    //    [super dealloc];
}

#pragma mark -
#pragma mark DB相关方法

/*
 * 更新到数据库
 */
- (BOOL)updateToDB
{
    //如果newsid为0，代表设定有问题，退出
    if (_readId == nil) {
        return NO;
    }
    
    //创建表，如果表存在就跳过不创建
    //[[DBDao getDaoInstance] createmsgInfoTable:user_id];
    
    BOOL ret = YES;
    // 判断服务器是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateData];
    } else {
        ret = [self insertData];
    }
    
    return ret;
}

/*
 * 判断是否有该条记录
 */
- (BOOL)isExistInDB
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from readStatus_table_%@ where readId = '%@'",
                     _uid, _readId];
    
    NSInteger iCnt = [[ReadStatusDBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    NSString *sql = [NSString stringWithFormat:@"insert into readStatus_table_%@ (readId, status) values ('%@', '%@')",
                     _uid,
                     self.readId,
                     self.status];
    
    BOOL ret = [[ReadStatusDBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    NSString *sql = [NSString stringWithFormat:@"update readStatus_table_%@ set status = '%@' where readId = '%@'",
                     _uid,
                     self.status,
                     self.readId];
    
    BOOL ret = [[ReadStatusDBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

@end
