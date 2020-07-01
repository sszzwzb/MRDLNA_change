//
//  MomentsList.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MomentsListObject.h"
#import "MomentsListDBDao.h"

@implementation MomentsListObject

@synthesize momentId;
@synthesize momentType;
@synthesize jsonStr;
@synthesize page;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (MomentsListObject *)init
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
    NSString *sql = [NSString stringWithFormat:@"select count(*) from momentsList_table_%@ where momentId = %@ and momentType = '%@'", uid, momentId, momentType];
    
    NSInteger iCnt = [[MomentsListDBDao getDaoInstance] getResultsToInt:sql];
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
    
    NSString *sql = [NSString stringWithFormat:@"insert into momentsList_table_%@ (momentId, momentType, jsonStr, page) values (?,?,?,?)",
                     uid
                     ];
    
    BOOL ret = [[MomentsListDBDao getDaoInstance] executeSql:sql mId:self.momentId momentType:self.momentType jsonStr:self.jsonStr page:self.page];
    
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    
    NSString *sql = [NSString stringWithFormat:@"update momentsList_table_%@ set jsonStr = '%@', page = '%@' where momentId = '%@' and momentType = '%@'",
                     uid,
                     self.jsonStr,
                     self.page,
                     self.momentId,
                     self.momentType
                     ];
    
    BOOL ret = [[MomentsListDBDao getDaoInstance] executeSql:sql];
    return ret;
}


@end
