//
//  MixChatListObject.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/19.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MixChatListObject.h"
#import "DBDao.h"
#import "Utilities.h"

@interface MixChatListObject (PRIVATE)

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

@implementation MixChatListObject

// 聊天ID
@synthesize msglist_id;
// 聊天表名
@synthesize msg_table_name;
// 消息的发送(0)接收(1)区分
@synthesize is_recieved;
//最后一条消息ID
@synthesize last_msg_id;
// 聊天的最后一条消息的类型
@synthesize last_msg_type;
// 聊天的最后一条消息内容
@synthesize last_msg;
//该条消息是否已经读取
@synthesize msg_state;
//是否有人@我
@synthesize at_state;
// 对方的user_id
@synthesize user_id;
// 聊天标题
@synthesize title;
//聊天的最后一条消息的时间戳
@synthesize timestamp;
//班级id
@synthesize cid;
// 最后一条消息id
@synthesize mid;
//群id
@synthesize gid;
//免打扰标实
@synthesize bother;


@synthesize stick;

// 学校名称
@synthesize schoolName;
@synthesize schoolID;

#pragma mark -
#pragma mark 构造方法

/*
 * 构造
 */
- (MixChatListObject *)init
{
    if (self = [super init]) {
        // 聊天表名
        msg_table_name = @"";
        // 最后一条消息ID
        last_msg_id = 0;
        // 消息的发送(0)接收(1)区分
        is_recieved = 0;
        // 聊天的最后一条消息的类型
        last_msg_type = 0;
        // 聊天的最后一条消息内容
        last_msg = @"";
        // 聊天的最后一条消息是否已读
        msg_state = 0;
        //是否有人at我
        at_state = 0;
        // 对方的user_id
        user_id = 0;
        // 聊天标题,对方的昵称
        title = @"";
        // 聊天的最后一条消息的时间戳
        timestamp = 0;
        // 消息免打扰
        bother = 0;
        

        //----2017.02.28------
         stick = 0;
         
        schoolName = @"";
        
        //--------------------

        
        userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
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
    
    //[[DBDao getDaoInstance] createMsgListForGroupTable:cid];
    
    BOOL ret = YES;
    // 判断是否有该条记录,没有的话再进行插入
    ret = [self isExistInDB];
    if (ret) {
        [self updateData];
    } else {
        [self insertData];
    }
    
    [self updateLastMsg];
    
    //返回
    return ret;
}

/// <summary>
/// 判断是否有该条记录
/// </summary>
- (BOOL)isExistInDB
{
    //[[DBDao getDaoInstance] createmsgInfoTable:cid];
    //----2017.02.28------
    NSString *sql = @"";
    if (self.gid == 0) {
        sql = [NSString stringWithFormat:@"select count(*) from msgListMix where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli",uid,self.gid,self.user_id,self.schoolID];
    }else{
         sql = [NSString stringWithFormat:@"select count(*) from msgListMix where uid = %lli and gid = %lli and user_id = %lli",uid,self.gid,self.user_id];
    }
    //-----------------------

#if 0
      NSString *sql = [NSString stringWithFormat:@"select count(*) from msgListMix where uid = %lli and gid = %lli and user_id = %lli",uid,self.gid,self.user_id];
#endif

    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

/// <summary>
/// 插入数据到DB
/// </summary>
- (BOOL)insertData
{
    //NSLog(@"uid:%lld",uid);
    self.last_msg = [self sqliteEscape:self.last_msg];
    NSLog(@"self.last_msg:%@",self.last_msg);
    
 //----2017.02.28------
    
    NSString *sql = [NSString stringWithFormat:@"insert into msgListMix (msg_table_name, is_recieved, last_msg_id, last_msg_type, last_msg, msg_state, uid, title, timestamp, gid, user_id, cid, bother, at_state, stick, schoolName, schoolID) values ('%@', %ld, %lli, %ld, '%@', %ld, %lli, '%@', %lli, %lli, %lli, %lli, %ld, %ld, %lld, '%@', %lld)",
                     self.msg_table_name,
                     (long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     uid,
                     self.title,
                     self.timestamp,
                     self.gid,
                     self.user_id,
                     self.cid,
                     (long)self.bother,
                     self.at_state,
                     self.stick,
                     self.schoolName,
                     self.schoolID
                     ];
//----------------------

    
#if 0
    NSString *sql = [NSString stringWithFormat:@"insert into msgListMix (msg_table_name, is_recieved, last_msg_id, last_msg_type, last_msg, msg_state, uid, title, timestamp, gid, user_id, cid, bother, at_state, type) values ('%@', %ld, %lli, %ld, '%@', %ld, %lli, '%@', %lli, %lli, %lli, %lli, %ld, %ld, %ld)",
                     self.msg_table_name,
                     (long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     uid,
                     self.title,
                     self.timestamp,
                     self.gid,
                     self.user_id,
                     self.cid,
                     (long)self.bother,
                     self.at_state];
#endif

    NSLog(@"sql:%@",sql);
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

/// <summary>
/// 更新数据到DB
/// </summary>
- (BOOL)updateData
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    //NSLog(@"self.cid:%lli",self.cid);
    
    NSString *sql2 = [NSString stringWithFormat:@"select at_state from msgListMix where uid = %lli and gid = %lld ORDER BY timestamp DESC",uid,self.gid];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql2];
    //NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
    NSInteger cnt = [chatsListDict.allKeys count];
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        NSLog(@"chatObjectDict:%@",chatObjectDict);
        if ([@"" isEqualToString:[Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"at_state"] ]]]) {
            self.at_state = 0;
        }else {
            if([[chatObjectDict objectForKey:@"at_state"] integerValue] == 1){
                
                self.at_state = 1;
            }
        }
        
    }
    
 //----2017.02.28------

    NSString *sql = [NSString stringWithFormat:@"update msgListMix set is_recieved = %ld, last_msg_id = %lli, last_msg_type = %ld, last_msg = '%@', msg_state = %ld, timestamp = %lli, at_state = %li, cid = %lli, stick = %lli, schoolID = %lli, schoolName = '%@' where uid = %lli and gid = %lli and user_id = %lli",(long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     self.timestamp,
                     (long)self.at_state,
                     self.cid,
                     self.stick,
                     self.schoolID,
                     self.schoolName,
                     uid,
                     self.gid,
                     self.user_id
                     ];
    
    if (self.gid == 0) {
       
        sql = [NSString stringWithFormat:@"update msgListMix set is_recieved = %ld, last_msg_id = %lli, last_msg_type = %ld, last_msg = '%@', msg_state = %ld, timestamp = %lli, at_state = %li, cid = %lli, stick = %lli, schoolName = '%@' where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli",(long)self.is_recieved,
               self.last_msg_id,
               (long)self.last_msg_type,
               self.last_msg,
               (long)self.msg_state,
               self.timestamp,
               (long)self.at_state,
               self.cid,
               self.stick,
               self.schoolName,
               uid,
               self.gid,
               self.user_id,
               self.schoolID
               ];
        
    }
//------------------------------------

#if 0
    NSString *sql = [NSString stringWithFormat:@"update msgListMix set is_recieved = %ld, last_msg_id = %lli, last_msg_type = %ld, last_msg = '%@', msg_state = %ld, timestamp = %lli, at_state = %li where uid = %lli and gid = %lli and user_id = %lli",
                     (long)self.is_recieved,
                     self.last_msg_id,
                     (long)self.last_msg_type,
                     self.last_msg,
                     (long)self.msg_state,
                     self.timestamp,
                     (long)self.at_state,
                     uid,
                     self.gid,
                     self.user_id
                     ];
#endif

    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
    
}

-(void)updateLastMsg{
    
    //NSString *sqlLast = [NSString stringWithFormat:@"select a.last_msg from msgInfoMix_%lli_%lli a inner join (select max(last_msg_id) as lid from msgInfoMix_%lli_%lli) b on a.last_msg_id = b.lid",self.gid,self.user_id,self.gid,self.user_id];
    
 //----2017.02.28------
    
     NSString *sqlLast = [NSString stringWithFormat:@"select msg_type,msg_content,userName,is_recieved from msgInfoMix_%lli_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", self.gid, self.user_id, 0, 1];
    
    if (self.gid == 0) {
        
        sqlLast = [NSString stringWithFormat:@"select msg_type,msg_content,userName,is_recieved from msgInfoMix_%lli_%lli where schoolID = %lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", self.gid, self.user_id, self.schoolID, 0, 1];
    }
//------------------------
    
#if 0
     NSString *sqlLast = [NSString stringWithFormat:@"select msg_type,msg_content,userName,is_recieved from msgInfoMix_%lli_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", self.gid, self.user_id, 0, 1];
    
#endif
    
    NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sqlLast];
    NSMutableDictionary *chatObjectDict = [retDictionary objectForKey:[NSNumber numberWithInt:0]];
    NSLog(@"chatObjectDict:%@",chatObjectDict);
    
    NSString *last = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"msg_content"]]];
    NSInteger msgType = [[chatObjectDict objectForKey:@"msg_type"] integerValue];
    NSInteger is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] integerValue];
    
    if (self.gid!=0) {
        
        if (self.is_recieved == MSG_IO_FLG_RECEIVE && msgType!=3 && msgType!=4 && msgType!=5) {
            
            NSArray *tempArray = [self.last_msg componentsSeparatedByString:@":"];
            
            if ([tempArray count] > 1){
                
                //self.last_msg的username
                NSString *userName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:0]]];
                //数据库里真正的最后一条的username
                NSString *lastUserName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"userName"]]];
                
                if ([userName isEqualToString:lastUserName]) {
                    
                    if (![@"" isEqualToString:userName] && ![@"" isEqualToString:last]) {
                        last = [NSString stringWithFormat:@"%@:%@",userName,last];
                        
                    }
                    
                }else{
                    
                    if (![@"" isEqualToString:lastUserName] && ![@"" isEqualToString:last]) {
                        last = [NSString stringWithFormat:@"%@:%@",lastUserName,last];
                    }
                }
                
            }else{
                
                NSString *userName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"userName"]]];
                
                if (![userName isEqualToString:@""]) {
                    last = [NSString stringWithFormat:@"%@:%@",userName,last];
                    
                }
                
            }
        }
        
    }
    if (last!=nil) {
        
        if (![@"" isEqualToString:last]) {
            NSString *sql = [NSString stringWithFormat:@"update msgListMix set last_msg = '%@' where uid = %lli and gid = %lli and user_id = %lli",
                             last,
                             uid,
                             self.gid,
                             self.user_id
                             ];
            
            if (self.gid == 0) {
                
                sql = [NSString stringWithFormat:@"update msgListMix set last_msg = '%@' where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli",
                       last,
                       uid,
                       self.gid,
                       self.user_id,
                       self.schoolID
                       ];
            }
        //---------------------
#if 0
     
            NSString *sql = [NSString stringWithFormat:@"update msgListMix set last_msg = '%@' where uid = %lli and gid = %lli and user_id = %lli",
                             last,
                             uid,
                             self.gid,
                             self.user_id
                             ];

            
#endif
            
            BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
            NSLog(@"ret:%d",ret);
            
            NSLog(@"111111111111111111last:%@",last);
        }
        
    }
    
}


// 更新群名字
- (BOOL)updateGroupName
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    NSLog(@"uid:%lld",uid);
    NSLog(@"title:%@",self.title);
    
    NSString *sql = [NSString stringWithFormat:@"update msgListMix set title = '%@' where uid = %lli and gid = %lli",
                     self.title,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

// 消息免打扰
-(BOOL)noBother{
    
    NSString *sql = [NSString stringWithFormat:@"update msgListMix set bother = %ld where uid = %lli and gid = %lli",
                     (long)self.bother,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}

// 更新列表at显示
- (BOOL)updateAtState
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    NSLog(@"uid:%lld",uid);
    NSLog(@"title:%@",self.title);
    
    NSString *sql = [NSString stringWithFormat:@"update msgListMix set at_state = '%d' where uid = %lli and gid = %lli",
                     0,
                     uid,
                     self.gid
                     ];
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}


// 是否置顶
-(BOOL)isStick{
    
    NSString *sqlLast = [NSString stringWithFormat:@"select stick from msgListMix where uid = %lli and gid = %lli and user_id = %lli", uid,self.gid, self.user_id];
    
    if ((self.gid == 0) && self.user_id>=0) {
        sqlLast = [NSString stringWithFormat:@"select stick from msgListMix where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli", uid,self.gid, self.user_id,self.schoolID];
    }
    
    NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sqlLast];
    NSMutableDictionary *chatObjectDict = [retDictionary objectForKey:[NSNumber numberWithInt:0]];
    NSLog(@"chatObjectDict:%@",chatObjectDict);
    
    NSString *sticktime = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"stick"]]];
    if ([sticktime integerValue] > 0) {
        return YES;
    }else{
        return NO;
    }
}

// 置顶/取消置顶
- (BOOL)updateStick
{
    NSLog(@"self.last_msg:%@",self.last_msg);
    NSLog(@"uid:%lld",uid);
    NSLog(@"title:%@",self.title);
 
    NSString *sql = [NSString stringWithFormat:@"update msgListMix set stick = '%lld' where uid = %lli and gid = %lli and user_id = %lli",
                         self.stick,
                         uid,
                         self.gid,
                         self.user_id
                         ];
 
    if ((self.gid == 0) && self.user_id>=0) {
        
        sql = [NSString stringWithFormat:@"update msgListMix set stick = '%lld' where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli",
               self.stick,
               uid,
               self.gid,
               self.user_id,
               self.schoolID
               ];
    }
    
    
    BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
    
    return ret;
}



-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    return keyWord;
}


@end
