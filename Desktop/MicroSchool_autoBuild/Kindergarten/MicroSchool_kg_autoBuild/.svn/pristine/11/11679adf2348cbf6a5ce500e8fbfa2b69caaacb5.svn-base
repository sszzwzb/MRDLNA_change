//
//  ReportObject.m
//  ShenMaPassenger
//
//  Created by Kate on 14-3-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ReportObject.h"
#import "ReportDBDao.h"
#import "Utilities.h"

@interface ReportObject (PRIVATE)

// 数据插入到数据库
- (BOOL)insertIntoDB;

@end

@implementation ReportObject

@synthesize timestamp, eventNo,newsModuleName, longitude,latitude;

#pragma mark -
#pragma mark 构造方法
/*
 * 构造
 */
- (ReportObject *)init
{
    if (self = [super init]) {
        
        timestamp = @"";
        eventNo = @"";
        newsModuleName = @"";
        longitude = @"0";
        latitude = @"0";
        
    }
    return self;
}

/*
 * 析构
 */
- (void)dealloc
{
    self.timestamp = nil;
    self.eventNo = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark DB相关方法

/*
 * 插入数据到DB
 */
- (BOOL)insertIntoDB
{    
    NSString *sql = [NSString stringWithFormat:@"insert into report (timestamp, eventNo, newsModuleName, longitude,latitude) values (%@, '%@', '%@', '%@', '%@')",
                     self.timestamp,
                     self.eventNo,
                     self.newsModuleName,
                     self.longitude,
                     self.latitude];
    
    //NSLog(@"sql:%@",sql);
    
    BOOL ret = [[ReportDBDao getDaoInstance] executeSqlNoPostNotification:sql];
    return ret;
}

/*
 * 其他上报 如果是新闻类需要加模块的名字
 */
+ (void)event:(NSString *)eventId module:(NSString*)name
{
    ReportObject *report = [[ReportObject alloc] init];
    report.timestamp = [Utilities GetCurLocalTime];
    report.eventNo = eventId;
    report.newsModuleName = name;
    [report insertIntoDB];
    [report release];
    
}

/*
 * 其他上报
 */
+ (void)event:(NSString *)eventId
{
    ReportObject *report = [[ReportObject alloc] init];
    long long  timeInterval = [[NSDate date] timeIntervalSince1970];
    report.timestamp = [NSString stringWithFormat:@"%lli",timeInterval];
    report.eventNo = eventId;
    [report insertIntoDB];
    [report release];
    
}

@end
