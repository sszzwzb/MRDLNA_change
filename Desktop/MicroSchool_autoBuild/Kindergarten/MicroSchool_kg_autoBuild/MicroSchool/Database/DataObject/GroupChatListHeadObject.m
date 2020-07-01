//
//  GroupChatListHeadObject.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatListHeadObject.h"

@implementation GroupChatListHeadObject

@synthesize name;
@synthesize headUrl;
@synthesize user_id;
@synthesize gid;

/*
 * 构造
 */
- (GroupChatListHeadObject *)init
{
    if (self = [super init]) {
      
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        uid = [[userInfo objectForKey:@"uid"] longLongValue];
    }
    return self;
}


#pragma mark -
#pragma mark DB相关方法

/// <summary>
/// 更新变更到数据库
/// </summary>
- (BOOL)updateToDB
{
    //如果user_id为0，代表设定有问题，退出
    if (uid == 0) {
        return NO;
    }
    
    BOOL ret = NO;
    
    if ([self deleteData]) {
       ret = [self insertData];
    }
    
    //返回
    return ret;
}



/// <summary>
/// 插入数据到DB
/// </summary>
- (BOOL)insertData
{
    //NSLog(@"uid:%lld",uid);
    
    NSString *sql = [NSString stringWithFormat:@"insert into msgGroupListForHeadImg (uid, gid, user_id, headUrl, name) values (%lli, %lli, %lli, '%@', '%@')",
                     uid,
                     self.gid,
                     self.user_id,
                     self.headUrl,
                     self.name];

    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/// <summary>
/// 删除数据到DB
/// </summary>
-(BOOL)deleteData{
    
    NSString *sql = [NSString stringWithFormat:@"delete from msgGroupListForHeadImg where uid = %lli and gid = %lli",uid,self.gid];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    return ret;
    
}

// 移除成员时删除所对应的头像
-(BOOL)deleteHead{
    
    NSString *sql = [NSString stringWithFormat:@"delete from msgGroupListForHeadImg where uid = %lli and gid = %lli and user_id = %lli",uid,self.gid,self.user_id];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    return ret;
    
}

@end
