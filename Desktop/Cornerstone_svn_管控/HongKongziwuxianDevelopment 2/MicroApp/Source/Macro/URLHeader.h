//
//  URLHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里是URL信息

#ifndef Project_URLHeader_h
#define Project_URLHeader_h

// 是否是测试服务器
// 1:测试
// 0:正式
#define IS_TEST_SERVER         1




#if IS_TEST_SERVER
// 测试  服务器api地址
#define REQ_URL                 @"http://app.meridianjet.vip/"
#else
// 服务器api地址
#define REQ_URL                 @"http://app.meridianjet.vip/"
#endif


#endif
