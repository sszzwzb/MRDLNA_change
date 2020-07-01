//
//  UserObject.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject
{
    // DB表中的行
    NSInteger userinfo_id;
    // 用户id
    long long user_id;
    // 用户类型 0:我的顾问  1:楼盘的顾问
    NSInteger user_type;
    // 用户名
    NSString *name;
    // 用户昵称
    NSString *nickname;
    // 简介，备注
    NSString *introduction;
    // 电话，多个电话用逗号隔开
    NSString *phone;
    // 头像地址
    NSString *headimgurl;
    // 所属楼盘ID
    NSInteger houses_id;
    // 所属楼盘名
    NSString *houses_name;
    // 服务过客户数
    NSInteger customer_quantity;
    // 总体评价
    NSInteger star;
    // 专业程度评价
    NSString *star1;
    // 服务态度评价
    NSString *star2;
    // 响应速度评价
    NSString *star3;
    // 我评价的专业程度
    NSInteger my_mark_star1;
    // 我评价的服务态度
    NSInteger my_mark_star2;
    // 我评价的响应速度
    NSInteger my_mark_star3;
    // 评价状态 0:没建立联系，不能评价  1:可以评价  2:已经评价过，不能再评价
    NSInteger markStarStatus;
    // 审查，禁用等状态
    NSInteger status;
    // 注册时间
    long long register_date;
    // 服务状态 0:没服务过  1:顾问服务过乘客
    NSInteger serviceType;
    
    
    /// 学校名称
    NSString *schoolName;
    /// 学校id
    long long schoolID;
    
}

#pragma mark -
#pragma mark 属性

@property (nonatomic, assign) NSInteger userinfo_id;
@property (nonatomic, assign) long long user_id;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *introduction;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *headimgurl;
@property (nonatomic, assign) NSInteger houses_id;
@property (nonatomic, retain) NSString *houses_name;
@property (nonatomic, assign) NSInteger customer_quantity;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, retain) NSString *star1;
@property (nonatomic, retain) NSString *star2;
@property (nonatomic, retain) NSString *star3;
@property (nonatomic, assign) NSInteger my_mark_star1;
@property (nonatomic, assign) NSInteger my_mark_star2;
@property (nonatomic, assign) NSInteger my_mark_star3;
@property (nonatomic, assign) NSInteger markStarStatus;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) long long register_date;
@property (nonatomic, assign) NSInteger serviceType;

/// 学校名称
@property (nonatomic,strong) NSString *schoolName;
/// 学校id
@property (nonatomic,assign) long long schoolID;

#pragma mark -
#pragma mark DB相关方法

// 设置备注信息以外的数据更新到数据库
- (BOOL)updateToDB;

/*
 * 服务器返回的我的顾问列表数据更新到数据库
 */
- (BOOL)updateMyListDataToDB;

/*
 * 服务器返回的楼盘顾问列表数据更新到数据库
 */
- (BOOL)updateListDataToDB;

+ (UserObject *)getUserInfoWithID:(long long)user_id;

// 教育局获取个人信息接口
+ (UserObject *)getUserInfoWithID:(long long)user_id sid:(long long)schoolID;

// 删除顾问
+ (BOOL)deleteUserInfoWithID:(long long)user_id;

@end
