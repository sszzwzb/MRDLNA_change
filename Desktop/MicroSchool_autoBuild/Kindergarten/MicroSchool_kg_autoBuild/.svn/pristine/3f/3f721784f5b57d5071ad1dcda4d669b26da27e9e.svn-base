//
//  StringUtil.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil


/*
 * sqlite 特殊符号处理('单引号)
 */
+ (NSString *)sqliteString:(NSString *) string;
{
    return [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

+ (NSString *)UserInfoPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *chatInfoDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserInfo"];
	return chatInfoDirectory;
}

@end
