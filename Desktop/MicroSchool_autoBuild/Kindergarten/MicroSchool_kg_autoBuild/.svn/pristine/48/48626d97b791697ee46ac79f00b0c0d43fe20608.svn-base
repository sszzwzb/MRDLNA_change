//
//  UserObject.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "UserObject.h"
#import "DBDao.h"
#import "Utilities.h"
#import <Foundation/Foundation.h>

@interface UserObject (PRIVATE)

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


@implementation UserObject

// DB表中的行
@synthesize userinfo_id;
// 用户id
@synthesize user_id;
// 用户类型 0:我的顾问  1:楼盘的顾问
@synthesize user_type;
// 用户名
@synthesize name;
// 用户昵称
@synthesize nickname;
// 简介，备注
@synthesize introduction;
// 电话，多个电话用逗号隔开
@synthesize phone;
// 头像地址
@synthesize headimgurl;
// 所属楼盘ID
@synthesize houses_id;
// 所属楼盘名
@synthesize houses_name;
// 服务过客户数
@synthesize customer_quantity;
// 总体评价
@synthesize star;
// 专业程度评价
@synthesize star1;
// 服务态度评价
@synthesize star2;
// 响应速度评价
@synthesize star3;
// 我评价的专业程度
@synthesize my_mark_star1;
// 我评价的服务态度
@synthesize my_mark_star2;
// 我评价的响应速度
@synthesize my_mark_star3;
// 评价状态 0:没建立联系，不能评价  1:可以评价  2:已经评价过，不能再评价
@synthesize markStarStatus;
// 审查，禁用等状态
@synthesize status;
// 注册时间
@synthesize register_date;
// 服务状态 0:没服务过  1:顾问服务过乘客
@synthesize serviceType;

// 学校名称
@synthesize schoolName;
@synthesize schoolID;


#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (UserObject *)init
{
    if (self = [super init]) {
        // 用户id
        user_id = 0;
        // 用户类型 0:我的顾问  1:楼盘的顾问
        user_type = 0;
        // 用户名
        name = @"";
        // 用户昵称
        nickname = @"";
        // 简介，备注
        introduction = @"";
        // 电话，多个电话用逗号隔开
        phone = @"";
        // 头像地址
        headimgurl = @"";
        // 所属楼盘ID
        houses_id = 0;
        // 所属楼盘名
        houses_name = @"";
        // 服务过客户数
        customer_quantity = 0;
        // 总体评价
        star = 0;
        // 专业程度评价
        star1 = @"0.0";
        // 服务态度评价
        star2 = @"0.0";
        // 响应速度评价
        star3 = @"0.0";
        // 我评价的专业程度
        my_mark_star1 = 0;
        // 我评价的服务态度
        my_mark_star2 = 0;
        // 我评价的响应速度
        my_mark_star3 = 0;
        // 评价状态 0:没建立联系，不能评价  1:可以评价  2:已经评价过，不能再评价
        markStarStatus = 0;
        // 审查，禁用等状态
        status = 0;
        // 注册时间
        register_date = 0;
        // 服务状态 0:没服务过  1:顾问服务过乘客
        serviceType = 0;
        
        schoolName = @"";
        
    }
    return self;
}

/*
 * 析构
 */
- (void)dealloc
{
    self.name = nil;
    self.nickname = nil;
    self.introduction = nil;
    self.phone = nil;
    self.headimgurl = nil;
    self.houses_name = nil;
    self.star1 = nil;
    self.star2 = nil;
    self.star3 = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark DB相关方法

/*
 * 设置备注信息以外的数据更新到数据库
 */
- (BOOL)updateToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (user_id == 0) {
        return NO;
    }
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateData];
    } else {
        ret = [self insertData];
    }
    
    //返回
    return ret;
}

/*
 * 服务器返回的我的顾问列表数据更新到数据库
 */
- (BOOL)updateMyListDataToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (user_id == 0) {
        return NO;
    }
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateMyListData];
    } else {
        ret = [self insertData];
    }
    
    //返回
    return ret;
}

/*
 * 服务器返回的楼盘顾问列表数据更新到数据库
 */
- (BOOL)updateListDataToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (user_id == 0) {
        return NO;
    }
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    if ([self isExistInDB]) {
        ret = [self updateListData];
    } else {
        ret = [self insertData];
    }
    
    //返回
    return ret;
}

/*
 * 判断是否有该条记录
 */
- (BOOL)isExistInDB
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from user where user_id = %lli",
                     self.user_id];
    
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

/*
 * 插入数据到DB
 */
- (BOOL)insertData
{
    //---2017.02.28-----------------
    NSString *sql = [NSString stringWithFormat:@"insert into user (user_id, user_type, name, schoolID, schoolName, nickname, introduction, phone, headimgurl, houses_id, houses_name, customer_quantity, star, star1, star2, star3, my_mark_star1, my_mark_star2, my_mark_star3, markStarStatus, status, register_date, serviceType) values (%lli, %ld, '%@', %lld, '%@','%@', '%@', '%@', '%@', %ld, '%@', %ld, %ld, '%@', '%@', '%@', %ld, %ld, %ld, %ld, %ld, %lli, %ld)",
                     self.user_id,
                     self.user_type,
                     self.name,
                     self.schoolID,
                     self.schoolName,
                     self.nickname,
                     self.introduction,
                     self.phone,
                     self.headimgurl,
                     self.houses_id,
                     self.houses_name,
                     self.customer_quantity,
                     self.star,
                     self.star1,
                     self.star2,
                     self.star3,
                     self.my_mark_star1,
                     self.my_mark_star2,
                     self.my_mark_star3,
                     self.markStarStatus,
                     self.status,
                     self.register_date,
                     self.serviceType];
    //--------------------
    
#if 0
    NSString *sql = [NSString stringWithFormat:@"insert into user (user_id, user_type, name, nickname, introduction, phone, headimgurl, houses_id, houses_name, customer_quantity, star, star1, star2, star3, my_mark_star1, my_mark_star2, my_mark_star3, markStarStatus, status, register_date, serviceType) values (%lli, %d, '%@', '%@', '%@', '%@', '%@', %d, '%@', %d, %d, '%@', '%@', '%@', %d, %d, %d, %d, %d, %lli, %d)",
                     self.user_id,
                     self.user_type,
                     self.name,
                     self.nickname,
                     self.introduction,
                     self.phone,
                     self.headimgurl,
                     self.houses_id,
                     self.houses_name,
                     self.customer_quantity,
                     self.star,
                     self.star1,
                     self.star2,
                     self.star3,
                     self.my_mark_star1,
                     self.my_mark_star2,
                     self.my_mark_star3,
                     self.markStarStatus,
                     self.status,
                     self.register_date,
                     self.serviceType];
#endif
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}


/*
 * 更新数据到DB
 */
- (BOOL)updateData
{
    //---2017.02.28-----------------
    NSString *sql = [NSString stringWithFormat:@"update user set name = '%@', introduction = '%@', phone = '%@', headimgurl = '%@', houses_id = %ld, houses_name = '%@', customer_quantity = %ld, star = %ld, star1 = '%@', star2 = '%@', star3 = '%@', my_mark_star1 = %ld, my_mark_star2 = %ld, my_mark_star3 = %ld, markStarStatus = %ld, status = %ld, register_date = %lli, serviceType = %ld where user_id = %lli and schoolID = %lli",
                     self.name,
                     self.introduction,
                     self.phone,
                     self.headimgurl,
                     (long)self.houses_id,
                     self.houses_name,
                     self.customer_quantity,
                     self.star,
                     self.star1,
                     self.star2,
                     self.star3,
                     self.my_mark_star1,
                     self.my_mark_star2,
                     self.my_mark_star3,
                     self.markStarStatus,
                     self.status,
                     self.register_date,
                     self.serviceType,
                     self.user_id,
                     self.schoolID
                     ];
    //-------------------------------------
#if 0
    NSString *sql = [NSString stringWithFormat:@"update user set name = '%@', introduction = '%@', phone = '%@', headimgurl = '%@', houses_id = %d, houses_name = '%@', customer_quantity = %d, star = %d, star1 = '%@', star2 = '%@', star3 = '%@', my_mark_star1 = %d, my_mark_star2 = %d, my_mark_star3 = %d, markStarStatus = %d, status = %d, register_date = %lli, serviceType = %d where user_id = %lli",
                     self.name,
                     self.introduction,
                     self.phone,
                     self.headimgurl,
                     self.houses_id,
                     self.houses_name,
                     self.customer_quantity,
                     self.star,
                     self.star1,
                     self.star2,
                     self.star3,
                     self.my_mark_star1,
                     self.my_mark_star2,
                     self.my_mark_star3,
                     self.markStarStatus,
                     self.status,
                     self.register_date,
                     self.serviceType,
                     self.user_id];
#endif
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/*
 * 更新我的顾问数据到DB
 */
- (BOOL)updateMyListData
{
    NSString *sql = [NSString stringWithFormat:@"update user set user_type = 0, name = '%@', headimgurl = '%@', houses_id = %d, houses_name = '%@', star = %d where user_id = %lli",
                     self.name,
                     self.headimgurl,
                     self.houses_id,
                     self.houses_name,
                     self.star,
                     self.user_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/*
 * 更新楼盘顾问数据到DB
 */
- (BOOL)updateListData
{
    NSString *sql = [NSString stringWithFormat:@"update user set name = '%@', headimgurl = '%@', houses_id = %d, houses_name = '%@', star = %d, serviceType = %d where user_id = %lli",
                     self.name,
                     self.headimgurl,
                     self.houses_id,
                     self.houses_name,
                     self.star,
                     self.serviceType,
                     self.user_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

+ (UserObject *)getUserInfoWithID:(long long)user_id
{
    //查询SQL文
    NSString *getDataSql = [NSString stringWithFormat:@"select * from user where user_id = %lli", user_id];
    
    //执行SQL
    NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
    int listCnt = [retDictionary.allKeys count];
    if (listCnt > 0) {
        NSMutableDictionary *userObjectDict = [retDictionary objectForKey:[NSNumber numberWithInt:0]];
        
        UserObject *userInfo = [[UserObject alloc] init];
        userInfo.userinfo_id = [[userObjectDict objectForKey:@"userinfo_id"] longLongValue];
        userInfo.user_type = [[userObjectDict objectForKey:@"user_type"] intValue];
        userInfo.user_id = [[userObjectDict objectForKey:@"user_id"] longLongValue];
        userInfo.name = [Utilities replaceNull:[userObjectDict objectForKey:@"name"]];
        userInfo.nickname = [Utilities replaceNull:[userObjectDict objectForKey:@"nickname"]];
        userInfo.introduction = [Utilities replaceNull:[userObjectDict objectForKey:@"introduction"]];
        userInfo.phone = [Utilities replaceNull:[userObjectDict objectForKey:@"phone"]];
        userInfo.headimgurl = [Utilities replaceNull:[userObjectDict objectForKey:@"headimgurl"]];
        userInfo.houses_id = [[userObjectDict objectForKey:@"houses_id"] intValue];
        userInfo.houses_name = [Utilities replaceNull:[userObjectDict objectForKey:@"houses_name"]];
        userInfo.customer_quantity = [[userObjectDict objectForKey:@"customer_quantity"] intValue];
        userInfo.star = [[userObjectDict objectForKey:@"star"] intValue];
        userInfo.star1 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star1"]]];
        userInfo.star2 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star2"]]];
        userInfo.star3 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star3"]]];
        userInfo.my_mark_star1 = [[userObjectDict objectForKey:@"my_mark_star1"] intValue];
        userInfo.my_mark_star2 = [[userObjectDict objectForKey:@"my_mark_star2"] intValue];
        userInfo.my_mark_star3 = [[userObjectDict objectForKey:@"my_mark_star3"] intValue];
        userInfo.markStarStatus = [[userObjectDict objectForKey:@"markStarStatus"] intValue];
        userInfo.status = [[userObjectDict objectForKey:@"status"] intValue];
        userInfo.register_date = [[userObjectDict objectForKey:@"register_date"] longLongValue];
        userInfo.serviceType = [[userObjectDict objectForKey:@"serviceType"] intValue];
        return [userInfo autorelease];
    } else {
        return nil;
    }
}

// 教育局获取个人信息接口
+ (UserObject *)getUserInfoWithID:(long long)user_id sid:(long long)schoolID
{
    //查询SQL文
    NSString *getDataSql = [NSString stringWithFormat:@"select * from user where user_id = %lli and schoolID = %lli", user_id,schoolID];
    
    //执行SQL
    NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
    NSInteger listCnt = [retDictionary.allKeys count];
    if (listCnt > 0) {
        NSMutableDictionary *userObjectDict = [retDictionary objectForKey:[NSNumber numberWithInt:0]];
        
        UserObject *userInfo = [[UserObject alloc] init];
        userInfo.userinfo_id = [[userObjectDict objectForKey:@"userinfo_id"] longLongValue];
        userInfo.user_type = [[userObjectDict objectForKey:@"user_type"] intValue];
        userInfo.user_id = [[userObjectDict objectForKey:@"user_id"] longLongValue];
        userInfo.schoolID = [[userObjectDict objectForKey:@"schoolID"] longLongValue];
        userInfo.schoolName = [userObjectDict objectForKey:@"schoolName"];
        userInfo.name = [Utilities replaceNull:[userObjectDict objectForKey:@"name"]];
        userInfo.nickname = [Utilities replaceNull:[userObjectDict objectForKey:@"nickname"]];
        userInfo.introduction = [Utilities replaceNull:[userObjectDict objectForKey:@"introduction"]];
        userInfo.phone = [Utilities replaceNull:[userObjectDict objectForKey:@"phone"]];
        userInfo.headimgurl = [Utilities replaceNull:[userObjectDict objectForKey:@"headimgurl"]];
        userInfo.houses_id = [[userObjectDict objectForKey:@"houses_id"] intValue];
        userInfo.houses_name = [Utilities replaceNull:[userObjectDict objectForKey:@"houses_name"]];
        userInfo.customer_quantity = [[userObjectDict objectForKey:@"customer_quantity"] intValue];
        userInfo.star = [[userObjectDict objectForKey:@"star"] intValue];
        userInfo.star1 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star1"]]];
        userInfo.star2 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star2"]]];
        userInfo.star3 = [Utilities replaceNull:[NSString stringWithFormat:@"%@", [userObjectDict objectForKey:@"star3"]]];
        userInfo.my_mark_star1 = [[userObjectDict objectForKey:@"my_mark_star1"] intValue];
        userInfo.my_mark_star2 = [[userObjectDict objectForKey:@"my_mark_star2"] intValue];
        userInfo.my_mark_star3 = [[userObjectDict objectForKey:@"my_mark_star3"] intValue];
        userInfo.markStarStatus = [[userObjectDict objectForKey:@"markStarStatus"] intValue];
        userInfo.status = [[userObjectDict objectForKey:@"status"] intValue];
        userInfo.register_date = [[userObjectDict objectForKey:@"register_date"] longLongValue];
        userInfo.serviceType = [[userObjectDict objectForKey:@"serviceType"] intValue];
        return [userInfo autorelease];
    } else {
        return nil;
    }
}

// 删除顾问
+ (BOOL)deleteUserInfoWithID:(long long)user_id
{
    NSString *sql = [NSString stringWithFormat:@"delete from user where user_id = %lli", user_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

@end
