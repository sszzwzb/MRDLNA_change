//
//  NewsListObject.m
//  MicroSchool
//
//  Created by jojo on 14-9-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "NewsListObject.h"
#import "Utilities.h"
#import "PublicConstant.h"

@interface NewsListObject (PRIVATE)
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

@implementation NewsListObject

@synthesize newsType;
@synthesize newsid;
@synthesize title;
@synthesize dateline;
@synthesize pic;
@synthesize updatetime;
@synthesize stick;
@synthesize digest;
@synthesize smessage;
@synthesize viewnum;//add by kate 2015.03.19

//add by beck 2015.06.24
@synthesize iscomment;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (NewsListObject *)init
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
    NSString *sql = [NSString stringWithFormat:@"select count(*) from newsList_table_%@ where newsid = %@ and newsType = '%@'", uid, newsid, newsType];
    
    NSInteger iCnt = [[NewsListDBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)insertData
{
    self.title = [self sqliteEscape:self.title];
    self.smessage = [self sqliteEscape:self.smessage];
    NSString *sql = [NSString stringWithFormat:@"insert into newsList_table_%@ (newsid, newsType, title, dateline, pic, updatetime, stick, digest, smessage, viewnum, iscomment) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                     uid,
                     self.newsid,
                     self.newsType,
                     self.title,
                     self.dateline,
                     self.pic,
                     self.updatetime,
                     self.stick,
                     self.digest,
                     self.smessage,
                     self.viewnum,
                     self.iscomment
                     ];
    NSLog(@"sql:%@",sql);
    BOOL ret = [[NewsListDBDao getDaoInstance] executeSql:sql];
    return ret;
}

/*
 * 更新记录状态
 */
- (BOOL)updateData
{
    self.title = [self sqliteEscape:self.title];
    self.smessage = [self sqliteEscape:self.smessage];
    NSString *sql = [NSString stringWithFormat:@"update newsList_table_%@ set title = '%@', dateline = '%@', pic = '%@', updatetime = '%@', stick = '%@', digest = '%@', viewnum = '%@', smessage = '%@', iscomment = '%@'  where newsid = '%@' and newsType = '%@'",
                     uid,
                     self.title,
                     self.dateline,
                     self.pic,
                     self.updatetime,
                     self.stick,
                     self.digest,
                     self.viewnum,
                     self.smessage,
                     self.iscomment,
                     self.newsid,
                     self.newsType
                     ];
    
    BOOL ret = [[NewsListDBDao getDaoInstance] executeSql:sql];
    return ret;
}

-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    //2019.12.12 by mutou
    keyWord = [NSString stringWithFormat:@"%@",keyWord];
    return keyWord;
}

@end
