//
//  StringUtil.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

/*
 * sqlite 特殊符号处理('单引号)
 */
+(NSString *)sqliteString:(NSString *) string;

/*
 * 获取Chat info路径
 */
+ (NSString *)UserInfoPath;


@end
