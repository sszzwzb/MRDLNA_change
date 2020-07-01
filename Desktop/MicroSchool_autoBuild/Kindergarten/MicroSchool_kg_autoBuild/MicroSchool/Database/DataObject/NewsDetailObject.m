//
//  NewsDetailObject.m
//  MicroSchool
//
//  Created by jojo on 14-9-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "NewsDetailObject.h"

@interface NewsDetailObject (PRIVATE)
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

@implementation NewsDetailObject

@synthesize newsid;
@synthesize title;
@synthesize updatetime;
@synthesize message;
@synthesize iscomment;
@synthesize name;
@synthesize viewnum;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (NewsDetailObject *)init
{
    if (self = [super init]) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

        uid = [userInfo objectForKey:@"uid"];
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
    if (newsid == nil) {
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
    NSString *sql = [NSString stringWithFormat:@"select count(*) from newsDetail_table_%@ where newsid = %@",
                     uid, newsid];
    
    NSInteger iCnt = [[NewsDetailDBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    NSString *sql = [NSString stringWithFormat:@"insert into newsDetail_table_%@ (newsid, title, updatetime, message, pics, iscomment, name, viewnum) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                     uid,
                     self.newsid,
                     self.title,
                     self.updatetime,
                     self.message,
                     self.pics,
                     self.iscomment,
                     self.name,
                     self.viewnum
                     ];
    
    BOOL ret = [[NewsDetailDBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    NSString *sql = [NSString stringWithFormat:@"update newsDetail_table_%@ set title = '%@', updatetime = '%@', message = '%@', pics = '%@', iscomment = '%@', name = '%@', viewnum = '%@' where newsid = '%@'",
                     uid,
                     self.title,
                     self.updatetime,
                     self.message,
                     self.pics,
                     self.iscomment,
                     self.name,
                     self.viewnum,
                     self.newsid
                     ];
    
    BOOL ret = [[NewsDetailDBDao getDaoInstance] executeSql:sql];
    
    return ret;
}

@end
