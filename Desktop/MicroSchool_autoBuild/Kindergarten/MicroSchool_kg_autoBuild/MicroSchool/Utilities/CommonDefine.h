//
//  CommonDefine.h
//  MicroSchool
//
//  Created by zhanghaotian on 5/15/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDefine : NSObject

// 版本信息
#define G_VERSION               @"知校 3.3.1.2"
#define G_APP_VERSION           @"3.3.1.2"

#define G_CERVERSION            299
#define G_BINDCERVERSION        @"299"

#define G_COPYRIGHT1            @"泰硕科技 版权所有"
#define G_COPYRIGHT2            @"Copyright  2010-2017"
#define G_COPYRIGHT3            @"All Rights Reserved"

// 是否是测试服务器
// 1:测试
// 0:正式
#define IS_TEST_SERVER 0

// 自动打包的宏定义，默认是注释掉的，在脚本里面会把注释打开。
//#define BUILD_AUTOMATICALLY

// 大连东方实验高级中学
#define G_SCHOOL_DFGZ

#ifdef BUILD_AUTOMATICALLY
#define G_SCHOOL_ID             @"15829"
#define G_SCHOOL_NAME           @"知校.幼儿园"
#endif

#define G_BAIDU_PUSHKEY         @"KvLG8R480v1KuDGasDqdvKW6"

// ------------------------------------------------------------------------
// 由于涉及到了自动打包，所以上面这条线以上的代码不要做任何修改，包括空行。

// 网络接口重构标识宏 1为使用新接口
#define NETWORKING_REFACTORING 1

// 新版教育局宏标识
#define BUREAU_OF_EDUCATION 0

// 自动打包的宏定义没有被定义的时候才有效，在下面选择打开不同的学校即可。
#ifndef BUILD_AUTOMATICALLY

// 北京202中学
//#define G_SCHOOL_202
//
//#ifdef G_SCHOOL_202
//#define G_SCHOOL_ID             @"5303"
//#define G_SCHOOL_NAME           @"北京202中学"
//#endif

// 大连市第一幼儿园
//#define G_SCHOOL_XGQDSYYEY
//
//#ifdef G_SCHOOL_XGQDSYYEY
//#define G_SCHOOL_ID             @"5802"
//#define G_SCHOOL_NAME           @"大连市第一幼儿园"
//#endif

// 汇林中学小学部
//#define G_SCHOOL_HLZXXXB
//
//#ifdef G_SCHOOL_HLZXXXB
//#define G_SCHOOL_ID             @"6186"
//#define G_SCHOOL_NAME           @"汇林中学小学部"
//#endif

// 泰硕科技
//#define G_SCHOOL_TSKJ
//
//#ifdef G_SCHOOL_TSKJ
//#define G_SCHOOL_ID             @"8802"
//#define G_SCHOOL_NAME           @"泰硕科技"
//#endif

// 大连西岗智慧教育
// 6351正式教育局
//#define G_SCHOOL_ZHJY
//
//#ifdef G_SCHOOL_ZHJY
//#define G_SCHOOL_ID             @"6112"
//#define G_SCHOOL_NAME           @"大连西岗智慧教育"
//#endif

// 东方测试幼儿园
//#define G_SCHOOL_ID             @"6661"
//#define G_SCHOOL_NAME           @"东方测试幼儿园"


//#define G_SCHOOL_ID             @"21643"
//#define G_SCHOOL_NAME           @"荣城丽都幼儿园"


#define G_SCHOOL_ID             @"19445"
#define G_SCHOOL_NAME           @"昊天幼儿园"


#endif

@end
