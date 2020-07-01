//
//  NewsListObject.h
//  MicroSchool
//
//  Created by jojo on 14-9-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewsListDBDao.h"
#import "GlobalSingletonUserInfo.h"

@interface NewsListObject : NSObject
{
    NSString *uid;
}

#pragma mark -
#pragma mark 属性
// DB表中的行
@property (nonatomic, assign) NSString *newsType;
@property (nonatomic, assign) NSString *newsid;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *dateline;
@property (nonatomic, assign) NSString *pic;
@property (nonatomic, assign) NSString *updatetime;
@property (nonatomic, assign) NSString *stick;
@property (nonatomic, assign) NSString *digest;
@property (nonatomic, assign) NSString *smessage;
@property (nonatomic, assign) NSString *viewnum;//add by kate 2015.03.19
@property (nonatomic, assign) NSString *iscomment;//add by beck 2015.06.24

- (BOOL)updateToDB;
@end
