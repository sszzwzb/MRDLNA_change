//
//  MomentsDetailObject.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MomentsDetailObject.h"
#import "MomentsDetailDBDao.h"


@implementation MomentsDetailObject

@synthesize momentId,momentType,jsonStr,page;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (MomentsDetailObject *)init
{
    if (self = [super init]) {
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        uid = [userInfo objectForKey:@"uid"];
    }
    return self;
}

#pragma mark -
#pragma mark DB相关方法

/*
 * 更新到数据库
 */
- (BOOL)updateToDB
{
    //如果newsid为0，代表设定有问题，退出
    if (momentId == nil) {
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
    NSString *sql = [NSString stringWithFormat:@"select count(*) from momentsDetail_table_%@ where momentId = %@ and momentType = '%@' and page = '%@'", uid, momentId, momentType,page];
    
    NSInteger iCnt = [[MomentsDetailDBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    //    NSString *sql = [NSString stringWithFormat:@"insert into momentsList_table_%@ (momentId, momentType, jsonStr, page) values ('%@', '%@', '%@', '%@')",
    //                     uid,
    //                     self.momentId,
    //                     self.momentType,
    //                     self.jsonStr,
    //                     self.page
    //                     ];
    
    //   NSLog(@"sql:%@",sql);// 这种方法json串很长的时候不好用
    
    NSString *sql = [NSString stringWithFormat:@"insert into momentsDetail_table_%@ (momentId, momentType, jsonStr, page) values (?,?,?,?)",
                     uid
                     ];
    
    BOOL ret = [[MomentsDetailDBDao getDaoInstance] executeSql:sql mId:self.momentId momentType:self.momentType jsonStr:self.jsonStr page:self.page];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    
    NSString *sql = [NSString stringWithFormat:@"update momentsDetail_table_%@ set jsonStr = '%@' where momentId = '%@' and momentType = '%@' and page  = '%@'",
                     uid,
                     self.jsonStr,
                     self.momentId,
                     self.momentType,
                     self.page
                     ];
    
    BOOL ret = [[MomentsDetailDBDao getDaoInstance] executeSql:sql];
    return ret;
}

@end
